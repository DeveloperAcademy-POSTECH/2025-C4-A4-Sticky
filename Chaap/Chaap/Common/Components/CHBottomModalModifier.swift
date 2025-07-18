//
//  CHBottomModalModifier.swift
//  Chaap
//
//  Created by BoMin Lee on 7/18/25.
//

import SwiftUI

struct CHBottomModalModifier<SheetContent: View>: ViewModifier {
    @Binding var isPresented: Bool
        @GestureState private var dragOffset: CGFloat = 0

        let minHeight: CGFloat
        let maxHeight: CGFloat
        let content: () -> SheetContent

        func body(content base: Content) -> some View {
            ZStack {
                base
                    .onTapGesture {
                        withAnimation {
                            isPresented = false
                        }
                    }
                if isPresented {
                    // MARK: 모달 아래 배경에 dim 효과 주는 코드인데, 쓰이지 않는 것 같아 우선 주석 처리
//                    Color.black.opacity(0.3)
//                        .ignoresSafeArea()
//                        .onTapGesture {
//                            withAnimation { isPresented = false }
//                        }
                    sheetView()
                        .transition(.move(edge: .bottom))
                        .animation(.easeInOut, value: isPresented)
                }
            }
        }

        @ViewBuilder
        private func sheetView() -> some View {
            GeometryReader { geometry in
                let defaultHeight = maxHeight
                VStack {
                    Spacer()
                    VStack {
                        Capsule()
                            .frame(width: 40, height: 4)
                            .foregroundColor(.white)
                            .padding(.top, 12)
                        self.content()
                            .padding()
                    }
                    .frame(width: geometry.size.width, height: defaultHeight - dragOffset)
                    // TODO: 배경 Glass Morphism 적용해야 함.
                    .background(Color.red.opacity(0.3))
                    .cornerRadius(36)
                    .shadow(radius: 10)
                    .offset(y: dragOffset)
                    .gesture(
                        DragGesture()
                            .updating($dragOffset) { value, state, _ in
                                if value.translation.height > 0 {
                                    state = value.translation.height
                                }
                            }
                            .onEnded { value in
                                if value.translation.height > 150 {
                                    withAnimation {
                                        isPresented = false
                                    }
                                }
                            }
                    )
                }
                .ignoresSafeArea(.all, edges: .bottom)
            }
        }
}
