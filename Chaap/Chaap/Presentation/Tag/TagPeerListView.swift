//
//  TagPeerListView.swift
//  Chaap
//
//  Created by BoMin Lee on 7/25/25.
//

import SwiftUI
import MultipeerConnectivity

struct TagPeerListView: View {
    var mpcManager: MultipeerConnectivityManager
    var onPeerSelected: (MCPeerID) -> Void
    
    var body: some View {
        List {
            ForEach(mpcManager.nearbyPeers, id: \.self) { peer in
                Button {
                    print("연결하기 버튼 누름")
                    mpcManager.invite(peer)
                    onPeerSelected(peer)
                } label : {
                    HStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 54, height: 54)
                            Image(systemName: "fossil.shell")
                                .foregroundStyle(Color.black.opacity(0.5))
                        }
                        Text(peer.displayName)
                            .font(.chBodyMedium)
                            .foregroundStyle(Color.chLabelWhitePrimary)
                        Spacer()
                        // TODO: Component 만들어서 연결 필요
                        Text("연결하기")
                            .font(.chBodyRegular)
                            .foregroundStyle(Color.chLabelWhitePrimary)
                    }
                    .background(Color.clear)
                }
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
            }
        }
        .listRowSeparator(.hidden)
        .listStyle(PlainListStyle())
        .scrollContentBackground(.hidden)
        .background(Color.clear)
    }
}
