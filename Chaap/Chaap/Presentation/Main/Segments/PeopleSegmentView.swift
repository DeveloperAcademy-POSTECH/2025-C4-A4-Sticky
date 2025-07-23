//
//  PeopleSegmentView.swift
//  Chaap
//
//  Created by BoMin Lee on 7/17/25.
//

import SwiftUI

/// Person model for mock data
struct Person: Identifiable {
    let id = UUID()
    let name: String
    let imageName: String
    let totalCards: Int
    let currentCard: Int
}

struct PeopleSegmentView: View {
    @State private var selectedTabIndex = 1 // People tab selected by default
    
    /// Mock data for people
    private let people = [
        Person(name: "Enoch", imageName: "person.fill", totalCards: 13, currentCard: 1),
        Person(name: "Mumin", imageName: "person.fill", totalCards: 8, currentCard: 1),
        Person(name: "Minbol", imageName: "person.fill", totalCards: 5, currentCard: 1),
        Person(name: "Peppr", imageName: "person.fill", totalCards: 13, currentCard: 1),
        Person(name: "Jacob", imageName: "person.fill", totalCards: 7, currentCard: 1),
        Person(name: "Hari", imageName: "person.fill", totalCards: 12, currentCard: 1),
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack(spacing: 0) {
                    /// Top navigation bar
                    HStack {
                        Spacer()
                        
                        HStack(spacing: 16) {
                            /// Search icon
                            Button(action: searchTapped) {
                                Image(systemName: "magnifyingglass")
                                    .font(.system(size: 20))
                                    .foregroundColor(.white)
                                    .frame(width: 40, height: 40)
                                    .background(Color.white.opacity(0.2))
                                    .clipShape(Circle())
                            }
                            
                            /// Profile icon
                            Button(action: profileTapped) {
                                Image(systemName: "person.crop.circle")
                                    .font(.system(size: 20))
                                    .foregroundColor(.white)
                                    .frame(width: 40, height: 40)
                                    .background(Color.white.opacity(0.2))
                                    .clipShape(Circle())
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 60)
                    
                    /// Navigation tabs
                    HStack {
                        ForEach(0..<4) { index in
                            let icons = ["message", "person.2", "calendar", "map"]
                            let isSelected = index == selectedTabIndex
                            
                            Button(action: { tabTapped(at: index) }) {
                                Image(systemName: icons[index])
                                    .font(.system(size: 18))
                                    .foregroundColor(isSelected ? .black : .white)
                                    .frame(width: 50, height: 50)
                                    .background(
                                        isSelected ? Color.white : Color.white.opacity(0.2)
                                    )
                                    .clipShape(Circle())
                            }
                        }
                    }
                    .padding(.horizontal, 40)
                    .padding(.top, 90)
                    
                    Spacer()
                    
                    /// People grid
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                    ], spacing: 40) {
                        ForEach(people) { person in
                            VStack(spacing: 8) {
                                NavigationLink(
                                    destination: PeopleDetailView(person: person)
                                ) {
                                    ZStack {
                                        /// Circle background
                                        Circle()
                                            .fill(
                                                person.name == "Mumin" 
                                                ? Color.white 
                                                : Color.white.opacity(0.2)
                                            )
                                            .frame(width: 80, height: 80)
                                        
                                        /// Person icon
                                        Image(systemName: person.imageName)
                                            .font(.system(size: 30))
                                            .foregroundColor(
                                                person.name == "Mumin" ? .gray : .white
                                            )
                                    }
                                }
                                
                                Text(person.name)
                                    .font(.chPrimaryCaptionMedium)
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    .padding(.horizontal, 40)
                    
                    Spacer()
                    
                    /// Bottom tagging button
                    Button(action: taggingTapped) {
                        Image(systemName: "asterisk")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                            .frame(width: 60, height: 60)
                            .background(Color.white.opacity(0.3))
                            .clipShape(Circle())
                    }
                    .padding(.bottom, 50)
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
        }
    }
    
    // MARK: - Event Handlers
    
    private func searchTapped() {
        // TODO: Search functionality
    }
    
    private func profileTapped() {
        // TODO: Profile functionality
    }
    
    private func tabTapped(at index: Int) {
        selectedTabIndex = index
    }
    
    private func taggingTapped() {
        // TODO: Tagging functionality
    }
}

#Preview {
    PeopleSegmentView()
}
