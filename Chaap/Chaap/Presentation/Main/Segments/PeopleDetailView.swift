//
//  PeopleDetailView.swift
//  Chaap
//
//  Created by BoMin Lee on 7/17/25.
//

import SwiftUI
import SwiftData

struct PeopleDetailView: View {
    let displayName: String
    let peers: [Peer]
    
    @Environment(\.presentationMode) var presentationMode
    
    @Query(sort: [SortDescriptor(\Chaap.createdAt, order: .reverse)])
    var allChaaps: [Chaap]
    
    // 이 Peer들이 포함된 Chaap만 추출
    var filteredChaaps: [Chaap] {
        allChaaps.filter { chaap in
            chaap.peers.contains { peer in
                peer.displayName == displayName
            }
        }
    }

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
                        Text(displayName)
                            .font(.systemEmphasized)
                            .foregroundColor(.white)
                        
                        Spacer()
                    }
                }
                .padding(.horizontal, 16)
                
                /// Card counter
                Text("n / \(filteredChaaps.count)")
                    .font(.chBodyBold)
                    .foregroundColor(.white)
                
                /// Person card
//                ScrollView(.horizontal) {
                    VStack(spacing: 16) {
                        ForEach(allChaaps, id: \.id) { chaap in
                            // TODO: CardView or ChaapCellView
                            VStack {
                                Text("Chaap")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Text(chaap.createdAt.formatted(date: .abbreviated, time: .shortened))
                                    .foregroundColor(.white)
                            }
                            .padding()
                            .background(Color.black.opacity(0.2))
                            .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal, 16)
//                }
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
