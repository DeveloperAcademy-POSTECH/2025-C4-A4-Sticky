//
//  SegmentsModel.swift
//  Chaap
//
//  Created by Enoch on 7/18/25.
//

import Foundation

enum Segments: String, CaseIterable {
    case cardSegment
    case peopleSegment
    case calendarSegment
    case mapSegment
    
    var iconName: String {
        switch self {
        case .cardSegment: return "quote.bubble.fill"
        case .peopleSegment: return "person.2.fill"
        case .calendarSegment: return "calendar"
        case .mapSegment: return "map.fill"
        }
    }
}
