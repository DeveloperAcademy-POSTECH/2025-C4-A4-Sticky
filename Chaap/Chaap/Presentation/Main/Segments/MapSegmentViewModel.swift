//
//  MapSegmentViewModel.swift
//  Chaap
//
//  Created by BoMin Lee on 7/24/25.
//

import Foundation
import MapKit
import SwiftData

@Observable
class MapSegmentViewModel {
    var chaaps: [Chaap] = [] {
        didSet {
            updateGroupedAnnotations()
        }
    }
    
    var groupedAnnotations: [CoordinateWrapper: [Chaap]] = [:]
    var shouldMoveToCurrentLocation: Bool = false
    var userDragged: Bool = false
    var cameraCenter: CLLocationCoordinate2D?
    
    private let threshold: Double = 0.0005 // 약 50m
    
    func updateGroupedAnnotations() {
        var grouped: [CoordinateWrapper: [Chaap]] = [:]
        
        for chaap in chaaps {
            guard let lat = chaap.latitude, let lon = chaap.longitude else { continue }
            let coord = CoordinateWrapper(CLLocationCoordinate2D(latitude: lat, longitude: lon))
            
            if let key = grouped.keys.first(where: {
                abs($0.latitude - coord.latitude) < threshold &&
                abs($0.longitude - coord.longitude) < threshold
            }) {
                grouped[key, default: []].append(chaap)
            } else {
                grouped[coord] = [chaap]
            }
        }
        
        groupedAnnotations = grouped
    }
    
    func requestMoveToCurrentLocation() {
        shouldMoveToCurrentLocation = true
    }
}

struct CoordinateWrapper: Hashable {
    let latitude: Double
    let longitude: Double
    
    init(_ coordinate: CLLocationCoordinate2D) {
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
    }
    
    var clCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
