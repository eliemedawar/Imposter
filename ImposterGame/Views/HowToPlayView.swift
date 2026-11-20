import SwiftUI

struct HowToPlayView: View {
    @Environment(\.dismiss) private var dismiss

    private struct Step: Identifiable {
        let icon: String
        let title: String
        let text: String
        var id: String { title }
    }

    private let steps: [Step] = [
        Step(icon: "person.3.fill", title: "Set up", text: "Add everyone's name, choose how many imposters, and pick your categories."),
        Step(icon: "iphone", title: "Pass the phone", text: "Each player taps to see their secret word, memorizes it, then hides it and passes the phone on."),
        Step(icon: "theatermasks.fill", title: "The twist", text: "Most players get the same word. The imposter gets a different word from the same category, and doesn't know they're the imposter."),
        Step(icon: "bubble.left.and.bubble.right.fill", title: "Ask questions", text: "Take turns asking each other questions out loud. Don't say your word! Listen for answers that don't quite fit."),
        Step(icon: "hand.point.up.left.fill", title: "Vote", text: "When you're ready, everyone points at who they think the imposter is."),
        Step(icon: "eye.fill", title: "Reveal", text: "Tap reveal to see who the imposter really was, and both words."),
    ]

    var body: some View {
        NavigationStack {
            List {
                ForEach(steps) { step in
                    HStack(alignment: .top, spacing: 14) {
                        Image(systemName: step.icon)
                            .font(.title3)
                            .foregroundStyle(Color.accentColor)
                            .frame(width: 32)
                        VStack(alignment: .leading, spacing: 4) {
                            Text(step.title).font(.headline)
                            Text(step.text).foregroundStyle(.secondary)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("How to play")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}
