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
    
    @State private var currentIndex: Int = 0
    @GestureState private var dragOffset: CGFloat = 0
    
    // 최근 5개
    var recentFiveChaaps: [Chaap] {
        Array(allChaaps.prefix(5))
    }
    
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
            
            GeometryReader { proxy in
                ZStack {
                    ForEach(recentFiveChaaps.indices, id: \.self) { index in
                        let chaap = recentFiveChaaps[index]
                        
                        if abs(index - currentIndex) <= 1 {
                            CHCardShow(chaap: chaap)
                                .frame(width: 319, height: 389)
                                .offset(y: cardOffset(for: index))
                                .scaleEffect(scale(for: index))
                                .opacity(scale(for: index))
                                .zIndex(zIndex(for: index))
                                .animation(.spring(), value: currentIndex)
                                .gesture(
                                    DragGesture()
                                        .updating($dragOffset) { value, state, _ in
                                            if index == currentIndex {
                                                let direction = value.translation.height
                                                if (currentIndex > 0 && direction > 0) || (currentIndex < recentFiveChaaps.count - 1 && direction < 0) {
                                                    state = value.translation.height
                                                }
                                            }
                                        }
                                        .onEnded { value in
                                            if value.translation.height < -10 && currentIndex < recentFiveChaaps.count - 1 {
                                                currentIndex += 1
                                            } else if value.translation.height > 10 && currentIndex > 0 {
                                                currentIndex -= 1
                                            }
                                        }
                                )
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .safeAreaPadding(.horizontal, 37)
                .safeAreaPadding(.top, 203)
                .safeAreaPadding(.bottom, 176)
            }
        }
    }
    
    func cardOffset(for index: Int) -> CGFloat {
        if index == currentIndex {
            return dragOffset
        } else if index < currentIndex {
            return -45
        } else {
            return 45
        }
    }
    
    func scale(for index: Int) -> CGFloat {
        index == currentIndex ? 1.0 : 0.9
    }
    
    func opacity(for index: Int) -> Double {
        index == currentIndex ? 1.0 : 0.9
    }
    
    func zIndex(for index: Int) -> Double {
        index == currentIndex ? 2 : 1
    }
}

#Preview {
    CardSegmentView()
}
