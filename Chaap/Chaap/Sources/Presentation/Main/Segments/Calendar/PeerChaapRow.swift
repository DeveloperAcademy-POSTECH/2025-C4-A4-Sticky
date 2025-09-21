//
//  PeerChaapRow.swift
//  Chaap
//
//  Created by BoMin Lee on 7/28/25.
//

import SwiftUI

struct PeerChaapRow: View {
    var chaap: Chaap
    
    var body: some View {
        HStack(spacing: 16) {
            // 원형 프로필 이미지
            Circle()
                .fill(Color.white)
                .frame(width: 54, height: 54)
                .overlay(
                    Circle()
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
                .overlay(
                    // 나비 아이콘 또는 사람 이름 첫 글자
                    Group {
                        if let iconName = chaap.peers.first?.iconName {
                            Image(iconName)
                                .resizable()
                                .frame(width: 24, height: 24)
                                .frame(
                                    maxWidth: .infinity,
                                    minHeight: 44,
                                    maxHeight: 44,
                                    alignment: .center
                                )
                                .background(.white)
                                .clipShape(Circle())
                        } else {
                            Image(.profileButterfly)
                                .resizable()
                                .frame(width: 24, height: 24)
                                .frame(
                                    maxWidth: .infinity,
                                    minHeight: 44,
                                    maxHeight: 44,
                                    alignment: .center
                                )
                                .background(.white)
                                .clipShape(Circle())
                        }
                    }
                )
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    // 사람 이름
                    if !chaap.peers.isEmpty {
                        Text(chaap.peers.map { $0.displayName }.joined(separator: ", "))
                            .multilineTextAlignment(.leading)
                            .font(.chSecondaryCaptionMedium)
                            .lineHeight(1.2, fontSize: 12)
                            .foregroundStyle(Color.chLabelWhiteSecondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    // 제목
                    Text(chaap.title)
                        .multilineTextAlignment(.leading)
                        .font(.chBodyMedium)
                        .lineHeight(1.2, fontSize: 18)
                        .foregroundStyle(Color.chLabelWhitePrimary)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(width: 146, height: 46)
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    // 날짜 시간
                    Text(formatDateTime(chaap.createdAt))
                        .font(.chSecondaryCaptionMedium)
                        .lineHeight(1.2, fontSize: 12)
                        .foregroundStyle(Color.chLabelWhiteSecondary)
                        .lineLimit(1)
                    
                    // 장소
                    Text(chaap.place)
                        .font(.chSecondaryCaptionMedium)
                        .lineHeight(1.2, fontSize: 12)
                        .foregroundStyle(Color.chLabelWhiteSecondary)
                        .lineLimit(1)
                }
                .frame(height: 46, alignment: .topTrailing)
            }
            .padding(.vertical, 4)
        }
        .frame(minWidth: 361)
    }
    
    // 날짜 시간 포맷 함수
    private func formatDateTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd 월요일 HH:mm"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
}
