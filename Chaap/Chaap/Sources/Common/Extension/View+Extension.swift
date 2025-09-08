//
//  View+Extension.swift
//  Chaap
//
//  Created by BoMin Lee on 7/18/25.
//

import SwiftUI

/// Extension for CHBottomModalModifier
extension View {
    func chBottomModal<SheetContent: View>(
        isPresented: Binding<Bool>,
        minHeight: CGFloat = 200,
        maxHeight: CGFloat = 400,
        @ViewBuilder content: @escaping () -> SheetContent
    ) -> some View {
        self.modifier(CHBottomModalModifier(
            isPresented: isPresented,
            minHeight: minHeight,
            maxHeight: maxHeight,
            content: content
        ))
    }
}
