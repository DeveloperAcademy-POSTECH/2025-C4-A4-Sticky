//
//  SearchView.swift
//  Chaap
//
//  Created by BoMin Lee on 7/17/25.
//

import SwiftUI
import SwiftData

struct SearchView: View {
    @State private var searchText = ""
    
    @Query(sort: [SortDescriptor(\Chaap.createdAt, order: .reverse)]) private var allChaaps: [Chaap]
    
    @EnvironmentObject private var navigationManager: CHNavigationManager
    
    var body: some View {
        NavigationView {
            VStack(spacing: 33) {
                SearchBar(text: $searchText)
                searchList
            }
            .safeAreaPadding(.horizontal, 16)
            .safeAreaPadding(.top, 9)
        }
        .navigationBarBackButtonHidden()
    }
    
    // MARK: - Chaaps filtering
    var filteredChaaps: [Chaap] {
        if searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return allChaaps
        } else {
            return allChaaps.filter { 
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.memo.localizedCaseInsensitiveContains(searchText) ||
                $0.place.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    // MARK: - List
    var searchList: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(filteredChaaps, id: \.id) { chaap in
                    Button {
                        if chaap.isEditable {
                            navigationManager.push(.compose(chaap))
                        } else {
                            navigationManager.push(.detail(chaap))
                        }
                    } label: {
                        HStack(spacing: 16) {
                            // 상대 프로필 이미지
                            if let iconName = chaap.peers.first?.iconName {
                                Image(iconName)
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .frame(width: 44, height: 44)
                                    .background(.white)
                                    .clipShape(Circle())
                                    .shadow(color: .black.opacity(0.1), radius: 3, x: 1.5, y: 1.5)
                                    .shadow(color: .black.opacity(0.05), radius: 1.2, x: 3, y: 3)
                            }
                            
                            VStack(alignment: .leading) {
                                Text(chaap.peers.first?.displayName ?? "이름 없음")
                                    .font(.chSecondaryCaptionMedium)
                                    .foregroundStyle(Color.chLabelBlackSecondary)
                                
                                Spacer()
                                
                                Text(chaap.title)
                                    .font(.chBodyRegular)
                                    .foregroundStyle(Color.chLabelBlackPrimary)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .trailing) {
                                Text(chaap.createdAt.formatted(date: .abbreviated, time: .shortened))
                                    .font(.chSecondaryCaptionMedium)
                                    .foregroundStyle(Color.chLabelBlackSecondary)
                                
                                Spacer()
                                
                                Text(chaap.place)
                                    .font(.chSecondaryCaptionMedium)
                                    .foregroundStyle(Color.chLabelBlackSecondary)
                                
                                Spacer()
                            }
                        }
                        .frame(height: 46)
                        .padding(.vertical, 8)
                    }
                }
            }
        }
    }
}
