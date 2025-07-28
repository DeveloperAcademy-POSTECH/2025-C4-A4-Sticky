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
            
            if displayName.isEmpty {
                ProfileView()
            } else {
                MainView()
            }
        }
        
    }
}

#Preview {
    ContentView()
}
