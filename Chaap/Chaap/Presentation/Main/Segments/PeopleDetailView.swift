//
//  PeopleDetailView.swift
//  Chaap
//
//  Created by BoMin Lee on 7/17/25.
//

import SwiftUI

struct PeopleDetailView: View {
    let person: Person
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            VStack(spacing: 62) {
                /// Top navigation
                ZStack {
                    HStack {
                        /// Back button
                        Button(action: backTapped) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                                .frame(width: 40, height: 40)
                                .background(Color.black.opacity(0.4))
                                .clipShape(Circle())
                        }
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        Text(person.name)
                            .font(.systemEmphasized)
                            .foregroundColor(.white)
                        
                        Spacer()
                    }
                }
                .padding(.horizontal, 16)
                
                /// Card counter
                Text("\(person.currentCard) / \(person.totalCards)")
                    .font(.chBodyBold)
                    .foregroundColor(.white)
                
                /// Person card
                // TODO: CardView 추가 예정
                Spacer()
            }
        }
        // TODO: Custom Background에 얹을 거라서 삭제
        .background(.blue)
        .navigationBarHidden(true)
    }
    
    // TODO: 네비게이션 연결 방식에 따라 변경
    private func backTapped() {
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    NavigationView {
        PeopleDetailView(
            person: Person(
                name: "Peppr",
                imageName: "person.fill",
                totalCards: 13,
                currentCard: 1
            )
        )
    }
} 
