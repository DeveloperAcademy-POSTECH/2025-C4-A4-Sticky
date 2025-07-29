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
        ScrollView {
            LazyVStack {
                ForEach(mpcManager.nearbyPeers, id: \.self) { peer in
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
                        
                        CHMainButton(
                            actionType: .connect,
                            action: {
                                print("연결하기 버튼 누름")
                                mpcManager.invite(peer)
                                onPeerSelected(peer)
                            }
                        )
                        .frame(width: 89)
                    }
                }
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color.clear)
    }
        
}
