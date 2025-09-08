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
            if let data = chaap.photoData, let chaapImage = UIImage(data: data) {
                Image(uiImage: chaapImage)
                    .resizable()
                    .scaledToFill()
                    .frame(minWidth: .zero, maxWidth: .infinity, alignment: .center)
                    .ignoresSafeArea(.all)
                Color.chBlack.opacity(0.2)
                    .ignoresSafeArea(.all)
            } else {
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
            }
            
            if let data = chaap.photoData, let chaapImage = UIImage(data: data) {
                ScrollView {
                    VStack {
                        Spacer().frame(height: 103)
                        cardView
                        Spacer().frame(height: 103)
                    }
                }
                .scrollIndicators(.hidden)
                .safeAreaPadding(.horizontal, 40)
            } else {
                VStack {
                    Spacer()
                    cardView
                    Spacer()
                }
                .safeAreaPadding(.horizontal, 40)
            }
            
            VStack(spacing: 0) {
                topNavigationView
                Spacer()
            }
            .safeAreaPadding(.horizontal, 16)
        }
        .navigationBarBackButtonHidden(true)
    }
    
    var topNavigationView: some View {
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
        .background(
            Color.clear
                .blur(radius: 3)
        )
    }
    
    var cardView: some View {
        VStack(spacing: 50) {
            peerDateInfoView
            VStack(spacing: 8) {
                titleLabel
                contextLabel
            }
            placeView
            photoView
        }
        .padding(24)
        .background(
            CHCardBG()
        )
    }
    
    var peerDateInfoView: some View {
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
                .lineHeight(1.4, fontSize: 18)
                .foregroundStyle(Color.chLabelWhitePrimary)
            
            Text(chaap.createdAt.formatted(date: .abbreviated, time: .shortened))
                .font(.chPrimaryCaptionRegular)
                .lineHeight(1.4, fontSize: 16)
                .foregroundStyle(Color.chLabelWhitePrimary)
        }

    }
    
    var titleLabel: some View {
        Text(chaap.title)
            .font(.chBodyBold)
            .lineHeight(1.4, fontSize: 18)
            .foregroundStyle(Color.chLabelWhitePrimary)
    }
    
    var contextLabel: some View {
        Text(chaap.memo)
            .font(.chBodyRegular)
            .lineHeight(1.4, fontSize: 18)
            .foregroundStyle(Color.chLabelWhitePrimary)
    }
    
    var placeView: some View {
        HStack {
            Spacer()
            HStack(alignment: .top, spacing: 4){
                Image(.placeMarker)
                Text(chaap.place)
                    .font(.chPrimaryCaptionRegular)
                    .lineHeight(1.4, fontSize: 16)
                    .foregroundStyle(Color.chLabelWhiteSecondary)
            }
            Spacer()
        }
    }
    
    @ViewBuilder
    var photoView: some View {
        if let data = chaap.photoData, let chaapImage = UIImage(data: data) {
            ZStack {
                Color.clear
                    .aspectRatio(1, contentMode: .fit)
                Image(uiImage: chaapImage)
                    .resizable()
                    .aspectRatio(1, contentMode: .fill)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(color: Color.chBlack.opacity(0.25), radius: 4, x: 0, y: 4)
            }
        } else {
            EmptyView()
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
