//
//  ChaapComposeViewModel.swift
//  Chaap
//
//  Created by BoMin Lee on 8/31/25.
//

import AVFoundation

@MainActor
final class ChaapComposeViewModel: ObservableObject {
    @Published var showingCamera = false
    @Published var cameraDeniedAlert = false

    func openCameraTapped() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            showingCamera = true
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                Task { @MainActor in
                    if granted { self?.showingCamera = true }
                    else { self?.cameraDeniedAlert = true }
                }
            }
        case .denied, .restricted:
            cameraDeniedAlert = true
        @unknown default:
            cameraDeniedAlert = true
        }
    }
}
