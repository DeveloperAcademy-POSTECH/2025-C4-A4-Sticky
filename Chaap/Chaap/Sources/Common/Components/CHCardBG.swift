//
//  CHCard.swift
//  Chaap
//
//  Created by Enoch on 7/22/25.
//

import SwiftUI

struct CHCardBG: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 36.87)
                .fill(.black.opacity(0.3))
                .background(
                    CHBlurView(style: .systemUltraThinMaterialDark)
                        .clipShape(RoundedRectangle(cornerRadius: 36.87))
                )
                .overlay(
                    GradientStroke()
                )
                .shadow(color: .black.opacity(0.1), radius: 4.6087, x: 4.6087, y: 4.6087)
        }
    }
}
