import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var artStore: SavedArtStore

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 28) {
                    hero

                    NavigationLink {
                        MyArtView()
                    } label: {
                        HStack(spacing: 14) {
                            Image(systemName: "photo.on.rectangle.angled")
                                .font(.title2)
                                .foregroundStyle(Color(hex: "E63946"))
                            VStack(alignment: .leading, spacing: 2) {
                                Text("My Gallery")
                                    .font(.custom("AvenirNext-Bold", size: 20))
                                    .foregroundStyle(Color(hex: "1D3557"))
                                Text("\(artStore.items.count) saved masterpiece\(artStore.items.count == 1 ? "" : "s")")
                                    .font(.custom("AvenirNext-Regular", size: 14))
                                    .foregroundStyle(Color(hex: "457B9D"))
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundStyle(Color(hex: "A8DADC"))
                        }
                        .padding(18)
                        .background(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .fill(Color.white.opacity(0.85))
                        )
                    }

                    Text("Pick a Theme")
                        .font(.custom("AvenirNext-Bold", size: 22))
                        .foregroundStyle(Color(hex: "1D3557"))
                        .padding(.horizontal, 4)

                    LazyVGrid(
                        columns: [GridItem(.adaptive(minimum: 150), spacing: 16)],
                        spacing: 16
                    ) {
                        ForEach(ColoringTheme.allCases) { theme in
                            NavigationLink {
                                ThemeGalleryView(theme: theme)
                            } label: {
                                ThemeCard(theme: theme)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(20)
                .padding(.bottom, 24)
            }
            .background(homeBackground.ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private var hero: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("AbyPaints")
                .font(.custom("AvenirNext-Heavy", size: 42))
                .foregroundStyle(Color(hex: "1D3557"))
            Text("Tap to fill or paint with a brush. Pick a theme and make it yours!")
                .font(.custom("AvenirNext-Medium", size: 17))
                .foregroundStyle(Color(hex: "457B9D"))
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 8)
    }

    private var homeBackground: some View {
        LinearGradient(
            colors: [Color(hex: "F1FAEE"), Color(hex: "A8DADC").opacity(0.45), Color(hex: "FFE5EC")],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

struct ThemeCard: View {
    let theme: ColoringTheme

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(theme.emoji)
                .font(.system(size: 40))
            Text(theme.title)
                .font(.custom("AvenirNext-Bold", size: 17))
                .foregroundStyle(.white)
                .multilineTextAlignment(.leading)
            Text(theme.subtitle)
                .font(.custom("AvenirNext-Regular", size: 13))
                .foregroundStyle(.white.opacity(0.85))
                .multilineTextAlignment(.leading)
        }
        .padding(18)
        .frame(maxWidth: .infinity, minHeight: 140, alignment: .topLeading)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(
                    LinearGradient(colors: theme.gradient, startPoint: .topLeading, endPoint: .bottomTrailing)
                )
        )
        .shadow(color: theme.accent.opacity(0.35), radius: 10, y: 6)
    }
}
