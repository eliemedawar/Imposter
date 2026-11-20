import SwiftUI

/// The home screen: a deck of cards passed around the table, one per player.
struct DeckView: View {
    @EnvironmentObject private var store: GameStore
    @EnvironmentObject private var router: Router
    @State private var flipAngle: Double = 0
    @State private var slideOffset: CGFloat = 0
    @State private var cardScale: CGFloat = 1
    @State private var isAnimating = false
    @State private var showHelp = false

    private let cardShape = RoundedRectangle(cornerRadius: 28, style: .continuous)

    var body: some View {
        VStack(spacing: 0) {
            TopBar(title) {
                Button { showHelp = true } label: {
                    IconTile(systemName: "questionmark")
                }
                .buttonStyle(PressableStyle())
                .accessibilityLabel("How to play")
            } trailing: {
                Button(action: redeal) {
                    IconTile(systemName: "arrow.triangle.2.circlepath")
                }
                .buttonStyle(PressableStyle())
                .accessibilityLabel("Deal new cards")
            }

            deck
                .padding(.top, 24)
                .padding(.leading, 16)
                .padding(.trailing, 38)
                .padding(.bottom, 32)
                .frame(maxHeight: .infinity)

            bottomControls
                .frame(height: 114, alignment: .top)
                .padding(.horizontal, 20)
                .padding(.bottom, 12)
        }
        .themedScreen()
        .sheet(isPresented: $showHelp) { HowToPlayView() }
        .onAppear { store.dealIfNeeded() }
    }

    private var title: String {
        guard let round = store.round else { return "Imposter" }
        if store.allDealt { return "Ready" }
        return "Card \(store.cardIndex + 1) of \(round.players.count)"
    }

    // MARK: - Deck

    private var deck: some View {
        let remaining = store.round.map { $0.players.count - store.cardIndex } ?? 1
        return ZStack {
            if store.allDealt || remaining >= 3 {
                backCard(Color(hex: 0x1A1A1D))
                    .offset(x: 20, y: 20)
                    .rotationEffect(.degrees(1.4))
            }
            if store.allDealt || remaining >= 2 {
                backCard(Color(hex: 0x222226))
                    .offset(x: 10, y: 10)
                    .rotationEffect(.degrees(0.7))
            }
            frontCard
        }
    }

    private func backCard(_ color: Color) -> some View {
        cardShape
            .fill(color)
            .shadow(color: .black.opacity(0.6), radius: 11, y: 10)
    }

    private var frontCard: some View {
        cardShape
            .fill(Theme.card)
            .overlay(cardContent.clipShape(cardShape))
            .overlay(cardShape.stroke(Color.white.opacity(0.06), lineWidth: 1))
            .shadow(color: .black.opacity(0.6), radius: 13, y: 12)
            .rotation3DEffect(.degrees(flipAngle), axis: (x: 0, y: 1, z: 0), perspective: 0.5)
            .scaleEffect(cardScale)
            .offset(x: slideOffset)
            .rotationEffect(.degrees(Double(slideOffset) / -30))
            .contentShape(cardShape)
            .onTapGesture(perform: tapCard)
            .accessibilityElement(children: .combine)
            .accessibilityAddTraits(.isButton)
    }

    @ViewBuilder private var cardContent: some View {
        if let round = store.round {
            if store.allDealt {
                readyFace(round)
            } else if store.cardRevealed {
                wordFace(round.word(for: store.cardIndex))
            } else {
                nameFace(round.players[store.cardIndex].name)
            }
        } else {
            problemFace
        }
    }

    private func nameFace(_ name: String) -> some View {
        ZStack {
            StripesBackground()
            VStack(spacing: 16) {
                Text(name)
                    .font(Theme.font(42))
                    .tracking(2.5)
                    .foregroundStyle(Theme.red)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.4)
                Text("Tap to see your word")
                    .font(Theme.font(14))
                    .tracking(2)
                    .foregroundStyle(Theme.muted)
            }
            .padding(24)
        }
    }

    private func wordFace(_ word: String) -> some View {
        GeometryReader { geo in
            let compact = geo.size.height < 460
            VStack(spacing: 0) {
                BubbleSticker(size: compact ? 84 : 118)
                    .padding(.top, compact ? 28 : 56)
                Text("Secret word")
                    .font(Theme.font(12))
                    .tracking(2.6)
                    .foregroundStyle(Theme.muted)
                    .padding(.top, compact ? 18 : 30)
                Text(word)
                    .font(Theme.font(36))
                    .tracking(2)
                    .foregroundStyle(Theme.red)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.4)
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                Rectangle()
                    .fill(Theme.divider)
                    .frame(height: 1)
                    .padding(.horizontal, 22)
                    .padding(.top, compact ? 18 : 26)
                Text("Everyone got a secret word, but one of you got a different one and doesn't know it. Ask questions to find out who.")
                    .font(Theme.lightFont(13))
                    .tracking(0.8)
                    .lineSpacing(5)
                    .foregroundStyle(Theme.bodyText)
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.8)
                    .padding(.horizontal, 26)
                    .padding(.top, compact ? 14 : 20)
                Spacer(minLength: 8)
                Text("Tap to hide · pass the phone")
                    .font(Theme.font(11))
                    .tracking(2)
                    .foregroundStyle(Theme.dim)
                    .padding(.bottom, 22)
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
    }

    private func readyFace(_ round: Round) -> some View {
        VStack(spacing: 18) {
            SpySticker(size: 132)
            Text("Everyone has a word")
                .font(Theme.font(28))
                .tracking(1.7)
                .foregroundStyle(Theme.text)
                .multilineTextAlignment(.center)
            Text("\(round.starter.name) asks first")
                .font(Theme.font(14))
                .tracking(1.7)
                .foregroundStyle(Theme.muted)
        }
        .padding(28)
    }

    private var problemFace: some View {
        ZStack {
            StripesBackground()
            VStack(spacing: 14) {
                SpySticker(size: 96)
                Text(store.startProblem ?? "")
                    .font(Theme.font(22))
                    .tracking(1.5)
                    .foregroundStyle(Theme.red)
                    .multilineTextAlignment(.center)
                Text("Tap to fix it")
                    .font(Theme.font(14))
                    .tracking(2)
                    .foregroundStyle(Theme.muted)
            }
            .padding(24)
        }
    }

    // MARK: - Bottom controls

    @ViewBuilder private var bottomControls: some View {
        if store.allDealt {
            Button("Start round") {
                router.path.append(.timer)
            }
            .buttonStyle(RedButtonStyle())
            .padding(.top, 18)
        } else {
            VStack(spacing: 14) {
                HStack(spacing: 10) {
                    NavigationLink(value: Route.players) {
                        Text("Players · \(store.players.count)")
                    }
                    NavigationLink(value: Route.players) {
                        Text("Imposters · \(store.effectiveImposterCount)")
                    }
                }
                .buttonStyle(DarkButtonStyle())

                NavigationLink(value: Route.categories) {
                    HStack {
                        Text(categorySummary)
                            .lineLimit(1)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(Theme.dim)
                    }
                }
                .buttonStyle(DarkButtonStyle(height: 54, fullWidth: true))
            }
            .opacity(store.cardRevealed ? 0.35 : 1)
            .disabled(store.cardRevealed)
            .animation(.easeOut(duration: 0.2), value: store.cardRevealed)
        }
    }

    private var categorySummary: String {
        let names = store.playableSelectedCategories.map(\.name)
        if names.isEmpty { return "Choose categories" }
        if names.count <= 3 { return names.joined(separator: ", ") }
        return names.prefix(3).joined(separator: ", ") + " +\(names.count - 3)"
    }

    // MARK: - Actions

    private func tapCard() {
        guard !isAnimating else { return }
        guard let round = store.round else {
            router.path.append(store.playersAreReady ? .categories : .players)
            return
        }
        if store.allDealt { return }
        haptic(.light)

        if !store.cardRevealed {
            flip { store.cardRevealed = true }
        } else if store.cardIndex < round.players.count - 1 {
            slideAway {
                store.cardRevealed = false
                store.cardIndex += 1
            }
        } else {
            flip {
                store.cardRevealed = false
                store.allDealt = true
            }
        }
    }

    private func redeal() {
        guard !isAnimating else { return }
        haptic()
        flip { store.deal() }
    }

    /// Turns the card edge-on, swaps its face, then turns it back.
    private func flip(_ change: @escaping () -> Void) {
        isAnimating = true
        withAnimation(.easeIn(duration: 0.14)) { flipAngle = 90 }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.14) {
            var instant = Transaction()
            instant.disablesAnimations = true
            withTransaction(instant) {
                change()
                flipAngle = -90
            }
            DispatchQueue.main.async {
                withAnimation(.easeOut(duration: 0.18)) { flipAngle = 0 }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { isAnimating = false }
            }
        }
    }

    /// Throws the current card off to the side and brings up the next one.
    private func slideAway(_ change: @escaping () -> Void) {
        isAnimating = true
        withAnimation(.easeIn(duration: 0.22)) { slideOffset = -520 }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.22) {
            var instant = Transaction()
            instant.disablesAnimations = true
            withTransaction(instant) {
                change()
                slideOffset = 0
                cardScale = 0.92
            }
            DispatchQueue.main.async {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) { cardScale = 1 }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { isAnimating = false }
            }
        }
    }
}
