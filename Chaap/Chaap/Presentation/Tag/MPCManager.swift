//
//  MPCManager.swift
//  Chaap
//
//  Created by BoMin Lee on 7/25/25.
//

import Foundation
import MultipeerConnectivity
import SwiftUI

@Observable
class MultipeerConnectivityManager: NSObject {
 
    private var advertiser: MCNearbyServiceAdvertiser?
    private var browser: MCNearbyServiceBrowser?
    
    var mcSession: MCSession
    
    private let serviceType = "chaap" // info.plist에 있는 것과 동일
    private let myPeerID: MCPeerID = {
        let name = UserDefaults.standard.string(forKey: "displayName") ?? UIDevice.current.name
        return MCPeerID(displayName: name)
    }()
    private let maxNumPeers: Int = 5
    
    var peerDataHandler: ((Data, MCPeerID) -> Void)?    // 다른 피어로부터 데이터를 받았을 때
    var peerConnectedHandler: ((MCPeerID) -> Void)?     // 다른 피어와 연결됐을 때
    var peerDisconnectedHandler: ((MCPeerID) -> Void)?  // 다른 피어와 연결 끊어졌을 때
    
    var nearbyPeers: [MCPeerID] = []
    var connectedPeer: MCPeerID?
    var mpcSessionState: MCSessionState = .notConnected
    
    var pendingInvitation: (peerID: MCPeerID, handler: (Bool, MCSession?) -> Void)?
        
    override init() {
        // advertiser 초기화
        self.advertiser = MCNearbyServiceAdvertiser(
            peer: myPeerID,
            discoveryInfo: nil,
            serviceType: serviceType
        )
        
        // browser 초기화
        self.browser = MCNearbyServiceBrowser(peer: myPeerID, serviceType: serviceType)
        
        // mcSession 초기화
        self.mcSession = MCSession(
            peer: myPeerID,
            securityIdentity: nil,
            encryptionPreference: .required
        )
        
        // super.init() 호출
        super.init()
        
        // delegate 설정
        mcSession.delegate = self
        advertiser?.delegate = self
        browser?.delegate = self
    }

    
    private func makeNewSession() -> MCSession {
        let session = MCSession(peer: myPeerID, securityIdentity: nil, encryptionPreference: .required)
        session.delegate = self
        return session
    }
    
    // Error
    enum MPCError: Error {
        case invitationFailed(String)
        case startBrowsingFailed(String)
        case startAdvertisingFailed(String)
        case sendMessageFailed(String)
        
        var message: String {
            switch self {
            case .invitationFailed(let text):
                text
            case .startBrowsingFailed(let text):
                text
            case .startAdvertisingFailed(let text):
                text
            case .sendMessageFailed(let text):
                text
            }
        }
    }
    
    // 오류 메시지를 화면에 잠깐 보여주고 자동으로 사라지게 함
    var error: MPCError? = nil {
        didSet {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                self.error = nil
            })
        }
    }
    
    /// MPC 실행
    func start() {
        print("MPC 실행")
        
        if advertiser == nil {
            print("start() - advertiser 재초기화")
            advertiser = MCNearbyServiceAdvertiser(peer: myPeerID, discoveryInfo: nil, serviceType: serviceType)
            advertiser?.delegate = self
        }
        
        advertiser?.startAdvertisingPeer()
        
        if browser == nil {
            print("start() - browser 재초기화")
            browser = MCNearbyServiceBrowser(peer: myPeerID, serviceType: serviceType)
            browser?.delegate = self
        }
        browser?.startBrowsingForPeers()
    }
    
    /// MPC adverting & browsing 중단
    func suspend() {
        print("MP Manager - suspend() browsing & advertising 중단")
        
        advertiser?.stopAdvertisingPeer()
        browser?.stopBrowsingForPeers()
        advertiser = nil
        browser = nil
    }

    /// MPC adverting & browsing 중단 MCSession 해제
    func invalidate() {
        print("MultipeerManager - invalidate()")
        // 1. advertising, browsing 중지
        advertiser?.stopAdvertisingPeer()
        browser?.stopBrowsingForPeers()

        // 2. mcSession 해제
        mcSession.disconnect()
        mcSession.delegate = nil

        // 3. delegate 해제
        advertiser?.delegate = nil
        browser?.delegate = nil

        // 4. 객체 제거
        advertiser = nil
        browser = nil
    }
    
    /// peer의 연결에 성공했을 때 호출
    private func peerConnected(peerID: MCPeerID) {
        print("MPC - peerConnected")
        if let handler = peerConnectedHandler {
            DispatchQueue.main.async {
                handler(peerID)
                self.connectedPeer = peerID
                print("MPC: \(peerID) 실행")
            }
        }
        
        // 연결된 peer가 있다면 advertising, browsing 중단
        if mcSession.connectedPeers.count == maxNumPeers {
            self.suspend()
        }
    }
    
    /// peer의 연결이 끊어졌을 때 호출
    private func peerDisconnected(peerID: MCPeerID) {
        print("MPC - peerDisconnected")
        if let handler = peerDisconnectedHandler {
            DispatchQueue.main.async {
                handler(peerID)
                self.connectedPeer = nil
                print("MPC: \(peerID) 연결 해제")
            }
        }
        
        // 연결된 peer가 없으면 계속 advertising, browsing 유지
        if mcSession.connectedPeers.count < maxNumPeers {
            self.start()
        }
    }
    
    /// 연결된 peer들에게 data 전송
    func sendDataToAllPeers(data: Data) {
        sendData(data: data, peers: mcSession.connectedPeers, mode: .reliable)
    }
    
    func sendData(data: Data, peers: [MCPeerID], mode: MCSessionSendDataMode) {
        do {
            // data 전송
            try mcSession.send(data, toPeers: peers, with: mode)
        } catch let error {
            NSLog("Error sending data: \(error)")
        }
    }
    
    /// 사용자가 특정 peer를 선택했을 때 연결 요청 보내는 함수
    func invite(_ peer: MCPeerID) {
        print("📨 Invite sent to \(peer.displayName)")
        browser?.invitePeer(peer, to: mcSession, withContext: nil, timeout: 10)
    }
}

extension MultipeerConnectivityManager: MCNearbyServiceBrowserDelegate {
    /// 연결할 수 있는 MPSession 찾고, Invitation 보내기
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        print("=====browsing=====")
        
        print("상대 peerID: \(peerID) || 내 peerID: \(self.myPeerID)")
        guard peerID != myPeerID else { return }  // 자기 자신에 대한 초대 방지
        
        if !nearbyPeers.contains(peerID) {
            DispatchQueue.main.async {
                self.nearbyPeers.append(peerID)
            }
        }
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        print("🛑 Lost peer: \(peerID.displayName)")
        DispatchQueue.main.async {
            self.nearbyPeers.removeAll { $0 == peerID }
        }
    }
}

extension MultipeerConnectivityManager: MCNearbyServiceAdvertiserDelegate {
    // 내 기기가 서비스 중일 때, 근처 기기(MCPeer)로부터 세션에 연결하겠다는 요청이 들어왔을 때 호출
    // -> 내가 advertiser를 실행할 때, 다른 기기가 invitePeer()를 호출하면 이 메서드가 자동 실행
    // peerID: 연결을 요청한 상대방의 peer ID
    // context:w 상대방이 초대에 포함시킨 부가 정보. ex. 사용자의 ID등 (신뢰할 수 없으므로 주의)
    // invitationHandler: 초대 수락/거절을 결정하는 콜백. true: 수락, false: 거절. 세션도 같이 넘겨야 함
    /// MCSession 열고, 들어온 invitations 수락 or 거절
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        print("초대 받음: \(peerID.displayName)")
        
        // 수신자 상태 저장
        DispatchQueue.main.async {
            self.pendingInvitation = (peerID: peerID, handler: invitationHandler)
        }
    }
}

extension MultipeerConnectivityManager: MCSessionDelegate {
    // 피어의 연결 상태가 바뀔 때 호출
    // 연결이 끊겼는지 확인
    // state에 따라 어떤 핸들러를 부를지 결정
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            self.mpcSessionState = .connected
            self.peerConnected(peerID: peerID)
        case .notConnected:
            self.mpcSessionState = .notConnected
            self.peerDisconnected(peerID: peerID)
        case .connecting:
            self.mpcSessionState = .connecting

        @unknown default:   // 미래 확장성을 고려하여 추가
            fatalError("Unhandled MCSessionState")
        }
        
        print("MPC Manager : \(state.displayString)")
    }
    
    // 상대 peer가 나한테 Data를 전송했을 때 호출
    // 텍스트, JSON, 커맨드 등의 메시지
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        if let handler = peerDataHandler {
            DispatchQueue.main.async {
                handler(data, peerID)
            }
        }
    }
    
    /// 사용 안 함
    // 실시간 스트리밍 데이터 (오디오, 비디오 등)를 수신할 때 사용
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        print("receive stream.")
    }
    
    // 상대방이 파일 등을 전송하기 시작했을 때 호출
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        print("start receiving resource with progress: \(progress)")
    }
    
    // 리소스(파일 등)를 모두 수신했을 때 호출
    // localURL에 파일이 저장
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: (any Error)?) {
        print("finish receiving resource. url: \(String(describing: localURL)), error: \(String(describing: error))")
    }
}
