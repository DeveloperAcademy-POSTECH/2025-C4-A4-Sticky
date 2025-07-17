//
//  ContentView.swift
//  Chaap
//
//  Created by BoMin Lee on 7/17/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
                .font(.chTitle) // 폰트 적용 테스트용으로 추가했습니다.
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
