//
//  GradientStroke.swift
//  Chaap
//
//  Created by Enoch on 7/18/25.
//

import SwiftUI

struct GradientStroke: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 36.87)
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
                            Color.white.opacity(0.6 * 0.5),
                            Color.white.opacity(0.1 * 0.5)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .center
                    ),
                    lineWidth: 0.92
                )
        }
    }
}

#Preview {
    GradientStroke()
}
