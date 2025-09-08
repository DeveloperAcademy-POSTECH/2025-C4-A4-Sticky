//
//  UserProfileViewModel.swift
//  Chaap
//
//  Created by Enoch on 9/6/25.
//

import SwiftUI

@Observable
class UserProfileViewModel {
    // MARK: - Properties
    var nickname: String = "" {
        didSet {
            if nickname.count > 10 {
                nickname = String(nickname.prefix(10))
            }
            updateEditedState()
        }
    }
    
    var selectedImageName: String? {
        didSet {
            updateEditedState()
        }
    }
    
    private(set) var originalNickname: String
    private(set) var originalImageName: String?
    
    // 상태 플래그
    var hasUserEdited: Bool = false
    var isNextButtonEnabled: Bool {
        !nickname.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        && nickname.utf8ByteCount <= 50
    }
    
    // MARK: - Init
    init() {
        let savedNickname = UserDefaults.standard.string(forKey: UserDefaultsKey.nickname) ?? ""
        let savedImage = UserDefaults.standard.string(forKey: "SelectedProfileImageName")
        
        self.nickname = savedNickname
        self.originalNickname = savedNickname
        self.selectedImageName = savedImage
        self.originalImageName = savedImage
    }
    
    // MARK: - Save
    func saveProfile() {
        saveNickname()
        saveProfileImage()
        hasUserEdited = false
    }
    
    func saveNickname() {
        UserDefaults.standard.set(nickname, forKey: UserDefaultsKey.nickname)
        originalNickname = nickname
    }
    
    func saveProfileImage() {
        if let imgName = selectedImageName {
            UserDefaults.standard.set(imgName, forKey: "SelectedProfileImageName")
            originalImageName = imgName
        } else {
            UserDefaults.standard.removeObject(forKey: "SelectedProfileImageName")
            originalImageName = nil
        }
    }
    
    // MARK: - Helper
    private func updateEditedState() {
        hasUserEdited = (nickname != originalNickname) || (selectedImageName != originalImageName)
    }
}

enum UserDefaultsKey {
    static let nickname = "displayName"
}
