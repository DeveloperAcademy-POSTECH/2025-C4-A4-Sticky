//
//  Font+Extension.swift
//  Chaap
//
//  Created by BoMin Lee on 7/17/25.
//

import SwiftUI

// TODO: Line Height 적용 필요

extension Font {
    enum Pretend {
        case extraBold
        case bold
        case semibold
        case medium
        case regular
        case light
        
        var value: String {
            switch self {
            case .extraBold:
                return "Pretendard-ExtraBold"
            case .bold:
                return "Pretendard-Bold"
            case .semibold:
                return "Pretendard-SemiBold"
            case .medium:
                return "Pretendard-Medium"
            case .regular:
                return "Pretendard-Regular"
            case .light:
                return "Pretendard-Light"
            }
        }
    }
    
    static func pretend(type: Pretend, size: CGFloat) -> Font {
        return .custom(type.value, size: size)
    }
    
    static var chTitle: Font {
        return .pretend(type: .bold, size: 24)
    }
    
    static var chBodyBold: Font {
        return .pretend(type: .bold, size: 18)
    }
    
    static var chBodyRegular: Font {
        return .pretend(type: .regular, size: 18)
    }
    
    static var chBodyMedium: Font {
        return .pretend(type: .medium, size: 18)
    }
    
    static var chPrimaryCaptionRegular: Font {
        return .pretend(type: .regular, size: 16)
    }
    
    static var chPrimaryCaptionMedium: Font {
        return .pretend(type: .medium, size: 16)
    }
    
    static var chSecondaryCaptionRegular: Font {
        return .pretend(type: .regular, size: 11)
    }
    
    static var systemEmphasized: Font {
        return .system(size: 17, weight: .semibold)
    }
}
