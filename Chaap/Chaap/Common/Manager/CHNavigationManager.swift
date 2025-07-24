//
//  CHNavigationRouter.swift
//  Chaap
//
//  Created by BoMin Lee on 7/24/25.
//

import Foundation

/// MainView에서 도달 가능한 Route
enum CHAppRoute: Hashable {
    case search
    case editProfile
    case chaapping
}

class CHNavigationManager: ObservableObject {
    @Published var appRoutes: [CHAppRoute] = []
    
    func push(_ route: CHAppRoute) {
        appRoutes.append(route)
    }
    
    func pop() {
        appRoutes.removeLast()
    }
    
    func goToRoot() {
        appRoutes.removeAll()
    }
}

// MARK: 사용 예시는 다음과 같습니다
//struct ContentView: View {
//    @StateObject private var router = CHNavigationManager()
//    
//    var body: some View {
//        NavigationStack(path: $route.appRoutes) {
//            MainView()
//                .navigationDestination(for: CHAppRoute.self) { route in
//                    switch route {
//                    case .search:
//                        SearchView()
//                    case .editProfile:
//                        EditProfileView()
//                    case .chaapping:
//                        ChaappingView()
//                    }
//                }
//        }
//        .environmentObject(router)
//    }
//}

// MARK: push 액션 예시
//Button(action: {
//    router.push(.search)
//}) {
//    Image(systemName: "magnifyingglass")
//}
