import SwiftUI

struct HowToPlayView: View {
    @Environment(\.dismiss) private var dismiss

    private struct Step: Identifiable {
        let title: String
        let text: String
        var id: String { title }
    }

    private let steps: [Step] = [
        Step(title: "Set up", text: "Add everyone's name, choose how many imposters, and pick your categories."),
        Step(title: "Pass the deck", text: "Each player taps the card to see their secret word, memorizes it, then taps again to hide it and passes the phone on."),
        Step(title: "The twist", text: "Most players get the same word. The imposter gets a different word from the same category, and doesn't know they're the imposter."),
        Step(title: "Ask questions", text: "Start the timer and take turns asking each other questions out loud. Never say your word. Listen for answers that don't quite fit."),
        Step(title: "Vote", text: "When you're ready, everyone points at who they think the imposter is."),
        Step(title: "Reveal", text: "End the round to see who the imposter really was, and both words."),
    ]

    var body: some View {
        VStack(spacing: 0) {
            TopBar("How to play") {
                BarSpacer()
            } trailing: {
                Button { dismiss() } label: {
                    IconTile(systemName: "xmark")
                }
                .buttonStyle(PressableStyle())
                .accessibilityLabel("Close")
            }

            ScrollView {
                VStack(spacing: 12) {
                    ForEach(Array(steps.enumerated()), id: \.element.id) { index, step in
                        HStack(alignment: .top, spacing: 14) {
                            Text("\(index + 1)")
                                .font(Theme.font(16))
                                .foregroundStyle(Theme.red)
                                .frame(width: 38, height: 38)
                                .background(RoundedRectangle(cornerRadius: 11, style: .continuous).fill(Theme.background))
                            VStack(alignment: .leading, spacing: 6) {
                                Text(step.title)
                                    .font(Theme.font(16))
                                    .tracking(1.4)
                                    .foregroundStyle(Theme.text)
                                Text(step.text)
                                    .font(Theme.lightFont(14))
                                    .tracking(0.6)
                                    .lineSpacing(4)
                                    .foregroundStyle(Theme.bodyText)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            Spacer(minLength: 0)
                        }
                        .padding(16)
                        .raised(Theme.tile, radius: 18)
                    }
                }
                .padding(16)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Theme.background.ignoresSafeArea())
    }
}
