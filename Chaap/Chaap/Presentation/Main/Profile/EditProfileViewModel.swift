//
//  EditProfileViewModel.swift
//  Chaap
//
//  Created by BoMin Lee on 7/24/25.
//

import SwiftUI

@Observable
class EditProfileViewModel {
    private var rawNickname: String
    var originalNickname: String
    var originalImageName: String? = UserDefaults.standard.string(forKey: "SelectedProfileImageName")

    var hasUserEdited: Bool = false
    
    var nickname: String {
        get { rawNickname }
        set {
            rawNickname = newValue.utf8ByteCount > 50
            ? newValue.trimmedToMaxByteLength(50)
            : newValue
            hasUserEdited = true
        }
    }
    
    var selectedImageName: String? {
        didSet {
            hasUserEdited = (selectedImageName != originalImageName) || hasUserEdited
        }
    }

    init() {
        // Original Nickname UserDefaults에서 가져옴
        let saved = UserDefaults.standard.string(forKey: UserDefaultsKey.nickname) ?? ""
        self.rawNickname = saved
        self.originalNickname = saved
        self.selectedImageName = originalImageName 
    }

    func saveNickname() {
        UserDefaults.standard.set(nickname, forKey: UserDefaultsKey.nickname)
        originalNickname = nickname
        hasUserEdited = false
    }
    
    func saveProfileImage() {
        if let imgName = selectedImageName {
            UserDefaults.standard.set(imgName, forKey: "SelectedProfileImageName")
            originalImageName = imgName
        } else {
            UserDefaults.standard.removeObject(forKey: "SelectedProfileImageName")
            originalImageName = nil
        }
        hasUserEdited = false
    }
}

enum UserDefaultsKey {
    static let nickname = "displayName"
}
