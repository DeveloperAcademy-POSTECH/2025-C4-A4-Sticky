//
//  TagView.swift
//  Chaap
//
//  Created by BoMin Lee on 7/17/25.
//

import SwiftUI
import SwiftData
import Lottie

struct TagView: View {
    @State private var viewModel: TagViewModel
    
    @State private var showPeerList = false
    @State private var showInvitationPending = false
    @State private var showInvitationAlert = false
    @State private var showDistanceWithPeer = false
    @State private var hasDetectedDistanceChange = false
    
    @State private var showChaapList = false
    
    init(modelContext: ModelContext) {
        _viewModel = State(initialValue: TagViewModel(modelContext: modelContext))
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.clear)
                .background(.black.opacity(0.05))
                .background(
                    EllipticalGradient(
                        colors: [Color(hex: "#0A0E18"), Color(hex: "0F2471")],
                        center: .topLeading,
                        startRadiusFraction: 0.2,
                        endRadiusFraction: 1.0
                    )
                    .scaleEffect(x: 1.6, y: 1.0, anchor: .topLeading)
                )
                .ignoresSafeArea(.all)
            
            LottieView(animation: .named("findingPeer"))
                .playing(loopMode: .loop)
                .ignoresSafeArea(.all)
            
            VStack {
                Button {
                    showChaapList.toggle()
                } label: {
                    Text("저장된 챱 보기")
                        .foregroundStyle(.white)
                }
            }
        }
        .onAppear {
            viewModel.startMPC()
        }
        .onChange(of: viewModel.mpcManager?.nearbyPeers.count) {
            showPeerList = true
        }
        .chBottomModal(isPresented: $showPeerList) {
            if let mpcManager = viewModel.mpcManager {
                TagPeerListView(mpcManager: mpcManager) { mcPeerID in
                    showPeerList = false
                    showInvitationPending = true
                }
            } else {
                VStack {
                    Text("UNAVAILABLE")
                }
            }
        }
        .chBottomModal(isPresented: $showInvitationPending) {
            if let peerName = viewModel.mpcManager?.pendingInvitation?.peerID.displayName {
                VStack {
                    Text("\(peerName)님의 수락을 기다리는 중")
                        .font(.chTitle)
                        .foregroundStyle(Color.chLabelWhitePrimary)
                }
            }
        }
        .chBottomModal(isPresented: $showInvitationAlert) {
            if let peerName = viewModel.mpcManager?.pendingInvitation?.peerID.displayName {
                VStack {
                    ZStack {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 96, height: 96)
                        Image(systemName: "fossil.shell")
                            .foregroundStyle(Color.black.opacity(0.5))
                    }
                    
                    Text("\(peerName)을 찾았습니다.\n연결하시겠습니까?")
                        .font(.chTitle)
                        .foregroundStyle(Color.chLabelWhitePrimary)
                        .multilineTextAlignment(.center)
            
                    HStack {
                        // TODO: Component 적용 해야 함.
                        Button {
                            viewModel.rejectInvitation()
                            showInvitationAlert = false
                        } label: {
                            Text("거절")
                                .font(.chTitleSemibold)
                                .foregroundStyle(Color.chLabelWhitePrimary)
                        }
                        Spacer()
                        Button {
                            viewModel.acceptInvitation()
                            showInvitationAlert = false
                        } label: {
                            Text("수락")
                                .font(.chTitleSemibold)
                                .foregroundStyle(Color.chLabelWhitePrimary)
                        }
                    }
                }
            }
        }
        
        .onChange(of: viewModel.distance) { oldValue, newValue in
            if !hasDetectedDistanceChange {
                hasDetectedDistanceChange = true
                showPeerList = false
                showInvitationAlert = false
                showInvitationPending = false
                showDistanceWithPeer = true
            }
        }
        
        .chBottomModal(isPresented: $showDistanceWithPeer){
            if let distance = viewModel.distance {
                Text(String(format: "%.1fm", distance))
                    .font(.pretend(type: .bold, size: 35))
                    .foregroundStyle(Color.chLabelWhitePrimary)
                if !viewModel.isNearby(distance) {
                    Text("조금 더 가까이 다가가세요!")
                        .font(.pretend(type: .bold, size: 35))
                        .foregroundStyle(Color.chLabelWhitePrimary)
                }
            }
        }
        
        .onChange(of: viewModel.mpcManager?.pendingInvitation?.peerID) { oldValue, newValue in
            if newValue != nil {
                print("Invitation 대기 중...")
                showInvitationPending = false
                showInvitationAlert = true
            }
        }
        
        .sheet(isPresented: $showChaapList) {
            ShowChaapTestView()
        }
    }
}
