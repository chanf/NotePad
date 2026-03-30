import SwiftUI
import AppKit

// MARK: - Color Theme Model
struct ColorTheme: Identifiable, Hashable {
    let id: String
    let name: String
    let backgroundColor: NSColor
    let textColor: NSColor
    let category: ThemeCategory

    enum ThemeCategory: String, CaseIterable {
        case classic = "Classic"
        case modern = "Modern"
        case terminal = "Terminal"
    }

    // 预设主题
    static let presetThemes: [ColorTheme] = [
        // Classic - 经典编辑器配色
        ColorTheme(id: "light", name: "Light", backgroundColor: .white, textColor: .textColor, category: .classic),
        ColorTheme(id: "sepia", name: "Sepia", backgroundColor: NSColor(red: 0.96, green: 0.94, blue: 0.86, alpha: 1.0), textColor: .textColor, category: .classic),

        // Modern - 现代暗色主题
        ColorTheme(id: "dark", name: "Dark", backgroundColor: NSColor(white: 0.15, alpha: 1.0), textColor: .white, category: .modern),
        ColorTheme(id: "dim", name: "Dim", backgroundColor: NSColor(white: 0.2, alpha: 1.0), textColor: NSColor(white: 0.9, alpha: 1.0), category: .modern),

        // Terminal - 经典终端配色
        ColorTheme(id: "terminal_black", name: "Terminal Black", backgroundColor: .black, textColor: .green, category: .terminal),
        ColorTheme(id: "solarized_dark", name: "Solarized Dark", backgroundColor: NSColor(red: 0.0, green: 0.16, blue: 0.21, alpha: 1.0), textColor: NSColor(red: 0.51, green: 0.58, blue: 0.58, alpha: 1.0), category: .terminal),
        ColorTheme(id: "monokai", name: "Monokai", backgroundColor: NSColor(red: 0.15, green: 0.15, blue: 0.16, alpha: 1.0), textColor: NSColor(red: 0.97, green: 0.97, blue: 0.95, alpha: 1.0), category: .terminal),
        ColorTheme(id: "dracula", name: "Dracula", backgroundColor: NSColor(red: 0.16, green: 0.14, blue: 0.19, alpha: 1.0), textColor: NSColor(red: 0.98, green: 0.96, blue: 0.96, alpha: 1.0), category: .terminal),
        ColorTheme(id: "nord", name: "Nord", backgroundColor: NSColor(red: 0.16, green: 0.17, blue: 0.21, alpha: 1.0), textColor: NSColor(red: 0.93, green: 0.94, blue: 0.95, alpha: 1.0), category: .terminal),
        ColorTheme(id: "github_dark", name: "GitHub Dark", backgroundColor: NSColor(red: 0.13, green: 0.13, blue: 0.15, alpha: 1.0), textColor: NSColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1.0), category: .terminal),
    ]

    // 常用主题（用于网格显示）
    static let popularThemes: [ColorTheme] = [
        presetThemes[0], // Light
        presetThemes[2], // Dark
        presetThemes[4], // Terminal Black
        presetThemes[5], // Solarized Dark
    ]
}

// MARK: - Theme Color Button Component
struct ThemeColorButton: View {
    let theme: ColorTheme
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            ZStack {
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color(theme.backgroundColor))
                    .frame(width: 36, height: 36)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color(theme.textColor), lineWidth: 1)
                    )

                if isSelected {
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.accentColor, lineWidth: 2)
                        .frame(width: 40, height: 40)
                }
            }
        }
        .buttonStyle(.plain)
        .help(theme.name)
    }
}

// MARK: - Color Extensions
extension NSColor {
    var luminance: CGFloat {
        // 使用 colorSpace 确保在正确的颜色空间中获取分量
        let color = usingColorSpace(.deviceRGB) ?? self
        let r = color.redComponent
        let g = color.greenComponent
        let b = color.blueComponent
        return 0.299 * r + 0.587 * g + 0.114 * b
    }
}
