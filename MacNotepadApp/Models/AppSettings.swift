import SwiftUI
import AppKit

// MARK: - App Settings Manager
@MainActor
class AppSettings: ObservableObject {
    // MARK: - Published Properties
    @Published var fontSize: CGFloat
    @Published var fontName: String
    @Published var textColor: NSColor
    @Published var backgroundColor: NSColor
    @Published var selectedThemeId: String?
    @Published var textMargin: CGFloat  // 文本边距（左右）
    @Published var tabWidth: Int
    @Published var lineEnding: String
    @Published var defaultEncoding: String.Encoding

    // MARK: - UserDefaults Keys
    private enum Keys {
        static let fontSize = "fontSize"
        static let fontName = "fontName"
        static let textColor = "textColor"
        static let backgroundColor = "backgroundColor"
        static let selectedThemeId = "selectedThemeId"
        static let textMargin = "textMargin"
        static let tabWidth = "tabWidth"
        static let lineEnding = "lineEnding"
        static let defaultEncoding = "defaultEncoding"
    }

    // MARK: - Defaults
    static let defaultFontSize: CGFloat = 13
    static let defaultFontName = "Menlo"
    static let defaultTextColor = NSColor.textColor
    static let defaultBackgroundColor = NSColor.white
    static let defaultTextMargin: CGFloat = 8
    static let defaultTabWidth = 4
    static let defaultLineEnding = "lf"
    static let defaultEncoding = String.Encoding.utf8

    // MARK: - Singleton
    static let shared = AppSettings()

    private init() {
        // 读取保存的设置
        self.fontSize = UserDefaults.standard.object(forKey: Keys.fontSize) as? CGFloat ?? AppSettings.defaultFontSize
        self.fontName = UserDefaults.standard.string(forKey: Keys.fontName) ?? AppSettings.defaultFontName

        let tabWidthValue = UserDefaults.standard.integer(forKey: Keys.tabWidth)
        self.tabWidth = tabWidthValue == 0 ? AppSettings.defaultTabWidth : tabWidthValue

        self.lineEnding = UserDefaults.standard.string(forKey: Keys.lineEnding) ?? AppSettings.defaultLineEnding

        let encodingValue = UserDefaults.standard.integer(forKey: Keys.defaultEncoding)
        self.defaultEncoding = String.Encoding(rawValue: UInt(encodingValue)) ?? AppSettings.defaultEncoding

        self.selectedThemeId = UserDefaults.standard.string(forKey: Keys.selectedThemeId)

        self.textMargin = UserDefaults.standard.object(forKey: Keys.textMargin) as? CGFloat ?? AppSettings.defaultTextMargin

        // 读取颜色
        if let textColorData = UserDefaults.standard.data(forKey: Keys.textColor),
           let textColor = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NSColor.self, from: textColorData) {
            self.textColor = textColor
        } else {
            self.textColor = AppSettings.defaultTextColor
        }

        if let bgColorData = UserDefaults.standard.data(forKey: Keys.backgroundColor),
           let bgColor = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NSColor.self, from: bgColorData) {
            self.backgroundColor = bgColor
        } else {
            self.backgroundColor = AppSettings.defaultBackgroundColor
        }
    }

    // MARK: - Save Methods
    func saveFontSize(_ size: CGFloat) {
        fontSize = size
        UserDefaults.standard.set(size, forKey: Keys.fontSize)
    }

    func saveFontName(_ name: String) {
        fontName = name
        UserDefaults.standard.set(name, forKey: Keys.fontName)
    }

    func saveTextColor(_ color: NSColor) {
        textColor = color
        if let data = try? NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false) {
            UserDefaults.standard.set(data, forKey: Keys.textColor)
        }
    }

    func saveBackgroundColor(_ color: NSColor) {
        backgroundColor = color
        if let data = try? NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false) {
            UserDefaults.standard.set(data, forKey: Keys.backgroundColor)
        }
    }

    func saveSelectedThemeId(_ themeId: String?) {
        selectedThemeId = themeId
        UserDefaults.standard.set(themeId, forKey: Keys.selectedThemeId)
    }

    func saveTextMargin(_ margin: CGFloat) {
        textMargin = margin
        UserDefaults.standard.set(margin, forKey: Keys.textMargin)
    }

    func saveTabWidth(_ width: Int) {
        tabWidth = width
        UserDefaults.standard.set(width, forKey: Keys.tabWidth)
    }

    func saveLineEnding(_ ending: String) {
        lineEnding = ending
        UserDefaults.standard.set(ending, forKey: Keys.lineEnding)
    }

    func saveDefaultEncoding(_ encoding: String.Encoding) {
        defaultEncoding = encoding
        UserDefaults.standard.set(encoding.rawValue, forKey: Keys.defaultEncoding)
    }

    // MARK: - Apply Theme
    func applyTheme(_ theme: ColorTheme) {
        saveBackgroundColor(theme.backgroundColor)
        saveTextColor(theme.textColor)
        saveSelectedThemeId(theme.id)
    }

    // MARK: - Reset to Defaults
    func resetToDefaults() {
        saveFontSize(AppSettings.defaultFontSize)
        saveFontName(AppSettings.defaultFontName)
        saveTextColor(AppSettings.defaultTextColor)
        saveBackgroundColor(AppSettings.defaultBackgroundColor)
        saveSelectedThemeId(nil)
        saveTextMargin(AppSettings.defaultTextMargin)
        saveTabWidth(AppSettings.defaultTabWidth)
        saveLineEnding(AppSettings.defaultLineEnding)
        saveDefaultEncoding(AppSettings.defaultEncoding)
    }
}
