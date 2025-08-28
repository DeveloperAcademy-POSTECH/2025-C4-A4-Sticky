//
//  CHCircleButton.swift
//  Chaap
//
//  Created by Enoch on 8/28/25.
//

import SwiftUI

struct CHCircleButton: View {
    var buttonImageName: String
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.chBackgroundPrimary)
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.3), lineWidth: 1.5)
                        .offset(x: 0, y: -0.5)
                        .mask(
                            Circle()
                                .fill(LinearGradient(colors: [.white, .white.opacity(0)], startPoint: .bottom, endPoint: .top))
                        )
                )
                .overlay(
                    Circle()
                        .stroke(Color.black.opacity(0.1), lineWidth: 4)
                        .offset(x: 1, y: 1.5)
                        .blur(radius: 1)
                        .mask(
                            Circle()
                                .fill(LinearGradient(colors: [.white, .white.opacity(0)], startPoint: .top, endPoint: .bottom))
                        )
                )
                .frame(width: 44, height: 44)
        
            Image(systemName: buttonImageName)
                .resizable()
                .scaledToFit()
                .foregroundStyle(Color.chLabelWhitePrimary)
                .frame(height: 20)
        }
    }
}

#Preview {
    CHCircleButton(buttonImageName: "chevron.backward")
}
