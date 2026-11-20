import SwiftUI
import UIKit

struct GameView: View {
    enum Phase: Hashable {
        case pass(Int)
        case reveal(Int)
        case discuss
        case result
    }

    @EnvironmentObject private var store: GameStore
    @Environment(\.dismiss) private var dismiss
    @State private var round: Round
    @State private var phase: Phase = .pass(0)
    @State private var confirmQuit = false
    @State private var confirmReveal = false

    init(round: Round) {
        _round = State(initialValue: round)
    }

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(red: 0.25, green: 0.08, blue: 0.42), Color(red: 0.05, green: 0.04, blue: 0.14)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            Group {
                switch phase {
                case .pass(let index): passView(index)
                case .reveal(let index): revealView(index)
                case .discuss: discussView
                case .result: resultView
                }
            }
            .id(phase)
            .transition(.opacity.combined(with: .scale(scale: 0.97)))
            .padding(24)
        }
        .foregroundStyle(.white)
        .overlay(alignment: .topLeading) {
            Button { confirmQuit = true } label: {
                Image(systemName: "xmark")
                    .font(.headline)
                    .padding(12)
                    .background(Color.white.opacity(0.12), in: Circle())
            }
            .padding(.leading, 20)
            .padding(.top, 8)
        }
        .confirmationDialog("End this game?", isPresented: $confirmQuit, titleVisibility: .visible) {
            Button("End game", role: .destructive) { dismiss() }
        }
        .confirmationDialog("Reveal the imposter?", isPresented: $confirmReveal, titleVisibility: .visible) {
            Button("Reveal") { go(to: .result) }
        } message: {
            Text("Make sure everyone has made their guess first.")
        }
        .onAppear { UIApplication.shared.isIdleTimerDisabled = true }
        .onDisappear { UIApplication.shared.isIdleTimerDisabled = false }
    }

    // MARK: - Phases

    private func passView(_ index: Int) -> some View {
        let player = round.players[index]
        return VStack(spacing: 20) {
            Spacer()
            Text("Player \(index + 1) of \(round.players.count)")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(Color.white.opacity(0.6))
            Image(systemName: "iphone.radiowaves.left.and.right")
                .font(.system(size: 60))
                .foregroundStyle(Color.white.opacity(0.85))
            Text("Pass the phone to")
                .font(.title3)
                .foregroundStyle(Color.white.opacity(0.8))
            Text(player.name)
                .font(.system(size: 44, weight: .heavy, design: .rounded))
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.5)
                .lineLimit(2)
            Text("Make sure nobody else can see the screen.")
                .font(.footnote)
                .foregroundStyle(Color.white.opacity(0.6))
            Spacer()
            Button("I'm \(player.name), show my word") {
                haptic()
                go(to: .reveal(index))
            }
            .buttonStyle(BigButtonStyle())
        }
    }

    private func revealView(_ index: Int) -> some View {
        let player = round.players[index]
        let isLast = index == round.players.count - 1
        return VStack(spacing: 20) {
            Spacer()
            Text("\(player.name), your word is")
                .font(.title3)
                .foregroundStyle(Color.white.opacity(0.8))
            VStack(spacing: 10) {
                Text("\(round.categoryEmoji) \(round.categoryName)")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Color.white.opacity(0.6))
                Text(round.word(for: player))
                    .font(.system(size: 48, weight: .black, design: .rounded))
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.4)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 36)
            .padding(.horizontal, 16)
            .background(Color.white.opacity(0.1), in: RoundedRectangle(cornerRadius: 28, style: .continuous))
            Text("Memorize it, then hide it before passing the phone.")
                .font(.footnote)
                .foregroundStyle(Color.white.opacity(0.6))
                .multilineTextAlignment(.center)
            Spacer()
            Button(isLast ? "Hide word & start" : "Hide & pass to \(round.players[index + 1].name)") {
                go(to: isLast ? .discuss : .pass(index + 1))
            }
            .buttonStyle(BigButtonStyle())
        }
    }

    private var discussView: some View {
        let count = round.imposterIDs.count
        return VStack(spacing: 20) {
            Spacer()
            Text("🕵️")
                .font(.system(size: 72))
            Text("Everyone has their word!")
                .font(.system(size: 30, weight: .heavy, design: .rounded))
                .multilineTextAlignment(.center)
            Text(count == 1 ? "There is 1 imposter among you." : "There are \(count) imposters among you.")
                .font(.headline)
                .foregroundStyle(Color.white.opacity(0.8))

            VStack(spacing: 6) {
                Text("First question")
                    .font(.caption.weight(.semibold))
                    .textCase(.uppercase)
                    .foregroundStyle(Color.white.opacity(0.6))
                Text("\(round.starter.name) asks first")
                    .font(.title2.weight(.bold))
            }
            .frame(maxWidth: .infinity)
            .padding(20)
            .background(Color.white.opacity(0.1), in: RoundedRectangle(cornerRadius: 22, style: .continuous))

            Text("Take turns asking each other questions about your word. Be vague enough not to give it away, but specific enough to prove you're not the imposter. When you're ready, vote out loud, then reveal.")
                .font(.callout)
                .foregroundStyle(Color.white.opacity(0.7))
                .multilineTextAlignment(.center)
            Spacer()
            Button(count == 1 ? "Reveal the imposter" : "Reveal the imposters") {
                confirmReveal = true
            }
            .buttonStyle(BigButtonStyle(color: .pink, textColor: .white))
        }
    }

    private var resultView: some View {
        let imposters = round.imposters
        return VStack(spacing: 20) {
            Spacer()
            Text(imposters.count == 1 ? "The imposter was" : "The imposters were")
                .font(.title3)
                .foregroundStyle(Color.white.opacity(0.8))
            Text(imposters.map(\.name).joined(separator: " & "))
                .font(.system(size: 42, weight: .heavy, design: .rounded))
                .foregroundStyle(.pink)
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.5)
                .lineLimit(3)

            HStack(spacing: 12) {
                wordCard(title: "Everyone's word", word: round.civilianWord)
                wordCard(title: imposters.count == 1 ? "Imposter's word" : "Imposters' word", word: round.imposterWord)
            }
            Text("\(round.categoryEmoji) \(round.categoryName)")
                .font(.subheadline)
                .foregroundStyle(Color.white.opacity(0.6))
            Spacer()
            Button("Play again") {
                if let next = store.makeRound() {
                    round = next
                    go(to: .pass(0))
                } else {
                    dismiss()
                }
            }
            .buttonStyle(BigButtonStyle())
            Button("Back to menu") { dismiss() }
                .buttonStyle(BigButtonStyle(color: .white.opacity(0.12), textColor: .white))
        }
        .onAppear { haptic(.heavy) }
    }

    private func wordCard(title: String, word: String) -> some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.caption.weight(.semibold))
                .textCase(.uppercase)
                .foregroundStyle(Color.white.opacity(0.6))
            Text(word)
                .font(.title3.weight(.bold))
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.6)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity, minHeight: 90)
        .padding(12)
        .background(Color.white.opacity(0.1), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
    }

    // MARK: - Helpers

    private func go(to next: Phase) {
        withAnimation(.easeInOut(duration: 0.25)) { phase = next }
    }

    private func haptic(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        UIImpactFeedbackGenerator(style: style).impactOccurred()
    }
}
