#!/usr/bin/env swift
import Cocoa
import SwiftUI

struct IconGeneratorView: View {
    var body: some View {
        ZStack {
            // 背景 - 白色记事本
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)

            // 记事本装订线（左侧）
            Rectangle()
                .fill(Color.gray.opacity(0.4))
                .frame(width: 8, height: 100)

            // 装订孔
            Circle()
                .fill(Color.gray.opacity(0.6))
                .frame(width: 12, height: 12)
                .offset(x: 0, y: -35)

            Circle()
                .fill(Color.gray.opacity(0.6))
                .frame(width: 12, height: 12)
                .offset(x: 0, y: 35)

            // 文本行
            VStack(spacing: 8) {
                ForEach(0..<5) { _ in
                    HStack(spacing: 6) {
                        Rectangle()
                            .fill(Color.gray.opacity(0.5))
                            .frame(width: 80, height: 3)
                        Rectangle()
                            .fill(Color.gray.opacity(0.5))
                            .frame(width: 60, height: 3)
                    }
                }
            }
            .offset(x: 20, y: 0)

            // 笔（蓝色，放在右下角）
            VStack(spacing: 0) {
                Rectangle()
                    .fill(Color.blue)
                    .frame(width: 10, height: 80)
                    .rotation(.degrees(20))
                Rectangle()
                    .fill(Color.blue.opacity(0.9))
                    .frame(width: 16, height: 6)
                    .offset(x: -3)
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.blue.opacity(0.8))
                    .frame(width: 6, height: 12)
                    .offset(x: -3)
            }
            .offset(x: 75, y: 15)
            .shadow(color: .black.opacity(0.2), radius: 2, x: 1, y: 1)
        }
        .frame(width: 512, height: 512)
        .background(Color.clear)
    }
}

// 生成图标
let iconSize = CGSize(width: 512, height: 512)
let view = IconGeneratorView().frame(width: iconSize.width, height: iconSize.height)

let hostingView = NSHostingView(rootView: view)
hostingView.frame = NSRect(origin: .zero, size: iconSize)

// 生成图片
let bitmapRep = NSBitmapImageRep(bitmapDataPrimitives: false)
let size = iconSize
bitmapRep.size = size
bitmapRep.pixelsWide = Int(size.width)
bitmapRep.pixelsHigh = Int(size.height)
bitmapRep.bitsPerSample = 8
bitmapRep.samplesPerPixel = 4
bitmapRep.hasAlpha = true

let context = NSGraphicsContext(bitmapImageRep: bitmapRep)
context?.graphicsContext.setShouldAntialias(true)
hostingView.display(in: context!.graphicsContext, dirtyRect: NSRect(origin: .zero, size: iconSize))

let image = NSImage(size: iconSize)
image.addRepresentation(bitmapRep)

// 保存不同尺寸的图标
let outputPath = "/Users/feng/Work/tmp/3322/MacNotepadApp/MacNotepadApp/Resources/Assets.xcassets/AppIcon.appiconset/"

let sizes = [16, 32, 128, 256, 512]

for size in sizes {
    // 生成 1x 图标
    let targetSize = NSSize(width: size, height: size)
    let scaledImage = NSImage(size: targetSize)
    scaledImage.lockFocus()
    scaledImage.draw(in: NSRect(origin: .zero, size: targetSize), from: NSRect(origin: .zero, size: iconSize))
    scaledImage.unlockFocus()

    if let tiffData = scaledImage.tiffRepresentation,
       let imageRep = NSBitmapImageRep(data: tiffData),
       let pngData = imageRep.representation(using: .png, properties: [:]) {
        let filename = "\(outputPath)icon_\(size)x\(size).png"
        try? pngData.write(to: URL(fileURLWithPath: filename))
        print("Generated: icon_\(size)x\(size).png")
    }

    // 生成 2x 图标
    let size2x = size * 2
    let targetSize2x = NSSize(width: size2x, height: size2x)
    let scaledImage2x = NSImage(size: targetSize2x)
    scaledImage2x.lockFocus()
    scaledImage2x.draw(in: NSRect(origin: .zero, size: targetSize2x), from: NSRect(origin: .zero, size: iconSize))
    scaledImage2x.unlockFocus()

    if let tiffData = scaledImage2x.tiffRepresentation,
       let imageRep = NSBitmapImageRep(data: tiffData),
       let pngData = imageRep.representation(using: .png, properties: [:]) {
        let filename = "\(outputPath)icon_\(size)x\(size)@2x.png"
        try? pngData.write(to: URL(fileURLWithPath: filename))
        print("Generated: icon_\(size)x\(size)@2x.png")
    }
}

print("\n✅ Icons generated successfully!")
print("Location: \(outputPath)")
