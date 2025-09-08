//
//  ContentView.swift
//  Chaap
//
//  Created by BoMin Lee on 7/17/25.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @AppStorage("displayName") private var displayName: String = ""
    
    @State private var showOnboarding = false
    @State private var isSplashFinished = false
    @State private var userProfileViewModel = UserProfileViewModel()
    
    var body: some View {
        if isSplashFinished {
            if displayName.isEmpty && !showOnboarding  {
                ProfileView(viewModel: userProfileViewModel, showOnboarding: $showOnboarding)
            } else if !displayName.isEmpty && showOnboarding {
                OnboardingView(showOnboarding: $showOnboarding)
            } else {
                MainView(userProfileViewModel: userProfileViewModel)
            }
        } else {
            SplashView()
                .ignoresSafeArea()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .task {
                    try? await Task.sleep(nanoseconds: 1_250_000_000)
                    withAnimation {
                        isSplashFinished = true
                    }
                }
        }
    }
}

#Preview {
    ContentView()
}
