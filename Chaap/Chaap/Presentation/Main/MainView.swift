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
                selectedSegmentView
                
                VStack(alignment: .center, spacing: 15) {
                    CHNavBar()
                    SegmentControlPicker(selected: $viewModel.selectedSegement)
                    Spacer()
                }
                .safeAreaPadding(.top, 14)
                .safeAreaPadding(.horizontal, 16)
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
