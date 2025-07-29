//
//  TagViewModel.swift
//  Chaap
//
//  Created by BoMin Lee on 7/25/25.
//

import Foundation
import MultipeerConnectivity
import NearbyInteraction
import SwiftUI
import SwiftData
import AVFoundation

@MainActor
@Observable
class TagViewModel: NSObject {
    var hasCreatedChaap = false
    let modelContext: ModelContext
    var createdChaap: Chaap?
    
    /// LocationManager
    var locationManager = TagLocationManager.shared
    
    /// MPC
    var isConnectedWithPeer: Bool = false // Peer와 연결되어있는지 여부
    var connectedPeer: MCPeerID? // 연결된 Peer
    var isCompleted: Bool = false
    var mpcManager: MultipeerConnectivityManager?
    
    // NI
    var niSession: NISession? // Nearby Interaction Session
    var peerDiscoveryToken: NIDiscoveryToken? // Peer의 DiscoveryToken
    var hasSharedTokenWithPeer = false // Peer와의 토큰 교환 여부
    var currentDistanceState: DistanceState = .unknown
    
    var distance: Float? // Peer 간의 거리
    let nearbyDistanceThreshold: Float = 0.2 // 태깅 범위
    
    // Audio
    var player: AVAudioPlayer?
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func startMPC() {
        print("ChaapViewModel - startMPC()")
        
        if mpcManager != nil {
            mpcManager?.invalidate()
        }
        
        let newMPCManager = MultipeerConnectivityManager()
        newMPCManager.peerConnectedHandler = connectedToPeer
        newMPCManager.peerDataHandler = dataReceivedHandler
        newMPCManager.peerDisconnectedHandler = disconnectedFromPeer
        
        newMPCManager.start()
        self.mpcManager = newMPCManager
    }
    
    func stopMPC() {
        print("stopMPC()")
        mpcManager?.invalidate()
        mpcManager = nil  // 반드시 nil 할당으로 인스턴스 제거
        isConnectedWithPeer = false
        connectedPeer = nil
    }
    
    func startNI() {
        print("ChaapViewModel - startNI()")
        
        // NISession 생성
        niSession = NISession()
        // delegate 설정
        niSession?.delegate = self
        
        hasSharedTokenWithPeer = false
        
        if connectedPeer != nil && mpcManager != nil {
            if let myToken = niSession?.discoveryToken {
                print("myToken: \(myToken)")
                if !hasSharedTokenWithPeer {
                    print("나의 discoveryToken 공유\(myToken)")
                    shareMyDiscoveryToken(token: myToken)
                }
                guard let peerToken = peerDiscoveryToken else {
                    print("peerToken 없음")
                    return
                }
                print("run config")
                let config = NINearbyPeerConfiguration(peerToken: peerToken)
                niSession?.run(config)
            }  else {
                print("Error - (Unable to get self discovery token)")
            }
        } else {
            print("startNI() - MPC 재연결을 시작합니다")
            print("connectedPeer: \(String(describing: connectedPeer?.displayName)) | mpc: \(String(describing: mpcManager?.description))")
            startMPC()
        }
    }
    
    // Nearby Interaction 종료
    func stopNI() {
        print("ChaapingViewModel - stopNI()")
        self.niSession?.pause()
        self.niSession?.invalidate()
    }
    
    // MPC 연결이 완료되었을 때 호출
    func connectedToPeer(peer: MCPeerID) {
        print("MPC Connected")
        
        if connectedPeer != nil {
            return
        }
        
        mpcManager?.mpcSessionState = .connected
        connectedPeer = peer
        isConnectedWithPeer = true
        
        // NI 시작
//        startNI()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.startNI()
        }
    }
    
    /// MPC 연결이 끊겼을 때 실행
    func disconnectedFromPeer(peer: MCPeerID) {
        print("MPC Disconnected")
        if connectedPeer == peer {
            connectedPeer = nil         // 연결된 Peer id 제거
            isConnectedWithPeer = false   // TODO: - 상태 변경 -> enum으로 관리하기
        }
        
        mpcManager?.mpcSessionState = .notConnected
        print("👐 isConnectWithPeer: \(isConnectedWithPeer)")
    }
    
    /// 상대방이 보내온 NIDiscoveryToken을 수신했을 때 실행
    func dataReceivedHandler(data: Data, peer: MCPeerID) {
        print("💬 NI 토큰 수신 from \(peer.displayName)")
        
        // discoveryToken을 서로 공유했다면, ni 시작
        print("상대방이 보내온 NIDiscoveryToken을 수신했을 때 실행")
        // 1. peerToken 저장
        guard let discoveryToken = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NIDiscoveryToken.self, from: data) else {
            fatalError("Unexpectedly failed to decode discovery token.")
        }
        peerDidShareDiscoveryToken(peer: peer, token: discoveryToken)
    }
    
    /// NIN 통신을 위한 discoveryToken 공유
    func shareMyDiscoveryToken(token: NIDiscoveryToken) {
        print("shareMyDiscoveryToken()")
        guard let encodedData = try?  NSKeyedArchiver.archivedData(withRootObject: token, requiringSecureCoding: true) else {
            fatalError("Unexpectedly failed to encode discovery token.")
        }
        mpcManager?.sendDataToAllPeers(data: encodedData)
        hasSharedTokenWithPeer = true
    }
    
    /// discoveryToken 공유, config 파일 제작, NIN 통신 시작
    func peerDidShareDiscoveryToken(peer: MCPeerID, token: NIDiscoveryToken) {
        print("peerDidShareDiscoveryToken - peer: \(peer), token: \(token)")
        if connectedPeer != peer {
            #if DEBUG
            fatalError("Received token from unexpected peer.")
            #endif
        }
        // Create a configuration.
        peerDiscoveryToken = token

        let config = NINearbyPeerConfiguration(peerToken: token)

        // Run the session.
        print("run the session")
        niSession?.run(config)
    }
    
    func isNearby(_ distance: Float) -> Bool {
        return distance < nearbyDistanceThreshold
    }
    
    func createChaap(peerToken: NIDiscoveryToken) async -> Chaap? {
        print("➡️ createChaap 호출됨")
        
        guard let location = locationManager.currentLocation else {
            print("❌ 위치 없음")
            return nil
        }

        await locationManager.reverseGeocode(location: location)

        // Peer 생성
        guard let displayName = connectedPeer?.displayName else {
            return nil
        }
        let peer = getOrCreatePeer(for: peerToken, displayName: displayName)
        
        let chaap = Chaap(
            createdAt: Date(),
            place: locationManager.currentAddress,
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude,
            peers: [peer]
        )

        do {
            modelContext.insert(chaap)
            try modelContext.save()
            print("✅ Chaap 저장 성공")
            return chaap
        } catch {
            print("❌ Chaap 저장 실패: \(error.localizedDescription)")
            return nil
        }
    }
    
    func getOrCreatePeer(for token: NIDiscoveryToken, displayName: String) -> Peer {
        let tokenID = Peer.tokenToString(token)

        if let existing = try? modelContext.fetch(FetchDescriptor<Peer>(predicate: #Predicate { $0.tokenString == tokenID })).first {
            return existing
        } else {
            let newPeer = Peer(token: token, displayName: displayName)
            modelContext.insert(newPeer)
            return newPeer
        }
    }
    
    func acceptInvitation() {
        guard let pending = mpcManager?.pendingInvitation else { return }
        pending.handler(true, mpcManager?.mcSession)
        mpcManager?.pendingInvitation = nil
    }

    func rejectInvitation() {
        guard let pending = mpcManager?.pendingInvitation else { return }
        pending.handler(false, nil)
        mpcManager?.pendingInvitation = nil
    }
    
    func resetSessionState() {
        print("🔄 세션 상태 초기화")
        niSession = nil
        peerDiscoveryToken = nil
        distance = nil
        currentDistanceState = .unknown
        connectedPeer = nil
        isConnectedWithPeer = false
        hasCreatedChaap = false
    }
}

extension TagViewModel: NISessionDelegate {
    func session(_ session: NISession, didUpdate nearbyObjects: [NINearbyObject]) {
//        print("➡️ didUpdate called with \(nearbyObjects.count) objects")
        
        guard let peerToken = peerDiscoveryToken else {
//            fatalError("don't have peer token")
            return
        }
        
//        guard let peerToken = peerDiscoveryToken else {
//            print("⚠️ peerToken이 아직 설정되지 않음")
//            return
//        }
        
        /// discoveryToken을 사용해서 peer 확인
        let peerObj = nearbyObjects.first { (obj) -> Bool in
            return obj.discoveryToken == peerToken
        }

        guard let nearbyObjectUpdate = peerObj else {
            return
        }
        
        self.distance = nearbyObjectUpdate.distance
        
        if let distance = nearbyObjectUpdate.distance {
            self.distance = distance
            
            if isNearby(distance), !hasCreatedChaap {
                hasCreatedChaap = true
                Task {
//                    await createChaap(peerToken: peerToken)
//                    stopNI()
//                    stopMPC()
//                    resetSessionState()
                    if let chaap = await createChaap(peerToken: peerToken) {
//                        await MainActor.run {
                            self.createdChaap = chaap
                            stopNI()
                            stopMPC()
                            resetSessionState()
//                        }
                    }
                }
                
                
            }
        }
    }

    func session(_ session: NISession, didRemove nearbyObjects: [NINearbyObject], reason: NINearbyObject.RemovalReason) {
        print("NISession didRemove")
        guard let peerToken = peerDiscoveryToken else {
            fatalError("don't have peer token")
        }
        // Find the right peer.
        let peerObj = nearbyObjects.first { (obj) -> Bool in
            return obj.discoveryToken == peerToken
        }

        if peerObj == nil {
            return
        }

        currentDistanceState = .unknown
        
        // 피어 연결해제 원인
        switch reason {
        case .peerEnded:
            // The peer token is no longer valid.
            peerDiscoveryToken = nil
 
            session.invalidate()
            
            // Restart the sequence to see if the peer comes back.
            startNI()

        case .timeout:
            
            // The peer timed out, but the session is valid.
            // If the configuration is valid, run the session again.
            if let config = session.configuration {
                session.run(config)
            }
        default:
            fatalError("Unknown and unhandled NINearbyObject.RemovalReason")
        }
    }
    
    func session(_ session: NISession, didInvalidateWith error: Error) {
        currentDistanceState = .unknown
        
        if case NIError.userDidNotAllow = error {
            if #available(iOS 15.0, *) {

                let accessAlert = UIAlertController(title: "Access Required",
                                                    message: """
                                                    NIPeekaboo requires access to Nearby Interactions for this app.
                                                    Use this string to explain to users which functionality will be enabled if they change
                                                    Nearby Interactions access in Settings.
                                                    """,
                                                    preferredStyle: .alert)
                accessAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                accessAlert.addAction(UIAlertAction(title: "Go to Settings", style: .default, handler: {_ in
                    if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                    }
                }))
                
            } else {

            }
            
            return
        }
    }
}

extension TagViewModel {
    func prepareToPlayAudio() {
        guard let url = Bundle.main.url(forResource: "activesound", withExtension: "wav") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true) // 오디오 세션 활성화. 앱이 백그라운드로 이동하거나 중단되었을 때, 다시 활성화해야함
            
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
        } catch {
            print("Error loading audio: \(error)")
        }
    }
    
    func playAudio() {
        guard let player else { return }
        player.play()
    }
}
