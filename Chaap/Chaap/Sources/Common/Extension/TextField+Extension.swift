//
//  TextField+Extension.swift
//  Chaap
//
//  Created by Enoch on 8/31/25.
//

import SwiftUI

extension TextField {
    /// TextField 최대 글자수 Modifier
    func maxLength(text: Binding<String>, _ maxLength: Int) -> some View {
        return ModifiedContent(content: self,
                               modifier: MaxLengthModifier(text: text,
                                                           maxLength: maxLength))
    }
}
