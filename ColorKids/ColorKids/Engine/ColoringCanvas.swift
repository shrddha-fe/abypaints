import SwiftUI
import UIKit

final class ColoringCanvasController: ObservableObject {
    @Published var displayImage: UIImage?
    @Published var canUndo = false

    private var outlineImage: UIImage
    private var colorLayer: UIImage
    private var history: [UIImage] = []
    private let maxHistory = 20

    var selectedColor: UIColor = .systemPink
    var tool: DrawingTool = .fill
    var brushSize: CGFloat = 24

    init(outline: UIImage) {
        self.outlineImage = outline
        self.colorLayer = Self.blankImage(size: outline.size)
        rebuildDisplay()
    }

    func reset(with outline: UIImage) {
        outlineImage = outline
        colorLayer = Self.blankImage(size: outline.size)
        history.removeAll()
        canUndo = false
        rebuildDisplay()
    }

    func clearColors() {
        pushHistory()
        colorLayer = Self.blankImage(size: outlineImage.size)
        rebuildDisplay()
    }

    func undo() {
        guard let previous = history.popLast() else { return }
        colorLayer = previous
        canUndo = !history.isEmpty
        rebuildDisplay()
    }

    func handleTap(at viewPoint: CGPoint, in viewSize: CGSize) {
        let imagePoint = convert(viewPoint, viewSize: viewSize)
        switch tool {
        case .fill:
            applyFill(at: imagePoint)
        case .brush:
            pushHistory()
            drawBrush(at: imagePoint)
            rebuildDisplay()
        }
    }

    func handleBrushMoved(to viewPoint: CGPoint, in viewSize: CGSize, began: Bool) {
        guard tool == .brush else { return }
        let imagePoint = convert(viewPoint, viewSize: viewSize)
        if began { pushHistory() }
        drawBrush(at: imagePoint)
        rebuildDisplay()
    }

    func exportImage() -> UIImage? {
        displayImage
    }

    // MARK: - Private

    private func convert(_ point: CGPoint, viewSize: CGSize) -> CGPoint {
        let imageSize = outlineImage.size
        let scale = min(viewSize.width / imageSize.width, viewSize.height / imageSize.height)
        let drawnSize = CGSize(width: imageSize.width * scale, height: imageSize.height * scale)
        let origin = CGPoint(
            x: (viewSize.width - drawnSize.width) / 2,
            y: (viewSize.height - drawnSize.height) / 2
        )
        let x = (point.x - origin.x) / scale
        let y = (point.y - origin.y) / scale
        return CGPoint(x: x, y: y)
    }

    private func applyFill(at point: CGPoint) {
        // Composite outline + color for flood-fill walls, then write into color layer
        guard let composite = compositeForFill(),
              let bufferData = PixelBuffer.from(composite),
              var colorData = PixelBuffer.from(colorLayer) else { return }

        let x = Int(point.x)
        let y = Int(point.y)
        guard x >= 0, y >= 0, x < bufferData.width, y < bufferData.height else { return }

        pushHistory()

        // Fill on composite to know the region, then copy filled pixels that aren't outline onto color layer
        var fillBuffer = bufferData.pixels
        FloodFill.fill(
            buffer: &fillBuffer,
            width: bufferData.width,
            height: bufferData.height,
            startX: x,
            startY: y,
            color: selectedColor
        )

        // Transfer non-outline filled pixels to color layer
        let count = bufferData.width * bufferData.height
        for i in 0..<count {
            let o = i * 4
            let r = Int(fillBuffer[o])
            let g = Int(fillBuffer[o + 1])
            let b = Int(fillBuffer[o + 2])
            let a = Int(fillBuffer[o + 3])
            let isOutline = a > 200 && r < 50 && g < 50 && b < 50
            if isOutline { continue }

            // If pixel changed from original composite white/colored area to selected color, write it
            let cr = Int(bufferData.pixels[o])
            let cg = Int(bufferData.pixels[o + 1])
            let cb = Int(bufferData.pixels[o + 2])
            if r != cr || g != cg || b != cb {
                colorData.pixels[o] = fillBuffer[o]
                colorData.pixels[o + 1] = fillBuffer[o + 1]
                colorData.pixels[o + 2] = fillBuffer[o + 2]
                colorData.pixels[o + 3] = fillBuffer[o + 3]
            }
        }

        if let updated = PixelBuffer.image(from: colorData.pixels, width: colorData.width, height: colorData.height) {
            colorLayer = updated
        }
        rebuildDisplay()
    }

    private func drawBrush(at point: CGPoint) {
        let size = outlineImage.size
        let format = UIGraphicsImageRendererFormat()
        format.opaque = false
        format.scale = 1
        let renderer = UIGraphicsImageRenderer(size: size, format: format)
        colorLayer = renderer.image { _ in
            colorLayer.draw(in: CGRect(origin: .zero, size: size))
            selectedColor.setFill()
            let rect = CGRect(
                x: point.x - brushSize / 2,
                y: point.y - brushSize / 2,
                width: brushSize,
                height: brushSize
            )
            UIBezierPath(ovalIn: rect).fill()
        }
    }

    private func compositeForFill() -> UIImage? {
        let size = outlineImage.size
        let format = UIGraphicsImageRendererFormat()
        format.opaque = true
        format.scale = 1
        let renderer = UIGraphicsImageRenderer(size: size, format: format)
        return renderer.image { _ in
            UIColor.white.setFill()
            UIRectFill(CGRect(origin: .zero, size: size))
            colorLayer.draw(in: CGRect(origin: .zero, size: size))
            outlineImage.draw(in: CGRect(origin: .zero, size: size))
        }
    }

    private func rebuildDisplay() {
        let size = outlineImage.size
        let format = UIGraphicsImageRendererFormat()
        format.opaque = true
        format.scale = 1
        let renderer = UIGraphicsImageRenderer(size: size, format: format)
        displayImage = renderer.image { _ in
            UIColor.white.setFill()
            UIRectFill(CGRect(origin: .zero, size: size))
            colorLayer.draw(in: CGRect(origin: .zero, size: size))
            outlineImage.draw(in: CGRect(origin: .zero, size: size))
        }
    }

    private func pushHistory() {
        history.append(colorLayer)
        if history.count > maxHistory {
            history.removeFirst(history.count - maxHistory)
        }
        canUndo = true
    }

    private static func blankImage(size: CGSize) -> UIImage {
        let format = UIGraphicsImageRendererFormat()
        format.opaque = false
        format.scale = 1
        let renderer = UIGraphicsImageRenderer(size: size, format: format)
        return renderer.image { ctx in
            ctx.cgContext.clear(CGRect(origin: .zero, size: size))
        }
    }
}

struct ColoringCanvasView: View {
    @ObservedObject var controller: ColoringCanvasController
    @State private var isBrushing = false

    var body: some View {
        GeometryReader { geo in
            ZStack {
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.12), radius: 16, y: 8)

                if let image = controller.displayImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        .padding(12)
                }
            }
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        let size = geo.size
                        if controller.tool == .brush {
                            let began = !isBrushing
                            isBrushing = true
                            controller.handleBrushMoved(to: value.location, in: size, began: began)
                        }
                    }
                    .onEnded { value in
                        let size = geo.size
                        if controller.tool == .fill {
                            controller.handleTap(at: value.location, in: size)
                        }
                        isBrushing = false
                    }
            )
        }
    }
}
