import SwiftUI
import UIKit

struct TimerView: View {
    @EnvironmentObject private var store: GameStore
    @EnvironmentObject private var router: Router
    @State private var total = 1
    @State private var remaining = 0
    @State private var running = true
    @State private var started = false

    private let ticker = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(spacing: 0) {
            TopBar("Round") {
                BackButton()
            } trailing: {
                BarSpacer()
            }

            ring
                .frame(width: 264, height: 264)
                .padding(.top, 56)

            Text("Start asking questions! Find the imposter before the time runs out.")
                .font(Theme.font(15))
                .tracking(1.2)
                .lineSpacing(6)
                .foregroundStyle(Theme.softText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 28)
                .padding(.top, 44)

            if let starter = store.round?.starter {
                HStack(spacing: 10) {
                    Circle()
                        .fill(Theme.red)
                        .frame(width: 8, height: 8)
                    Text("\(starter.name) asks first")
                        .font(Theme.font(13))
                        .tracking(1.6)
                        .foregroundStyle(Theme.chipText)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(Capsule().fill(Theme.surface))
                .padding(.top, 18)
            }

            Spacer()

            HStack(spacing: 12) {
                Button(running ? "Pause" : "Resume") {
                    haptic(.light)
                    running.toggle()
                }
                .buttonStyle(DarkButtonStyle(height: 56, fontSize: 16))

                Button("End round") {
                    router.path.append(.result)
                }
                .buttonStyle(RedButtonStyle(height: 56, fontSize: 16, fullWidth: false))
            }
            .padding(.bottom, 28)
        }
        .themedScreen()
        .onAppear {
            if !started {
                total = max(store.roundMinutes, 1) * 60
                remaining = total
                started = true
            }
            UIApplication.shared.isIdleTimerDisabled = true
        }
        .onDisappear { UIApplication.shared.isIdleTimerDisabled = false }
        .onReceive(ticker) { _ in
            guard running, remaining > 0 else { return }
            remaining -= 1
            if remaining == 0 {
                UINotificationFeedbackGenerator().notificationOccurred(.warning)
            }
        }
    }

    private var ring: some View {
        ZStack {
            Circle()
                .stroke(Color(hex: 0x2A1618), lineWidth: 12)
            Circle()
                .trim(from: 0, to: CGFloat(remaining) / CGFloat(max(total, 1)))
                .stroke(Theme.ring, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.linear(duration: 1), value: remaining)
            VStack(spacing: 6) {
                Text(clock)
                    .font(Theme.font(64))
                    .tracking(2)
                    .monospacedDigit()
                    .foregroundStyle(Theme.red)
                Text(status)
                    .font(Theme.font(12))
                    .tracking(2.4)
                    .foregroundStyle(Theme.muted)
            }
        }
    }

    private var clock: String {
        String(format: "%d:%02d", remaining / 60, remaining % 60)
    }

    private var status: String {
        if started && remaining == 0 { return "Time is up · vote!" }
        return running ? "Time left" : "Paused"
    }
}
