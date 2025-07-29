//
//  CHMainButtonAction.swift
//  Chaap
//
//  Created by Enoch on 7/29/25.
//

import Foundation
import SwiftUI

enum MainButtonAction {
    case save
    case cancel
    case connect
    case accept
    case decline

    // MARK: - button text 내용
    var title: String {
        switch self {
        case .save: return "저장"
        case .cancel: return "취소"
        case .connect: return "연결하기"
        case .accept: return "수락"
        case .decline: return "거절"
        }
    }

    // MARK: - button text font
    var font: Font {
        switch self {
        case .cancel, .accept, .decline:
            return .chTitleSemibold
        case .save:
            return .chBodyMedium
        case .connect:
            return .chPrimaryCaptionMedium
        }
    }
    
    // MARK: - button text color
    var textColor: Color {
        switch self {
        case .accept, .connect, .save:
            return .chLabelWhitePrimary
        case .cancel, .decline:
            return .chLabelBlackPrimary
        }
    }
    
    // MARK: - button text vertical padding
    var verticalPadding: CGFloat {
        switch self {
        case .save:
            return 13
        case .cancel, .accept, .decline:
            return 17
        case .connect:
            return 7.5
        }
    }
}
