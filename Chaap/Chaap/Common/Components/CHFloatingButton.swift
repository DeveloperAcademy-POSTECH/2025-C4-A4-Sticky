//
//  CHFloatingBtn.swift
//  Chaap
//
//  Created by Enoch on 7/25/25.
//

import SwiftUI
import SwiftData

struct CHFloatingButton: View {
    @EnvironmentObject private var navManager: CHNavigationManager

    var body: some View {
        Button(action: {
            navManager.push(.tagView)
        }, label: {
            Image(.chaapBtn)
                .resizable()
                .frame(width: 33.37298, height: 31.7691)
                .padding(26)
                .background(.black.opacity(0.1))
                .background(
                    CHBlurView(style: .systemUltraThinMaterialDark)
                        .clipShape(Circle())
                )
                .clipShape(Circle())
                .overlay(
                    ZStack {
                        Circle()
                            .inset(by: 0.46)
                            .stroke(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.white.opacity(0),
                                        Color.white.opacity(0.6 * 0.2)
                                    ]),
                                    startPoint: .center,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 0.92
                            )
                            .stroke(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color(hex: "#EEEEEE").opacity(0.8 * 0.2),
                                        Color(hex: "#EEEEEE").opacity(0)
                                    ]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                ),
                                lineWidth: 0.92
                            )
                            .stroke(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.white.opacity(0.6),
                                        Color.white.opacity(0.1)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .center
                                ),
                                lineWidth: 0.92
                            )
                    }
                )
        })
    }
}

#Preview {
    CHFloatingButton()
}
