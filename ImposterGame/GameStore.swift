import Foundation

final class GameStore: ObservableObject {
    @Published var players: [Player] { didSet { persist() } }
    @Published var imposterCount: Int { didSet { persist() } }
    @Published var customCategories: [WordCategory] { didSet { persist() } }
    @Published var selectedCategoryIDs: Set<String> { didSet { persist() } }

    /// Recently used words, so the same word doesn't come up again right away.
    private var recentWords: [String] = []
    private let storageKey = "imposter.state.v1"

    private struct SavedState: Codable {
        var players: [Player]
        var imposterCount: Int
        var customCategories: [WordCategory]
        var selectedCategoryIDs: Set<String>
    }

    init() {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let saved = try? JSONDecoder().decode(SavedState.self, from: data) {
            players = saved.players
            imposterCount = saved.imposterCount
            customCategories = saved.customCategories
            selectedCategoryIDs = saved.selectedCategoryIDs
        } else {
            players = (1...5).map { Player(name: "Player \($0)") }
            imposterCount = 1
            customCategories = []
            selectedCategoryIDs = Set(BuiltInCategories.all.map(\.id))
        }
    }

    private func persist() {
        let state = SavedState(
            players: players,
            imposterCount: imposterCount,
            customCategories: customCategories,
            selectedCategoryIDs: selectedCategoryIDs
        )
        if let data = try? JSONEncoder().encode(state) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }

    // MARK: - Categories

    var allCategories: [WordCategory] { BuiltInCategories.all + customCategories }

    var playableSelectedCategories: [WordCategory] {
        allCategories.filter { selectedCategoryIDs.contains($0.id) && $0.cleanWords.count >= 2 }
    }

    func isSelected(_ category: WordCategory) -> Bool {
        selectedCategoryIDs.contains(category.id)
    }

    func toggle(_ category: WordCategory) {
        if selectedCategoryIDs.contains(category.id) {
            selectedCategoryIDs.remove(category.id)
        } else {
            selectedCategoryIDs.insert(category.id)
        }
    }

    func selectAll() { selectedCategoryIDs = Set(allCategories.map(\.id)) }
    func deselectAll() { selectedCategoryIDs = [] }

    func saveCategory(_ category: WordCategory) {
        if let index = customCategories.firstIndex(where: { $0.id == category.id }) {
            customCategories[index] = category
        } else {
            customCategories.append(category)
            selectedCategoryIDs.insert(category.id)
        }
    }

    func deleteCategory(_ category: WordCategory) {
        customCategories.removeAll { $0.id == category.id }
        selectedCategoryIDs.remove(category.id)
    }

    // MARK: - Game setup

    /// Imposters must be outnumbered by everyone else.
    var maxImposters: Int { max(1, (players.count - 1) / 2) }
    var effectiveImposterCount: Int { min(max(imposterCount, 1), maxImposters) }

    var startProblem: String? {
        if players.count < 3 { return "Add at least 3 players." }
        if players.contains(where: { $0.name.trimmed.isEmpty }) { return "Every player needs a name." }
        if playableSelectedCategories.isEmpty { return "Pick at least one category with 2 or more words." }
        return nil
    }

    func makeRound() -> Round? {
        guard startProblem == nil,
              let category = playableSelectedCategories.randomElement() else { return nil }

        let words = category.cleanWords
        var candidates = words.filter { !recentWords.contains($0.lowercased()) }
        if candidates.isEmpty { candidates = words }

        guard let civilianWord = candidates.randomElement(),
              let imposterWord = words.filter({ $0 != civilianWord }).randomElement() else { return nil }

        recentWords.append(civilianWord.lowercased())
        if recentWords.count > 20 { recentWords.removeFirst() }

        let roundPlayers = players.map { Player(id: $0.id, name: $0.name.trimmed) }
        let imposterIDs = Set(roundPlayers.shuffled().prefix(effectiveImposterCount).map(\.id))

        return Round(
            categoryName: category.name,
            categoryEmoji: category.emoji,
            civilianWord: civilianWord,
            imposterWord: imposterWord,
            players: roundPlayers,
            imposterIDs: imposterIDs,
            starter: roundPlayers.randomElement()!
        )
    }
}
