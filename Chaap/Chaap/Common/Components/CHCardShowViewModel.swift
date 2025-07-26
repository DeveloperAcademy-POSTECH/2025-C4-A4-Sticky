//
//  CHCardShowViewModel.swift
//  Chaap
//
//  Created by Enoch on 7/25/25.
//

import Foundation
import SwiftData

@Observable
class CHCardShowViewModel {
    var chaap: Chaap
    
    init(chaap: Chaap) {
        self.chaap = chaap
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd EEEE HH:mm"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: chaap.createdAt)
    }
    
    var peerName: String {
        chaap.peers.first?.displayName ?? "이름 없음"
    }
    
    var title: String {
        chaap.title ?? "제목 없음"
    }
    
    var memo: String {
        chaap.memo ?? "내용 없음"
    }
    
    var location: String {
        chaap.place ?? "장소 정보 없음"
    }
}
