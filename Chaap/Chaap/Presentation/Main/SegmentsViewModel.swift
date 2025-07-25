//
//  SegmentsViewModel.swift
//  Chaap
//
//  Created by Enoch on 7/18/25.
//

import Foundation
import SwiftUI

class SegmentsViewModel: ObservableObject {
    @Published var selectedSegement: SegmentsModel = .cardSegment
}
