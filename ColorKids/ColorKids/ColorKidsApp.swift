import SwiftUI

@main
struct ColorKidsApp: App {
    @StateObject private var artStore = SavedArtStore()

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(artStore)
        }
    }
}
