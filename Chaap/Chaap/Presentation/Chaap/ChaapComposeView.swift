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
                    Spacer().frame(height: 94)
                    cardView
                    Spacer().frame(height: 80)
                    
                }
            }
            .scrollIndicators(.hidden)
            .safeAreaPadding(.horizontal, 16)
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
        .safeAreaPadding(.top, 9)
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
            .padding(.horizontal, 20)
            .padding(.vertical, 24)
        }
    }
    
    var peerDateInfoView: some View {
        VStack(spacing: 8) {
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
            if chaap.title.isEmpty {
                Text("제목을 입력하세요")
                    .font(.chBodyRegular)
                    .lineHeight(1.4, fontSize: 18)
                    .foregroundStyle(Color.chLabelWhiteSecondary)
            }
            TextField("", text: $chaap.title)
                .font(.chBodyBold)
                .lineHeight(1.4, fontSize: 18)
                .foregroundStyle(Color.chLabelWhitePrimary)
                .lineLimit(1)
                .background(Color.clear)
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .multilineTextAlignment(.center)
                .tint(Color.chLabelWhitePrimary)
        }
        .frame(height: 57)
        .background(
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
            })
    }
    
    var contextInputView: some View {
        /// 메모 입력
        ZStack(alignment: .center) {
            if chaap.memo.isEmpty {
                Text("내용을 입력하세요")
                    .font(.chBodyRegular)
                    .lineHeight(1.4, fontSize: 18)
                    .foregroundStyle(Color.chLabelWhiteSecondary)
            }
            
            TextEditor(text: $chaap.memo)
                .font(.chBodyRegular)
                .lineHeight(1.4, fontSize: 18)
                .foregroundStyle(Color.chLabelWhitePrimary)
                .frame(height: 130)
                .scrollContentBackground(.hidden)
                .scrollDisabled(true)
                .background(Color.clear)
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.never)
                .multilineTextAlignment(.center)
                .lineLimit(3)
                .tint(Color.chLabelWhitePrimary)
        }
        .frame(height: 136)
        .background(
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
        )
    }
    
    var placeInputView: some View {
        /// 장소 수정 및 입력
        HStack {
            Spacer()
            HStack(alignment: .center, spacing: 4){
                Image(.placeMarker)
                TextField("\(chaap.place)", text: $chaap.place)
                    .font(.chPrimaryCaptionRegular)
                    .lineHeight(1.4, fontSize: 16)
                    .foregroundStyle(Color.chLabelWhiteSecondary)
                    .lineLimit(1)
                    .background(Color.clear)
                    .autocorrectionDisabled(true)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .multilineTextAlignment(.center)
                    .tint(Color.chLabelWhitePrimary)
            }
            Spacer()
        }
        .padding(.horizontal, 20)
        .frame(height: 54)
        .background(
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
            })
    }
    
    var photoInputView: some View {
        VStack(spacing: 8) {
            if let data = chaap.photoData, let chaapImage = UIImage(data: data) {
                ZStack {
                    Color.clear
                        .aspectRatio(1, contentMode: .fit)
                    Image(uiImage: chaapImage)
                        .resizable()
                        .aspectRatio(1, contentMode: .fill)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .shadow(color: Color.chBlack.opacity(0.25), radius: 4, x: 0, y: 4)
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
            // TODO: 디자인 적용
            if chaap.photoData != nil {
                Button {
                    viewModel.openCameraTapped()
                } label: { Text("다시 촬영") }
            }
//            if chaap.photoData != nil {
//                Button(role: .destructive) {
//                    chaap.photoData = nil
//                } label: { Text("사진 삭제") }
//            }
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
