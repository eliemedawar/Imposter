import SwiftUI
import UIKit

enum Theme {
    static let background = Color(hex: 0x141416)
    static let surface = Color(hex: 0x1E1E21)
    static let card = Color(hex: 0x2C2C30)
    static let tile = Color(hex: 0x2A2A2E)
    static let hairline = Color(hex: 0x26262A)
    static let divider = Color(hex: 0x46464C)
    static let dashed = Color(hex: 0x4A4A50)

    static let red = Color(hex: 0xE5484D)
    static let redButton = Color(hex: 0xD7373D)
    static let redShadow = Color(hex: 0x8C1D21)
    static let ring = Color(hex: 0xC8262C)
    static let selectedTile = Color(hex: 0x3A2426)

    static let text = Color(hex: 0xF2F2F2)
    static let softText = Color(hex: 0xE6E6E9)
    static let chipText = Color(hex: 0xC9C9CE)
    static let bodyText = Color(hex: 0xB4B4B9)
    static let muted = Color(hex: 0xA3A3A8)
    static let dim = Color(hex: 0x8A8A90)

    /// Copperplate ships with iOS; lowercase letters render as small caps.
    static func font(_ size: CGFloat) -> Font { .custom("Copperplate-Bold", size: size) }
    static func lightFont(_ size: CGFloat) -> Font { .custom("Copperplate", size: size) }
}

extension Color {
    init(hex: UInt32) {
        self.init(
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255
        )
    }
}

func haptic(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
    UIImpactFeedbackGenerator(style: style).impactOccurred()
}

// MARK: - Surfaces

extension View {
    /// A slightly lifted dark surface with a top highlight and drop shadow.
    func raised(_ fill: Color = Theme.surface, radius: CGFloat = 14) -> some View {
        background(RoundedRectangle(cornerRadius: radius, style: .continuous).fill(fill))
            .overlay(
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .stroke(Color.white.opacity(0.05), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.5), radius: 5, y: 4)
    }

    func dashedBorder(radius: CGFloat = 18) -> some View {
        overlay(
            RoundedRectangle(cornerRadius: radius, style: .continuous)
                .strokeBorder(Theme.dashed, style: StrokeStyle(lineWidth: 2, dash: [6, 5]))
        )
    }

    /// Full-screen dark page with the system navigation bar hidden.
    func themedScreen() -> some View {
        frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(Theme.background.ignoresSafeArea())
            .toolbar(.hidden, for: .navigationBar)
            .navigationBarBackButtonHidden(true)
    }
}

// MARK: - Buttons

struct RedButtonStyle: ButtonStyle {
    var height: CGFloat = 60
    var fontSize: CGFloat = 21
    var fullWidth = true

    func makeBody(configuration: Configuration) -> some View {
        let pressed = configuration.isPressed
        return configuration.label
            .font(Theme.font(fontSize))
            .tracking(fontSize * 0.14)
            .foregroundStyle(.white)
            .padding(.horizontal, 26)
            .frame(maxWidth: fullWidth ? .infinity : nil)
            .frame(height: height)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(Theme.redShadow)
                        .offset(y: pressed ? 2 : 5)
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(Theme.redButton)
                }
            )
            .offset(y: pressed ? 3 : 0)
            .shadow(color: .black.opacity(0.45), radius: 10, y: 8)
            .animation(.easeOut(duration: 0.12), value: pressed)
    }
}

struct DarkButtonStyle: ButtonStyle {
    var height: CGFloat = 46
    var fontSize: CGFloat = 14
    var fullWidth = false

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(Theme.font(fontSize))
            .tracking(fontSize * 0.12)
            .foregroundStyle(Theme.softText)
            .padding(.horizontal, 18)
            .frame(maxWidth: fullWidth ? .infinity : nil)
            .frame(height: height)
            .raised(Theme.surface, radius: 14)
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}

struct PressableStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}

struct IconTile: View {
    let systemName: String

    var body: some View {
        Image(systemName: systemName)
            .font(.system(size: 18, weight: .bold))
            .foregroundStyle(Theme.red)
            .frame(width: 44, height: 44)
            .raised(Theme.surface, radius: 12)
    }
}

struct BackButton: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Button { dismiss() } label: {
            IconTile(systemName: "chevron.left")
        }
        .buttonStyle(PressableStyle())
        .accessibilityLabel("Back")
    }
}

struct BarSpacer: View {
    var body: some View {
        Color.clear.frame(width: 44, height: 44)
    }
}

// MARK: - Top bar

struct TopBar<Leading: View, Trailing: View>: View {
    let title: String
    let onTitleTap: (() -> Void)?
    let leading: Leading
    let trailing: Trailing

    init(
        _ title: String,
        onTitleTap: (() -> Void)? = nil,
        @ViewBuilder leading: () -> Leading,
        @ViewBuilder trailing: () -> Trailing
    ) {
        self.title = title
        self.onTitleTap = onTitleTap
        self.leading = leading()
        self.trailing = trailing()
    }

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                titleView
                    .padding(.horizontal, 104)
                HStack {
                    leading
                    Spacer()
                    trailing
                }
            }
            .frame(height: 64)
            .padding(.horizontal, 16)

            Rectangle()
                .fill(Theme.hairline)
                .frame(height: 1)
        }
    }

    @ViewBuilder private var titleView: some View {
        let label = Text(title)
            .font(Theme.font(18))
            .tracking(2.2)
            .foregroundStyle(Theme.text)
            .lineLimit(1)
            .minimumScaleFactor(0.6)
        if let onTitleTap {
            Button(action: onTitleTap) {
                HStack(spacing: 6) {
                    label
                    Image(systemName: "pencil")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(Theme.dim)
                }
            }
            .buttonStyle(.plain)
        } else {
            label
        }
    }
}

// MARK: - Card texture

struct StripesBackground: View {
    var body: some View {
        Canvas { context, size in
            let reach = (size.width + size.height) * 1.5
            context.translateBy(x: size.width / 2, y: size.height / 2)
            context.rotate(by: .degrees(68))
            var x = -reach
            while x < reach {
                let stripe = CGRect(x: x, y: -reach, width: 16, height: reach * 2)
                context.fill(Path(stripe), with: .color(Color.white.opacity(0.028)))
                x += 34
            }
        }
        .allowsHitTesting(false)
    }
}
