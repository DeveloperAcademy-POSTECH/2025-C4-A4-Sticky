//
//  CameraPicker.swift
//  Chaap
//
//  Created by BoMin Lee on 8/31/25.
//

import SwiftUI
import UIKit
import CoreImage

struct CameraPicker: UIViewControllerRepresentable {
    @Environment(\.dismiss) private var dismiss
    let onImagePicked: (Data) -> Void   // JPEG Data를 콜백으로 넘김

    final class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: CameraPicker
        init(_ parent: CameraPicker) { self.parent = parent }

        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            // 원본 이미지 우선
            let image = (info[.originalImage] ?? info[.editedImage]) as? UIImage
//            if let image, let data = image.jpegData(compressionQuality: 0.9) {
//                parent.onImagePicked(data)
//            }
            if let image,
               let data = squareCroppedJPEGData(from: image, targetMaxSide: nil, quality: 0.9) {
                parent.onImagePicked(data)
            }
            parent.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
        
        func squareCroppedJPEGData(from image: UIImage,
                                   targetMaxSide: CGFloat? = nil,
                                   quality: CGFloat = 0.9) -> Data? {
            var cg: CGImage?
            if let raw = image.cgImage {
                cg = raw
            } else if let ci = image.ciImage {
                let ctx = CIContext(options: nil)
                cg = ctx.createCGImage(ci, from: ci.extent)
            }
            guard let src = cg else { return image.jpegData(compressionQuality: quality) }

            let w = src.width, h = src.height
            let side = min(w, h)
            let x = (w - side) / 2
            let y = (h - side) / 2
            guard let cropped = src.cropping(to: CGRect(x: x, y: y, width: side, height: side)) else {
                return image.jpegData(compressionQuality: quality)
            }

            let square = UIImage(cgImage: cropped, scale: image.scale, orientation: image.imageOrientation)
            let output: UIImage
            if let target = targetMaxSide, target > 0 {
                let renderer = UIGraphicsImageRenderer(size: CGSize(width: target, height: target))
                output = renderer.image { _ in
                    square.draw(in: CGRect(origin: .zero, size: CGSize(width: target, height: target)))
                }
            } else {
                output = square
            }

            return output.jpegData(compressionQuality: quality)
        }
    }

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        picker.cameraCaptureMode = .photo
        picker.allowsEditing = false
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}
