import UIKit

enum FloodFill {
    /// Fills a connected region of similar pixels. Treats near-black pixels as walls (outlines).
    static func fill(
        buffer: inout [UInt8],
        width: Int,
        height: Int,
        startX: Int,
        startY: Int,
        color: UIColor,
        tolerance: Int = 40
    ) {
        guard startX >= 0, startY >= 0, startX < width, startY < height else { return }

        let bytesPerPixel = 4
        let startOffset = (startY * width + startX) * bytesPerPixel

        let sr = Int(buffer[startOffset])
        let sg = Int(buffer[startOffset + 1])
        let sb = Int(buffer[startOffset + 2])
        let sa = Int(buffer[startOffset + 3])

        // Don't fill on outline strokes
        if isOutline(r: sr, g: sg, b: sb, a: sa) { return }

        var cr: CGFloat = 0, cg: CGFloat = 0, cb: CGFloat = 0, ca: CGFloat = 0
        color.getRed(&cr, green: &cg, blue: &cb, alpha: &ca)
        let fr = UInt8(cr * 255)
        let fg = UInt8(cg * 255)
        let fb = UInt8(cb * 255)
        let fa = UInt8(ca * 255)

        // Already that color
        if sr == Int(fr), sg == Int(fg), sb == Int(fb), sa == Int(fa) { return }

        var stack = [(startX, startY)]
        var visited = Set<Int>()
        visited.reserveCapacity(width * height / 8)

        while let (x, y) = stack.popLast() {
            let idx = y * width + x
            if visited.contains(idx) { continue }
            visited.insert(idx)

            let offset = idx * bytesPerPixel
            let r = Int(buffer[offset])
            let g = Int(buffer[offset + 1])
            let b = Int(buffer[offset + 2])
            let a = Int(buffer[offset + 3])

            if isOutline(r: r, g: g, b: b, a: a) { continue }
            if !matches(r: r, g: g, b: b, a: a, tr: sr, tg: sg, tb: sb, ta: sa, tolerance: tolerance) {
                continue
            }

            buffer[offset] = fr
            buffer[offset + 1] = fg
            buffer[offset + 2] = fb
            buffer[offset + 3] = fa

            if x + 1 < width { stack.append((x + 1, y)) }
            if x - 1 >= 0 { stack.append((x - 1, y)) }
            if y + 1 < height { stack.append((x, y + 1)) }
            if y - 1 >= 0 { stack.append((x, y - 1)) }
        }
    }

    private static func isOutline(r: Int, g: Int, b: Int, a: Int) -> Bool {
        a > 200 && r < 50 && g < 50 && b < 50
    }

    private static func matches(
        r: Int, g: Int, b: Int, a: Int,
        tr: Int, tg: Int, tb: Int, ta: Int,
        tolerance: Int
    ) -> Bool {
        abs(r - tr) <= tolerance &&
        abs(g - tg) <= tolerance &&
        abs(b - tb) <= tolerance &&
        abs(a - ta) <= tolerance
    }
}

enum PixelBuffer {
    static func from(_ image: UIImage) -> (pixels: [UInt8], width: Int, height: Int)? {
        guard let cgImage = image.cgImage else { return nil }
        let width = cgImage.width
        let height = cgImage.height
        var pixels = [UInt8](repeating: 0, count: width * height * 4)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        guard let ctx = CGContext(
            data: &pixels,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: width * 4,
            space: colorSpace,
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        ) else { return nil }
        ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        return (pixels, width, height)
    }

    static func image(from pixels: [UInt8], width: Int, height: Int) -> UIImage? {
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        var data = pixels
        guard let ctx = CGContext(
            data: &data,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: width * 4,
            space: colorSpace,
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        ), let cgImage = ctx.makeImage() else { return nil }
        return UIImage(cgImage: cgImage)
    }
}
