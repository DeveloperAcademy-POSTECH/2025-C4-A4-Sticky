//
//  ChaapComposeView.swift
//  Chaap
//
//  Created by BoMin Lee on 7/17/25.
//

import SwiftUI
import SwiftData

struct ChaapComposeView: View {
    @Bindable var chaap: Chaap
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private var navigationManager: CHNavigationManager
    
    var modelContext: ModelContext
    @StateObject private var viewModel = ChaapComposeViewModel()
    
    @FocusState private var isFocused: Bool
    @FocusState private var isMemoFocused: Bool
    
    @State private var showDeleteAlert = false
    
    var body: some View {
        ZStack {
            if let data = chaap.photoData, let chaapImage = UIImage(data: data) {
                Image(uiImage: chaapImage)
                    .resizable()
                    .scaledToFill()
                    .frame(minWidth: .zero, maxWidth: .infinity, alignment: .center)
                    .ignoresSafeArea(.all)
                Color.chBlack.opacity(0.2)
                    .ignoresSafeArea(.all)
            } else {
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
            }
            
            ScrollView {
                VStack {
                    Spacer().frame(height: 103)
                    cardView
                    Spacer().frame(height: 105)
                }
            }
            .scrollIndicators(.hidden)
            .safeAreaPadding(.horizontal, 40)
            
            VStack(spacing: 0) {
                topNavigationView
                
                Spacer()
                CHMainButton(
                    actionType: .save,
                    action: {
                        navigationManager.goToRoot()
                    }
                )
            }
            .safeAreaPadding(.horizontal, 16)
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
        .navigationBarBackButtonHidden(true)
        .alert("정말 삭제하시겠습니까?", isPresented: $showDeleteAlert) {
            Button("삭제", role: .destructive, action: deleteChaap)
            Button("취소", role: .cancel) { }
        } message: {
            Text("이 기록은 완전히 삭제되며 되돌릴 수 없습니다.")
        }
        .alert("카메라 접근이 차단되어 있습니다.",
               isPresented: $viewModel.cameraDeniedAlert) {
            Button("설정으로 이동") {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
            Button("취소", role: .cancel) { }
        } message: {
            Text("설정 > 개인정보 보호 > 카메라에서 권한을 허용해 주세요.")
        }
        .fullScreenCover(isPresented: $viewModel.showingCamera) {
            CameraPicker { data in
                chaap.photoData = data
            }
            .ignoresSafeArea()
        }
        .contentShape(Rectangle()) // 빈 영역도 터치 인식
        .onTapGesture {
            isFocused = false  // 포커스 해제 → 키보드 내려감
            isMemoFocused = false
        }
    }
    
    var topNavigationView: some View {
        HStack{
            Button {
                dismiss()
            } label: {
                CHCircleButton(buttonImageName: "chevron.backward")
            }
            Spacer()
            Button {
                showDeleteAlert = true
            } label: {
                CHCircleButton(buttonImageName: "trash")
            }
        }
        .padding(.bottom, 8)
    }
    
    var cardView: some View {
        ZStack {
            CHCardBG()
            VStack(spacing: 24) {
                peerDateInfoView
                VStack(spacing: 8) {
                    titleInputView
                    contextInputView
                    placeInputView
                }
                photoInputView
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 24)
        }
    }
    
    var peerDateInfoView: some View {
        VStack(spacing: 6) {
            if let iconName = chaap.peers.first?.iconName {
                Image(iconName)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .frame(
                        maxWidth: .infinity,
                        minHeight: 44,
                        maxHeight: 44,
                        alignment: .center
                    )
                    .background(.white)
                    .clipShape(Circle())
            } else {
                Image(.profileButterfly)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .frame(
                        maxWidth: .infinity,
                        minHeight: 44,
                        maxHeight: 44,
                        alignment: .center
                    )
                    .background(.white)
                    .clipShape(Circle())
            }
            
            Text("with \(chaap.peers.first?.displayName ?? "이름 없음")")
                .font(.chBodyBold)
                .lineHeight(1.4, fontSize: 18)
                .foregroundStyle(Color.chLabelWhitePrimary)
            
            Text(chaap.createdAt.formatted(date: .abbreviated, time: .shortened))
                .font(.chPrimaryCaptionRegular)
                .lineHeight(1.4, fontSize: 16)
                .foregroundStyle(Color.chLabelWhitePrimary)
        }
    }
    
    var titleInputView: some View {
        /// 제목 입력
        ZStack(alignment: .center) {
            if chaap.title.isEmpty && !isFocused {
                Text("제목을 입력하세요")
                    .font(.chBodyRegular)
                    .lineHeight(1.4, fontSize: 18)
                    .foregroundStyle(Color.chLabelWhiteSecondary)
                    .allowsHitTesting(false)
            }
            TextField("", text: $chaap.title)
                .maxLength(text: $chaap.title, 15)
                .font(.chBodyBold)
                .lineHeight(1.4, fontSize: 18)
                .foregroundStyle(Color.chLabelWhitePrimary)
                .multilineTextAlignment(.center)
                .background(Color.clear)
                .focused($isFocused)
                .onTapGesture { isFocused = true }
                .tint(.chLabelWhitePrimary)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background( backgroundForInput )
    }
    
    var contextInputView: some View {
        /// 메모 입력
        ZStack(alignment: .center) {
            AutoGrowingTextEditor(
                text: $chaap.memo,
                placeholder: "내용을 입력하세요",
                font: .chBodyRegular,
                fontSize: 18
            )
            .frame(maxWidth: .infinity)
            .focused($isMemoFocused)
            .onTapGesture { isMemoFocused = true }
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 1)
        .frame(height: 160)
        .background( backgroundForInput )
    }
    
    var placeInputView: some View {
        /// 장소 수정 및 입력
        HStack {
            Spacer()
            HStack(alignment: .center, spacing: 4){
                Image(.placeMarker)
                TextField("\(chaap.place)", text: $chaap.place)
                    .maxLength(text: $chaap.place, 15)
                    .font(.chPrimaryCaptionRegular)
                    .lineHeight(1.4, fontSize: 16)
                    .foregroundStyle(Color.chLabelWhiteSecondary)

                    .multilineTextAlignment(.center)
                    .background(Color.clear)
                    .focused($isFocused)
                    .onTapGesture { isFocused = true }
                    .tint(.chLabelWhiteSecondary)
            }
            Spacer()
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 14)
        .frame(height: 57)
        .background( backgroundForInput )
    }
    
    private var backgroundForInput: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(hex: "#808080").opacity(0.25))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .inset(by: 0.46)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.white.opacity(0),
                                    Color.white.opacity(0.6 * 0.2)
                                ]),
                                startPoint: .center,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 0.92
                        )
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(hex: "#EEEEEE").opacity(0.8 * 0.2),
                                    Color(hex: "#EEEEEE").opacity(0)
                                ]),
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            lineWidth: 0.92
                        )
                )
            RoundedRectangle(cornerRadius: 12)
                .fill(.shadow(.inner(color: .black, radius: 4, x: 1, y: 1.5)))
                .opacity(0.08)
        }
    }
    
    var photoInputView: some View {
        VStack(spacing: 8) {
            if let data = chaap.photoData, let chaapImage = UIImage(data: data) {
                ZStack {
                    Color.clear
                        .aspectRatio(1, contentMode: .fit)
                    ZStack (alignment: .topTrailing) {
                        Image(uiImage: chaapImage)
                            .resizable()
                            .aspectRatio(1, contentMode: .fill)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .shadow(color: Color.chBlack.opacity(0.25), radius: 4, x: 0, y: 4)
                        if chaap.photoData != nil {
                            Button {
                                chaap.photoData = nil
                            } label: {
                                CHCircleButton(buttonImageName: "multiply", imageSize: 15, width: 28, height: 28)
                            }
                            .padding(.top, 8)
                            .padding(.trailing, 8)
                        }
                    }
                }
            } else {
                Button { viewModel.openCameraTapped() } label: {
                    Image(systemName: "camera.circle")
                        .font(.system(size: 44, weight: .regular))
                        .lineHeight(1.4, fontSize: 44)
                        .foregroundStyle(Color.chLabelWhiteSecondary)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .contentShape(Rectangle())
                }
            }
        }
    }
    
    private func deleteChaap() {
        modelContext.delete(chaap)
        do {
            try modelContext.save()
            dismiss()
        } catch {
            print("❌ 삭제 실패: \(error.localizedDescription)")
        }
    }
}
