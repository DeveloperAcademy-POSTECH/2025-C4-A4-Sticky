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
        ZStack(alignment: .bottom) {
            VStack(spacing: 19) {
                /// 상단 네비게이션
                topNavigation
                
                /// 메인 컨텐츠
                changeProfileImage
                
                
                nicknameField
                
                Spacer()
            }
        }
        .chBottomModal(isPresented: $showImagePicker) {
            VStack(spacing: 20) {
                Text("프로필 이미지 선택")
                    .font(.chBodyMedium)
                    .foregroundStyle(Color.chLabelWhitePrimary)
                
                imageOption
                Spacer()
            }
            .padding(.top, 15)
            .presentationDetents([.medium])
            .presentationDragIndicator(.visible)
        }
        .background(Color.white)
        .navigationBarBackButtonHidden(true)
    }
    
    // MARK: - top Navigation
    var topNavigation: some View {
        ZStack {
            HStack {
                /// 뒤로가기 버튼
                Button{
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20))
                        .foregroundColor(Color.chLabelBlackPrimary)
                        .frame(width: 40, height: 40)
                }
                Spacer()
                
                /// 오른쪽(저장) 버튼
                Button("저장") {
                    viewModel.saveNickname()
                    viewModel.saveProfileImage()
                    selectedImageName = viewModel.selectedImageName
                    navigationManager.pop()
                }
                .font(.chPrimaryCaptionMedium)
                .foregroundColor(.chLabelBlackPrimary)
                //            .foregroundColor(viewModel.hasUserEdited ? .chLabelBlackPrimary : .chLabelBlackSecondary)
                //            .disabled(!viewModel.hasUserEdited)
            }
            
            /// 중앙 타이틀
            Text("프로필 수정")
                .font(.systemEmphasized)
                .foregroundColor(.black)
            
        }
        .safeAreaPadding(.horizontal, 16)
        .padding(.bottom, 10)
    }
    
    // MARK: - choose profile image
    var changeProfileImage: some View {
        ZStack {
            Circle()
                .frame(width: 111, height: 111)
                .foregroundColor(Color.chLabelWhitePrimary)
                .shadow(color: .black.opacity(0.1), radius: 5, x: 1.5, y: 1.5)
                .shadow(color: .black.opacity(0.05), radius: 2, x: 3, y: 3)
            
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
    }
    
    // MARK: - Image Option Sheet
    var imageOption: some View {
        let imageNames = [
            "profileBird",
            "profileButterfly",
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
                        .shadow(color: .black.opacity(0.3), radius: 2.5, x: 3, y: 3)
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
    
    var nicknameField: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("닉네임")
                    .font(.chPrimaryCaptionMedium)
                    .foregroundColor(.chLabelBlackPrimary)
                Spacer()
            }
            
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 100)
                    .foregroundColor(Color.black.opacity(0.05))
                    .frame(height: 52)
                    .overlay(
                        RoundedRectangle(cornerRadius: 100)
                            .stroke(Color.black.opacity(0.1), lineWidth: 3)
                            .blur(radius: 1)
                            .offset(x: 1, y: 2)
                            .mask(
                                RoundedRectangle(cornerRadius: 100)
                                    .fill(LinearGradient(colors: [.black, .black], startPoint: .topLeading, endPoint: .bottomTrailing))
                            )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 100)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                            .offset(x: 0, y: -1)
                            .mask(
                                RoundedRectangle(cornerRadius: 100)
                                    .fill(LinearGradient(colors: [.white, .white.opacity(0.6)], startPoint: .topLeading, endPoint: .bottomTrailing))
                            )
                    )
                
                TextField("\($viewModel.originalNickname)", text: $viewModel.nickname)
                    .font(.chPrimaryCaptionMedium)
                    .foregroundColor(
                        viewModel.hasUserEdited ? .chLabelBlackPrimary : .chLabelBlackSecondary
                    )
                    .padding(.horizontal, 20)
                    .tint(.chPrimary)
            }
        }
        .safeAreaPadding(.horizontal, 22)
    }
}
