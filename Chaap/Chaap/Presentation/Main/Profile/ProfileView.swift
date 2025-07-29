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
    
    @State private var showImagePicker = false
    @State private var selectedImageName: String? = nil
    
    var body: some View {
        NavigationStack {
            ZStack {
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
                
                VStack(spacing: 0) {
                    /// 상단 네비게이션
                    topNavigation
                    
                    /// 메인 컨텐츠
                    VStack(spacing: 50) {
                        /// 프로필 사진
                        chooseProfileImage
                        
                        /// 닉네임 섹션
                        nicknameField
                    }
                    Spacer()
                }
            }
        }
    }
    
    var topNavigation: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack {
                /// 중앙 타이틀
                Text("Chaap")
                    .font(.systemEmphasized)
                    .foregroundColor(.chLabelWhitePrimary)
                
                /// 오른쪽(다음) 버튼
                HStack {
                    Spacer()
                    Button("다음") {
                        viewModel.saveNickname()
                        
                        if let selectedImageName {
                            UserDefaults.standard.set(selectedImageName, forKey: "SelectedProfileImageName")
                        }
                        
                        shouldNavigateToHome = true
                        // TODO: 연결
                    }
                    .font(.chPrimaryCaptionMedium)
                    .foregroundColor(viewModel.isNextButtonEnabled ? .chLabelWhitePrimary : .chLabelWhiteSecondary)
                    .disabled(!viewModel.isNextButtonEnabled)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 29)
    }
    
    // MARK: - choose profile image
    var chooseProfileImage: some View {
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
    
    // MARK: Nickname Section
    var nicknameField: some View {
        VStack(alignment: .leading, spacing: 12) {
            /// 닉네임 레이블
            HStack {
                Text("닉네임")
                    .font(.chPrimaryCaptionMedium)
                    .foregroundColor(.chLabelWhitePrimary)
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
                    .foregroundColor(.chLabelWhitePrimary)
                    .padding(.horizontal, 20)
                    .frame(height: 52)
                    .background(.black.opacity(0.05))
                    .cornerRadius(100)
            }
        }
        .padding(.horizontal, 30)
    }
}

#Preview {
    ProfileView()
}
