//
//  ChaapDetailView.swift
//  Chaap
//
//  Created by BoMin Lee on 7/17/25.
//

import SwiftUI
import SwiftData

struct ChaapDetailView: View {
    @Bindable var chaap: Chaap
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private var navigationManager: CHNavigationManager
    
    var modelContext: ModelContext
    
    @State private var showDeleteAlert = false
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.clear)
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
            Rectangle()
                .foregroundColor(.clear)
                .background(
                    Color.black.opacity(0.25)
                )
                .ignoresSafeArea(.all)
            VStack {
                HStack{
                    Button {
                        dismiss()
                    } label: {
                        CHCircleButton(buttonImageName: "chevron.backward")
                    }
                    Spacer()
                    Button {
                        showDeleteAlert = true
                    } label: {
                        CHCircleButton(buttonImageName: "trash")
                    }
                }
                .safeAreaPadding(.top, 9)
                Spacer()
                // MARK: - Card 부분
                ZStack {
                    CHCardBG()
                    VStack(spacing: 24) {
                        // MARK: - Peer & Date
                        VStack(spacing: 8) {
                            if let iconName = chaap.peers.first?.iconName {
                                Image(iconName)
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .frame(
                                        maxWidth: .infinity,
                                        minHeight: 44,
                                        maxHeight: 44,
                                        alignment: .center
                                    )
                                    .background(.white)
                                    .clipShape(Circle())
                            } else {
                                Image(.profileButterfly)
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .frame(
                                        maxWidth: .infinity,
                                        minHeight: 44,
                                        maxHeight: 44,
                                        alignment: .center
                                    )
                                    .background(.white)
                                    .clipShape(Circle())
                            }
                            
                            Text("with \(chaap.peers.first?.displayName ?? "이름 없음")")
                                .font(.chBodyBold)
                                .foregroundStyle(Color.chLabelWhitePrimary)
                            
                            Text(chaap.createdAt.formatted(date: .abbreviated, time: .shortened))
                                .font(.chPrimaryCaptionRegular)
                                .foregroundStyle(Color.chLabelWhitePrimary)
                        }
                        VStack(spacing: 8) {
                            /// 제목
                            Text(chaap.title)
                                .font(.chBodyBold)
                                .foregroundStyle(Color.chLabelWhitePrimary)
                            /// 메모
                            Text(chaap.memo)
                                .font(.chBodyRegular)
                                .foregroundStyle(Color.chLabelWhitePrimary)
                        }
                        /// 장소
                        HStack {
                            Spacer()
                            HStack(alignment: .top, spacing: 4){
                                Image(.placeMarker)
                                Text(chaap.place)
                                    .font(.chPrimaryCaptionRegular)
                                    .foregroundStyle(Color.chLabelWhiteSecondary)
                            }
                            Spacer()
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 24)
                }
                // TODO: 임의로 상수 넣었음..
                .frame(height: 430)
                Spacer()
            }
            .safeAreaPadding(.horizontal, 16)
        }
        .navigationBarBackButtonHidden(true)
        .alert("정말 삭제하시겠습니까?", isPresented: $showDeleteAlert) {
            Button("삭제", role: .destructive, action: deleteChaap)
            Button("취소", role: .cancel) { }
        } message: {
            Text("이 기록은 완전히 삭제되며 되돌릴 수 없습니다.")
        }
    }
    
    private func deleteChaap() {
        modelContext.delete(chaap)
        do {
            try modelContext.save()
            dismiss()
        } catch {
            print("❌ 삭제 실패: \(error.localizedDescription)")
        }
    }
}
