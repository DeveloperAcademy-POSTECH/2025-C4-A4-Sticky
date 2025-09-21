//
//  PeopleDetailView.swift
//  Chaap
//
//  Created by BoMin Lee on 7/17/25.
//

import SwiftUI
import SwiftData

struct PeopleDetailView: View {
    let displayName: String
    let peers: [Peer]
    
    enum SortOption: String, CaseIterable, Identifiable {
        case newest = "최근순"
        case oldest = "오래된 순"
        
        var id: Self { self }
    }
    
    @State private var sortOption: SortOption = .newest
    
    var sortedChaaps: [Chaap] {
        switch sortOption {
        case .newest:
            return filteredChaaps.sorted {
                $0.createdAt > $1.createdAt
            }
        case .oldest:
            return filteredChaaps.sorted {
                $0.createdAt < $1.createdAt
            }
        }
    }
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private var navigationManager: CHNavigationManager
    
    @Environment(\.presentationMode) var presentationMode
    @Query(sort: [SortDescriptor(\Chaap.createdAt, order: .reverse)]) var allChaaps: [Chaap]
    
    @State private var currentIndex: Int? = 0
    @GestureState private var dragOffset: CGFloat = 0
    
    private let cardWidth = UIScreen.main.bounds.width * 0.816
    private let cardHeight = UIScreen.main.bounds.height * 0.37
    
    // 이 Peer들이 포함된 Chaap만 추출
    var filteredChaaps: [Chaap] {
        allChaaps.filter { chaap in
            chaap.peers.contains { peer in
                peer.displayName == displayName
            }
        }
    }
    
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
                topNavigation
                chaapList
            }
            .safeAreaPadding(.horizontal, 16)
        }
        .navigationBarHidden(true)
    }
    
    // MARK: - Top navigation
    var topNavigation: some View {
        HStack {
            /// Back button
            Button {
                dismiss()
            } label: {
                CHCircleButton(buttonImageName: "chevron.backward")
            }
            
            Spacer()
            
            Text(displayName)
                .font(.chTitleSemibold)
                .lineHeight(1.4, fontSize: 22)
                .foregroundColor(.white)
            
            Spacer()
            
            /// Filter button
            Menu {
                Button {
                    sortOption = .newest
                } label: {
                    HStack {
                        Text("최근순")
                        Spacer()
                        if sortOption == .newest {
                            Image(systemName: "checkmark")
                        }
                    }
                }
                
                Button {
                    sortOption = .oldest
                } label: {
                    HStack {
                        Text("오래된 순")
                        Spacer()
                        if sortOption == .oldest {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            } label: {
                CHCircleButton(buttonImageName: "slider.horizontal.3")
            }
        }
        .padding(.bottom, 10)
        .safeAreaPadding(.top, 9)
    }
    
    // MARK: - chaapList
    var chaapList: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(sortedChaaps, id: \.self) { chaap in
                    Button {
                        if chaap.isEditable {
                            navigationManager.push(.compose(chaap))
                        } else {
                            navigationManager.push(.detail(chaap))
                        }
                    } label: {
                        listRowView(for: chaap)
                    }
                    .background(Color.clear)
                    
                    Rectangle()
                        .foregroundColor(Color.white.opacity(0.2))
                        .frame(height: 1)
                        .padding(.vertical, 16)
                }
            }
        }
    }
    
    private func listRowView(for chaap: Chaap) -> some View {
        HStack(spacing: 12) {
            // TODO: - Chaap 사진
            ZStack {
                if let data = chaap.photoData, let chaapImage = UIImage(data: data) {
                    Color.clear
                        .aspectRatio(1, contentMode: .fit)
                    Image(uiImage: chaapImage)
                        .resizable()
                        .aspectRatio(1, contentMode: .fill)
                        .clipShape(Circle())
                        .shadow(color: Color.chBlack.opacity(0.25), radius: 4, x: 0, y: 4)
                }
                else {
                    Circle()
                        .fill(Color(hex: "#D9D9D9").opacity(0.25))
                }
                
                imageCircleStroke
            }
            .frame(width: 54, height: 54)
            .padding(.trailing, 4)
            
            Text(chaap.title.isEmpty ? "제목 없음" : chaap.title)
                .font(.chBodyMedium)
                .lineHeight(1.4, fontSize: 18)
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)
                .lineLimit(1)
                .frame(width: 157, alignment: .leading)
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(chaap.createdAt, style: .date)
                    .font(.chSecondaryCaptionMedium)
                    .lineHeight(1.4, fontSize: 12)
                    .lineLimit(1)
                    .foregroundStyle(Color.chLabelWhiteSecondary)
                
                Text(chaap.place.isEmpty ? "장소 없음" : chaap.place)
                    .font(.chSecondaryCaptionMedium)
                    .lineHeight(1.4, fontSize: 12)
                    .lineLimit(1)
                    .foregroundStyle(Color.chLabelWhiteSecondary)
            }
            .frame(width: 122, height: 46)
        }
    }
    
    var imageCircleStroke: some View {
            Circle()
                .strokeBorder(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.white.opacity(0),
                            Color.white.opacity(0.6 * 0.2)
                        ]),
                        startPoint: .center,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
                .strokeBorder(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(hex: "#EEEEEE").opacity(0.8 * 0.2),
                            Color(hex: "#EEEEEE").opacity(0)
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    lineWidth: 1
                )
                .strokeBorder(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.white.opacity(0.6),
                            Color.white.opacity(0.1 * 0.2)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .center
                    ),
                    lineWidth: 1
                )
    }
}
