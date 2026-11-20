import SwiftUI

struct CategoryWordsView: View {
    let categoryID: String

    @EnvironmentObject private var store: GameStore
    @Environment(\.dismiss) private var dismiss
    @State private var showAdd = false
    @State private var showRename = false
    @State private var confirmDelete = false
    @State private var draft = ""

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 3)

    var body: some View {
        let category = store.category(id: categoryID)
        let selected = store.isSelected(categoryID)

        VStack(spacing: 0) {
            TopBar(category?.name ?? "", onTitleTap: {
                draft = category?.name ?? ""
                showRename = true
            }) {
                BackButton()
            } trailing: {
                Button { confirmDelete = true } label: {
                    IconTile(systemName: "trash")
                }
                .buttonStyle(PressableStyle())
                .accessibilityLabel("Delete category")
            }

            ScrollView {
                if let category, category.cleanWords.count < 2 {
                    Text("Add at least 2 words to play this category")
                        .font(Theme.font(12))
                        .tracking(1)
                        .foregroundStyle(Theme.red)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                        .padding(.top, 16)
                }

                LazyVGrid(columns: columns, spacing: 12) {
                    addTile
                    ForEach(category?.words ?? [], id: \.self) { word in
                        wordTile(word)
                    }
                }
                .padding(16)
                .padding(.bottom, 12)
            }

            Group {
                if selected {
                    Button("Deselect") {
                        store.setSelected(categoryID, false)
                        dismiss()
                    }
                    .buttonStyle(DarkButtonStyle(height: 60, fontSize: 19, fullWidth: true))
                } else {
                    Button("Select") {
                        store.setSelected(categoryID, true)
                        dismiss()
                    }
                    .buttonStyle(RedButtonStyle())
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .padding(.bottom, 16)
        }
        .themedScreen()
        .alert("Add words", isPresented: $showAdd) {
            TextField("Pizza, Burger, Sushi", text: $draft)
            Button("Add") {
                store.addWords(draft, to: categoryID)
                draft = ""
            }
            Button("Cancel", role: .cancel) { draft = "" }
        } message: {
            Text("Separate several words with commas.")
        }
        .alert("Rename category", isPresented: $showRename) {
            TextField("Name", text: $draft)
            Button("Save") {
                let name = draft.trimmed
                if !name.isEmpty { store.renameCategory(categoryID, to: name) }
                draft = ""
            }
            Button("Cancel", role: .cancel) { draft = "" }
        }
        .confirmationDialog("Delete this category?", isPresented: $confirmDelete, titleVisibility: .visible) {
            Button("Delete", role: .destructive) {
                store.deleteCategory(categoryID)
                dismiss()
            }
        } message: {
            Text(category?.isBuiltIn == true ? "You can restore built-in categories later." : "This can't be undone.")
        }
    }

    private var addTile: some View {
        Button {
            draft = ""
            showAdd = true
        } label: {
            VStack(spacing: 8) {
                Image(systemName: "plus")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(Theme.chipText)
                Text("Add a\nnew word")
                    .font(Theme.font(12))
                    .tracking(1.2)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Theme.softText)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 112)
            .dashedBorder(radius: 18)
            .contentShape(Rectangle())
        }
        .buttonStyle(PressableStyle())
    }

    private func wordTile(_ word: String) -> some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 0) {
                BubbleSticker(size: 46)
                    .padding(.top, 12)
                Spacer(minLength: 4)
                Text(word)
                    .font(Theme.font(12))
                    .tracking(1.2)
                    .foregroundStyle(Theme.text)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.7)
                    .padding(.horizontal, 6)
                    .padding(.bottom, 14)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 112)
            .raised(Theme.tile, radius: 18)

            Button {
                withAnimation { store.removeWord(word, from: categoryID) }
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundStyle(Color(hex: 0x6E6E74))
                    .frame(width: 32, height: 32)
            }
            .accessibilityLabel("Remove \(word)")
        }
    }
}
