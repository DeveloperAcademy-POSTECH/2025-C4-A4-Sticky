//
//  OnboardingView.swift
//  Chaap
//
//  Created by Enoch on 9/7/25.
//
import SwiftUI

struct OnboardingView: View {
    @Binding var showOnboarding: Bool
    @State private var userProfileViewModel = UserProfileViewModel()
    @State private var pageIndex = 0
    
    var body: some View {
        ZStack {
            MainView(userProfileViewModel: userProfileViewModel)
            Color.black.opacity(0.3)
                .ignoresSafeArea()
            
            if pageIndex == 0 {
                VStack(spacing: 16) {
                    Spacer()
                    Text("‘챱’ 버튼으로 상대방과 태그하여\n그날의 기록을 남겨보세요!")
                        .font(.chBodyBold)
                        .foregroundStyle(Color.chLabelWhitePrimary)
                        .lineHeight(1.4, fontSize: 18)
                        .multilineTextAlignment(.center)
                    
                    Image("arrow")
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .safeAreaPadding(.bottom, 131)
            } else if pageIndex == 1 {
                VStack(spacing: 16) {
                    Image("arrow")
                        .rotationEffect(Angle(degrees: 180))
                    
                    Text("최근 카드와 함께 누구와, 언제 , 어디에서\n남긴 기록인지 쉽게 찾아보세요! ")
                        .font(.chBodyBold)
                        .foregroundStyle(Color.chLabelWhitePrimary)
                        .lineHeight(1.4, fontSize: 18)
                        .multilineTextAlignment(.center)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .safeAreaPadding(.top, 205)
            }
        }
        // ✅ ZStack 전체를 터치 영역으로 사용
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation {
                if pageIndex == 0 {
                    pageIndex = 1
                } else {
                    showOnboarding = false
                }
            }
        }
        .transition(.opacity)
        .ignoresSafeArea()
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingPreviewWrapper()
    }
}

struct OnboardingPreviewWrapper: View {
    @State private var showOnboarding = true
    
    var body: some View {
        OnboardingView(showOnboarding: $showOnboarding)
    }
}
