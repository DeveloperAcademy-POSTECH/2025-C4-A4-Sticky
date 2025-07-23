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
            VStack(spacing: 0) {
                /// Top navigation
                HStack {
                    /// Back button
                    Button(action: backTapped) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                            .frame(width: 40, height: 40)
                            .background(Color.white.opacity(0.2))
                            .clipShape(Circle())
                    }
                    
                    Spacer()
                    
                    /// Person name
                    Text(person.name)
                        .font(.chBodyBold)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    /// Invisible spacer to center the name
                    Rectangle()
                        .frame(width: 40, height: 40)
                        .opacity(0)
                }
                .padding(.horizontal, 20)
                .padding(.top, 60)
                
                /// Card counter
                Text("\(person.currentCard) / \(person.totalCards)")
                    .font(.chBodyRegular)
                    .foregroundColor(.white)
                    .padding(.top, 71)
                
                Spacer()
                
                /// Person card
                VStack(spacing: 0) {
                    /// Card content
                    VStack(spacing: 16) {
                        /// Person avatar and name
                        VStack(spacing: 8) {
                            ZStack {
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 50, height: 50)
                                
                                Image(systemName: person.imageName)
                                    .font(.system(size: 24))
                                    .foregroundColor(.gray)
                            }
                            
                            Text("with \(person.name.lowercased())")
                                .font(.chPrimaryCaptionMedium)
                                .foregroundColor(.white)
                        }
                        
                        /// Date and time
                        Text("2025.07.08 화요일 18:00")
                            .font(.chSecondaryCaptionRegular)
                            .foregroundColor(.white.opacity(0.8))
                        
                        Spacer()
                            .frame(height: 20)
                        
                        /// Title
                        Text("카페 공쥬!")
                            .font(.chBodyBold)
                            .foregroundColor(.white)
                        
                        /// Korean text content
                        VStack(alignment: .leading, spacing: 8) {
                            Text("패피와 같이 카페에서 공부를 했다.")
                            Text("역시 공부는 집에서 안하는 것 같다..")
                            Text("무즈진 밖에 나와야 한다..!")
                        }
                        .font(.chPrimaryCaptionRegular)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                        
                        Spacer()
                            .frame(height: 20)
                        
                        /// Location
                        HStack {
                            Image(systemName: "location")
                                .font(.system(size: 12))
                                .foregroundColor(.white)
                            
                            Text("두낫지스터빗 홍차")
                                .font(.chSecondaryCaptionRegular)
                                .foregroundColor(.white)
                        }
                    }
                    .padding(32)
                    .frame(width: 280, height: 380)
                    .background(
                        RoundedRectangle(cornerRadius: 24)
                            .fill(Color.white.opacity(0.15))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                    )
                }
                .padding(.horizontal, 40)
                
                Spacer()
                Spacer()
            }
        }
        .background(.black.opacity(0.05))
        .background(
            EllipticalGradient(
                stops: [
                    Gradient.Stop(
                        color: Color(red: 0.11, green: 0.22, blue: 0.53),
                        location: 0.00
                    ),
                    Gradient.Stop(
                        color: Color(red: 0.62, green: 0.66, blue: 0.88),
                        location: 1.00
                    ),
                ],
                center: UnitPoint(x: -0.05, y: 0.21)
            )
        )
        .ignoresSafeArea()
        .navigationBarHidden(true)
    }
    
    // MARK: - Event Handlers
    
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