//
//  CHMainButton.swift
//  Chaap
//
//  Created by Enoch on 7/29/25.
//

import SwiftUI

struct CHMainButton: View {
    var fontStyle: String = ""
    var actionType: MainButtonAction
    var action: () -> Void = {}
    var isEnabled: Bool = true
    
    var body: some View {
        ZStack {
            Button(action: action) {
                HStack(alignment: .center) {
                    Text(actionType.title)
                        .font(actionType.font)
                        .foregroundStyle(actionType.textColor)
                }
                .padding(.vertical, actionType.verticalPadding)
                .frame(maxWidth: .infinity)
                .background(
                    backgroundView
                )
                .background(
                    CHBlurView(style: .systemUltraThinMaterialDark)
                        .clipShape(RoundedRectangle(cornerRadius: 50))
                )
                .cornerRadius(50)
                .shadow(color: .black.opacity(0.1), radius: 4.6087, x: 4.6087, y: 4.6087)
                .overlay(
                    GradientStroke()
                )
            }
        }
    }
    
    // MARK: - button background color
    @ViewBuilder
    var backgroundView: some View {
        if actionType == .save {
            if isEnabled {
                EllipticalGradient(
                    stops: [
                        Gradient.Stop(color: Color(hex: "#051A6B"), location: 0.0),
                        Gradient.Stop(color: Color(hex: "#051A6B").opacity(0.5), location: 1.0)
                    ],
                    center: UnitPoint(x: 0.49, y: 0)
                )
                .clipShape(RoundedRectangle(cornerRadius: 50))
            } else {
                Color(hex: "#D9D9D9")
                    .clipShape(RoundedRectangle(cornerRadius: 50))
            }
        } else if actionType == .accept || actionType == .connect {
            EllipticalGradient(
                stops: [
                    Gradient.Stop(color: Color(hex: "#051A6B"), location: 0.0),
                    Gradient.Stop(color: Color(hex: "#051A6B").opacity(0.5), location: 1.0)
                ],
                center: UnitPoint(x: 0.49, y: 0)
            )
            .clipShape(RoundedRectangle(cornerRadius: 50))
        } else {
            Color(hex: "#D9D9D9")
                .clipShape(RoundedRectangle(cornerRadius: 50))
        }
    }
}

#Preview {
    CHMainButton(actionType: .save)
}
