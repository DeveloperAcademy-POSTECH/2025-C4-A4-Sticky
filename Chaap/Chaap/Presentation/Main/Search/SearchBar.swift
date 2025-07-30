//
//  SearchBar.swift
//  Chaap
//
//  Created by Enoch on 7/26/25.
//
import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    @Environment(\.presentationMode) var presentaionMode
    @EnvironmentObject private var navigationManager: CHNavigationManager

    var body: some View {
        HStack(spacing: 8) {
            ZStack {
                RoundedRectangle(cornerRadius: 100)
                    .foregroundColor(Color.black.opacity(0.05))
                    .frame(height: 44)
                    .overlay(
                        RoundedRectangle(cornerRadius: 100)
                            .stroke(Color.black.opacity(0.1), lineWidth: 3)
                            .blur(radius: 1)
                            .offset(x: 1, y: 2)
                            .mask(
                                RoundedRectangle(cornerRadius: 100)
                                    .fill(LinearGradient(colors: [.black, .black], startPoint: .topLeading, endPoint: .bottomTrailing))
                            )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 100)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                            .offset(x: 0, y: -1)
                            .mask(
                                RoundedRectangle(cornerRadius: 100)
                                    .fill(LinearGradient(colors: [.white, .white.opacity(0.6)], startPoint: .topLeading, endPoint: .bottomTrailing))
                            )
                    )
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(Color.chLabelBlackSecondary)
                    
                    ZStack(alignment: .leading) {
                        if text.isEmpty{
                            Text("사람, 장소, 내용 등")
                                .font(.chPrimaryCaptionMedium)
                                .foregroundStyle(Color.chLabelBlackSecondary)
                        }
                        TextField("", text: $text)
                            .font(.chPrimaryCaptionMedium)
                            .foregroundStyle(Color.chLabelBlackPrimary)
                            .tint(.chPrimary)
                    }
                }
                .padding(.vertical, 11)
                .padding(.horizontal, 16)
            }
        
            Button("취소") {
                navigationManager.pop()
            }
            .font(.chPrimaryCaptionMedium)
            .foregroundStyle(Color(hex: "#202020"))
        }
    }
}
