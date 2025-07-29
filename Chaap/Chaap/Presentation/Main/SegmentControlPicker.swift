//
//  SegmentControlPicker.swift
//  Chaap
//
//  Created by Enoch on 7/18/25.
//

import SwiftUI

struct SegmentControlPicker: View {
    @Binding var selected: SegmentsModel
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(SegmentsModel.allCases, id: \.self) { item in
                Button(action: {
                    selected = item
                }, label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 36.87)
                            .fill(Color(red: 0.85, green: 0.85, blue: 0.85))
                            .opacity(selected == item ? 0.01 : 0)
                            .background(
                                CHBlurView(style: .systemUltraThinMaterial)
                                    .clipShape(RoundedRectangle(cornerRadius: 36.87))
                                    .opacity(selected == item ? 0.9 : 0)
                                    .clipShape(RoundedRectangle(cornerRadius: 36.87))
                            )
                            .overlay(
                                GradientStroke()
                                    .opacity(selected == item ? 1 : 0)
                            )
                    
                        Image(systemName: item.iconName)
                            .frame(width: 85.25, height: 47)
                            .foregroundStyle(selected == item ? .white.opacity(0.96) : .white.opacity(0.23))
                    }
                })
            }
        }
        .padding(4)
        .frame(height: 55, alignment: .center)
        .background(
            ZStack {
            RoundedRectangle(cornerRadius: 100)
                .fill(Color(red: 0.82, green: 0.82, blue: 0.82).opacity(0.5))
                .fill(Color.black.opacity(0.15))
            
            RoundedRectangle(cornerRadius: 100)
                .fill(.shadow(.inner(color: .white, radius: 1, x: 0, y: -0.5)))
                .opacity(0.3)
            
            RoundedRectangle(cornerRadius: 100)
                .fill(.shadow(.inner(color: .white, radius: 1, x: 0, y: -0.5)))
                .opacity(0.25)
            
            RoundedRectangle(cornerRadius: 100)
                .fill(.shadow(.inner(color: .black, radius: 4, x: 1, y: 1.5)))
                .opacity(0.08)
            
            RoundedRectangle(cornerRadius: 100)
                .fill(.shadow(.inner(color: .black, radius: 4, x: 1, y: 1.5)))
                .opacity(0.1)
            
        })
    }
    
    // MARK: - Picker's BG -> 못씀
    var bgPicker: some View {
        ZStack {
            // BG Color fill
            RoundedRectangle(cornerRadius: 100)
                .fill(Color.black.opacity(0.4))
            
            // TODO: inner shadow 안되는 거 고치기
            // Inner Shadow 1
            RoundedRectangle(cornerRadius: 100)
                .fill(.shadow(.inner(color: Color.white.opacity(0.3), radius: 1, x: 0, y: -0.5)))
            
            // Inner Shadow 2
            RoundedRectangle(cornerRadius: 100)
                .fill(.shadow(.inner(color: Color.white.opacity(0.25), radius: 1, x: 0, y: -0.5)))
            
            // Inner Shadow 3
            RoundedRectangle(cornerRadius: 100)
                .fill(.shadow(.inner(color: Color.black.opacity(0.08), radius: 4, x: 1, y: 1.5)))
            
            // Inner Shadow 4
            RoundedRectangle(cornerRadius: 100)
                .fill(.shadow(.inner(color: Color.black.opacity(0.1), radius: 4, x: 1, y: 1.5)))
        }
    }
}

#Preview {
    MainView()
}
