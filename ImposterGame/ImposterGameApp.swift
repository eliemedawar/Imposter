import SwiftUI

@main
struct ImposterGameApp: App {
    @StateObject private var store = GameStore()

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(store)
                .preferredColorScheme(.dark)
                .tint(.purple)
        }
    }
}
