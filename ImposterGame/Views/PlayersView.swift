import SwiftUI

struct PlayersView: View {
    @EnvironmentObject private var store: GameStore
    @Environment(\.dismiss) private var dismiss
    @State private var draft = ""
    @FocusState private var focusedPlayer: UUID?
    @FocusState private var draftFocused: Bool

    var body: some View {
        VStack(spacing: 0) {
            TopBar("Players") {
                BackButton()
            } trailing: {
                BarSpacer()
            }

            ScrollView {
                VStack(spacing: 12) {
                    ForEach(Array(store.players.enumerated()), id: \.element.id) { index, player in
                        playerRow(number: index + 1, player: player)
                    }
                    addRow

                    stepperRow(
                        title: "Imposters",
                        subtitle: "Up to \(store.maxImposters) with \(store.players.count) players",
                        value: store.effectiveImposterCount,
                        range: 1...store.maxImposters
                    ) { store.imposterCount = $0 }
                    .padding(.top, 10)

                    stepperRow(
                        title: "Timer",
                        subtitle: "Minutes per round",
                        value: store.roundMinutes,
                        range: 1...15
                    ) { store.roundMinutes = $0 }
                }
                .padding(16)
            }
            .scrollDismissesKeyboard(.interactively)

            Button("Deal cards") {
                focusedPlayer = nil
                draftFocused = false
                dismiss()
            }
            .buttonStyle(RedButtonStyle())
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .padding(.bottom, 16)
        }
        .themedScreen()
    }

    private func playerRow(number: Int, player: Player) -> some View {
        HStack(spacing: 14) {
            Text("\(number)")
                .font(Theme.font(16))
                .foregroundStyle(Theme.red)
                .frame(width: 38, height: 38)
                .background(RoundedRectangle(cornerRadius: 11, style: .continuous).fill(Theme.background))
            TextField("", text: nameBinding(for: player.id), prompt: Text("Name").foregroundColor(Theme.dim))
                .font(Theme.font(17))
                .foregroundStyle(Theme.text)
                .textInputAutocapitalization(.words)
                .autocorrectionDisabled()
                .submitLabel(.done)
                .focused($focusedPlayer, equals: player.id)
            Button {
                withAnimation { store.removePlayer(id: player.id) }
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(Theme.dim)
                    .frame(width: 44, height: 44)
            }
            .accessibilityLabel("Remove \(player.name)")
        }
        .padding(.leading, 12)
        .padding(.trailing, 6)
        .frame(height: 62)
        .raised(Theme.tile, radius: 16)
    }

    private var addRow: some View {
        HStack(spacing: 10) {
            TextField("", text: $draft, prompt: Text("Add a player").foregroundColor(Theme.dim))
                .font(Theme.font(16))
                .foregroundStyle(Theme.text)
                .textInputAutocapitalization(.words)
                .autocorrectionDisabled()
                .submitLabel(.done)
                .focused($draftFocused)
                .onSubmit(addDraft)
            Button(action: addDraft) {
                IconTile(systemName: "plus")
            }
            .buttonStyle(PressableStyle())
            .accessibilityLabel("Add player")
        }
        .padding(.leading, 16)
        .padding(.trailing, 8)
        .frame(height: 62)
        .dashedBorder(radius: 16)
    }

    private func stepperRow(
        title: String,
        subtitle: String,
        value: Int,
        range: ClosedRange<Int>,
        set: @escaping (Int) -> Void
    ) -> some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(Theme.font(17))
                    .tracking(1.6)
                    .foregroundStyle(Theme.text)
                Text(subtitle)
                    .font(Theme.lightFont(12))
                    .tracking(0.8)
                    .foregroundStyle(Theme.muted)
            }
            Spacer()
            stepButton("minus", enabled: value > range.lowerBound) { set(value - 1) }
            Text("\(value)")
                .font(Theme.font(26))
                .foregroundStyle(Theme.red)
                .frame(minWidth: 30)
            stepButton("plus", enabled: value < range.upperBound) { set(value + 1) }
        }
        .padding(16)
        .raised(Theme.tile, radius: 18)
    }

    private func stepButton(_ symbol: String, enabled: Bool, action: @escaping () -> Void) -> some View {
        Button {
            haptic(.light)
            action()
        } label: {
            Image(systemName: symbol)
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(enabled ? Theme.red : Theme.dashed)
                .frame(width: 44, height: 44)
                .background(RoundedRectangle(cornerRadius: 12, style: .continuous).fill(Theme.background))
        }
        .buttonStyle(PressableStyle())
        .disabled(!enabled)
        .accessibilityLabel(symbol == "plus" ? "Increase" : "Decrease")
    }

    /// Looks the player up by id so deleting rows never reads a stale index.
    private func nameBinding(for id: UUID) -> Binding<String> {
        Binding(
            get: { store.players.first { $0.id == id }?.name ?? "" },
            set: { newValue in
                if let index = store.players.firstIndex(where: { $0.id == id }) {
                    store.players[index].name = newValue
                }
            }
        )
    }

    private func addDraft() {
        let name = draft.trimmed
        guard !name.isEmpty else { return }
        withAnimation { store.addPlayer(named: name) }
        draft = ""
        draftFocused = true
    }
}
