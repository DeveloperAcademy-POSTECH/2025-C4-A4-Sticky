//
//  CHCardShow.swift
//  Chaap
//
//  Created by Enoch on 7/22/25.
//

import SwiftUI
import SwiftData

struct CHCardShow: View {
    let chaap: Chaap
    
    var body: some View {
        ZStack {
            CHCardBG()
            
            // TODO: 데이터 가져와서 넣기
            VStack {
                topContent
                Spacer()
                middleContent
                Spacer()
                bottomContent
            }
            .padding(24)
            
        }
    }
    
    // MARK: - top content (profile, date)
    var topContent: some View {
        VStack(spacing: 8) {
            // 상대 프로필 이미지
            Circle()
                .frame(width: 44, height: 44)
                .foregroundStyle(.white)
            
            // 상대 프로필 닉네임
            Text("with \(chaap.peers.first?.displayName ?? "이름 없음")")
                .font(.chBodyBold)
                .foregroundStyle(.white)
            
            Text(chaap.createdAt.formatted(date: .abbreviated, time: .shortened))
                .font(.caption)
                .foregroundStyle(.white.opacity(0.8))
        }
    }
    
    // MARK: - middle content (title, content)
    var middleContent: some View {
        VStack(spacing: 8) {
            // 기록 제목
            Text(chaap.title ?? "제목 없음")
                .font(.chBodyBold)
                .foregroundStyle(.white)
            
            // 기록 내용
            Text(chaap.memo ?? "내용 없음")
                .font(.chBodyRegular)
                .foregroundStyle(.white.opacity(0.8))
        }
    }
    
    // MARK: - bottom content (location)
    var bottomContent: some View {
        HStack(spacing: 4) {
            // 장소 아이콘
            Image(systemName: "pin.fill")
                .foregroundStyle(.white.opacity(0.8))
            
            // 위치 정보
            Text(chaap.place ?? "위치 없음")
                .font(.caption)
                .foregroundStyle(.white.opacity(0.8))
        }
    }
}
