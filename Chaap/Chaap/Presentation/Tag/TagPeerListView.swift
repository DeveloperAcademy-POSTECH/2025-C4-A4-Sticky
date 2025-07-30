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
                    HStack {
                        Text(peer.displayName)
                            .font(.chTitleSemibold)
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
                    .frame(height: 46)
                }
            }
            .padding(.top, 8)
        }
        .scrollContentBackground(.hidden)
        .background(Color.clear)
    }
        
}
