import SwiftUI

struct ResultView: View {
    @EnvironmentObject private var store: GameStore
    @EnvironmentObject private var router: Router

    var body: some View {
        VStack(spacing: 0) {
            TopBar("Results") {
                BackButton()
            } trailing: {
                BarSpacer()
            }

            ScrollView {
                if let round = store.round {
                    card(round)
                        .padding(.horizontal, 16)
                        .padding(.top, 24)
                        .padding(.bottom, 16)
                }
            }

            VStack(spacing: 14) {
                Button("Play again") {
                    store.finishRound()
                    router.path = []
                }
                .buttonStyle(RedButtonStyle())

                Button("Change players") {
                    store.finishRound()
                    router.path = [.players]
                }
                .buttonStyle(DarkButtonStyle(height: 52, fontSize: 15, fullWidth: true))
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .padding(.bottom, 16)
        }
        .themedScreen()
        .onAppear { haptic(.heavy) }
    }

    private func card(_ round: Round) -> some View {
        let imposters = round.imposters
        return VStack(spacing: 0) {
            HStack {
                Text("Category · \(round.categoryName)")
                    .font(Theme.font(11))
                    .tracking(2)
                    .foregroundStyle(Theme.chipText)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(Capsule().fill(Theme.background))
                Spacer()
            }

            SpySticker(size: 132)
                .padding(.top, 14)

            Text(imposters.count == 1 ? "The imposter was" : "The imposters were")
                .font(Theme.font(12))
                .tracking(2.6)
                .foregroundStyle(Theme.muted)
                .padding(.top, 22)

            Text(imposters.map(\.name).joined(separator: " & "))
                .font(Theme.font(44))
                .tracking(2.6)
                .foregroundStyle(Theme.red)
                .multilineTextAlignment(.center)
                .lineLimit(3)
                .minimumScaleFactor(0.4)
                .padding(.top, 8)

            Rectangle()
                .fill(Theme.divider)
                .frame(height: 1)
                .padding(.horizontal, 20)
                .padding(.top, 22)

            HStack(spacing: 12) {
                wordBox(title: "Everyone's word", word: round.civilianWord, highlight: false)
                wordBox(title: imposters.count == 1 ? "Imposter's word" : "Imposters' word", word: round.imposterWord, highlight: true)
            }
            .padding(.top, 20)
        }
        .padding(.horizontal, 22)
        .padding(.top, 18)
        .padding(.bottom, 26)
        .background(RoundedRectangle(cornerRadius: 28, style: .continuous).fill(Theme.card))
        .overlay(RoundedRectangle(cornerRadius: 28, style: .continuous).stroke(Color.white.opacity(0.06), lineWidth: 1))
        .shadow(color: .black.opacity(0.6), radius: 13, y: 12)
    }

    private func wordBox(title: String, word: String, highlight: Bool) -> some View {
        VStack(spacing: 8) {
            Text(title)
                .font(Theme.font(11))
                .tracking(1.8)
                .foregroundStyle(highlight ? Color(hex: 0xF0A3A6) : Theme.muted)
            Text(word)
                .font(Theme.font(22))
                .tracking(1.3)
                .foregroundStyle(highlight ? Theme.red : Theme.text)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.5)
        }
        .frame(maxWidth: .infinity, minHeight: 84)
        .padding(.horizontal, 8)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(highlight ? Color(hex: 0x3A2224) : Color(hex: 0x222226))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .strokeBorder(highlight ? Theme.ring : Color.clear, lineWidth: 2)
        )
    }
}
