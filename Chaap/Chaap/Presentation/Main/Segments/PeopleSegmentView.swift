//
//  PeopleSegmentView.swift
//  Chaap
//
//  Created by BoMin Lee on 7/17/25.
//

import SwiftUI
import SwiftData

struct PeopleSegmentView: View {
    @Query(sort: [SortDescriptor(\Chaap.createdAt, order: .reverse)])
    var allChaaps: [Chaap]
    
    let columns = Array(repeating: GridItem(.flexible()), count: 3)

    // Chaap에서 모든 Peer를 추출
    var allPeers: [Peer] {
        allChaaps.flatMap { $0.peers }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 32) {
                    ForEach(allPeers, id: \.tokenString) { peer in
                        NavigationLink(destination: PeopleDetailView(peer: peer)) {
                            PeopleCircle(name: peer.displayName, iconName: peer.iconName)
                        }
                    }
                }
                .padding(.horizontal, 22)
            }
            .padding(.top, 155)
        }
        
    }
}

#Preview {
    PeopleSegmentView()
}
