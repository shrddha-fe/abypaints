import SwiftUI

struct ThemeGalleryView: View {
    let theme: ColoringTheme
    private var pages: [ColoringPage] { ColoringPage.pages(for: theme) }

    var body: some View {
        ScrollView {
            LazyVGrid(
                columns: [GridItem(.adaptive(minimum: 160), spacing: 16)],
                spacing: 16
            ) {
                ForEach(pages) { page in
                    NavigationLink {
                        ColoringView(page: page)
                    } label: {
                        PageCard(page: page)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(20)
        }
        .background(
            LinearGradient(colors: theme.gradient.map { $0.opacity(0.15) } + [Color(hex: "F1FAEE")], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
        )
        .navigationTitle(theme.title)
        .navigationBarTitleDisplayMode(.large)
    }
}

struct PageCard: View {
    let page: ColoringPage

    var body: some View {
        VStack(spacing: 12) {
            Image(uiImage: OutlineArtGenerator.image(for: page.artKind))
                .resizable()
                .scaledToFit()
                .padding(10)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

            Text(page.title)
                .font(.custom("AvenirNext-DemiBold", size: 16))
                .foregroundStyle(Color(hex: "1D3557"))
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.white.opacity(0.9))
                .shadow(color: .black.opacity(0.08), radius: 8, y: 4)
        )
    }
}
