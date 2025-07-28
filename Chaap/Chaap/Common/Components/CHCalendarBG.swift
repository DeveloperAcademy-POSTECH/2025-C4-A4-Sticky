//
//  CHCalendarBG.swift
//  Chaap
//
//  Created by Assistant on 7/25/25.
//

import SwiftUI

struct CHCalendarBG: View {
    let bottomExtension: CGFloat
    
    init(bottomExtension: CGFloat = 0) {
        self.bottomExtension = bottomExtension
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 36.87)
                .fill(Color(red: 0.85, green: 0.85, blue: 0.85).opacity(0.01))
                .background(
                    CHBlurView(style: .systemUltraThinMaterialDark)
                        .clipShape(RoundedRectangle(cornerRadius: 36.87))
                )
                .overlay(
                    GradientStroke()
                )
                .shadow(
                    color: .black.opacity(0.1),
                    radius: 4.6087,
                    x: 4.6087,
                    y: 4.6087
                )
                .padding(.bottom, -bottomExtension)
        }
    }
}
