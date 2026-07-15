import SwiftUI

enum ColoringTheme: String, CaseIterable, Identifiable, Codable {
    case space
    case unicorn
    case wizard
    case kawaii
    case kitty

    var id: String { rawValue }

    var title: String {
        switch self {
        case .space: return "Space Adventures"
        case .unicorn: return "Magical Unicorns"
        case .wizard: return "Wizard Academy"
        case .kawaii: return "Kawaii Friends"
        case .kitty: return "Cute Kitty Club"
        }
    }

    var subtitle: String {
        switch self {
        case .space: return "Rockets, planets & stars"
        case .unicorn: return "Rainbows & sparkles"
        case .wizard: return "Wands, owls & spells"
        case .kawaii: return "Sweet pastel pals"
        case .kitty: return "Bow cats & friends"
        }
    }

    var emoji: String {
        switch self {
        case .space: return "🚀"
        case .unicorn: return "🦄"
        case .wizard: return "🪄"
        case .kawaii: return "🍡"
        case .kitty: return "🐱"
        }
    }

    var gradient: [Color] {
        switch self {
        case .space: return [Color(hex: "1B3A4B"), Color(hex: "0D1B2A")]
        case .unicorn: return [Color(hex: "F7A8C8"), Color(hex: "C9B6FF")]
        case .wizard: return [Color(hex: "2D6A4F"), Color(hex: "1B4332")]
        case .kawaii: return [Color(hex: "FFB4A2"), Color(hex: "FFC8DD")]
        case .kitty: return [Color(hex: "FF8FAB"), Color(hex: "FFB5C8")]
        }
    }

    var accent: Color {
        switch self {
        case .space: return Color(hex: "48CAE4")
        case .unicorn: return Color(hex: "E056A0")
        case .wizard: return Color(hex: "D4A373")
        case .kawaii: return Color(hex: "FF6B9D")
        case .kitty: return Color(hex: "E63946")
        }
    }
}

extension Color {
    init(hex: String) {
        let cleaned = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: cleaned).scanHexInt64(&int)
        let r, g, b: UInt64
        switch cleaned.count {
        case 6:
            (r, g, b) = ((int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        default:
            (r, g, b) = (0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: 1
        )
    }
}
