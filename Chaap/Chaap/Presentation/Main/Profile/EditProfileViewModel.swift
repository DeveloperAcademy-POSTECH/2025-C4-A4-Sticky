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

    var nickname: String {
        get { rawNickname }
        set {
            rawNickname = newValue.utf8ByteCount > 50
                ? newValue.trimmedToMaxByteLength(50)
                : newValue
            hasUserEdited = true
        }
    }

    var hasUserEdited: Bool = false

    var hasChanges: Bool {
        nickname != originalNickname
    }

    init() {
        // Original Nickname UserDefaults에서 가져옴
        let saved = UserDefaults.standard.string(forKey: UserDefaultsKey.nickname) ?? ""
        self.rawNickname = saved
        self.originalNickname = saved
    }

    func saveNickname() {
        UserDefaults.standard.set(nickname, forKey: UserDefaultsKey.nickname)
        originalNickname = nickname
        hasUserEdited = false
    }
}

enum UserDefaultsKey {
    static let nickname = "nickname"
}
