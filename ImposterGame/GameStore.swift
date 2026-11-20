import Foundation

final class GameStore: ObservableObject {
    // MARK: Saved settings

    @Published var players: [Player] { didSet { settingsChanged() } }
    @Published var imposterCount: Int { didSet { settingsChanged() } }
    @Published var roundMinutes: Int { didSet { persist() } }
    /// User categories, plus edited copies of built-in ones (same id as the built-in).
    @Published var customCategories: [WordCategory] { didSet { settingsChanged() } }
    @Published var hiddenBuiltInIDs: Set<String> { didSet { settingsChanged() } }
    @Published var selectedCategoryIDs: Set<String> { didSet { settingsChanged() } }

    // MARK: Current deal (not saved)

    @Published private(set) var round: Round? = nil
    @Published var cardIndex = 0
    @Published var cardRevealed = false
    @Published var allDealt = false

    private var needsDeal = true
    /// Recently used words, so the same word doesn't come up again right away.
    private var recentWords: [String] = []
    private let storageKey = "imposter.state.v2"

    private struct SavedState: Codable {
        var players: [Player]
        var imposterCount: Int
        var roundMinutes: Int?
        var customCategories: [WordCategory]
        var hiddenBuiltInIDs: Set<String>?
        var selectedCategoryIDs: Set<String>
    }

    init() {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let saved = try? JSONDecoder().decode(SavedState.self, from: data) {
            players = saved.players
            imposterCount = saved.imposterCount
            roundMinutes = saved.roundMinutes ?? 5
            customCategories = saved.customCategories
            hiddenBuiltInIDs = saved.hiddenBuiltInIDs ?? []
            selectedCategoryIDs = saved.selectedCategoryIDs
        } else {
            players = (1...5).map { Player(name: "Player \($0)") }
            imposterCount = 1
            roundMinutes = 5
            customCategories = []
            hiddenBuiltInIDs = []
            selectedCategoryIDs = Set(BuiltInCategories.all.map(\.id))
        }
    }

    private func settingsChanged() {
        needsDeal = true
        persist()
    }

    private func persist() {
        let state = SavedState(
            players: players,
            imposterCount: imposterCount,
            roundMinutes: roundMinutes,
            customCategories: customCategories,
            hiddenBuiltInIDs: hiddenBuiltInIDs,
            selectedCategoryIDs: selectedCategoryIDs
        )
        if let data = try? JSONEncoder().encode(state) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }

    // MARK: - Players

    func addPlayer(named name: String) {
        players.append(Player(name: name))
    }

    func removePlayer(id: UUID) {
        players.removeAll { $0.id == id }
    }

    /// Imposters must be outnumbered by everyone else.
    var maxImposters: Int { max(1, (players.count - 1) / 2) }
    var effectiveImposterCount: Int { min(max(imposterCount, 1), maxImposters) }

    var playersAreReady: Bool {
        players.count >= 3 && !players.contains { $0.name.trimmed.isEmpty }
    }

    // MARK: - Categories

    var allCategories: [WordCategory] {
        let edited = Dictionary(customCategories.map { ($0.id, $0) }, uniquingKeysWith: { first, _ in first })
        let builtIns = BuiltInCategories.all
            .filter { !hiddenBuiltInIDs.contains($0.id) }
            .map { edited[$0.id] ?? $0 }
        return builtIns + customCategories.filter { !$0.isBuiltIn }
    }

    func category(id: String) -> WordCategory? {
        allCategories.first { $0.id == id }
    }

    var playableSelectedCategories: [WordCategory] {
        allCategories.filter { selectedCategoryIDs.contains($0.id) && $0.cleanWords.count >= 2 }
    }

    func isSelected(_ id: String) -> Bool { selectedCategoryIDs.contains(id) }

    func setSelected(_ id: String, _ selected: Bool) {
        if selected {
            selectedCategoryIDs.insert(id)
        } else {
            selectedCategoryIDs.remove(id)
        }
    }

    func toggle(_ id: String) { setSelected(id, !isSelected(id)) }

    var allSelected: Bool {
        allCategories.allSatisfy { selectedCategoryIDs.contains($0.id) }
    }

    func selectAll() { selectedCategoryIDs = Set(allCategories.map(\.id)) }
    func deselectAll() { selectedCategoryIDs = [] }

    /// Creates an empty, selected category and returns its id.
    func createCategory(named name: String) -> String {
        let category = WordCategory(id: UUID().uuidString, name: name, words: [])
        customCategories.append(category)
        selectedCategoryIDs.insert(category.id)
        return category.id
    }

    /// Changes a category; editing a built-in one saves an edited copy of it.
    func updateCategory(id: String, _ change: (inout WordCategory) -> Void) {
        if let index = customCategories.firstIndex(where: { $0.id == id }) {
            change(&customCategories[index])
        } else if var builtIn = BuiltInCategories.all.first(where: { $0.id == id }) {
            change(&builtIn)
            customCategories.append(builtIn)
        }
    }

    /// Adds words separated by commas or new lines, skipping ones already in the category.
    func addWords(_ text: String, to id: String) {
        updateCategory(id: id) { category in
            var known = Set(category.words.map { $0.lowercased() })
            let incoming = text
                .components(separatedBy: CharacterSet(charactersIn: ",\n"))
                .map(\.trimmed)
                .filter { !$0.isEmpty && known.insert($0.lowercased()).inserted }
            category.words.insert(contentsOf: incoming, at: 0)
        }
    }

    func removeWord(_ word: String, from id: String) {
        updateCategory(id: id) { $0.words.removeAll { $0 == word } }
    }

    func renameCategory(_ id: String, to name: String) {
        updateCategory(id: id) { $0.name = name }
    }

    func deleteCategory(_ id: String) {
        if BuiltInCategories.all.contains(where: { $0.id == id }) {
            hiddenBuiltInIDs.insert(id)
        }
        customCategories.removeAll { $0.id == id }
        selectedCategoryIDs.remove(id)
    }

    func restoreBuiltIns() { hiddenBuiltInIDs = [] }

    // MARK: - Dealing

    var startProblem: String? {
        if players.count < 3 { return "Add at least 3 players" }
        if players.contains(where: { $0.name.trimmed.isEmpty }) { return "Every player needs a name" }
        if playableSelectedCategories.isEmpty { return "Choose a category" }
        return nil
    }

    func deal() {
        round = makeRound()
        cardIndex = 0
        cardRevealed = false
        allDealt = false
        needsDeal = false
    }

    func dealIfNeeded() {
        if needsDeal || round == nil { deal() }
    }

    /// The next time the deck shows, it deals fresh cards.
    func finishRound() { needsDeal = true }

    private func makeRound() -> Round? {
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
            civilianWord: civilianWord,
            imposterWord: imposterWord,
            players: roundPlayers,
            imposterIDs: imposterIDs,
            starter: roundPlayers.randomElement()!
        )
    }
}
