//
//  MainView.swift
//  Chaap
//
//  Created by BoMin Lee on 7/17/25.
//

import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = SegmentsViewModel()
    @StateObject private var navManager = CHNavigationManager()
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        NavigationStack(path: $navManager.appRoutes) {
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
                        .environmentObject(navManager)
                }
            }
            .safeAreaPadding(.horizontal, 16)
            .navigationDestination(for: CHAppRoute.self) { route in
                            switch route {
                            case .tagView:
                                TagView(modelContext: modelContext)
                            case .search:
                                // 다른 뷰
                                EmptyView()
                            case .editProfile:
                                EmptyView()
                            case .chaapping:
                                EmptyView()
                            }
                        }
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
