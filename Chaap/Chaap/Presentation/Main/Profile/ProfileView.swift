//
//  ProfileView.swift
//  Chaap
//
//  Created by BoMin Lee on 7/17/25.
//

import SwiftUI

struct ProfileView: View {
    @Bindable var viewModel: UserProfileViewModel
    @State private var shouldNavigateToHome = false
    
    @State private var showImagePicker = false
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                Rectangle()
                    .foregroundColor(.clear)
                    .background(
                        EllipticalGradient(
                            colors: [Color.chPrimary, Color.chSecondary],
                            center: .topLeading,
                            startRadiusFraction: 0.2,
                            endRadiusFraction: 1.0
                        )
                        .scaleEffect(x: 1.6, y: 1.0, anchor: .topLeading)
                    )
                    .ignoresSafeArea(.all)
                Rectangle()
                    .foregroundColor(.clear)
                    .background(
                        Color.black.opacity(0.25)
                    )
                    .ignoresSafeArea(.all)
                
                VStack(spacing: 19) {
                    topNavigation
                        .padding(.bottom, 10)
                    chooseProfileImage
                    nicknameField
                    
                    Spacer()
                }
            }
            .chBottomModal(isPresented: $showImagePicker) {
                VStack(spacing: 20) {
                    Text("프로필 이미지 선택")
                        .font(.chBodyMedium)
                        .foregroundStyle(Color.chLabelWhitePrimary)
                        .lineHeight(1.4, fontSize: 18)
                    
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
    }
    
    var topNavigation: some View {
        ZStack {
            /// 중앙 타이틀
            Text("Chaap")
                .font(.systemEmphasized)
                .foregroundColor(.chLabelWhitePrimary)
                .lineHeight(1.4, fontSize: 17)
            
            /// 오른쪽(다음) 버튼
            HStack {
                Spacer()
                Button("다음") {
                    viewModel.saveProfile()
//                    shouldNavigateToHome = true
                }
                .font(.chPrimaryCaptionMedium)
                .lineHeight(1.4, fontSize: 16)
                .foregroundColor(viewModel.isNextButtonEnabled ? .chLabelWhitePrimary : .chLabelWhiteSecondary)
                .disabled(!viewModel.isNextButtonEnabled)
            }
        }
        .safeAreaPadding(.horizontal, 16)
    }
    
    // MARK: - choose profile image
    var chooseProfileImage: some View {
        ZStack {
            Circle()
                .frame(width: 111, height: 111)
                .foregroundColor(Color.chLabelWhitePrimary)
                .shadow(color: .black.opacity(0.3), radius: 2.5, x: 3, y: 3)
            
            if let selectedImageName = viewModel.selectedImageName {
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
        .onTapGesture { showImagePicker = true }
    }
    
    // MARK: - Image Option Sheet
    var imageOption: some View {
        let imageNames = ["profileBird", "profileButterfly", "profileCat", "profileDog", "profileRabbit", "profileTurtle"]
        
        return LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 50), count: 3), spacing: 30) {
            ForEach(imageNames, id: \.self) { imageName in
                ZStack {
                    Circle()
                        .frame(width: 90, height: 90)
                        .foregroundColor(Color.chLabelWhitePrimary)
                        .shadow(color: .black.opacity(0.3), radius: 2.5, x: 3, y: 3)
                        .onTapGesture {
                            viewModel.selectedImageName = imageName
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
    
    // MARK: Nickname Section
    var nicknameField: some View {
        VStack(alignment: .leading, spacing: 12) {
            /// 닉네임 레이블
            HStack {
                Text("닉네임")
                    .font(.chPrimaryCaptionMedium)
                    .foregroundColor(.chLabelWhitePrimary)
                    .lineHeight(1.4, fontSize: 16)
                Spacer()
            }
            
            /// 닉네임 입력란
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 100)
                    .foregroundColor(Color.black.opacity(0.1))
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
                
                if viewModel.nickname.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    Text("닉네임을 입력해주세요.")
                        .foregroundColor(.chLabelBlackSecondary)
                        .font(.chPrimaryCaptionMedium)
                        .lineHeight(1.4, fontSize: 16)
                        .padding(.horizontal, 20)
                }
                
                TextField("", text: $viewModel.nickname)
                    .maxLength(text: $viewModel.nickname, 8)
                    .font(.chPrimaryCaptionMedium)
                    .foregroundColor(.chLabelWhitePrimary)
                    .lineHeight(1.4, fontSize: 16)
                    .padding(.horizontal, 20)
                    .frame(height: 52)
                    .cornerRadius(100)
                    .tint(Color.chLabelWhitePrimary)
                    .background(Color.clear)
                    .autocorrectionDisabled(true)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
            }
        }
        .safeAreaPadding(.horizontal, 22)
    }
}
