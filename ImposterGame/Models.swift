import Foundation

struct Player: Identifiable, Codable, Hashable {
    var id = UUID()
    var name: String
}

struct WordCategory: Identifiable, Codable, Hashable {
    var id: String
    var name: String
    var emoji: String
    var words: [String]
    var isBuiltIn: Bool = false

    /// Trimmed, non-empty, case-insensitively unique words.
    var cleanWords: [String] {
        var seen = Set<String>()
        return words
            .map(\.trimmed)
            .filter { !$0.isEmpty && seen.insert($0.lowercased()).inserted }
    }

    static func newCustom() -> WordCategory {
        WordCategory(id: UUID().uuidString, name: "", emoji: "⭐️", words: [])
    }

    /// An editable copy of a built-in category.
    func customCopy() -> WordCategory {
        WordCategory(id: UUID().uuidString, name: "\(name) (mine)", emoji: emoji, words: cleanWords)
    }
}

struct Round: Identifiable {
    let id = UUID()
    let categoryName: String
    let categoryEmoji: String
    let civilianWord: String
    let imposterWord: String
    let players: [Player]
    let imposterIDs: Set<UUID>
    let starter: Player

    func word(for player: Player) -> String {
        imposterIDs.contains(player.id) ? imposterWord : civilianWord
    }

    var imposters: [Player] {
        players.filter { imposterIDs.contains($0.id) }
    }
}

extension String {
    var trimmed: String { trimmingCharacters(in: .whitespacesAndNewlines) }
}
