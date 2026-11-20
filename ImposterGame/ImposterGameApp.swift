import SwiftUI

enum Route: Hashable {
    case players
    case categories
    case words(String)
    case timer
    case result
}

final class Router: ObservableObject {
    @Published var path: [Route] = []
}

@main
struct ImposterGameApp: App {
    @StateObject private var store = GameStore()
    @StateObject private var router = Router()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(store)
                .environmentObject(router)
                .preferredColorScheme(.dark)
        }
    }
}

struct RootView: View {
    @EnvironmentObject private var store: GameStore
    @EnvironmentObject private var router: Router

    var body: some View {
        NavigationStack(path: $router.path) {
            DeckView()
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .players: PlayersView()
                    case .categories: CategoriesView()
                    case .words(let id): CategoryWordsView(categoryID: id)
                    case .timer: TimerView()
                    case .result: ResultView()
                    }
                }
        }
        .tint(Theme.red)
        .onChange(of: router.path) { path in
            if path.isEmpty { store.dealIfNeeded() }
        }
    }
}
