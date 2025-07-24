//
//  String+Extension.swift
//  Chaap
//
//  Created by BoMin Lee on 7/24/25.
//

import Foundation

extension String {
    /// 문자열의 UTF-8 바이트 수
    var utf8ByteCount: Int {
        return self.data(using: .utf8)?.count ?? 0
    }
    
    /// 주어진 바이트 수 이하로 잘린 문자열 반환
    func trimmedToMaxByteLength(_ maxBytes: Int) -> String {
        var trimmed = self
        while trimmed.utf8ByteCount > maxBytes {
            trimmed = String(trimmed.dropLast())
        }
        return trimmed
    }
}
