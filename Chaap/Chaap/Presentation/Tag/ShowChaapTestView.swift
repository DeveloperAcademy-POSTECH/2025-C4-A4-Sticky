//
//  ShowChaapTestView.swift
//  Chaap
//
//  Created by BoMin Lee on 7/27/25.
//

import SwiftUI
import SwiftData

struct ShowChaapTestView: View {
    @Query var chaaps: [Chaap]

    var body: some View {
        NavigationStack {
            Text("저장된 Chaap 수: \(chaaps.count)")
            List {
                ForEach(chaaps) { chaap in
                    VStack(alignment: .leading, spacing: 8) {
                        Text("🕰️ \(chaap.createdAt.formatted(date: .abbreviated, time: .shortened))")
                        Text("📍 \(chaap.place ?? "위치 없음")")
                            .font(.subheadline)
                        if let title = chaap.title {
                            Text("📝 제목: \(title)")
                                .font(.footnote)
                        }
                        ForEach(chaap.peers) { peer in
                            Text("\(peer.displayName)")
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
            .navigationTitle("Chaap 기록")
        }
    }
}
