import UIKit

enum OutlineArtKind: String, Codable, Hashable {
    case rocket, planet, astronaut, ufo
    case unicorn, rainbow, castle, magicStar
    case wizardHat, owl, wand, potion
    case bunny, cupcake, smileyStar, heartFriend
    case bowKitty, fish, yarn, kittyHouse
}

enum OutlineArtGenerator {
    static let canvasSize = CGSize(width: 800, height: 800)

    static func image(for kind: OutlineArtKind) -> UIImage {
        let size = canvasSize
        let format = UIGraphicsImageRendererFormat()
        format.opaque = false
        format.scale = 1
        let renderer = UIGraphicsImageRenderer(size: size, format: format)
        return renderer.image { ctx in
            let cg = ctx.cgContext
            cg.clear(CGRect(origin: .zero, size: size))

            cg.setStrokeColor(UIColor.black.cgColor)
            cg.setFillColor(UIColor.clear.cgColor)
            cg.setLineWidth(6)
            cg.setLineCap(.round)
            cg.setLineJoin(.round)

            switch kind {
            case .rocket: drawRocket(cg, size)
            case .planet: drawPlanet(cg, size)
            case .astronaut: drawAstronaut(cg, size)
            case .ufo: drawUFO(cg, size)
            case .unicorn: drawUnicorn(cg, size)
            case .rainbow: drawRainbow(cg, size)
            case .castle: drawCastle(cg, size)
            case .magicStar: drawMagicStar(cg, size)
            case .wizardHat: drawWizardHat(cg, size)
            case .owl: drawOwl(cg, size)
            case .wand: drawWand(cg, size)
            case .potion: drawPotion(cg, size)
            case .bunny: drawBunny(cg, size)
            case .cupcake: drawCupcake(cg, size)
            case .smileyStar: drawSmileyStar(cg, size)
            case .heartFriend: drawHeartFriend(cg, size)
            case .bowKitty: drawBowKitty(cg, size)
            case .fish: drawFish(cg, size)
            case .yarn: drawYarn(cg, size)
            case .kittyHouse: drawKittyHouse(cg, size)
            }
        }
    }

    // MARK: - Helpers

    private static func strokeCircle(_ cg: CGContext, _ c: CGPoint, _ r: CGFloat) {
        cg.strokeEllipse(in: CGRect(x: c.x - r, y: c.y - r, width: r * 2, height: r * 2))
    }

    private static func strokeOval(_ cg: CGContext, _ rect: CGRect) {
        cg.strokeEllipse(in: rect)
    }

    private static func strokePath(_ cg: CGContext, _ points: [CGPoint], close: Bool = false) {
        guard let first = points.first else { return }
        cg.beginPath()
        cg.move(to: first)
        for p in points.dropFirst() { cg.addLine(to: p) }
        if close { cg.closePath() }
        cg.strokePath()
    }

    private static func strokeRoundedRect(_ cg: CGContext, _ rect: CGRect, _ radius: CGFloat) {
        let path = UIBezierPath(roundedRect: rect, cornerRadius: radius)
        cg.addPath(path.cgPath)
        cg.strokePath()
    }

    // MARK: - Space

    private static func drawRocket(_ cg: CGContext, _ size: CGSize) {
        let cx = size.width / 2
        strokePath(cg, [
            CGPoint(x: cx, y: 80),
            CGPoint(x: cx + 90, y: 280),
            CGPoint(x: cx + 90, y: 520),
            CGPoint(x: cx - 90, y: 520),
            CGPoint(x: cx - 90, y: 280),
        ], close: true)
        strokeCircle(cg, CGPoint(x: cx, y: 300), 40)
        strokePath(cg, [CGPoint(x: cx - 90, y: 520), CGPoint(x: cx - 140, y: 640), CGPoint(x: cx - 40, y: 560)], close: true)
        strokePath(cg, [CGPoint(x: cx + 90, y: 520), CGPoint(x: cx + 140, y: 640), CGPoint(x: cx + 40, y: 560)], close: true)
        strokePath(cg, [CGPoint(x: cx - 40, y: 520), CGPoint(x: cx, y: 680), CGPoint(x: cx + 40, y: 520)], close: true)
        for i in 0..<5 {
            let x = 120 + CGFloat(i) * 130
            strokePath(cg, [CGPoint(x: x, y: 100), CGPoint(x: x + 12, y: 120), CGPoint(x: x, y: 140), CGPoint(x: x - 12, y: 120)], close: true)
        }
    }

    private static func drawPlanet(_ cg: CGContext, _ size: CGSize) {
        let c = CGPoint(x: size.width / 2, y: size.height / 2)
        strokeCircle(cg, c, 180)
        strokeOval(cg, CGRect(x: c.x - 260, y: c.y - 40, width: 520, height: 80))
        strokeCircle(cg, CGPoint(x: c.x - 60, y: c.y - 40), 35)
        strokeCircle(cg, CGPoint(x: c.x + 50, y: c.y + 30), 50)
        strokeCircle(cg, CGPoint(x: c.x + 20, y: c.y - 90), 25)
        strokeCircle(cg, CGPoint(x: 140, y: 140), 18)
        strokeCircle(cg, CGPoint(x: 660, y: 180), 12)
        strokeCircle(cg, CGPoint(x: 620, y: 620), 16)
    }

    private static func drawAstronaut(_ cg: CGContext, _ size: CGSize) {
        let cx = size.width / 2
        strokeCircle(cg, CGPoint(x: cx, y: 180), 90)
        strokeCircle(cg, CGPoint(x: cx, y: 180), 60)
        strokeRoundedRect(cg, CGRect(x: cx - 100, y: 280, width: 200, height: 240), 40)
        strokeRoundedRect(cg, CGRect(x: cx - 55, y: 320, width: 110, height: 80), 16)
        strokePath(cg, [CGPoint(x: cx - 100, y: 340), CGPoint(x: cx - 180, y: 420), CGPoint(x: cx - 150, y: 460), CGPoint(x: cx - 100, y: 400)])
        strokePath(cg, [CGPoint(x: cx + 100, y: 340), CGPoint(x: cx + 180, y: 420), CGPoint(x: cx + 150, y: 460), CGPoint(x: cx + 100, y: 400)])
        strokeRoundedRect(cg, CGRect(x: cx - 90, y: 520, width: 70, height: 120), 20)
        strokeRoundedRect(cg, CGRect(x: cx + 20, y: 520, width: 70, height: 120), 20)
    }

    private static func drawUFO(_ cg: CGContext, _ size: CGSize) {
        let cx = size.width / 2
        strokeOval(cg, CGRect(x: cx - 80, y: 220, width: 160, height: 100))
        strokeOval(cg, CGRect(x: cx - 200, y: 280, width: 400, height: 120))
        for i in 0..<5 {
            strokeCircle(cg, CGPoint(x: cx - 140 + CGFloat(i) * 70, y: 340), 14)
        }
        strokePath(cg, [CGPoint(x: cx - 40, y: 400), CGPoint(x: cx - 100, y: 560), CGPoint(x: cx + 100, y: 560), CGPoint(x: cx + 40, y: 400)])
        strokeCircle(cg, CGPoint(x: 150, y: 150), 10)
        strokeCircle(cg, CGPoint(x: 650, y: 180), 14)
    }

    // MARK: - Unicorn

    private static func drawUnicorn(_ cg: CGContext, _ size: CGSize) {
        let cx = size.width / 2
        strokeCircle(cg, CGPoint(x: cx + 40, y: 220), 90)
        strokePath(cg, [CGPoint(x: cx + 40, y: 130), CGPoint(x: cx + 20, y: 40), CGPoint(x: cx + 70, y: 120)], close: true)
        strokePath(cg, [
            CGPoint(x: cx - 20, y: 180), CGPoint(x: cx - 80, y: 120), CGPoint(x: cx - 40, y: 200),
            CGPoint(x: cx - 100, y: 220), CGPoint(x: cx - 30, y: 250)
        ])
        strokeCircle(cg, CGPoint(x: cx + 70, y: 210), 10)
        strokePath(cg, [CGPoint(x: cx + 90, y: 250), CGPoint(x: cx + 130, y: 270)])
        strokeOval(cg, CGRect(x: cx - 120, y: 300, width: 220, height: 260))
        strokePath(cg, [CGPoint(x: cx - 80, y: 540), CGPoint(x: cx - 90, y: 680)])
        strokePath(cg, [CGPoint(x: cx - 40, y: 560), CGPoint(x: cx - 30, y: 690)])
        strokePath(cg, [CGPoint(x: cx + 20, y: 560), CGPoint(x: cx + 30, y: 690)])
        strokePath(cg, [CGPoint(x: cx + 60, y: 540), CGPoint(x: cx + 80, y: 680)])
        strokePath(cg, [
            CGPoint(x: cx - 100, y: 380), CGPoint(x: cx - 180, y: 320), CGPoint(x: cx - 160, y: 450),
            CGPoint(x: cx - 200, y: 520), CGPoint(x: cx - 90, y: 500)
        ])
    }

    private static func drawRainbow(_ cg: CGContext, _ size: CGSize) {
        let cx = size.width / 2
        for i in 0..<5 {
            let inset = CGFloat(i) * 36
            strokeOval(cg, CGRect(x: 120 + inset, y: 220 + inset, width: 560 - inset * 2, height: 360 - inset * 2))
        }
        // Clip bottom visually by covering? Skip — just draw arcs via ovals is fine for coloring
        strokeOval(cg, CGRect(x: cx - 160, y: 480, width: 140, height: 90))
        strokeOval(cg, CGRect(x: cx + 20, y: 480, width: 140, height: 90))
        strokeCircle(cg, CGPoint(x: cx - 100, y: 500), 8)
        strokeCircle(cg, CGPoint(x: cx + 80, y: 500), 8)
    }

    private static func drawCastle(_ cg: CGContext, _ size: CGSize) {
        let cx = size.width / 2
        strokePath(cg, [
            CGPoint(x: cx - 180, y: 560), CGPoint(x: cx - 180, y: 300),
            CGPoint(x: cx - 120, y: 300), CGPoint(x: cx - 120, y: 260),
            CGPoint(x: cx - 60, y: 260), CGPoint(x: cx - 60, y: 300),
            CGPoint(x: cx + 60, y: 300), CGPoint(x: cx + 60, y: 260),
            CGPoint(x: cx + 120, y: 260), CGPoint(x: cx + 120, y: 300),
            CGPoint(x: cx + 180, y: 300), CGPoint(x: cx + 180, y: 560)
        ], close: true)
        strokePath(cg, [CGPoint(x: cx - 40, y: 200), CGPoint(x: cx, y: 100), CGPoint(x: cx + 40, y: 200)], close: true)
        strokeRoundedRect(cg, CGRect(x: cx - 35, y: 200, width: 70, height: 100), 8)
        strokeRoundedRect(cg, CGRect(x: cx - 50, y: 420, width: 100, height: 140), 8)
        strokeCircle(cg, CGPoint(x: cx - 110, y: 380), 28)
        strokeCircle(cg, CGPoint(x: cx + 110, y: 380), 28)
    }

    private static func drawMagicStar(_ cg: CGContext, _ size: CGSize) {
        let c = CGPoint(x: size.width / 2, y: size.height / 2)
        starPath(cg, center: c, points: 5, r1: 200, r2: 90)
        strokeCircle(cg, CGPoint(x: c.x, y: c.y + 20), 40)
        strokePath(cg, [CGPoint(x: c.x - 18, y: c.y + 15), CGPoint(x: c.x - 8, y: c.y + 15)])
        strokePath(cg, [CGPoint(x: c.x + 8, y: c.y + 15), CGPoint(x: c.x + 18, y: c.y + 15)])
        strokePath(cg, [CGPoint(x: c.x - 15, y: c.y + 40), CGPoint(x: c.x, y: c.y + 50), CGPoint(x: c.x + 15, y: c.y + 40)])
        strokeCircle(cg, CGPoint(x: 140, y: 160), 20)
        strokeCircle(cg, CGPoint(x: 640, y: 200), 16)
        strokeCircle(cg, CGPoint(x: 180, y: 620), 14)
    }

    private static func starPath(_ cg: CGContext, center: CGPoint, points: Int, r1: CGFloat, r2: CGFloat) {
        cg.beginPath()
        for i in 0..<(points * 2) {
            let angle = CGFloat(i) * .pi / CGFloat(points) - .pi / 2
            let r = i % 2 == 0 ? r1 : r2
            let p = CGPoint(x: center.x + cos(angle) * r, y: center.y + sin(angle) * r)
            if i == 0 { cg.move(to: p) } else { cg.addLine(to: p) }
        }
        cg.closePath()
        cg.strokePath()
    }

    // MARK: - Wizard

    private static func drawWizardHat(_ cg: CGContext, _ size: CGSize) {
        let cx = size.width / 2
        strokePath(cg, [CGPoint(x: cx, y: 80), CGPoint(x: cx + 140, y: 480), CGPoint(x: cx - 140, y: 480)], close: true)
        strokeOval(cg, CGRect(x: cx - 220, y: 450, width: 440, height: 100))
        strokePath(cg, [
            CGPoint(x: cx - 40, y: 280), CGPoint(x: cx + 10, y: 240), CGPoint(x: cx + 50, y: 300),
            CGPoint(x: cx + 20, y: 340), CGPoint(x: cx - 30, y: 320)
        ], close: true)
        strokeCircle(cg, CGPoint(x: cx + 30, y: 180), 18)
        strokeCircle(cg, CGPoint(x: cx - 50, y: 360), 14)
    }

    private static func drawOwl(_ cg: CGContext, _ size: CGSize) {
        let cx = size.width / 2
        strokeOval(cg, CGRect(x: cx - 140, y: 200, width: 280, height: 360))
        strokeCircle(cg, CGPoint(x: cx - 55, y: 300), 50)
        strokeCircle(cg, CGPoint(x: cx + 55, y: 300), 50)
        strokeCircle(cg, CGPoint(x: cx - 55, y: 300), 18)
        strokeCircle(cg, CGPoint(x: cx + 55, y: 300), 18)
        strokePath(cg, [CGPoint(x: cx, y: 340), CGPoint(x: cx - 25, y: 380), CGPoint(x: cx + 25, y: 380)], close: true)
        strokePath(cg, [CGPoint(x: cx - 100, y: 180), CGPoint(x: cx - 60, y: 120), CGPoint(x: cx - 20, y: 200)])
        strokePath(cg, [CGPoint(x: cx + 100, y: 180), CGPoint(x: cx + 60, y: 120), CGPoint(x: cx + 20, y: 200)])
        strokePath(cg, [CGPoint(x: cx - 40, y: 560), CGPoint(x: cx - 60, y: 620), CGPoint(x: cx - 10, y: 600)])
        strokePath(cg, [CGPoint(x: cx + 40, y: 560), CGPoint(x: cx + 60, y: 620), CGPoint(x: cx + 10, y: 600)])
    }

    private static func drawWand(_ cg: CGContext, _ size: CGSize) {
        strokePath(cg, [CGPoint(x: 220, y: 620), CGPoint(x: 520, y: 180)])
        strokePath(cg, [CGPoint(x: 200, y: 640), CGPoint(x: 240, y: 600), CGPoint(x: 260, y: 640), CGPoint(x: 200, y: 660)], close: true)
        starPath(cg, center: CGPoint(x: 560, y: 140), points: 4, r1: 50, r2: 20)
        strokeCircle(cg, CGPoint(x: 620, y: 220), 12)
        strokeCircle(cg, CGPoint(x: 480, y: 100), 10)
        strokeCircle(cg, CGPoint(x: 640, y: 100), 8)
    }

    private static func drawPotion(_ cg: CGContext, _ size: CGSize) {
        let cx = size.width / 2
        strokeRoundedRect(cg, CGRect(x: cx - 40, y: 120, width: 80, height: 80), 12)
        strokePath(cg, [
            CGPoint(x: cx - 40, y: 200), CGPoint(x: cx - 40, y: 260),
            CGPoint(x: cx - 120, y: 360), CGPoint(x: cx - 120, y: 560),
            CGPoint(x: cx + 120, y: 560), CGPoint(x: cx + 120, y: 360),
            CGPoint(x: cx + 40, y: 260), CGPoint(x: cx + 40, y: 200)
        ], close: true)
        strokePath(cg, [CGPoint(x: cx - 90, y: 420), CGPoint(x: cx - 40, y: 400), CGPoint(x: cx + 20, y: 430), CGPoint(x: cx + 90, y: 410)])
        strokeCircle(cg, CGPoint(x: cx - 40, y: 480), 16)
        strokeCircle(cg, CGPoint(x: cx + 50, y: 500), 12)
        strokeCircle(cg, CGPoint(x: cx + 10, y: 460), 10)
    }

    // MARK: - Kawaii

    private static func drawBunny(_ cg: CGContext, _ size: CGSize) {
        let cx = size.width / 2
        strokeOval(cg, CGRect(x: cx - 50, y: 80, width: 50, height: 180))
        strokeOval(cg, CGRect(x: cx + 10, y: 80, width: 50, height: 180))
        strokeCircle(cg, CGPoint(x: cx, y: 320), 120)
        strokeCircle(cg, CGPoint(x: cx - 45, y: 300), 12)
        strokeCircle(cg, CGPoint(x: cx + 45, y: 300), 12)
        strokeOval(cg, CGRect(x: cx - 18, y: 330, width: 36, height: 24))
        strokePath(cg, [CGPoint(x: cx - 30, y: 370), CGPoint(x: cx, y: 385), CGPoint(x: cx + 30, y: 370)])
        strokeOval(cg, CGRect(x: cx - 130, y: 440, width: 260, height: 220))
        strokeCircle(cg, CGPoint(x: cx - 100, y: 520), 40)
        strokeCircle(cg, CGPoint(x: cx + 100, y: 520), 40)
    }

    private static func drawCupcake(_ cg: CGContext, _ size: CGSize) {
        let cx = size.width / 2
        strokePath(cg, [
            CGPoint(x: cx - 140, y: 340), CGPoint(x: cx - 160, y: 280),
            CGPoint(x: cx - 80, y: 240), CGPoint(x: cx, y: 200),
            CGPoint(x: cx + 80, y: 240), CGPoint(x: cx + 160, y: 280),
            CGPoint(x: cx + 140, y: 340)
        ], close: true)
        strokeCircle(cg, CGPoint(x: cx, y: 160), 28)
        strokePath(cg, [
            CGPoint(x: cx - 140, y: 340), CGPoint(x: cx - 110, y: 620),
            CGPoint(x: cx + 110, y: 620), CGPoint(x: cx + 140, y: 340)
        ], close: true)
        for i in 0..<4 {
            let x = cx - 90 + CGFloat(i) * 60
            strokePath(cg, [CGPoint(x: x, y: 360), CGPoint(x: x + 10, y: 600)])
        }
    }

    private static func drawSmileyStar(_ cg: CGContext, _ size: CGSize) {
        let c = CGPoint(x: size.width / 2, y: size.height / 2)
        starPath(cg, center: c, points: 5, r1: 220, r2: 100)
        strokeCircle(cg, CGPoint(x: c.x - 50, y: c.y - 10), 16)
        strokeCircle(cg, CGPoint(x: c.x + 50, y: c.y - 10), 16)
        strokePath(cg, [CGPoint(x: c.x - 40, y: c.y + 40), CGPoint(x: c.x, y: c.y + 60), CGPoint(x: c.x + 40, y: c.y + 40)])
        strokeOval(cg, CGRect(x: c.x - 70, y: c.y + 10, width: 40, height: 24))
        strokeOval(cg, CGRect(x: c.x + 30, y: c.y + 10, width: 40, height: 24))
    }

    private static func drawHeartFriend(_ cg: CGContext, _ size: CGSize) {
        let cx = size.width / 2
        let cy: CGFloat = 360
        cg.beginPath()
        cg.move(to: CGPoint(x: cx, y: cy + 180))
        cg.addCurve(
            to: CGPoint(x: cx - 180, y: cy - 40),
            control1: CGPoint(x: cx - 40, y: cy + 100),
            control2: CGPoint(x: cx - 180, y: cy + 80)
        )
        cg.addCurve(
            to: CGPoint(x: cx, y: cy - 100),
            control1: CGPoint(x: cx - 180, y: cy - 140),
            control2: CGPoint(x: cx - 60, y: cy - 140)
        )
        cg.addCurve(
            to: CGPoint(x: cx + 180, y: cy - 40),
            control1: CGPoint(x: cx + 60, y: cy - 140),
            control2: CGPoint(x: cx + 180, y: cy - 140)
        )
        cg.addCurve(
            to: CGPoint(x: cx, y: cy + 180),
            control1: CGPoint(x: cx + 180, y: cy + 80),
            control2: CGPoint(x: cx + 40, y: cy + 100)
        )
        cg.strokePath()
        strokeCircle(cg, CGPoint(x: cx - 50, y: cy - 20), 14)
        strokeCircle(cg, CGPoint(x: cx + 50, y: cy - 20), 14)
        strokePath(cg, [CGPoint(x: cx - 30, y: cy + 40), CGPoint(x: cx, y: cy + 55), CGPoint(x: cx + 30, y: cy + 40)])
    }

    // MARK: - Kitty

    private static func drawBowKitty(_ cg: CGContext, _ size: CGSize) {
        let cx = size.width / 2
        strokeCircle(cg, CGPoint(x: cx, y: 320), 150)
        strokePath(cg, [CGPoint(x: cx - 120, y: 220), CGPoint(x: cx - 160, y: 100), CGPoint(x: cx - 40, y: 200)], close: true)
        strokePath(cg, [CGPoint(x: cx + 120, y: 220), CGPoint(x: cx + 160, y: 100), CGPoint(x: cx + 40, y: 200)], close: true)
        strokeCircle(cg, CGPoint(x: cx - 50, y: 310), 18)
        strokeCircle(cg, CGPoint(x: cx + 50, y: 310), 18)
        strokeOval(cg, CGRect(x: cx - 16, y: 350, width: 32, height: 22))
        strokePath(cg, [CGPoint(x: cx, y: 372), CGPoint(x: cx, y: 400)])
        strokePath(cg, [CGPoint(x: cx, y: 390), CGPoint(x: cx - 40, y: 410)])
        strokePath(cg, [CGPoint(x: cx, y: 390), CGPoint(x: cx + 40, y: 410)])
        // Bow
        strokePath(cg, [CGPoint(x: cx - 30, y: 180), CGPoint(x: cx - 90, y: 140), CGPoint(x: cx - 90, y: 220)], close: true)
        strokePath(cg, [CGPoint(x: cx + 30, y: 180), CGPoint(x: cx + 90, y: 140), CGPoint(x: cx + 90, y: 220)], close: true)
        strokeCircle(cg, CGPoint(x: cx, y: 180), 22)
        strokeOval(cg, CGRect(x: cx - 100, y: 470, width: 200, height: 160))
    }

    private static func drawFish(_ cg: CGContext, _ size: CGSize) {
        let cx = size.width / 2
        strokeOval(cg, CGRect(x: cx - 180, y: 280, width: 320, height: 200))
        strokePath(cg, [CGPoint(x: cx + 140, y: 380), CGPoint(x: cx + 260, y: 280), CGPoint(x: cx + 260, y: 480)], close: true)
        strokeCircle(cg, CGPoint(x: cx - 80, y: 360), 18)
        strokePath(cg, [CGPoint(x: cx - 160, y: 380), CGPoint(x: cx - 200, y: 360), CGPoint(x: cx - 200, y: 400)], close: true)
        strokePath(cg, [CGPoint(x: cx - 20, y: 300), CGPoint(x: cx + 20, y: 250), CGPoint(x: cx + 40, y: 310)])
        strokePath(cg, [CGPoint(x: cx - 20, y: 460), CGPoint(x: cx + 20, y: 510), CGPoint(x: cx + 40, y: 450)])
    }

    private static func drawYarn(_ cg: CGContext, _ size: CGSize) {
        let c = CGPoint(x: size.width / 2, y: size.height / 2 - 20)
        strokeCircle(cg, c, 180)
        for i in -3...3 {
            let y = c.y + CGFloat(i) * 36
            cg.beginPath()
            cg.move(to: CGPoint(x: c.x - 160, y: y))
            cg.addQuadCurve(to: CGPoint(x: c.x + 160, y: y), control: CGPoint(x: c.x, y: y + (i % 2 == 0 ? 40 : -40)))
            cg.strokePath()
        }
        strokePath(cg, [CGPoint(x: c.x + 120, y: c.y + 100), CGPoint(x: c.x + 240, y: c.y + 220), CGPoint(x: c.x + 280, y: c.y + 180)])
    }

    private static func drawKittyHouse(_ cg: CGContext, _ size: CGSize) {
        let cx = size.width / 2
        strokePath(cg, [
            CGPoint(x: cx - 200, y: 400), CGPoint(x: cx, y: 160), CGPoint(x: cx + 200, y: 400)
        ], close: true)
        strokeRoundedRect(cg, CGRect(x: cx - 180, y: 400, width: 360, height: 240), 12)
        strokeRoundedRect(cg, CGRect(x: cx - 50, y: 480, width: 100, height: 160), 50)
        strokeCircle(cg, CGPoint(x: cx - 100, y: 460), 28)
        strokeCircle(cg, CGPoint(x: cx + 100, y: 460), 28)
        strokeCircle(cg, CGPoint(x: cx, y: 240), 20)
        // Little cat ears on roof
        strokePath(cg, [CGPoint(x: cx - 40, y: 200), CGPoint(x: cx - 60, y: 140), CGPoint(x: cx - 10, y: 180)])
        strokePath(cg, [CGPoint(x: cx + 40, y: 200), CGPoint(x: cx + 60, y: 140), CGPoint(x: cx + 10, y: 180)])
    }
}
