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
                        if let firstPeer = chaap.peers.first {
                            Text(String(firstPeer.displayName.prefix(1)).uppercased())
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.black)
                        } else {
                            Image(systemName: "person.fill")
                                .font(.system(size: 16))
                                .foregroundColor(.gray)
                        }
                    }
                )
            
            VStack(alignment: .leading, spacing: 4) {
                // 사람 이름
                if !chaap.peers.isEmpty {
                    Text(chaap.peers.map { $0.displayName }.joined(separator: ", "))
                        .font(.chSecondaryCaptionRegular)
                        .foregroundStyle(Color.chLabelWhiteSecondary)
                }
                
                // 제목
                if let title = chaap.title, !title.isEmpty {
                    Text(title)
                        .font(.chBodyMedium)
                        .foregroundStyle(Color.chLabelWhitePrimary)
                        .lineLimit(1)
                } else {
                    /// title 빈 경우 공백으로 자리 차지
                    Text("")
                        .font(.chBodyMedium)
                        .foregroundStyle(Color.chLabelWhitePrimary)
                        .lineLimit(1)
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                // 날짜 시간
                Text(formatDateTime(chaap.createdAt))
                    .font(.chSecondaryCaptionRegular)
                    .foregroundStyle(Color.chLabelWhiteSecondary)
                
                // 장소
                if let place = chaap.place, !place.isEmpty {
                    Text(place)
                        .font(.chSecondaryCaptionRegular)
                        .foregroundStyle(Color.chLabelWhiteSecondary)
                        .lineLimit(1)
                } else {
                    Text("")
                        .font(.chSecondaryCaptionRegular)
                        .foregroundStyle(Color.chLabelWhiteSecondary)
                        .lineLimit(1)
                }
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
