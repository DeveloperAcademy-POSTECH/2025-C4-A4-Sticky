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
        HStack {
            /// Back button
            Button {
                dismiss()
            } label: {
                CHCircleButton(buttonImageName: "chevron.backward")
            }
            
            Spacer()
            
            Text(displayName)
                .font(.systemEmphasized)
                .foregroundColor(.white)
            
            Spacer()
            
            /// Filter button
            Menu {
                Button {
                    sortOption = .newest
                } label: {
                    HStack {
                        Text("최신순")
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
}
