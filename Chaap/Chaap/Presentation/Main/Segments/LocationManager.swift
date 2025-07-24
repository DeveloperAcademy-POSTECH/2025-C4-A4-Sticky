//
//  LocationManager.swift
//  Chaap
//
//  Created by BoMin Lee on 7/24/25.
//

import Foundation
import CoreLocation
import MapKit
import Observation

@Observable
class LocationManager: NSObject {
    static let shared = LocationManager()
    
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    
    var currentLocation: CLLocation?
    var currentHeading: CLHeading?
    
    var currentAddress: String? = nil
    
    var currentSpeed: CLLocationSpeed = 0
    var currentDirection: CLLocationDirection = 0
    
    var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    override init() {
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.headingFilter = kCLHeadingFilterNone
        
        requestAuthorization()
        startUpdatingLocation()
    }
    
    /// 권한 요청
    func requestAuthorization() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
    }

    /// 위치 추적
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }

    /// Significant Location Change
    func startMonitoringSignificantLocationChanges() {
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    func stopMonitoringSignificantLocationChanges() {
        locationManager.stopMonitoringSignificantLocationChanges()
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let latest = locations.last {
            DispatchQueue.main.async {
                self.currentLocation = latest
                self.currentSpeed = max(latest.speed, 0)
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        DispatchQueue.main.async {
            self.currentHeading = newHeading
            self.currentDirection = newHeading.trueHeading > 0 ? newHeading.trueHeading : newHeading.magneticHeading
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("위치 오류: \(error.localizedDescription)")
    }
}

/// Reverse Geocoding
extension LocationManager {
    @MainActor
    func reverseGeocode(location: CLLocation) async {
        do {
            let placemarks = try await geocoder.reverseGeocodeLocation(location)
            if let placemark = placemarks.first {
                let address = [
                    placemark.administrativeArea, // 시/도
                    placemark.locality, // 시
                    placemark.subLocality, // 동네
                    placemark.thoroughfare, // 상세주소
                    // placemark.name // 장소명인데 일단 도로명으로 뜨긴 함... 검색용일지도?
                ]
                    .compactMap { $0 }
                    .joined(separator: " ")
                
                self.currentAddress = address
                print("✅ 역지오코딩 주소: \(address)")
            }
        } catch {
            print("❌ 역지오코딩 실패: \(error.localizedDescription)")
        }
    }
}

extension LocationManager {
    func printCurrentLocation() async {
        if let location = currentLocation {
            print("현재 위치: 위도 \(location.coordinate.latitude), 경도 \(location.coordinate.longitude)")
            await reverseGeocode(location: location)
        } else {
            print("현재 위치 정보를 가져올 수 없습니다.")
        }
    }
}
