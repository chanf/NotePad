import SwiftUI
import AppKit

struct IconGenerator: View {
    var body: some View {
        ZStack {
            // 背景
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 1)

            // 记事本装订线（左侧）
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 4, height: 80)

            // 装订孔
            Circle()
                .fill(Color.gray.opacity(0.5))
                .frame(width: 8, height: 8)
                .offset(x: 0, y: -28)

            Circle()
                .fill(Color.gray.opacity(0.5))
                .frame(width: 8, height: 8)
                .offset(x: 0, y: 28)

            // 文本行
            VStack(spacing: 6) {
                ForEach(0..<5) { _ in
                    HStack(spacing: 4) {
                        Rectangle()
                            .fill(Color.gray.opacity(0.4))
                            .frame(width: 50, height: 2)
                        Rectangle()
                            .fill(Color.gray.opacity(0.4))
                            .frame(width: 40, height: 2)
                    }
                }
            }
            .offset(x: 12, y: 0)

            // 笔（蓝色，放在右侧）
            VStack(spacing: 0) {
                Rectangle()
                    .fill(Color.blue)
                    .frame(width: 6, height: 60)
                    .rotation(.degrees(15))
                Rectangle()
                    .fill(Color.blue.opacity(0.8))
                    .frame(width: 10, height: 4)
                    .offset(x: -2)
                RoundedRectangle(cornerRadius: 1)
                    .fill(Color.blue.opacity(0.7))
                    .frame(width: 4, height: 8)
                    .offset(x: -2)
            }
            .offset(x: 50, y: 10)
            .shadow(color: .black.opacity(0.2), radius: 1, x: 0, y: 1)
        }
        .frame(width: 128, height: 128)
        .background(Color.clear)
    }
}

// 生成图标
let iconSize = CGSize(width: 512, height: 512)
let view = IconGenerator()
            .frame(width: iconSize.width, height: iconSize.height)

let hostingView = NSHostingView(rootView: view)
hostingView.frame = NSRect(origin: .zero, size: iconSize)

let bitmapRep = hostingView.bitmapImageRepForCachingDisplay(in: NSRect(origin: .zero, size: iconSize))!
hostingView.cacheDisplay(in: NSRect(origin: .zero, size: iconSize), to: bitmapRep)

let image = NSImage(size: iconSize)
image.addRepresentation(bitmapRep)

// 保存不同尺寸的图标
let sizes = [16, 32, 128, 256, 512]
let outputPath = "/Users/feng/Work/tmp/3322/MacNotepadApp/MacNotepadApp/Resources/Assets.xcassets/AppIcon.appiconset/"

for size in sizes {
    let scaledImage = NSImage(size: NSSize(width: size, height: size))
    scaledImage.lockFocus()
    scaledImage.setSize(NSSize(width: size, height: size))
    scaledImage.draw(in: NSRect(origin: .zero, size: NSSize(width: size, height: size)), from: NSRect(origin: .zero, size: iconSize))
    scaledImage.unlockFocus()

    if let tiffData = scaledImage.tiffRepresentation,
       let imageRep = NSBitmapImageRep(data: tiffData),
       let pngData = imageRep.representation(using: .png, properties: [:]) {
        let filename = "\(outputPath)icon_\(size)x\(size).png"
        try? pngData.write(to: URL(fileURLWithPath: filename))
    }

    // @2x 版本
    let size2x = size * 2
    let scaledImage2x = NSImage(size: NSSize(width: size2x, height: size2x))
    scaledImage2x.lockFocus()
    scaledImage2x.draw(in: NSRect(origin: .zero, size: NSSize(width: size2x, height: size2x)), from: NSRect(origin: .zero, size: iconSize))
    scaledImage2x.unlockFocus()

    if let tiffData = scaledImage2x.tiffRepresentation,
       let imageRep = NSBitmapImageRep(data: tiffData),
       let pngData = imageRep.representation(using: .png, properties: [:]) {
        let filename = "\(outputPath)icon_\(size)x\(size)@2x.png"
        try? pngData.write(to: URL(fileURLWithPath: filename))
    }
}

print("Icons generated successfully!")
