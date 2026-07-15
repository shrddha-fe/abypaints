import Foundation
import UIKit

struct SavedArtwork: Identifiable, Codable, Equatable {
    let id: UUID
    let pageId: String
    let pageTitle: String
    let themeRaw: String
    let createdAt: Date
    let fileName: String

    var theme: ColoringTheme {
        ColoringTheme(rawValue: themeRaw) ?? .space
    }
}

@MainActor
final class SavedArtStore: ObservableObject {
    @Published private(set) var items: [SavedArtwork] = []

    private let folder: URL
    private let indexURL: URL
    private let fileManager = FileManager.default

    init() {
        let docs = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        folder = docs.appendingPathComponent("SavedArt", isDirectory: true)
        indexURL = folder.appendingPathComponent("index.json")
        try? fileManager.createDirectory(at: folder, withIntermediateDirectories: true)
        load()
    }

    func save(image: UIImage, page: ColoringPage) {
        let id = UUID()
        let fileName = "\(id.uuidString).png"
        let fileURL = folder.appendingPathComponent(fileName)
        guard let data = image.pngData() else { return }
        do {
            try data.write(to: fileURL, options: .atomic)
            let item = SavedArtwork(
                id: id,
                pageId: page.id,
                pageTitle: page.title,
                themeRaw: page.theme.rawValue,
                createdAt: Date(),
                fileName: fileName
            )
            items.insert(item, at: 0)
            persistIndex()
        } catch {
            print("Save failed: \(error)")
        }
    }

    func image(for item: SavedArtwork) -> UIImage? {
        let url = folder.appendingPathComponent(item.fileName)
        return UIImage(contentsOfFile: url.path)
    }

    func delete(_ item: SavedArtwork) {
        let url = folder.appendingPathComponent(item.fileName)
        try? fileManager.removeItem(at: url)
        items.removeAll { $0.id == item.id }
        persistIndex()
    }

    private func load() {
        guard let data = try? Data(contentsOf: indexURL),
              let decoded = try? JSONDecoder().decode([SavedArtwork].self, from: data) else {
            items = []
            return
        }
        items = decoded.sorted { $0.createdAt > $1.createdAt }
    }

    private func persistIndex() {
        guard let data = try? JSONEncoder().encode(items) else { return }
        try? data.write(to: indexURL, options: .atomic)
    }
}
