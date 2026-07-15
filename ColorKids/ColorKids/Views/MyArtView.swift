import SwiftUI

struct MyArtView: View {
    @EnvironmentObject private var artStore: SavedArtStore

    private let columns = [GridItem(.adaptive(minimum: 150), spacing: 16)]

    var body: some View {
        Group {
            if artStore.items.isEmpty {
                ContentUnavailableView(
                    "No art yet",
                    systemImage: "paintpalette",
                    description: Text("Color a picture and tap Save to keep it here.")
                )
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(artStore.items) { item in
                            SavedArtCard(item: item) {
                                artStore.delete(item)
                            }
                        }
                    }
                    .padding(20)
                }
            }
        }
        .background(
            LinearGradient(
                colors: [Color(hex: "FFF1E6"), Color(hex: "F1FAEE")],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
        .navigationTitle("My Gallery")
    }
}

struct SavedArtCard: View {
    let item: SavedArtwork
    let onDelete: () -> Void
    @EnvironmentObject private var artStore: SavedArtStore

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if let image = artStore.image(for: item) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            }

            Text(item.pageTitle)
                .font(.custom("AvenirNext-DemiBold", size: 15))
                .foregroundStyle(Color(hex: "1D3557"))

            Text(item.theme.title)
                .font(.custom("AvenirNext-Regular", size: 12))
                .foregroundStyle(Color(hex: "457B9D"))

            Button(role: .destructive, action: onDelete) {
                Label("Delete", systemImage: "trash")
                    .font(.custom("AvenirNext-Medium", size: 13))
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color.white.opacity(0.92))
                .shadow(color: .black.opacity(0.08), radius: 8, y: 4)
        )
    }
}
