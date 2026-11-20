import SwiftUI

struct CategoriesView: View {
    @EnvironmentObject private var store: GameStore
    @EnvironmentObject private var router: Router
    @State private var showNew = false
    @State private var newName = ""

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 3)

    var body: some View {
        VStack(spacing: 0) {
            TopBar("Categories") {
                BackButton()
            } trailing: {
                Button {
                    haptic(.light)
                    if store.allSelected {
                        store.deselectAll()
                    } else {
                        store.selectAll()
                    }
                } label: {
                    Text(store.allSelected ? "None" : "Select all")
                        .font(Theme.font(12))
                        .tracking(1.2)
                        .foregroundStyle(Theme.red)
                        .padding(.horizontal, 12)
                        .frame(height: 44)
                        .raised(Theme.surface, radius: 12)
                }
                .buttonStyle(PressableStyle())
            }

            ScrollView {
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(store.allCategories) { category in
                        tile(category)
                    }
                    newTile
                }
                .padding(16)

                if !store.hiddenBuiltInIDs.isEmpty {
                    Button("Restore built-in categories") {
                        store.restoreBuiltIns()
                    }
                    .buttonStyle(DarkButtonStyle(fontSize: 13, fullWidth: true))
                    .padding(.horizontal, 16)
                }

                Text("Tap to select. Each round picks one of the selected categories at random. Use the arrow to see or edit its words.")
                    .font(Theme.lightFont(12))
                    .tracking(0.8)
                    .lineSpacing(5)
                    .foregroundStyle(Theme.muted)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .padding(.top, 14)
                    .padding(.bottom, 30)
            }
        }
        .themedScreen()
        .alert("New category", isPresented: $showNew) {
            TextField("Name", text: $newName)
            Button("Create") {
                let name = newName.trimmed
                guard !name.isEmpty else { return }
                let id = store.createCategory(named: name)
                router.path.append(.words(id))
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Then add the words for it.")
        }
    }

    private func tile(_ category: WordCategory) -> some View {
        let selected = store.isSelected(category.id)
        let count = category.cleanWords.count
        return ZStack(alignment: .bottomTrailing) {
            Button {
                haptic(.light)
                store.toggle(category.id)
            } label: {
                VStack(spacing: 0) {
                    SpySticker(size: 54)
                        .padding(.top, 14)
                    Text(category.name)
                        .font(Theme.font(13))
                        .tracking(1.2)
                        .foregroundStyle(Theme.text)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .minimumScaleFactor(0.7)
                        .padding(.horizontal, 6)
                        .padding(.top, 10)
                    Text(count < 2 ? "Needs words" : "\(count)")
                        .font(Theme.font(12))
                        .tracking(1.2)
                        .foregroundStyle(count < 2 ? Theme.red : Theme.muted)
                        .padding(.top, 5)
                    Spacer(minLength: 0)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 150)
                .background(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(selected ? Theme.selectedTile : Theme.tile)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .strokeBorder(selected ? Theme.ring : Color.white.opacity(0.05), lineWidth: selected ? 2 : 1)
                )
                .shadow(color: .black.opacity(0.5), radius: 6, y: 5)
            }
            .buttonStyle(PressableStyle())
            .accessibilityLabel("\(category.name), \(count) words")
            .accessibilityAddTraits(selected ? .isSelected : [])

            NavigationLink(value: Route.words(category.id)) {
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(Theme.dim)
                    .frame(width: 40, height: 40)
            }
            .accessibilityLabel("Edit words in \(category.name)")
        }
        .overlay(alignment: .topTrailing) {
            if selected {
                Image(systemName: "checkmark")
                    .font(.system(size: 12, weight: .heavy))
                    .foregroundStyle(.white)
                    .frame(width: 26, height: 26)
                    .background(Circle().fill(Theme.ring))
                    .shadow(color: .black.opacity(0.5), radius: 3, y: 2)
                    .offset(x: 6, y: -6)
                    .allowsHitTesting(false)
            }
        }
    }

    private var newTile: some View {
        Button {
            newName = ""
            showNew = true
        } label: {
            VStack(spacing: 8) {
                Image(systemName: "plus")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(Theme.chipText)
                Text("New\ncategory")
                    .font(Theme.font(12))
                    .tracking(1.2)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Theme.softText)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 150)
            .dashedBorder(radius: 18)
            .contentShape(Rectangle())
        }
        .buttonStyle(PressableStyle())
    }
}
