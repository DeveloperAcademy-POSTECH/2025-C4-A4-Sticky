//
//  ChaapApp.swift
//  Chaap
//
//  Created by BoMin Lee on 7/17/25.
//

import SwiftUI

@main
struct ChaapApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: [Chaap.self, Peer.self])
        }
    }
}
