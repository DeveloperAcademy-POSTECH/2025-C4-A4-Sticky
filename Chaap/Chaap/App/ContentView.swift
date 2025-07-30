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
    
    @State private var isSplashFinished = false
    
    var body: some View {
        if isSplashFinished {
            if displayName.isEmpty {
                ProfileView()
            } else {
                MainView()
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
