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
        HStack(spacing: 12) {
            // 원형 프로필 이미지
            Circle()
                .fill(Color.white)
                .frame(width: 40, height: 40)
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
            
            VStack(alignment: .leading, spacing: 4) {
                // 사람 이름
                if !chaap.peers.isEmpty {
                    Text(chaap.peers.map { $0.displayName }.joined(separator: ", "))
                        .font(.chSecondaryCaptionMedium)
                        .lineHeight(1.4, fontSize: 11)
                        .foregroundStyle(Color.chLabelWhiteSecondary)
                }
                
                // 제목
                Text(chaap.title)
                        .font(.chBodyMedium)
                        .lineHeight(1.4, fontSize: 18)
                        .foregroundStyle(Color.chLabelWhitePrimary)
                        .lineLimit(1)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                // 날짜 시간
                Text(formatDateTime(chaap.createdAt))
                    .font(.chSecondaryCaptionMedium)
                    .lineHeight(1.4, fontSize: 11)
                    .foregroundStyle(Color.chLabelWhiteSecondary)
                
                // 장소
                Text(chaap.place)
                    .font(.chSecondaryCaptionMedium)
                    .lineHeight(1.4, fontSize: 11)
                    .foregroundStyle(Color.chLabelWhiteSecondary)
                    .lineLimit(1)
            }
        }
        .padding(.vertical, 4)
    }
    
    // 날짜 시간 포맷 함수
    private func formatDateTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd 월요일 HH:mm"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
}
