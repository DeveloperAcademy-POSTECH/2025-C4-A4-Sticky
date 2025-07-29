//
//  CHNavBar.swift
//  Chaap
//
//  Created by Enoch on 7/25/25.
//

import SwiftUI

struct CHNavBar: View {
    @Binding var selectedImageName: String?
    var didPressSearchButton: () -> Void
    var didPressProfileButton: () -> Void
    
    var body: some View {
        HStack(spacing: 9) {
            Spacer()
            searchButton
            profileButton
        }
    }
    
    // MARK: - Search Button
    var searchButton: some View {
        Button(action: {
            didPressSearchButton()
        }, label: {
            VStack {
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .foregroundStyle(Color(hex: "#CECECE"))
                    .mask({
                        Color.white
                            .blendMode(.lighten)
                    })
                    .frame(width: 16.39, height: 16.54)
                    .padding(.horizontal,11.80)
                    .padding(.vertical, 11.73)
                    .frame(width: 44, height: 44)
                    .clipShape(Circle())
            }
        })
        /// Inner Shadow
        .background(
            ZStack {
                Circle()
                    .fill(Color(red: 0.82, green: 0.82, blue: 0.82).opacity(0.5))
                    .fill(Color.black.opacity(0.15))
                
                Circle()
                    .fill(.shadow(.inner(color: .white, radius: 1, x: 0, y: -0.5)))
                    .opacity(0.3)
                
                Circle()
                    .fill(.shadow(.inner(color: .white, radius: 1, x: 0, y: -0.5)))
                    .opacity(0.25)
                
                Circle()
                    .fill(.shadow(.inner(color: .black, radius: 4, x: 1, y: 1.5)))
                    .opacity(0.08)
                
                Circle()
                    .fill(.shadow(.inner(color: .black, radius: 4, x: 1, y: 1.5)))
                    .opacity(0.1)
                
            })
    }
    
    // MARK: - Profile Button
    var profileButton: some View {
        Button(action: {
            didPressProfileButton()
        }, label: {
            ZStack {
                Circle()
                    .frame(width: 44, height: 44)
                    .foregroundColor(Color.chLabelWhitePrimary)
                
                if let imageName = selectedImageName, !imageName.isEmpty {
                    Image(imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 24, height: 24)
                } else {
                    Image(.profileButterfly)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 24, height: 24)
                }
            }
        })
    }
}
