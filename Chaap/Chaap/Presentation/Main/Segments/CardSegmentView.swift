//
//  CardSegmentView.swift
//  Chaap
//
//  Created by BoMin Lee on 7/17/25.
//

import SwiftUI
import SwiftData

struct CardSegmentView: View {
    @Query(sort: [SortDescriptor(\Chaap.createdAt, order: .reverse)]) var allChaaps: [Chaap]
    
    @State private var currentIndex: Int? = 0
    
    private let cardWidth = UIScreen.main.bounds.width * 0.816
    
    @EnvironmentObject private var navigationManager: CHNavigationManager
    
    // 최근 5개
    var recentFiveChaaps: [Chaap] {
        Array(allChaaps.prefix(5))
    }
    
    var body: some View {
        ZStack {
            if !recentFiveChaaps.isEmpty,
               let index = currentIndex,
               let data = recentFiveChaaps[index].photoData,
               let chaapImage = UIImage(data: data) {
                Image(uiImage: chaapImage)
                    .resizable()
                    .scaledToFill()
                    .frame(minWidth: .zero, maxWidth: .infinity, alignment: .center)
                    .ignoresSafeArea(.all)
                Color.chBlack.opacity(0.2)
                    .ignoresSafeArea(.all)
            }
            cardCarouselView
        }
    }
    
    var cardCarouselView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 13) {
                ForEach(recentFiveChaaps.indices, id: \.self) { index in
                    Button {
                        if recentFiveChaaps[index].isEditable {
                            navigationManager.push(.compose(recentFiveChaaps[index]))
                        } else {
                            navigationManager.push(.detail(recentFiveChaaps[index]))
                        }
                    } label: {
                        CHCardShow(chaap: recentFiveChaaps[index])
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

#Preview {
    CardSegmentView()
}
