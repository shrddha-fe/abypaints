import Foundation

struct ColoringPage: Identifiable, Hashable {
    let id: String
    let theme: ColoringTheme
    let title: String
    let artKind: OutlineArtKind

    static let catalog: [ColoringPage] = [
        // Space
        .init(id: "space-rocket", theme: .space, title: "Rocket Ship", artKind: .rocket),
        .init(id: "space-planet", theme: .space, title: "Happy Planet", artKind: .planet),
        .init(id: "space-astronaut", theme: .space, title: "Astronaut", artKind: .astronaut),
        .init(id: "space-ufo", theme: .space, title: "Friendly UFO", artKind: .ufo),

        // Unicorn
        .init(id: "uni-unicorn", theme: .unicorn, title: "Unicorn", artKind: .unicorn),
        .init(id: "uni-rainbow", theme: .unicorn, title: "Rainbow Cloud", artKind: .rainbow),
        .init(id: "uni-castle", theme: .unicorn, title: "Candy Castle", artKind: .castle),
        .init(id: "uni-star", theme: .unicorn, title: "Magic Star", artKind: .magicStar),

        // Wizard Academy (original — not Harry Potter branded)
        .init(id: "wiz-hat", theme: .wizard, title: "Wizard Hat", artKind: .wizardHat),
        .init(id: "wiz-owl", theme: .wizard, title: "Wise Owl", artKind: .owl),
        .init(id: "wiz-wand", theme: .wizard, title: "Magic Wand", artKind: .wand),
        .init(id: "wiz-potion", theme: .wizard, title: "Potion Bottle", artKind: .potion),

        // Kawaii Friends (original — not Sanrio branded)
        .init(id: "kaw-bunny", theme: .kawaii, title: "Bunny Pal", artKind: .bunny),
        .init(id: "kaw-cupcake", theme: .kawaii, title: "Cupcake", artKind: .cupcake),
        .init(id: "kaw-starface", theme: .kawaii, title: "Smiley Star", artKind: .smileyStar),
        .init(id: "kaw-heart", theme: .kawaii, title: "Heart Friend", artKind: .heartFriend),

        // Cute Kitty Club (original — not Hello Kitty branded)
        .init(id: "kit-bowcat", theme: .kitty, title: "Bow Kitty", artKind: .bowKitty),
        .init(id: "kit-fish", theme: .kitty, title: "Fish Snack", artKind: .fish),
        .init(id: "kit-yarn", theme: .kitty, title: "Yarn Ball", artKind: .yarn),
        .init(id: "kit-house", theme: .kitty, title: "Kitty House", artKind: .kittyHouse),
    ]

    static func pages(for theme: ColoringTheme) -> [ColoringPage] {
        catalog.filter { $0.theme == theme }
    }
}
