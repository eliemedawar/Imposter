import SwiftUI

struct CategoryEditorView: View {
    @EnvironmentObject private var store: GameStore
    @Environment(\.dismiss) private var dismiss
    @State private var draft: WordCategory
    @State private var newWord = ""
    @FocusState private var wordFieldFocused: Bool

    init(category: WordCategory) {
        _draft = State(initialValue: category)
    }

    private var isNew: Bool {
        !store.customCategories.contains { $0.id == draft.id }
    }

    private var canSave: Bool {
        !draft.name.trimmed.isEmpty && draft.cleanWords.count >= 2
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Category") {
                    TextField("Name (e.g. Movies)", text: $draft.name)
                        .textInputAutocapitalization(.words)
                    HStack {
                        Text("Emoji")
                        Spacer()
                        TextField("⭐️", text: $draft.emoji)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 80)
                    }
                }

                Section {
                    HStack {
                        TextField("Add a word", text: $newWord)
                            .textInputAutocapitalization(.words)
                            .autocorrectionDisabled()
                            .submitLabel(.done)
                            .focused($wordFieldFocused)
                            .onSubmit(addWords)
                        Button("Add", action: addWords)
                            .disabled(newWord.trimmed.isEmpty)
                    }

                    ForEach(draft.words, id: \.self) { word in
                        Text(word)
                    }
                    .onDelete { draft.words.remove(atOffsets: $0) }
                } header: {
                    Text("Words (\(draft.cleanWords.count))")
                } footer: {
                    Text("Tip: add several at once by separating them with commas. The imposter gets a different word from this same list, so related words make the game harder.")
                }
            }
            .navigationTitle(isNew ? "New category" : "Edit category")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save", action: save)
                        .disabled(!canSave)
                }
            }
        }
    }

    private func addWords() {
        let existing = Set(draft.words.map { $0.lowercased() })
        var added = Set<String>()
        let incoming = newWord
            .components(separatedBy: CharacterSet(charactersIn: ",\n"))
            .map(\.trimmed)
            .filter { word in
                let key = word.lowercased()
                return !word.isEmpty && !existing.contains(key) && added.insert(key).inserted
            }
        draft.words.insert(contentsOf: incoming, at: 0)
        newWord = ""
        wordFieldFocused = true
    }

    private func save() {
        var category = draft
        category.name = category.name.trimmed
        category.words = category.cleanWords
        let emoji = category.emoji.trimmed
        category.emoji = emoji.isEmpty ? "⭐️" : String(emoji.prefix(1))
        category.isBuiltIn = false
        store.saveCategory(category)
        dismiss()
    }
}
