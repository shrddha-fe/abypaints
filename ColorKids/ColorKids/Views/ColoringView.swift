import SwiftUI

struct ColoringView: View {
    let page: ColoringPage
    @EnvironmentObject private var artStore: SavedArtStore
    @StateObject private var canvas: ColoringCanvasController
    @State private var selectedColor = AppPalette.colors[11]
    @State private var tool: DrawingTool = .fill
    @State private var brushSize: CGFloat = 28
    @State private var showSavedToast = false

    init(page: ColoringPage) {
        self.page = page
        let outline = OutlineArtGenerator.image(for: page.artKind)
        _canvas = StateObject(wrappedValue: ColoringCanvasController(outline: outline))
    }

    var body: some View {
        VStack(spacing: 0) {
            ColoringCanvasView(controller: canvas)
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .frame(maxHeight: .infinity)

            controls
        }
        .background(
            LinearGradient(
                colors: [Color(hex: "F8F9FA"), page.theme.accent.opacity(0.12)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
        .navigationTitle(page.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button {
                    canvas.undo()
                } label: {
                    Image(systemName: "arrow.uturn.backward")
                }
                .disabled(!canvas.canUndo)

                Button {
                    canvas.clearColors()
                } label: {
                    Image(systemName: "trash")
                }

                Button {
                    saveArt()
                } label: {
                    Image(systemName: "square.and.arrow.down")
                }
            }
        }
        .overlay(alignment: .top) {
            if showSavedToast {
                Text("Saved to My Gallery!")
                    .font(.custom("AvenirNext-DemiBold", size: 16))
                    .padding(.horizontal, 18)
                    .padding(.vertical, 12)
                    .background(.ultraThinMaterial, in: Capsule())
                    .padding(.top, 8)
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .onChange(of: selectedColor) { _, newValue in
            canvas.selectedColor = newValue.uiColor
        }
        .onChange(of: tool) { _, newValue in
            canvas.tool = newValue
        }
        .onChange(of: brushSize) { _, newValue in
            canvas.brushSize = newValue
        }
        .onAppear {
            canvas.selectedColor = selectedColor.uiColor
            canvas.tool = tool
            canvas.brushSize = brushSize
        }
    }

    private var controls: some View {
        VStack(spacing: 14) {
            HStack(spacing: 12) {
                ForEach(DrawingTool.allCases) { item in
                    Button {
                        tool = item
                    } label: {
                        Label(item.title, systemImage: item.systemImage)
                            .font(.custom("AvenirNext-DemiBold", size: 15))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(
                                Capsule().fill(tool == item ? page.theme.accent : Color.white)
                            )
                            .foregroundStyle(tool == item ? .white : Color(hex: "1D3557"))
                    }
                    .buttonStyle(.plain)
                }

                Spacer()

                if tool == .brush {
                    HStack(spacing: 8) {
                        Image(systemName: "circle.fill")
                            .font(.system(size: 8))
                        Slider(value: $brushSize, in: 12...48)
                            .frame(width: 100)
                        Image(systemName: "circle.fill")
                            .font(.system(size: 16))
                    }
                    .foregroundStyle(Color(hex: "457B9D"))
                }
            }
            .padding(.horizontal, 16)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(AppPalette.colors) { swatch in
                        Button {
                            selectedColor = swatch
                        } label: {
                            Circle()
                                .fill(swatch.color)
                                .frame(width: 44, height: 44)
                                .overlay(
                                    Circle()
                                        .stroke(Color.white, lineWidth: selectedColor == swatch ? 3 : 0)
                                )
                                .overlay(
                                    Circle()
                                        .stroke(Color(hex: "1D3557").opacity(0.25), lineWidth: 1)
                                )
                                .shadow(color: selectedColor == swatch ? swatch.color.opacity(0.5) : .clear, radius: 6)
                                .scaleEffect(selectedColor == swatch ? 1.12 : 1)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 6)
            }
        }
        .padding(.vertical, 14)
        .background(.ultraThinMaterial)
    }

    private func saveArt() {
        guard let image = canvas.exportImage() else { return }
        artStore.save(image: image, page: page)
        withAnimation(.spring(response: 0.4)) {
            showSavedToast = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
            withAnimation { showSavedToast = false }
        }
    }
}
