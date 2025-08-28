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
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private var navigationManager: CHNavigationManager
    @State private var pushed = false
    
    @State private var viewModel: TagViewModel
    
    @State private var showPeerList = false
    @State private var showInvitationPending = false
    @State private var showInvitationAlert = false
    @State private var showDistanceWithPeer = false
    @State private var hasDetectedDistanceChange = false
    
    @State private var showRotatingAnimation = true
    @State private var showSendAnimation = false
    
    init(modelContext: ModelContext) {
        _viewModel = State(initialValue: TagViewModel(modelContext: modelContext))
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.clear)
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
            
            if showRotatingAnimation {
                LottieView(animation: .named("findingPeer"))
                    .playing(loopMode: .loop)
                    .ignoresSafeArea(.all)
            }
            
            if showSendAnimation {
                LottieView(animation: .named("creatingChaap"))
                    .playing(loopMode: .playOnce)
                    .ignoresSafeArea(.all)
            }
            
            
            VStack {
                ZStack {
                    Text("임시 텍스트")
                        .font(.pretend(type: .semibold, size: 17))
                        .foregroundStyle(.white)
                    
                    HStack {
                        /// Back button
                        Button(action: {
                            print("닫기 버튼 누름")
                            viewModel.stopNI()
                            viewModel.stopMPC()
                            dismiss()
                        }, label: {
                            CHCircleButton(buttonImageName: "chevron.backward")
                        })
                        Spacer()
                    }
                }
                .padding(.bottom, 10)
                .safeAreaPadding(.horizontal, 16)
                Spacer()
                LottieView(animation: .named("loadingDots"))
                    .playing(loopMode: .loop)
                    .frame(maxWidth: 50, maxHeight: 15)
                    
                Spacer()
                    .frame(height: 21)
                Text("사용자를 찾는중")
                    .font(.chTitle)
                    .foregroundStyle(Color.chLabelWhitePrimary)
                Spacer()
                    .frame(height: 11)
                Text("상대도 서칭중인지 확인하세요.")
                    .font(.chPrimaryCaptionMedium)
                    .foregroundStyle(Color(hex: "#D9D9D9"))
                Spacer()
                    .frame(height: 150)
            }
        }
        .onAppear {
            viewModel.startMPC()
            viewModel.prepareToPlayAudio()
            viewModel.playAudio()
        }
        .onChange(of: viewModel.mpcManager?.nearbyPeers.count) {
            if viewModel.mpcManager?.nearbyPeers.count ?? 0 >= 1 {
                showPeerList = true
            }
        }
        .chBottomModal(isPresented: $showPeerList) {
            if let mpcManager = viewModel.mpcManager {
                TagPeerListView(mpcManager: mpcManager) { mcPeerID in
                    showPeerList = false
                    showInvitationPending = true
                }
            }
        }
        .chBottomModal(isPresented: $showInvitationPending) {
            VStack {
                Spacer()
                if let peerName = viewModel.mpcManager?.connectedPeer?.displayName {
                    Text("\(peerName)님의 수락을 기다리는 중")
                        .font(.chTitle)
                        .foregroundStyle(Color.chLabelWhitePrimary)
                } else {
                    Text("수락을 기다리는 중")
                        .font(.chTitle)
                        .foregroundStyle(Color.chLabelWhitePrimary)
                }
                Spacer()
            }
        }
        .chBottomModal(isPresented: $showInvitationAlert) {
            if let peerName = viewModel.mpcManager?.pendingInvitation?.peerID.displayName {
                VStack(spacing: 28) {
                    Image(.chaapLogo)
                    Text("\(peerName)을 찾았습니다.\n연결하시겠습니까?")
                        .font(.chTitle)
                        .foregroundStyle(Color.chLabelWhitePrimary)
                        .multilineTextAlignment(.center)
                    HStack {
                        CHMainButton(
                            actionType: .decline,
                            action: {
                                viewModel.rejectInvitation()
                                showInvitationAlert = false
                            }
                        )
                        Spacer()
                        CHMainButton(
                            actionType: .accept,
                            action: {
                                viewModel.acceptInvitation()
                                showInvitationAlert = false
                            }
                        )
                    }
                }
                .padding(.top, 36)
                .safeAreaPadding(.bottom, 2)
            }
        }
        .onChange(of: viewModel.distance) { oldValue, newValue in
            if !hasDetectedDistanceChange {
                hasDetectedDistanceChange = true
                showPeerList = false
                showInvitationAlert = false
                showInvitationPending = false
                showDistanceWithPeer = true
                
                showRotatingAnimation = false
                showSendAnimation = true
            }
        }
        
        .chBottomModal(isPresented: $showDistanceWithPeer){
            if let distance = viewModel.distance {
                VStack(spacing: 18) {
                    Image(.chaapLogo)
                    VStack(spacing: 4) {
                        Text(String(format: "%.1fm", distance))
                            .font(.pretend(type: .bold, size: 35))
                            .foregroundStyle(Color.chLabelWhitePrimary)
                        if !viewModel.isNearby(distance) {
                            Text("조금 더 가까이 다가가세요!")
                                .font(.chTitle)
                                .foregroundStyle(Color.chLabelWhitePrimary)
                        } else {
                            Text("")
                                .font(.chTitle)
                                .foregroundStyle(Color.chLabelWhitePrimary)
                        }
                    }
                    CHMainButton(
                        actionType: .cancel,
                        action: {
                            viewModel.stopNI()
                            viewModel.stopMPC()
                            showDistanceWithPeer = false
                            showPeerList = false
                            viewModel.startMPC()
                            
                            showRotatingAnimation = true
                            showSendAnimation = false
                        }
                    )
                }
                .padding(.top, 36)
                .safeAreaPadding(.bottom, 2)
            }
        }
        
        .onChange(of: viewModel.mpcManager?.pendingInvitation?.peerID) { oldValue, newValue in
            if newValue != nil {
                print("Invitation 대기 중...")
                showInvitationPending = false
                showInvitationAlert = true
            }
        }
        
        .onChange(of: viewModel.createdChaap) { _, newChaap in
            guard let chaap = newChaap, !pushed else {
                print("compose로 이동 X")
                return
            }
            pushed = true
            navigationManager.push(.compose(chaap))
        }
        .navigationBarBackButtonHidden(true)
    }
}
