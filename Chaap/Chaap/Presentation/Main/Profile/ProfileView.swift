//
//  ProfileView.swift
//  Chaap
//
//  Created by BoMin Lee on 7/17/25.
//

import SwiftUI

struct ProfileView: View {
    @State private var nickname = ""
    
    /// 바이트 수 계산 함수
    private func getByteCount(of text: String) -> Int {
        return text.data(using: .utf8)?.count ?? 0
    }
    
    /// 입력 검증 및 제한 함수
    private func validateInput(_ newValue: String) -> String {
        let byteCount = getByteCount(of: newValue)
        if byteCount > 50 {
            // 50바이트를 초과하는 경우, 50바이트까지만 잘라서 반환
            var trimmedValue = newValue
            while getByteCount(of: trimmedValue) > 50 {
                trimmedValue = String(trimmedValue.dropLast())
            }
            return trimmedValue
        }
        return newValue
    }
    
    var body: some View {
        VStack(spacing: 0) {
            /// 상단 네비게이션
            VStack(alignment: .leading, spacing: 0) {
                ZStack {
                    /// 중앙 타이틀
                    Text("Chaap")
                        .font(
                            Font.custom("SF Pro", size: 17)
                                .weight(.semibold)
                        )
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(red: 0.13, green: 0.13, blue: 0.13))
                    
                    /// 오른쪽 버튼
                    HStack {
                        Spacer()
                        Button("다음") {
                            // 다음 버튼 액션
                        }
                        .font(.chPrimaryCaptionMedium)
                        // Secondary-Black : Primary-Black
                        .foregroundColor(nickname.isEmpty ? .gray : .black)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 0)
            .frame(width: 393, alignment: .topLeading)
            .padding(.top, 20)
            .padding(.bottom, 60)
            
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
                        
                        if nickname.isEmpty {
                            Text("닉네임을 입력해주세요.")
                                .font(.chPrimaryCaptionMedium)
                                // MiscellaneousTabUnselected 색상 대체
                                .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                                .padding(.leading, 20)
                        }
                        
                        TextField("", text: $nickname)
                            .font(.chPrimaryCaptionRegular)
                            .foregroundColor(.black) // Primary-Black
                            .padding(.horizontal, 20)
                            .onChange(of: nickname) { oldValue, newValue in
                                nickname = validateInput(newValue)
                            }
                    }
                }
                .padding(.horizontal, 30)
            }
            
            Spacer()
        }
        .background(Color.white)
    }
}

#Preview {
    ProfileView()
}
