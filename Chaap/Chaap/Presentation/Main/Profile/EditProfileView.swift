//
//  EditProfileView.swift
//  Chaap
//
//  Created by BoMin Lee on 7/17/25.
//

import SwiftUI

struct EditProfileView: View {
    @Bindable var viewModel = EditProfileViewModel()
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            /// 상단 네비게이션
            VStack(alignment: .leading, spacing: 0) {
                ZStack {
                    /// 뒤로가기 버튼
                    HStack {
                        Button{
                            dismiss()
                        } label: {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 20))
                                .foregroundColor(Color.chLabelBlackPrimary)
                                .frame(width: 40, height: 40)
                        }
                        Spacer()
                    }
                    /// 중앙 타이틀
                    Text("프로필 수정")
                        .font(.systemEmphasized)
                        .foregroundColor(.black)
                    
                    /// 오른쪽(저장) 버튼
                    HStack {
                        Spacer()
                        Button("저장") {
                            viewModel.saveNickname()
                            // TODO: 연결
                        }
                        .font(.chPrimaryCaptionMedium)
                        .foregroundColor(viewModel.hasChanges ? .chLabelBlackPrimary : .chLabelBlackSecondary)
                        .disabled(!viewModel.hasChanges)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 29)
            
            /// 메인 컨텐츠
            VStack(spacing: 50) {
                ZStack {
                    Circle()
                        .frame(width: 111, height: 111)
                        .foregroundColor(Color(red: 0.82, green: 0.82, blue: 0.82).opacity(0.5))
                    
                    Image(systemName: "person.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.black.opacity(0.6))
                }
                
                VStack(alignment: .leading, spacing: 11) {
                    HStack {
                        Text("닉네임")
                            .font(.chPrimaryCaptionMedium)
                            .foregroundColor(.black)
                        Spacer()
                    }
                    
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(height: 52)
                            .background(.black.opacity(0.05))
                            .cornerRadius(100)
                        
                        TextField("\($viewModel.originalNickname)", text: $viewModel.nickname)
                            .font(.chPrimaryCaptionRegular)
                            // 수정 시작하면 Primary-Black, 아니면 회색
                            .foregroundColor(
                                viewModel.hasUserEdited ? .chLabelBlackPrimary : .chLabelBlackSecondary
                            )
                            .padding(.horizontal, 20)
                    }
                }
                .padding(.horizontal, 30)
            }
            
            Spacer()
        }
        .background(Color.white)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    EditProfileView()
}
