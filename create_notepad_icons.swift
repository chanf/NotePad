#!/usr/bin/env swift
import Cocoa

func createNotepadIcon(size: Int) -> NSImage {
    let cgSize = CGSize(width: size, height: size)
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue

    guard let context = CGContext(data: nil,
                                    width: size,
                                    height: size,
                                    bitsPerComponent: 8,
                                    bytesPerRow: 0,
                                    space: colorSpace,
                                    bitmapInfo: bitmapInfo,
                                    renderer: nil) else {
        return NSImage()
    }

    // 清除背景（透明）
    context.clear(CGRect(origin: .zero, size: cgSize))

    let s = CGFloat(size)

    // 阴影
    let shadowRect = CGRect(x: s * 0.1 + 4, y: s * 0.1 + 4, width: s * 0.8, height: s * 0.8)
    context.setShadow(offset: CGSize(width: 0, height: -2), blur: 3, color: NSColor.black.withAlphaComponent(0.2).cgColor)
    context.setFillColor(NSColor.white.cgColor)
    context.fill(shadowRect)
    context.setShadow(offset: .zero, blur: 0, color: nil)

    // 白色记事本背景
    let notebookRect = CGRect(x: s * 0.1, y: s * 0.1, width: s * 0.8, height: s * 0.8)
    context.setFillColor(NSColor.white.cgColor)
    context.fill(notebookRect)

    // 圆角边框
    context.setStrokeColor(NSColor.gray.withAlphaComponent(0.3).cgColor)
    context.setLineWidth(s * 0.01)
    let path = CGPath(roundedRect: notebookRect, cornerWidth: s * 0.06, cornerHeight: s * 0.06, transform: nil)
    context.addPath(path)
    context.strokePath()

    // 装订线（左侧）
    let spineRect = CGRect(x: s * 0.12, y: s * 0.15, width: s * 0.015, height: s * 0.7)
    context.setFillColor(NSColor.gray.withAlphaComponent(0.4).cgColor)
    context.fill(spineRect)

    // 装订孔
    let holeSize = s * 0.025
    context.setFillColor(NSColor.gray.withAlphaComponent(0.6).cgColor)
    context.fillEllipse(in: CGRect(x: s * 0.1, y: s * 0.28 - holeSize/2, width: holeSize, height: holeSize))
    context.fillEllipse(in: CGRect(x: s * 0.1, y: s * 0.72 - holeSize/2, width: holeSize, height: holeSize))

    // 文本行
    let startX = s * 0.22
    let lineHeight = s * 0.025
    let lineSpacing = s * 0.06
    let textWidth = s * 0.45
    let textY = s * 0.25

    context.setFillColor(NSColor.gray.withAlphaComponent(0.5).cgColor)
    for i in 0..<5 {
        let y = textY + CGFloat(i) * (lineHeight + lineSpacing)

        // 第一行
        context.fill(CGRect(x: startX, y: y, width: textWidth, height: lineHeight))

        // 第二行
        context.fill(CGRect(x: startX, y: y + lineHeight + s * 0.015, width: textWidth * 0.75, height: lineHeight))
    }

    // 蓝色笔
    let penX = s * 0.75
    let penY = s * 0.65
    let penWidth = s * 0.025
    let penHeight = s * 0.2

    context.save()
    context.translateBy(x: penX, y: penY)
    context.rotate(by: 15.0 * .pi / 180.0)

    // 笔杆
    context.setFillColor(NSColor.blue.cgColor)
    context.fill(CGRect(x: -penWidth/2, y: 0, width: penWidth, height: penHeight))

    // 笔尖
    context.setFillColor(NSColor.blue.withAlphaComponent(0.9).cgColor)
    context.fill(CGRect(x: -penWidth, y: penHeight, width: penWidth * 1.5, height: s * 0.025))

    // 笔头
    context.setFillColor(NSColor.blue.withAlphaComponent(0.8).cgColor)
    context.fill(CGRect(x: -penWidth, y: s * 0.015, width: penWidth * 0.75, height: s * 0.03))

    context.restore()

    // 创建图像
    guard let cgImage = context.makeImage() else {
        return NSImage()
    }

    return NSImage(cgImage: cgImage, size: cgSize)
}

// 保存图标
let outputPath = "/Users/feng/Work/tmp/3322/MacNotepadApp/MacNotepadApp/Resources/Assets.xcassets/AppIcon.appiconset/"
let sizes = [16, 32, 128, 256, 512]

print("🎨 Generating Notepad icons...")

for size in sizes {
    // 1x
    let image1x = createNotepadIcon(size: size)
    if let tiffData = image1x.tiffRepresentation,
       let imageRep = NSBitmapImageRep(data: tiffData),
       let pngData = imageRep.representation(using: .png, properties: [:]) {
        let filename = "\(outputPath)icon_\(size)x\(size).png"
        try? pngData.write(to: URL(fileURLWithPath: filename))
    }

    // 2x
    let image2x = createNotepadIcon(size: size * 2)
    if let tiffData = image2x.tiffRepresentation,
       let imageRep = NSBitmapImageRep(data: tiffData),
       let pngData = imageRep.representation(using: .png, properties: [:]) {
        let filename = "\(outputPath)icon_\(size)x\(size)@2x.png"
        try? pngData.write(to: URL(fileURLWithPath: filename))
    }

    print("  ✓ \(size)x\(size)")
}

print("\n✅ Icons generated successfully!")
print("📁 Location: \(outputPath)")
