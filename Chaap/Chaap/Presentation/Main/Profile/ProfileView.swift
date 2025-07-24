//
//  ProfileView.swift
//  Chaap
//
//  Created by BoMin Lee on 7/17/25.
//

import SwiftUI

struct ProfileView: View {
    @Bindable var viewModel = ProfileViewModel()
    @State private var shouldNavigateToHome = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                /// 상단 네비게이션
                VStack(alignment: .leading, spacing: 0) {
                    ZStack {
                        /// 중앙 타이틀
                        Text("Chaap")
                            .font(.systemEmphasized)
                            .foregroundColor(.chLabelBlackPrimary)
                        
                        /// 오른쪽(다음) 버튼
                        HStack {
                            Spacer()
                            Button("다음") {
                                viewModel.saveNickname()
                                shouldNavigateToHome = true
                                // TODO: 연결
                            }
                            .font(.chPrimaryCaptionMedium)
                            .foregroundColor(viewModel.isNextButtonEnabled ? .chLabelBlackPrimary : .chLabelBlackSecondary)
                            .disabled(!viewModel.isNextButtonEnabled)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 29)
                
                /// 메인 컨텐츠
                VStack(spacing: 50) {
                    /// 프로필 사진
                    ZStack {
                        Circle()
                            .frame(width: 111, height: 111)
                            .foregroundColor(
                                Color(red: 0.82, green: 0.82, blue: 0.82).opacity(0.5)
                            )
                        
                        Image(systemName: "person.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.black.opacity(0.6))
                    }
                    
                    /// 닉네임 섹션
                    VStack(alignment: .leading, spacing: 12) {
                        /// 닉네임 레이블
                        HStack {
                            Text("닉네임")
                                .font(.chPrimaryCaptionMedium)
                                .foregroundColor(.black)
                            Spacer()
                        }
                        
                        /// 닉네임 입력란
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(height: 52)
                                .background(.black.opacity(0.05))
                                .cornerRadius(100)
                            
                            TextField("닉네임을 입력해주세요.", text: $viewModel.nickname)
                                .font(.chPrimaryCaptionRegular)
                                .foregroundColor(.black)
                                .padding(.horizontal, 20)
                                .frame(height: 52)
                                .background(.black.opacity(0.05))
                                .cornerRadius(100)
                        }
                    }
                    .padding(.horizontal, 30)
                }
                Spacer()
            }
            .background(Color.white)
        }
    }
}

#Preview {
    ProfileView()
}
