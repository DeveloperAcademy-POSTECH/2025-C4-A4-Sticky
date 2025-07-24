//
//  SegmentControlPicker.swift
//  Chaap
//
//  Created by Enoch on 7/18/25.
//

import SwiftUI

struct SegmentControlPicker: View {
    @Binding var selected: Segments
    
    var body: some View {
        HStack {
            ForEach(Segments.allCases, id: \.self) { item in
                Button(action: {
                    selected = item
                }, label: {
                    ZStack {
                        if selected == item {
//                            BlurView(style: .systemUltraThinMaterial)
//                                .clipShape(RoundedRectangle(cornerRadius: 36.9))
                        }
                        
                        Image(systemName: item.iconName)
                            .foregroundStyle(selected == item ? .white.opacity(0.96) : .white.opacity(0.23))
                            .padding(.horizontal, 28)
                    }
                })
            }
        }
        .padding(4)
        .frame(width: 361, height: 55, alignment: .center)
        .background(bgPicker)
    }
    
    // MARK: - Picker's BG
    var bgPicker: some View {
        ZStack {
            // BG Color fill
            RoundedRectangle(cornerRadius: 100)
                .fill(Color.black.opacity(0.4))
            
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
