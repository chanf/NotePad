#!/usr/bin/env swift
import Cocoa

func createNotepadIcon(size: CGFloat) -> NSImage {
    let rect = NSRect(x: 0, y: 0, width: size, height: size)
    let image = NSImage(size: rect.size)

    image.lockFocus()
    defer { image.unlockFocus() }

    guard let context = NSGraphicsContext.current?.graphicsContext else {
        return image
    }

    // 清除背景
    context.clear(rect)

    // 阴影
    let shadowPath = NSBezierPath(roundedRect: NSRect(x: size * 0.1 + 4, y: size * 0.1 + 4, width: size * 0.8, height: size * 0.8), xRadius: size * 0.06, yRadius: size * 0.06)
    NSColor.black.withAlphaComponent(0.2).set()
    shadowPath.fill()

    // 白色记事本背景
    let notebookPath = NSBezierPath(roundedRect: NSRect(x: size * 0.1, y: size * 0.1, width: size * 0.8, height: size * 0.8), xRadius: size * 0.06, yRadius: size * 0.06)
    NSColor.white.set()
    notebookPath.fill()

    // 灰色边框
    notebookPath.lineWidth = size * 0.01
    NSColor.gray.withAlphaComponent(0.3).set()
    notebookPath.stroke()

    // 装订线（左侧）
    let spinePath = NSBezierPath(rect: NSRect(x: size * 0.12, y: size * 0.15, width: size * 0.015, height: size * 0.7))
    NSColor.gray.withAlphaComponent(0.4).set()
    spinePath.fill()

    // 装订孔
    let holeSize = size * 0.025
    let holeY1 = size * 0.28
    let holeY2 = size * 0.72

    NSColor.gray.withAlphaComponent(0.6).set()
    NSBezierPath(ovalIn: NSRect(x: size * 0.1, y: holeY1 - holeSize/2, width: holeSize, height: holeSize)).fill()
    NSBezierPath(ovalIn: NSRect(x: size * 0.1, y: holeY2 - holeSize/2, width: holeSize, height: holeSize)).fill()

    // 文本行
    let startX = size * 0.22
    let lineHeight = size * 0.025
    let lineSpacing = size * 0.06
    let textWidth = size * 0.45
    let textY = size * 0.25

    NSColor.gray.withAlphaComponent(0.5).set()
    for i in 0..<5 {
        let y = textY + CGFloat(i) * (lineHeight + lineSpacing)
        let line1Width = textWidth
        let line2Width = textWidth * 0.75

        NSBezierPath(rect: NSRect(x: startX, y: y, width: line1Width, height: lineHeight)).fill()
        NSBezierPath(rect: NSRect(x: startX, y: y + lineHeight + size * 0.015, width: line2Width, height: lineHeight)).fill()
    }

    // 蓝色笔（右下角）
    let penX = size * 0.75
    let penY = size * 0.65
    let penWidth = size * 0.025
    let penHeight = size * 0.2
    let penAngle = 15.0 * .pi / 180.0

    context.save()
    context.translate(x: penX, y: penY)
    context.rotate(by: penAngle)

    // 笔杆
    let penPath = NSBezierPath(rect: NSRect(x: -penWidth/2, y: 0, width: penWidth, height: penHeight))
    NSColor.blue.set()
    penPath.fill()

    // 笔尖
    let tipPath = NSBezierPath(rect: NSRect(x: -penWidth, y: penHeight, width: penWidth * 1.5, height: size * 0.025))
    NSColor.blue.withAlphaComponent(0.9).set()
    tipPath.fill()

    // 笔头
    let headPath = NSBezierPath(rect: NSRect(x: -penWidth, y: size * 0.015, width: penWidth * 0.75, height: size * 0.03))
    NSColor.blue.withAlphaComponent(0.8).set()
    headPath.fill()

    context.restore()

    return image
}

// 保存图标
let outputPath = "/Users/feng/Work/tmp/3322/MacNotepadApp/MacNotepadApp/Resources/Assets.xcassets/AppIcon.appiconset/"
let sizes = [16, 32, 128, 256, 512]

print("🎨 Generating Notepad icons...")

for size in sizes {
    // 1x
    let image1x = createNotepadIcon(size: CGFloat(size))
    if let tiffData = image1x.tiffRepresentation,
       let imageRep = NSBitmapImageRep(data: tiffData),
       let pngData = imageRep.representation(using: .png, properties: [:]) {
        let filename = "\(outputPath)icon_\(size)x\(size).png"
        try? pngData.write(to: URL(fileURLWithPath: filename))
    }

    // 2x
    let image2x = createNotepadIcon(size: CGFloat(size * 2))
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
