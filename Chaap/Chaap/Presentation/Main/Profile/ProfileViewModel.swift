//
//  ProfileViewModel.swift
//  Chaap
//
//  Created by BoMin Lee on 7/24/25.
//

import SwiftUI

@Observable
class ProfileViewModel {
    private var rawNickname: String = ""

    var nickname: String {
        get { rawNickname }
        set {
            rawNickname = newValue.utf8ByteCount > 50
                ? newValue.trimmedToMaxByteLength(50)
                : newValue
        }
    }

    var isNextButtonEnabled: Bool {
        !nickname.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && nickname.utf8ByteCount <= 50
    }

    func saveNickname() {
        UserDefaults.standard.set(nickname, forKey: UserDefaultsKey.nickname)
    }
}
