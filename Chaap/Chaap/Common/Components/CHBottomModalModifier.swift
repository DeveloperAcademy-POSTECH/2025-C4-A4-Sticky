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
                sheetView()
                    .transition(.move(edge: .bottom))
                    .zIndex(1) // base보다 위에 보이게 하기 위함
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
                    self.content()
                        .padding()
                }
                .frame(width: geometry.size.width, height: defaultHeight - dragOffset)
                .background(
                    CHBlurView(style: .systemUltraThinMaterialDark)
                        .clipShape(RoundedRectangle(cornerRadius: 32)))
                .overlay(GradientStroke())
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
