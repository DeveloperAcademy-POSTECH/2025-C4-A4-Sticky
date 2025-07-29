//
//  MapSegmentViewModel.swift
//  Chaap
//
//  Created by BoMin Lee on 7/29/25.
//

import SwiftUI
import MapKit
import Observation

@Observable
final class MapSegmentViewModel {
    var cameraPosition: MapCameraPosition = .userLocation(fallback: .automatic)
    var currentMapCenter: CLLocationCoordinate2D?
    
    var markers: [ChaapMarker] = []
    
    var selectedChaaps: [Chaap]? = nil
}

extension MapSegmentViewModel {
    func loadMarkers(from chaaps: [Chaap]) {
        // 1. 좌표 있는 Chaap만 필터링
        let chaapsWithCoordinates = chaaps.filter {
            $0.latitude != nil && $0.longitude != nil
        }

        // 2. 반올림한 좌표로 그룹핑 (10m 단위)
        let grouped = Dictionary(grouping: chaapsWithCoordinates) { chaap in
            let latKey = round((chaap.latitude ?? 0) * 10_000) / 10_000
            let lonKey = round((chaap.longitude ?? 0) * 10_000) / 10_000
            return CoordinateKey(lat: latKey, lon: lonKey)
        }

        // 3. Marker 생성
        self.markers = grouped.map { key, group in
            let representative = group.first!
            let coordinate = CLLocationCoordinate2D(latitude: key.lat, longitude: key.lon)
            let title = representative.title.isEmpty ? representative.title : representative.place
            return ChaapMarker(coordinate: coordinate, title: title, count: group.count, chaaps: group)
        }
    }
}

struct ChaapMarker: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let title: String
    let count: Int
    let chaaps: [Chaap]
}

struct CoordinateKey: Hashable {
    let lat: Double
    let lon: Double
}
