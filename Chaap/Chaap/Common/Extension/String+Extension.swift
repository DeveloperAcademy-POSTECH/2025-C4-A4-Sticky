//
//  String+Extension.swift
//  Chaap
//
//  Created by BoMin Lee on 7/24/25.
//

import Foundation

extension String {
    var utf8ByteCount: Int {
        return self.data(using: .utf8)?.count ?? 0
    }

    func trimmedToMaxByteLength(_ maxBytes: Int) -> String {
        var trimmed = self
        while trimmed.utf8ByteCount > maxBytes {
            trimmed = String(trimmed.dropLast())
        }
        return trimmed
    }
}
