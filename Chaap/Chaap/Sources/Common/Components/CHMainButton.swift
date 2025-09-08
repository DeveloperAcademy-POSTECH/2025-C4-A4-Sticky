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
                        .lineHeight(1.4, fontSize: actionType.fontSize)
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
                RadialGradient(
                    gradient: Gradient(colors: [
                        Color(hex: "#051A6B"),
                        Color(hex: "#051A6B").opacity(0.5)
                    ]),
                    center: .top, startRadius: 0, endRadius: 300
                )
            } else {
                Color(hex: "#D9D9D9")
                    .opacity(0.25)
                    .clipShape(RoundedRectangle(cornerRadius: 50))
            }
        } else if actionType == .accept || actionType == .connect {
            RadialGradient(
                gradient: Gradient(colors: [
                    Color(hex: "#051A6B"),
                    Color(hex: "#051A6B").opacity(0.5)
                ]),
                center: .top, startRadius: 0, endRadius: 500
            )
        } else {
            Color(hex: "#D9D9D9")
                .opacity(0.25)
                .clipShape(RoundedRectangle(cornerRadius: 50))
        }
    }
}

#Preview {
    CHMainButton(actionType: .save)
}
