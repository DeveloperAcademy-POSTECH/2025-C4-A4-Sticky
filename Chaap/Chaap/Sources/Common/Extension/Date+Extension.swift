//
//  Date+Extension.swift
//  Chaap
//
//  Created by Enoch on 9/21/25.
//

import Foundation

extension Date {
    /// yyyy.MM.dd 요일 HH:mm 형태로 포맷팅
    func formatDateTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd EEEE HH:mm"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: self)
    }
}
