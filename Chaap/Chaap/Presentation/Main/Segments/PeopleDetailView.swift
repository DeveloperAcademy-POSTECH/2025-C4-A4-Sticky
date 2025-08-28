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
            
            VStack(spacing: 62) {
                topNavigation
                cardNumberView
                slideCard
                Spacer()
            }
        }
        .navigationBarHidden(true)
    }
    
    // MARK: - Top navigation
    var topNavigation: some View {
        ZStack {
            Text(displayName)
                .font(.systemEmphasized)
                .foregroundColor(.white)
            
            HStack {
                /// Back button
                Button(action: backTapped) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .frame(width: 40, height: 40)
                        .background(Color.black.opacity(0.4))
                        .clipShape(Circle())
                }
                Spacer()

//                CHNavBar()
            }
        }
        .padding(.bottom, 10)
        .safeAreaPadding(.horizontal, 16)
    }
    
    // MARK: - Card counter
    private var cardNumberView: some View {
        let displayIndex = min((currentIndex ?? 0) + 1, filteredChaaps.count)
        
        return
            Text("\(displayIndex)/\(filteredChaaps.count)")
                .font(.chBodyBold)
                .foregroundStyle(.white)

        
    }
    // MARK: - Card View
    var slideCard: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 13) {
                ForEach(filteredChaaps.indices, id: \.self) { index in
                    Button {
                        if filteredChaaps[index].isEditable {
                            navigationManager.push(.compose(filteredChaaps[index]))
                        } else {
                            navigationManager.push(.detail(filteredChaaps[index]))
                        }
                    } label: {
                        CHCardShow(chaap: filteredChaaps[index])
                            .frame(width: 319, height: 389)
                            .animation(.spring(), value: currentIndex)
                            .containerRelativeFrame(.horizontal)
                            .tag(index)
                    }
                }
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.viewAligned)
        .scrollPosition(id: $currentIndex)
        .contentMargins(.horizontal, (UIScreen.main.bounds.width - cardWidth) / 2, for: .scrollContent)
        
    }
    
    // TODO: 네비게이션 연결 방식에 따라 변경
    private func backTapped() {
        presentationMode.wrappedValue.dismiss()
    }
}
