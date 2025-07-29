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
            HStack {
                Image(systemName: "magnifyingglass")

                TextField("사람, 장소, 내용 등", text: $text)
                    .foregroundColor(.primary)
                    .autocapitalization(.none)
                

//                if !text.isEmpty {
//                    Button(action: {
//                        text = ""
//                    }) {
//                        Image(systemName: "xmark.circle.fill")
//                            .foregroundStyle(.gray)
//                    }
//                }
            }
            .padding(.vertical, 11)
            .padding(.horizontal, 16)
            .foregroundColor(.secondary)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(100)
            
            Button("취소") {
                navigationManager.pop()
            }
            .font(.chPrimaryCaptionMedium)
            .foregroundStyle(Color(hex: "#202020"))
        }
    }
}
