import SwiftUI

struct PaletteColor: Identifiable, Hashable {
    let id: String
    let color: Color
    let uiColor: UIColor

    init(id: String, hex: String) {
        self.id = id
        self.color = Color(hex: hex)
        self.uiColor = UIColor(hex: hex)
    }
}

extension UIColor {
    convenience init(hex: String) {
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
            red: CGFloat(r) / 255,
            green: CGFloat(g) / 255,
            blue: CGFloat(b) / 255,
            alpha: 1
        )
    }
}

enum AppPalette {
    static let colors: [PaletteColor] = [
        .init(id: "red", hex: "E63946"),
        .init(id: "coral", hex: "FF6B6B"),
        .init(id: "orange", hex: "FF9F1C"),
        .init(id: "yellow", hex: "FFD166"),
        .init(id: "lime", hex: "B5E48C"),
        .init(id: "green", hex: "52B788"),
        .init(id: "teal", hex: "2A9D8F"),
        .init(id: "sky", hex: "4CC9F0"),
        .init(id: "blue", hex: "4361EE"),
        .init(id: "indigo", hex: "3A0CA3"),
        .init(id: "purple", hex: "9B5DE5"),
        .init(id: "pink", hex: "F72585"),
        .init(id: "blush", hex: "FF8FAB"),
        .init(id: "brown", hex: "A47148"),
        .init(id: "cream", hex: "FFF1E6"),
        .init(id: "white", hex: "FFFFFF"),
        .init(id: "gray", hex: "ADB5BD"),
        .init(id: "black", hex: "212529"),
    ]
}

enum DrawingTool: String, CaseIterable, Identifiable {
    case fill
    case brush

    var id: String { rawValue }

    var title: String {
        switch self {
        case .fill: return "Fill"
        case .brush: return "Brush"
        }
    }

    var systemImage: String {
        switch self {
        case .fill: return "paintbucket.fill"
        case .brush: return "paintbrush.pointed.fill"
        }
    }
}
