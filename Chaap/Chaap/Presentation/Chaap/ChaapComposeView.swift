//
//  ChaapComposeView.swift
//  Chaap
//
//  Created by BoMin Lee on 7/17/25.
//

import SwiftUI

struct ChaapComposeView: View {
    @Bindable var chaap: Chaap
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private var navigationManager: CHNavigationManager
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.clear)
                .background(.black.opacity(0.05))
                .background(
                    EllipticalGradient(
                        colors: [Color.chPrimary, Color.chSecondary],
                        center: .topLeading,
                        startRadiusFraction: 0.2,
                        endRadiusFraction: 1.0
                    )
                    .scaleEffect(x: 1.6, y: 1.0, anchor: .topLeading)
                )
                .ignoresSafeArea(.all)
            VStack {
                // TODO: 카드 크기, 입력 배경 이상함...
                Spacer()
                // MARK: - Card 부분
                ZStack {
                    CHCardBG()
                    VStack(spacing: 24) {
                        // MARK: - Peer & Date
                        VStack(spacing: 8) {
                            Circle()
                                .frame(width: 44, height: 44)
                                .foregroundStyle(.gray.opacity(0.3))
                            
                            Text("with \(chaap.peers.first?.displayName ?? "이름 없음")")
                                .font(.chBodyBold)
                                .foregroundStyle(Color.chLabelWhitePrimary)
                            
                            Text(chaap.createdAt.formatted(date: .abbreviated, time: .shortened))
                                .font(.chPrimaryCaptionRegular)
                                .foregroundStyle(Color.chLabelWhitePrimary)
                        }
                        // MARK: - 입력
                        VStack(spacing: 8) {
                            /// 제목 입력
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .background(Color(hex: "#808080").opacity(0.25))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .inset(by: 0.46)
                                            .stroke(Color(red: 0.93, green: 0.93, blue: 0.93).opacity(0.8), lineWidth: 0.92174)
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .inset(by: 0.46)
                                            .stroke(.white.opacity(0), lineWidth: 0.92174)
                                    )
                                TextField("제목을 입력하세요", text: $chaap.title)
                                    .font(.chBodyRegular)
                                    .foregroundStyle(Color.chLabelWhiteSecondary)
                                    .multilineTextAlignment(.center)
                                    .background(Color.clear)
                            }
                            .frame(height: 57)
                            /// 메모 입력
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                //                                    .background(Color(hex: "#808080").opacity(0.25))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .inset(by: 0.46)
                                            .stroke(Color(red: 0.93, green: 0.93, blue: 0.93).opacity(0.8), lineWidth: 0.92174)
                                            .background(Color.clear)
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .inset(by: 0.46)
                                            .stroke(.white.opacity(0), lineWidth: 0.92174)
                                            .background(Color.clear)
                                    )
                                TextField("내용을 입력하세요", text: $chaap.memo)
                                    .font(.chBodyRegular)
                                    .foregroundStyle(Color.chLabelWhiteSecondary)
                                    .multilineTextAlignment(.center)
                                    .background(Color.clear)
                            }
                            .frame(height: 136)
                        }
                        // TODO: 장소 수정 어떤 방식으로 진행?
                        HStack(alignment: .top) {
                            Spacer()
                            Image(.placeMarker)
                            Text(chaap.place)
                                .font(.chPrimaryCaptionRegular)
                                .foregroundStyle(Color.chLabelWhitePrimary)
                            Spacer()
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 24)
                }
                // TODO: 임의로 상수 넣었음..
                .frame(height: 430)
                Spacer()
                /// 저장 버튼
                Button {
                    navigationManager.goToRoot()
                } label: {
                    HStack(alignment: .center) {
                        Spacer()
                        Text("저장")
                            .font(.chBodyMedium)
                            .foregroundStyle(Color.chLabelWhitePrimary)
                        Spacer()
                    }
                    .safeAreaPadding(.horizontal, 16)
                    .frame(height: 50)
                    // TODO: 여기 배경 이상함 다시 해야 함...
                    .background(
                        ZStack {
                            Color.chSecondary.opacity(0.2)
                            CHBlurView(style: .systemUltraThinMaterialDark)
                                .clipShape(RoundedRectangle(cornerRadius: 50))
                            EllipticalGradient(
                                stops: [
                                    Gradient.Stop(color: Color.chPrimary, location: 0.2),
                                    Gradient.Stop(color: Color.chPrimary.opacity(0.5), location: 1.00),
                                ],
                                center: UnitPoint(x: 0.49, y: 0)
                            )
                        }
                    )
                    .cornerRadius(50)
                    .shadow(color: .black.opacity(0.1), radius: 4.6087, x: 4.6087, y: 4.6087)
                    .overlay(
                        GradientStroke()
                    )
                }
            }
            .safeAreaPadding(.horizontal, 16)
        }
        .navigationBarBackButtonHidden(true)
    }
}
