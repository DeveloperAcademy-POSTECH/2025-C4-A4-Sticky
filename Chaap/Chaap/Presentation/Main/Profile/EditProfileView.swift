//
//  EditProfileView.swift
//  Chaap
//
//  Created by BoMin Lee on 7/17/25.
//

import SwiftUI

struct EditProfileView: View {
    @State private var nickname = "Minbol"
    @State private var originalNickname = "Minbol"
    @State private var hasUserEdited = false
    
    /// 변경사항 여부 체크
    private var hasChanges: Bool {
        return nickname != originalNickname
    }
    
    var body: some View {
        VStack(spacing: 0) {
            /// 상단 네비게이션
            VStack(alignment: .leading, spacing: 0) {
                ZStack {
                    /// 중앙 타이틀
                    Text("프로필 수정")
                        .font(.chPrimaryCaptionMedium)
                        .foregroundColor(.black)
                    
                    /// 오른쪽(저장) 버튼
                    HStack {
                        Spacer()
                        Button("저장") {
                            // 저장 버튼 액션
                        }
                        .font(.chPrimaryCaptionMedium)
                        .foregroundColor(hasChanges ? .chLabelBlackPrimary : .chLabelBlackSecondary)
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
                        
                        TextField("", text: $nickname)
                            .font(.chPrimaryCaptionRegular)
                            // 수정 시작하면 Primary-Black, 아니면 회색
                            .foregroundColor(
                                hasUserEdited ? .black : Color(red: 0.6, green: 0.6, blue: 0.6)
                            )
                            .padding(.horizontal, 20)
                            .onChange(of: nickname) { oldValue, newValue in
                                if !hasUserEdited {
                                    hasUserEdited = true
                                }
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
    EditProfileView()
} 