//
//  Font+Extension.swift
//  Chaap
//
//  Created by BoMin Lee on 7/17/25.
//

import SwiftUI

extension Font {
    enum Pretend {
        case bold
        case semibold
        case medium
        case regular
        
        var value: String {
            switch self {
            case .bold:
                return "Pretendard-Bold"
            case .semibold:
                return "Pretendard-SemiBold"
            case .medium:
                return "Pretendard-Medium"
            case .regular:
                return "Pretendard-Regular"
            }
        }
    }
    
    static func pretend(type: Pretend, size: CGFloat) -> Font {
        return .custom(type.value, size: size)
    }
    
    static var chTitle: Font {
        return .pretend(type: .bold, size: 24)
    }
    
    static var chTitle36: Font {
        return .pretend(type: .bold, size: 36)
    }
    
    static var chTitleSemibold: Font {
        return .pretend(type: .semibold, size: 22)
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
        return .pretend(type: .regular, size: 12)
    }
    
    static var chSecondaryCaptionMedium: Font {
        return .pretend(type: .medium, size: 12)
    }
    
    static var systemEmphasized: Font {
        return .system(size: 17, weight: .semibold)
    }
}

/// Line Height 적용 View Modifier
struct LineHeight: ViewModifier {
    let fontSize: CGFloat
    let lineHeight: CGFloat
    
    func body(content: Content) -> some View {
        content
            .lineSpacing(fontSize * lineHeight - fontSize)
            .padding(.vertical, (fontSize * lineHeight - fontSize) / 2)
    }
}

extension View {
    /// 뷰의 텍스트에 커스텀 lineHeight를 적용합니다.
    ///
    /// 주어진 폰트 크기를 기준으로 줄 간격과 세로 패딩을 조정하여
    /// 특정 줄 높이를 구현할 수 있습니다.
    ///
    /// - Parameters:
    ///   - lineHeight: 원하는 줄 높이 배수 (예: `1.2` → 120%).
    ///   - fontSize: 텍스트의 폰트 크기(pt).
    /// - Returns: 조정된 줄 높이가 적용된 뷰.
    ///
    /// ## 사용 예시
    /// ```swift
    /// Text("예시 텍스트입니다.")
    ///     .font(.chTitle)
    ///     .lineHeight(fontSize: 24, lineHeight: 1.4)
    /// ```
    func lineHeight(_ lineHeight: CGFloat, fontSize: CGFloat) -> some View {
        self.modifier(LineHeight(fontSize: fontSize, lineHeight: lineHeight))
    }
}
