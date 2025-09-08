//
//  BlurEffect.swift
//  Chaap
//
//  Created by Enoch on 7/18/25.
//
import SwiftUI

struct CHBlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> some UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: style))
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) { }
}
