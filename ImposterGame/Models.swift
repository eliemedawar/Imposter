import Foundation

struct Player: Identifiable, Codable, Hashable {
    var id = UUID()
    var name: String
}

struct WordCategory: Identifiable, Codable, Hashable {
    var id: String
    var name: String
    var words: [String]

    var isBuiltIn: Bool { id.hasPrefix(BuiltInCategories.idPrefix) }

    /// Trimmed, non-empty, case-insensitively unique words.
    var cleanWords: [String] {
        var seen = Set<String>()
        return words
            .map(\.trimmed)
            .filter { !$0.isEmpty && seen.insert($0.lowercased()).inserted }
    }
}

struct Round {
    let categoryName: String
    let civilianWord: String
    let imposterWord: String
    let players: [Player]
    let imposterIDs: Set<UUID>
    let starter: Player

    func word(for index: Int) -> String {
        imposterIDs.contains(players[index].id) ? imposterWord : civilianWord
    }

    var imposters: [Player] {
        players.filter { imposterIDs.contains($0.id) }
    }
}

extension String {
    var trimmed: String { trimmingCharacters(in: .whitespacesAndNewlines) }
}
