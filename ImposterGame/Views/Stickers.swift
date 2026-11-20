import SwiftUI

/// Pieces of the sticker illustrations, drawn in a 100×100 design space and scaled to fit.
struct StickerPath: Shape {
    enum Kind {
        case shoulders
        case mask
        case cords
        case bubble
        case questionMark
        case circle(CGFloat, CGFloat, CGFloat)
        case ellipse(CGFloat, CGFloat, CGFloat, CGFloat)
    }

    let kind: Kind

    func path(in rect: CGRect) -> Path {
        var p = Path()
        switch kind {
        case .shoulders:
            p.move(to: pt(20, 90))
            p.addCurve(to: pt(50, 63), control1: pt(20, 73), control2: pt(33, 63))
            p.addCurve(to: pt(80, 90), control1: pt(67, 63), control2: pt(80, 73))
            p.closeSubpath()
        case .mask:
            p.move(to: pt(31, 42))
            p.addCurve(to: pt(69, 42), control1: pt(37, 38), control2: pt(63, 38))
            p.addLine(to: pt(69, 49))
            p.addCurve(to: pt(31, 49), control1: pt(63, 53), control2: pt(37, 53))
            p.closeSubpath()
        case .cords:
            p.move(to: pt(44, 66))
            p.addLine(to: pt(44, 75))
            p.move(to: pt(56, 66))
            p.addLine(to: pt(56, 75))
        case .bubble:
            p.move(to: pt(16, 22))
            p.addQuadCurve(to: pt(28, 10), control: pt(16, 10))
            p.addLine(to: pt(72, 10))
            p.addQuadCurve(to: pt(84, 22), control: pt(84, 10))
            p.addLine(to: pt(84, 54))
            p.addQuadCurve(to: pt(72, 66), control: pt(84, 66))
            p.addLine(to: pt(48, 66))
            p.addLine(to: pt(32, 82))
            p.addLine(to: pt(32, 66))
            p.addLine(to: pt(28, 66))
            p.addQuadCurve(to: pt(16, 54), control: pt(16, 66))
            p.closeSubpath()
        case .questionMark:
            p.move(to: pt(44.5, 33))
            p.addQuadCurve(to: pt(50, 27.5), control: pt(44.5, 27.5))
            p.addQuadCurve(to: pt(55.5, 33), control: pt(55.5, 27.5))
            p.addQuadCurve(to: pt(50, 38.5), control: pt(55.5, 36.5))
            p.addLine(to: pt(50, 42))
        case let .circle(x, y, r):
            p.addEllipse(in: CGRect(x: x - r, y: y - r, width: r * 2, height: r * 2))
        case let .ellipse(x, y, rx, ry):
            p.addEllipse(in: CGRect(x: x - rx, y: y - ry, width: rx * 2, height: ry * 2))
        }
        return p.applying(CGAffineTransform(scaleX: rect.width / 100, y: rect.height / 100))
    }

    private func pt(_ x: CGFloat, _ y: CGFloat) -> CGPoint {
        CGPoint(x: x, y: y)
    }
}

private let stickerWhite = Color(hex: 0xF4F4F6)
private let stickerInk = Color(hex: 0x121214)

/// The white die-cut border around a sticker.
private func border(_ kind: StickerPath.Kind, width: CGFloat) -> some View {
    StickerPath(kind: kind)
        .fill(stickerWhite)
        .overlay(StickerPath(kind: kind).stroke(stickerWhite, style: StrokeStyle(lineWidth: width, lineJoin: .round)))
}

/// A filled piece with a dark ink outline.
private func inked(_ kind: StickerPath.Kind, fill: Color, width: CGFloat) -> some View {
    StickerPath(kind: kind)
        .fill(fill)
        .overlay(StickerPath(kind: kind).stroke(stickerInk, style: StrokeStyle(lineWidth: width, lineJoin: .round)))
}

/// A hooded figure with a red eye mask.
struct SpySticker: View {
    var size: CGFloat

    var body: some View {
        let s = size / 100
        ZStack {
            border(.shoulders, width: 9 * s)
            border(.circle(50, 44, 24), width: 9 * s)
            inked(.shoulders, fill: Color(hex: 0xC8343A), width: 3 * s)
            inked(.circle(50, 44, 24), fill: Color(hex: 0x2B2D33), width: 3 * s)
            inked(.circle(50, 47, 16), fill: Color(hex: 0x474A53), width: 3 * s)
            inked(.mask, fill: Theme.red, width: 3 * s)
            StickerPath(kind: .ellipse(42, 45.5, 3.6, 2.4)).fill(stickerWhite)
            StickerPath(kind: .ellipse(58, 45.5, 3.6, 2.4)).fill(stickerWhite)
            StickerPath(kind: .cords)
                .stroke(stickerWhite, style: StrokeStyle(lineWidth: 3 * s, lineCap: .round))
        }
        .frame(width: size, height: size)
        .shadow(color: .black.opacity(0.35), radius: 2 * s, y: 2 * s)
        .accessibilityHidden(true)
    }
}

/// A speech bubble holding a red question mark.
struct BubbleSticker: View {
    var size: CGFloat

    var body: some View {
        let s = size / 100
        ZStack {
            border(.bubble, width: 10 * s)
            inked(.bubble, fill: Color(hex: 0x5B606B), width: 3 * s)
            inked(.circle(50, 38, 17), fill: Color(hex: 0xECECEF), width: 3 * s)
            StickerPath(kind: .questionMark)
                .stroke(Theme.redButton, style: StrokeStyle(lineWidth: 4.5 * s, lineCap: .round, lineJoin: .round))
            StickerPath(kind: .circle(50, 48.5, 2.6)).fill(Theme.redButton)
        }
        .frame(width: size, height: size)
        .shadow(color: .black.opacity(0.35), radius: 2 * s, y: 2 * s)
        .accessibilityHidden(true)
    }
}
