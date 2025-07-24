//
//  MapSegmentView.swift
//  Chaap
//
//  Created by BoMin Lee on 7/17/25.
//

import SwiftUI
import SwiftData
import MapKit

struct MapSegmentView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = MapSegmentViewModel()
    
    var body: some View {
        MapView(viewModel: viewModel)
            .ignoresSafeArea()
            .onAppear {
                loadChaaps()
            }
    }
    
    func loadChaaps() {
        do {
            let fetchDescriptor = FetchDescriptor<Chaap>()
            let chaaps = try modelContext.fetch(fetchDescriptor)
            viewModel.chaaps = chaaps
        } catch {
            print("Chaap 불러오기 실패: \(error)")
        }
    }
}

struct MapView: UIViewRepresentable {
    var viewModel: MapSegmentViewModel
    private let mapView = MKMapView()

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> MKMapView {
        mapView.delegate = context.coordinator
        mapView.isRotateEnabled = false
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .none

        moveToCurrentLocationIfNeeded()

        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        // 기존 마커 제거 (사용자 위치 제외)
        uiView.removeAnnotations(uiView.annotations.filter { !($0 is MKUserLocation) })

        // 새로운 마커 추가
        for (coordWrapper, group) in viewModel.groupedAnnotations {
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordWrapper.clCoordinate
            annotation.title = group.count > 1 ? "기록 \(group.count)개" : (group.first?.title ?? "기록")
            uiView.addAnnotation(annotation)
        }

        // 중심 좌표 업데이트
        viewModel.cameraCenter = uiView.centerCoordinate

        // 현재 위치로 이동 요청 시
        if viewModel.shouldMoveToCurrentLocation {
            moveToCurrentLocationIfNeeded()
            DispatchQueue.main.async {
                viewModel.shouldMoveToCurrentLocation = false
            }
        }
    }

    private func moveToCurrentLocationIfNeeded() {
        guard let location = LocationManager.shared.currentLocation else { return }
        let region = MKCoordinateRegion(
            center: location.coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        )
        mapView.setRegion(region, animated: true)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        private var userInteracted = false

        init(_ parent: MapView) {
            self.parent = parent
        }

        func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
            if let view = mapView.subviews.first,
               let gestures = view.gestureRecognizers {
                for gesture in gestures where gesture.state == .began || gesture.state == .changed {
                    userInteracted = true
                    break
                }
            }
        }

        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            parent.viewModel.cameraCenter = mapView.centerCoordinate
            if userInteracted {
                parent.viewModel.userDragged = true
            }
        }

        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if annotation is MKUserLocation {
                return nil
            }

            let identifier = "ChaapAnnotation"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView

            if annotationView == nil {
                annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
                annotationView?.markerTintColor = .systemGreen
            } else {
                annotationView?.annotation = annotation
            }

            return annotationView
        }
    }
}

#Preview {
    MapSegmentView()
}
