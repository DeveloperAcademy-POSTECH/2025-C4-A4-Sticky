//
//  PeopleSegmentView.swift
//  Chaap
//
//  Created by BoMin Lee on 7/17/25.
//

import SwiftUI
import SwiftData

struct PeopleSegmentView: View {
    @EnvironmentObject private var navigationManager: CHNavigationManager
    
    @Query(sort: [SortDescriptor(\Chaap.createdAt, order: .reverse)])
    var allChaaps: [Chaap]
    
    let columns = Array(repeating: GridItem(.flexible()), count: 3)

    // Chaap에서 모든 Peer를 추출
    var allPeers: [Peer] {
        allChaaps.flatMap { $0.peers }
    }
    
    // displayName 기준으로 그룹화
    var groupedPeers: [String: [Peer]] {
        Dictionary(grouping: allPeers, by: { $0.displayName })
    }
    
    // 정렬된 이름 목록
    var displayNames: [String] {
        groupedPeers.keys.sorted()
    }

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 32) {
                ForEach(displayNames, id: \.self) { name in
                    if let peersForName = groupedPeers[name],
                       let iconName = peersForName.first?.iconName {
                        Button {
                            navigationManager.push(.people(name, peersForName))
                        } label: {
                            PeopleCircle(name: name, iconName: iconName)
                        }
                    }
                }
            }
            .padding(.horizontal, 22)
        }
        .padding(.top, 155)
    }
}

#Preview {
    PeopleSegmentView()
}
