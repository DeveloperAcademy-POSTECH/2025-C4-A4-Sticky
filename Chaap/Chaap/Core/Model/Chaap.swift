//
//  Chaap.swift
//  Chaap
//
//  Created by BoMin Lee on 7/21/25.
//

import Foundation
import SwiftData

@Model
class Chaap {
    @Attribute(.unique) var id: UUID = UUID()
    
    /// 기본으로 생성되는 것들
    var createdAt: Date
    var place: String? // 사용자가 수정 가능하게끔
    var latitude: Double?
    var longitude: Double?
    
    /// Optional, 사용자가 입력
    var title: String?
    var memo: String?
    var photoData: Data?
    
    /// Peer 목록
    @Relationship(deleteRule: .nullify) var peers: [Peer] = []
    
    init(createdAt: Date = Date(),
         place: String? = nil,
         latitude: Double? = nil,
         longitude: Double? = nil,
         title: String? = nil,
         memo: String? = nil,
         photoData: Data? = nil,
         peers: [Peer]) {
        
        self.createdAt = createdAt
        self.place = place
        self.latitude = latitude
        self.longitude = longitude
        self.title = title
        self.memo = memo
        self.photoData = photoData
        self.peers = peers
    }
    
    /// Chaap의 수정 가능 여부를 결정
    var isEditable: Bool {
        return Date().timeIntervalSince(createdAt) < 86400 // 24시간
    }
}
