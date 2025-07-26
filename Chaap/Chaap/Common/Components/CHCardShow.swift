//
//  CHCardShow.swift
//  Chaap
//
//  Created by Enoch on 7/22/25.
//

import SwiftUI

struct CHCardShow: View {
    @State var viewModel: CHCardShowViewModel
    
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
            Text("with \(viewModel.peerName)")
                .font(.chBodyBold)
                .foregroundStyle(.white)
            
            Text(viewModel.formattedDate)
                .font(.caption)
                .foregroundStyle(.white.opacity(0.8))
        }
    }
    
    // MARK: - middle content (title, content)
    var middleContent: some View {
        VStack(spacing: 8) {
            // 기록 제목
            Text(viewModel.title)
                .font(.chBodyBold)
                .foregroundStyle(.white)
            
            // 기록 내용
            Text(viewModel.memo)
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
            Text(viewModel.location)
                .font(.caption)
                .foregroundStyle(.white.opacity(0.8))
        }
    }
}
