//
//  MainView.swift
//  Chaap
//
//  Created by BoMin Lee on 7/17/25.
//

import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = SegmentsViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                // 전체 배경
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
                
                // SegmentView
                selectedSegmentView
                
                // Top Bar
                VStack(alignment: .center, spacing: 15) {
                    CHNavBar()
                    SegmentControlPicker(selected: $viewModel.selectedSegement)
                    Spacer()
                }
                .safeAreaPadding(.top, 14)
                .safeAreaPadding(.horizontal, 16)
                
                // Floating Button
                VStack {
                    Spacer()
                    CHFloatingButton()
                }
            }
            .safeAreaPadding(.horizontal, 16)
        }
    }
    
    // MARK: - Selected Segment View
    @ViewBuilder
    var selectedSegmentView: some View {
        switch viewModel.selectedSegement {
        case .cardSegment:
            CardSegmentView()
        case .peopleSegment:
            PeopleSegmentView()
        case .calendarSegment:
            CalendarSegmentView()
        case .mapSegment:
            MapSegmentView()
        }
    }
}

#Preview {
    MainView()
}
