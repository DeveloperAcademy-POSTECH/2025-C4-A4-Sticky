//
//  Color+Extension.swift
//  Chaap
//
//  Created by BoMin Lee on 7/17/25.
//

import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: UInt64
        switch hex.count {
        case 6: // RGB (without alpha)
            (r, g, b) = ((int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        default:
            (r, g, b) = (1, 1, 1) // Default to white in case of an error
        }
        self.init(
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255
        )
    }
    
    func toHex() -> String? {
        let uiColor = UIColor(self)
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        guard uiColor.getRed(&r, green: &g, blue: &b, alpha: &a) else {
            return nil
        }
        
        let rgb: Int = (Int)(r * 255) << 16 |
        (Int)(g * 255) << 8 |
        (Int)(b * 255) << 0
        
        return String(format: "%06X", rgb)
    }
    
    /// 16진수 색상코드 가져와서 커스텀 컬러 지정
    /// chColors
    static let chPrimary = Color(hex: "#1C3E98")
    static let chSecondary = Color(hex: "#9EA9E1")
    static let chBlack = Color(hex: "#020202")
    
    /// chLabelBlack
    static let chLabelBlackPrimary = Color(hex: "#202020")
    static let chLabelBlackSecondary = Color(hex: "#757575")
    
    /// chLabelWhite
    static let chLabelWhitePrimary = Color(hex: "#FEFEFE")
    static let chLabelWhiteSecondary = Color(hex: "#EBEDF0")
    
    /// Point Colors
    static let chPointColorPurple = Color(hex: "#8B5CF6")
    
    /// chBackground
    static let chBackgroundPrimary = Color(hex: "000000").opacity(0.4)
    static let chBackgroundSecondary = Color(hex: "#000000").opacity(0.15)
}
