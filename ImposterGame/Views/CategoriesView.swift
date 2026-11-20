import SwiftUI

struct CategoriesView: View {
    @EnvironmentObject private var store: GameStore
    @State private var editing: WordCategory?

    var body: some View {
        List {
            Section {
                ForEach(BuiltInCategories.all) { category in
                    row(for: category)
                        .swipeActions(edge: .trailing) {
                            Button {
                                editing = category.customCopy()
                            } label: {
                                Label("Customize", systemImage: "square.and.pencil")
                            }
                            .tint(.orange)
                        }
                }
            } header: {
                Text("Built-in")
            } footer: {
                Text("Swipe left on a built-in category to make your own editable copy.")
            }

            Section {
                ForEach(store.customCategories) { category in
                    row(for: category)
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                store.deleteCategory(category)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                            Button {
                                editing = category
                            } label: {
                                Label("Edit", systemImage: "pencil")
                            }
                            .tint(.orange)
                        }
                }

                Button {
                    editing = .newCustom()
                } label: {
                    Label("Create category", systemImage: "plus.circle.fill")
                }
            } header: {
                Text("My categories")
            } footer: {
                Text("Swipe left on your categories to edit or delete them. A category needs at least 2 words.")
            }
        }
        .navigationTitle("Categories")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button("Select all") { store.selectAll() }
                    Button("Deselect all") { store.deselectAll() }
                } label: {
                    Image(systemName: "checklist")
                }
            }
        }
        .sheet(item: $editing) { category in
            CategoryEditorView(category: category).environmentObject(store)
        }
    }

    private func row(for category: WordCategory) -> some View {
        let selected = store.isSelected(category)
        let wordCount = category.cleanWords.count
        return Button {
            store.toggle(category)
        } label: {
            HStack(spacing: 14) {
                Text(category.emoji)
                    .font(.title2)
                VStack(alignment: .leading, spacing: 2) {
                    Text(category.name.isEmpty ? "Untitled" : category.name)
                        .foregroundStyle(.primary)
                    Text(wordCount < 2 ? "Needs at least 2 words" : "\(wordCount) words")
                        .font(.caption)
                        .foregroundStyle(wordCount < 2 ? Color.orange : Color.secondary)
                }
                Spacer()
                Image(systemName: selected ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundStyle(selected ? Color.accentColor : Color.secondary)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
