//
//  MCSessionState.swift
//  Chaap
//
//  Created by BoMin Lee on 7/25/25.
//

import Foundation
import MultipeerConnectivity

extension MCSessionState {
    var displayString: String {
        switch self {
        case .notConnected:
            return "Not Connected"
        case .connecting:
            return "Connecting..."
        case .connected:
            return "Connected"
        @unknown default:
            return "Unknown"
        }
    }
}

//extension MCSessionState {
//    var string: String {
//        switch self {
//        case .connected: return "Connected"
//        case .notConnected: return "Not Connected"
//        case .connecting: return "Connecting"
//        @unknown default:
//            return ""
//        }
//    }
//}
