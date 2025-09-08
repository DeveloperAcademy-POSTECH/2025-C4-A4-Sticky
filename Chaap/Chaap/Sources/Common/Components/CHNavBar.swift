//
//  CHNavBar.swift
//  Chaap
//
//  Created by Enoch on 7/25/25.
//

import SwiftUI

struct CHNavBar: View {
    @Binding var selectedImageName: String?
    var didPressSearchButton: () -> Void
    var didPressProfileButton: () -> Void
    
    var body: some View {
        HStack(spacing: 9) {
            Spacer()
            searchButton
            profileButton
        }
    }
    
    // MARK: - Search Button
    var searchButton: some View {
        Button(action: {
            didPressSearchButton()
        }, label: {
            VStack {
                CHCircleButton(buttonImageName: "magnifyingglass")
            }
        })
    }
    
    // MARK: - Profile Button
    var profileButton: some View {
        Button(action: {
            didPressProfileButton()
        }, label: {
            ZStack {
                Circle()
                    .frame(width: 44, height: 44)
                    .foregroundColor(Color.chLabelWhitePrimary)
                
                if let imageName = selectedImageName, !imageName.isEmpty {
                    Image(imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 24, height: 24)
                } else {
                    Image(.profileButterfly)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 24, height: 24)
                }
            }
        })
    }
}

extension UINavigationController: UIGestureRecognizerDelegate {
    fileprivate static var isGestureDisabled: Bool = false
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.isHidden = true
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1 && !UINavigationController.isGestureDisabled
    }
}
