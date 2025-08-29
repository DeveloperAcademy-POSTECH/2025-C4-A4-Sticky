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
            backgroundView
            VStack {
                navigationBarView
                Spacer()
            }
            VStack {
                Spacer()
                cardView
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
    
    var backgroundView: some View {
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
        }
    }
    
    var navigationBarView: some View {
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
        .padding(.horizontal, 16)
        .safeAreaPadding(.top, 9)
    }
    
    var cardView: some View {
        ZStack {
            CHCardBG()
            VStack {
                cardTopContent
                Spacer()
                cardMiddleContent
                Spacer()
                cardBottomContent
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 24)
        }
        .frame(width: 319, height: 389)
    }
    
    var cardTopContent: some View {
        VStack(spacing: 8) {
            // 상대 프로필 이미지
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
            // 상대 프로필 닉네임
            Text("with \(chaap.peers.first?.displayName ?? "이름 없음")")
                .font(.chBodyBold)
                .foregroundStyle(Color.chLabelWhitePrimary)
            
            Text(chaap.createdAt.formatted(date: .abbreviated, time: .shortened))
                .font(.caption)
                .foregroundStyle(Color.chLabelWhiteSecondary)
        }
    }
    
    var cardMiddleContent: some View {
        VStack(alignment: .center, spacing: 8) {
            // 기록 제목
            Text(chaap.title)
                .font(.chBodyBold)
                .foregroundStyle(Color.chLabelWhitePrimary)
            
            // 기록 내용
            Text(chaap.memo)
                .font(.chBodyRegular)
                .foregroundStyle(Color.chLabelWhiteSecondary)
                .multilineTextAlignment(.center)
                .lineLimit(3)
        }
    }
    
    var cardBottomContent: some View {
        HStack(spacing: 4) {
            // 장소 아이콘
            Image(.placeMarker)
                .foregroundStyle(Color.chLabelWhiteSecondary)
            
            // 위치 정보
            Text(chaap.place)
                .font(.caption)
                .foregroundStyle(Color.chLabelWhiteSecondary)
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
