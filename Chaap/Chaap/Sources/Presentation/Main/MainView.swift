//
//  MainView.swift
//  Chaap
//
//  Created by BoMin Lee on 7/17/25.
//

import SwiftUI
import SwiftData

struct MainView: View {
    @StateObject private var viewModel = SegmentsViewModel()
    @StateObject private var navigationManager = CHNavigationManager()
    @Bindable var userProfileViewModel: UserProfileViewModel
    @Environment(\.modelContext) private var modelContext
    @AppStorage("SelectedProfileImageName") private var selectedImageName: String?

    var body: some View {
        NavigationStack(path: $navigationManager.appRoutes) {
            ZStack {
                // 전체 배경
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
            
                
                // SegmentView
                selectedSegmentView
                
                // Top Bar
                VStack(alignment: .center, spacing: 15) {
                    CHNavBar(
                        selectedImageName: $selectedImageName,
                        didPressSearchButton: {
                            navigationManager.push(.search)
                        }, didPressProfileButton: {
                            navigationManager.push(.editProfile)
                        })
                    SegmentControlPicker(selected: $viewModel.selectedSegement)
                    Spacer()
                }
                .safeAreaPadding(.top, 14)
                .safeAreaPadding(.horizontal, 16)
                
                // Floating Button
                VStack {
                    Spacer()
                    CHFloatingButton {
                        navigationManager.push(.tag)
                    }
                }
            }
            .safeAreaPadding(.horizontal, 16)
            .navigationDestination(for: CHAppRoute.self) { route in
                switch route {
                case .tag:
                    TagView(modelContext: modelContext)
                        .environmentObject(navigationManager)
                case .search:
                    SearchView()
                        .environmentObject(navigationManager)
                case .editProfile:
                    EditProfileView(viewModel: userProfileViewModel)
                        .environmentObject(navigationManager)
                case .compose(let chaap):
                    ChaapComposeView(chaap: chaap, modelContext: modelContext)
                        .environmentObject(navigationManager)
                case .detail(let chaap):
                    ChaapDetailView(chaap: chaap, modelContext: modelContext)
                        .environmentObject(navigationManager)
                case .people(let name, let peers):
                    PeopleDetailView(displayName: name, peers: peers)
                        .environmentObject(navigationManager)
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
                .environmentObject(navigationManager)
        case .peopleSegment:
            PeopleSegmentView()
                .environmentObject(navigationManager)
        case .calendarSegment:
            CalendarSegmentView(modelContext: modelContext)
                .environmentObject(navigationManager)
        case .mapSegment:
            MapSegmentView()
                .environmentObject(navigationManager)
        }
    }
}
