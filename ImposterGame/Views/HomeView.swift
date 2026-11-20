import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var store: GameStore
    @State private var round: Round?
    @State private var showHelp = false
    @FocusState private var focusedPlayer: UUID?

    var body: some View {
        NavigationStack {
            List {
                playersSection
                impostersSection
                categoriesSection
            }
            .navigationTitle("Imposter")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button { showHelp = true } label: {
                        Image(systemName: "questionmark.circle")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
            .safeAreaInset(edge: .bottom) { startBar }
            .sheet(isPresented: $showHelp) { HowToPlayView() }
            .fullScreenCover(item: $round) { round in
                GameView(round: round).environmentObject(store)
            }
        }
    }

    // MARK: - Sections

    private var playersSection: some View {
        Section {
            ForEach(store.players) { player in
                HStack(spacing: 12) {
                    Image(systemName: "person.fill")
                        .foregroundStyle(.secondary)
                    TextField("Player name", text: nameBinding(for: player))
                        .textInputAutocapitalization(.words)
                        .autocorrectionDisabled()
                        .submitLabel(.done)
                        .focused($focusedPlayer, equals: player.id)
                }
            }
            .onDelete { store.players.remove(atOffsets: $0) }
            .onMove { store.players.move(fromOffsets: $0, toOffset: $1) }

            Button(action: addPlayer) {
                Label("Add player", systemImage: "plus.circle.fill")
            }
        } header: {
            Text("Players (\(store.players.count))")
        } footer: {
            Text("Swipe left on a player to remove them. Tap Edit to reorder.")
        }
    }

    private var impostersSection: some View {
        Section {
            Stepper(value: imposterBinding, in: 1...store.maxImposters) {
                HStack {
                    Label("Imposters", systemImage: "theatermasks.fill")
                    Spacer()
                    Text("\(store.effectiveImposterCount)")
                        .font(.headline)
                        .monospacedDigit()
                }
            }
        } footer: {
            Text("Imposters get a different word from the same category, and they don't know it. Max \(store.maxImposters) for \(store.players.count) players.")
        }
    }

    private var categoriesSection: some View {
        Section {
            NavigationLink {
                CategoriesView()
            } label: {
                HStack {
                    Label("Categories", systemImage: "square.grid.2x2.fill")
                    Spacer()
                    Text("\(store.playableSelectedCategories.count) selected")
                        .foregroundStyle(.secondary)
                }
            }
        } footer: {
            Text("Each round picks a random category from the ones you select. You can create your own categories too.")
        }
    }

    private var startBar: some View {
        VStack(spacing: 8) {
            if let problem = store.startProblem {
                Text(problem)
                    .font(.footnote)
                    .foregroundStyle(.orange)
            }
            Button {
                focusedPlayer = nil
                round = store.makeRound()
            } label: {
                Label("Start game", systemImage: "play.fill")
            }
            .buttonStyle(BigButtonStyle(color: .purple, textColor: .white))
            .disabled(store.startProblem != nil)
            .opacity(store.startProblem == nil ? 1 : 0.5)
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(.bar)
    }

    // MARK: - Helpers

    private var imposterBinding: Binding<Int> {
        Binding(
            get: { store.effectiveImposterCount },
            set: { store.imposterCount = $0 }
        )
    }

    /// Looks the player up by id so deleting rows never reads a stale index.
    private func nameBinding(for player: Player) -> Binding<String> {
        Binding(
            get: { store.players.first { $0.id == player.id }?.name ?? "" },
            set: { newValue in
                if let index = store.players.firstIndex(where: { $0.id == player.id }) {
                    store.players[index].name = newValue
                }
            }
        )
    }

    private func addPlayer() {
        let player = Player(name: "")
        store.players.append(player)
        DispatchQueue.main.async { focusedPlayer = player.id }
    }
}
