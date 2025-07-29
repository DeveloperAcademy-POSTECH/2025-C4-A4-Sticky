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
                            ZStack(alignment: .center) {
                                if chaap.title.isEmpty {
                                    Text("제목을 입력하세요")
                                        .font(.chBodyRegular)
                                        .foregroundStyle(Color.chLabelWhiteSecondary)
                                }
                                TextField("", text: $chaap.title)
                                    .font(.chBodyBold)
                                    .foregroundStyle(Color.chLabelWhitePrimary)
                                    .lineLimit(1)
                                    .background(Color.clear)
                                    .autocorrectionDisabled(true)
                                    .textInputAutocapitalization(.never)
                                    .disableAutocorrection(true)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(height: 57)
                            .background(
                                ZStack {
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color(hex: "#808080").opacity(0.25))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .inset(by: 0.46)
                                                .stroke(
                                                    LinearGradient(
                                                        gradient: Gradient(colors: [
                                                            Color.white.opacity(0),
                                                            Color.white.opacity(0.6 * 0.2)
                                                        ]),
                                                        startPoint: .center,
                                                        endPoint: .bottomTrailing
                                                    ),
                                                    lineWidth: 0.92
                                                )
                                                .stroke(
                                                    LinearGradient(
                                                        gradient: Gradient(colors: [
                                                            Color(hex: "#EEEEEE").opacity(0.8 * 0.2),
                                                            Color(hex: "#EEEEEE").opacity(0)
                                                        ]),
                                                        startPoint: .leading,
                                                        endPoint: .trailing
                                                    ),
                                                    lineWidth: 0.92
                                                )
                                        )
                                    
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(.shadow(.inner(color: .black, radius: 4, x: 1, y: 1.5)))
                                        .opacity(0.08)
                                })
                            
                            /// 메모 입력
                            ZStack(alignment: .center) {
                                if chaap.memo.isEmpty {
                                    Text("내용을 입력하세요")
                                        .font(.chBodyRegular)
                                        .foregroundStyle(Color.chLabelWhiteSecondary)
                                }
                                
                                TextEditor(text: $chaap.memo)
                                    .font(.chBodyRegular)
                                    .foregroundStyle(Color.chLabelWhitePrimary)
                                    .frame(height: 130)
                                    .scrollContentBackground(.hidden)
                                    .scrollDisabled(true)
                                    .background(Color.clear)
                                    .autocorrectionDisabled(true)
                                    .textInputAutocapitalization(.never)
                                    .multilineTextAlignment(.center)
                                    .lineLimit(3)
                            }
                            .frame(height: 136)
                            .background(
                                ZStack {
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color(hex: "#808080").opacity(0.25))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .inset(by: 0.46)
                                                .stroke(
                                                    LinearGradient(
                                                        gradient: Gradient(colors: [
                                                            Color.white.opacity(0),
                                                            Color.white.opacity(0.6 * 0.2)
                                                        ]),
                                                        startPoint: .center,
                                                        endPoint: .bottomTrailing
                                                    ),
                                                    lineWidth: 0.92
                                                )
                                                .stroke(
                                                    LinearGradient(
                                                        gradient: Gradient(colors: [
                                                            Color(hex: "#EEEEEE").opacity(0.8 * 0.2),
                                                            Color(hex: "#EEEEEE").opacity(0)
                                                        ]),
                                                        startPoint: .leading,
                                                        endPoint: .trailing
                                                    ),
                                                    lineWidth: 0.92
                                                )
                                        )
                                    
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(.shadow(.inner(color: .black, radius: 4, x: 1, y: 1.5)))
                                        .opacity(0.08)
                                })
                        }
                        // TODO: 장소 수정 어떤 방식으로 진행?
                        //                        ZStack {
                        //                            RoundedRectangle(cornerRadius: 12)
                        //                                .background(Color(hex: "#808080").opacity(0.25))
                        //                                .overlay(
                        //                                    RoundedRectangle(cornerRadius: 12)
                        //                                        .inset(by: 0.46)
                        //                                        .stroke(Color(red: 0.93, green: 0.93, blue: 0.93).opacity(0.8), lineWidth: 0.92174)
                        //                                        .background(Color.clear)
                        //                                )
                        //                                .overlay(
                        //                                    RoundedRectangle(cornerRadius: 12)
                        //                                        .inset(by: 0.46)
                        //                                        .stroke(.white.opacity(0), lineWidth: 0.92174)
                        //                                        .background(Color.clear)
                        //                                )
                        HStack {
                            Spacer()
                            HStack(alignment: .top, spacing: 4){
                                Image(.placeMarker)
                                TextField("\(chaap.place)", text: $chaap.place)
                                    .font(.chPrimaryCaptionRegular)
                                    .foregroundStyle(Color.chLabelWhiteSecondary)
                                //                                        .frame(minWidth: 100, maxWidth: 140)
                                    .lineLimit(1)
                                    .background(Color.clear)
                                    .autocorrectionDisabled(true)
                                    .textInputAutocapitalization(.never)
                                    .disableAutocorrection(true)
                                    .multilineTextAlignment(.center)
                            }
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        .frame(height: 54)
                        .background(
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(hex: "#808080").opacity(0.25))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .inset(by: 0.46)
                                            .stroke(
                                                LinearGradient(
                                                    gradient: Gradient(colors: [
                                                        Color.white.opacity(0),
                                                        Color.white.opacity(0.6 * 0.2)
                                                    ]),
                                                    startPoint: .center,
                                                    endPoint: .bottomTrailing
                                                ),
                                                lineWidth: 0.92
                                            )
                                            .stroke(
                                                LinearGradient(
                                                    gradient: Gradient(colors: [
                                                        Color(hex: "#EEEEEE").opacity(0.8 * 0.2),
                                                        Color(hex: "#EEEEEE").opacity(0)
                                                    ]),
                                                    startPoint: .leading,
                                                    endPoint: .trailing
                                                ),
                                                lineWidth: 0.92
                                            )
                                    )
                                
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(.shadow(.inner(color: .black, radius: 4, x: 1, y: 1.5)))
                                    .opacity(0.08)
                            })
                    }
//                        HStack(alignment: .top) {
//                            Spacer()
//                            Image(.placeMarker)
//                            Text(chaap.place)
//                                .font(.chPrimaryCaptionRegular)
//                                .foregroundStyle(Color.chLabelWhitePrimary)
//                            Spacer()
//                        }
//                    }
                        
                    .padding(.horizontal, 20)
                    .padding(.vertical, 24)
                }
                // TODO: 임의로 상수 넣었음..
                .frame(height: 430)
                Spacer()
                /// 저장 버튼
                CHMainButton(
                    actionType: .save,
                    action: {
                        dismiss()
                    }
                )
            }
            .safeAreaPadding(.horizontal, 16)
        }
        .navigationBarBackButtonHidden(true)
    }
}
