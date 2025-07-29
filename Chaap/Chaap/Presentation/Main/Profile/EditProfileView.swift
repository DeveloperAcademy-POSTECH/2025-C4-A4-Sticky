//
//  EditProfileView.swift
//  Chaap
//
//  Created by BoMin Lee on 7/17/25.
//

import SwiftUI

struct EditProfileView: View {
    @Bindable var viewModel = EditProfileViewModel()
    @EnvironmentObject private var navigationManager: CHNavigationManager
    
    @Binding var selectedImageName: String?
    @State private var showImagePicker = false
    
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
                            viewModel.saveProfileImage()
                            selectedImageName = viewModel.selectedImageName
                            navigationManager.pop()
                        }
                        .font(.chPrimaryCaptionMedium)
                        .foregroundColor(.chLabelBlackPrimary)
//                        .foregroundColor(viewModel.hasUserEdited ? .chLabelBlackPrimary : .chLabelBlackSecondary)
//                        .disabled(!viewModel.hasUserEdited)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 29)
            
            /// 메인 컨텐츠
            VStack(spacing: 50) {
                changeProfileImage
                
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
    
    // MARK: - choose profile image
    var changeProfileImage: some View {
        ZStack {
            Circle()
                .frame(width: 111, height: 111)
                .foregroundColor(Color.chLabelWhitePrimary)
                .shadow(color: .black.opacity(0.1), radius: 2.5, x: 3, y: 3)
            
            if let selectedImageName {
                Image(selectedImageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 55, height: 55)
            } else {
                Image(.profileButterfly)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 55, height: 55)
            }
        }
        .onAppear {
            viewModel.selectedImageName = selectedImageName
        }
        .onChange(of: selectedImageName) { newValue in
            viewModel.selectedImageName = newValue
        }
        .onTapGesture {
            showImagePicker = true
        }
        .sheet(isPresented: $showImagePicker) {
            VStack(spacing: 20) {
                Text("프로필 이미지 선택")
                    .font(.headline)
                
                imageOption
            }
            .padding()
            .presentationDetents([.medium])
            .presentationDragIndicator(.visible)
        }
    }
    
    // MARK: - Image Option Sheet
    var imageOption: some View {
        let imageNames = [
            "profileBird",
            "profileCat",
            "profileDog",
            "profileRabbit",
            "profileTurtle"
        ]
        
        return LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 50), count: 3), spacing: 20) {
            ForEach(imageNames, id: \.self) { imageName in
                ZStack {
                    Circle()
                        .frame(width: 111, height: 111)
                        .foregroundColor(Color.chLabelWhitePrimary)
                        .shadow(color: .black.opacity(0.1), radius: 2.5, x: 3, y: 3)
                        .shadow(color: .black.opacity(0.1), radius: 2.5, x: 3, y: 3)
                        .onTapGesture {
                            selectedImageName = imageName
                            showImagePicker = false
                        }
                    
                    Image(imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 45, height: 45)
                }
            }
        }
        .padding()
    }
}
