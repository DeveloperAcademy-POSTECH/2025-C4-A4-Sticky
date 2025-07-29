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
            // TODO: 색 조정 필요
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
                .background(.black.opacity(0.4))
                .clipShape(Circle())
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
