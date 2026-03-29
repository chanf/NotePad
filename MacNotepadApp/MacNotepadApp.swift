import SwiftUI

@main
struct MacNotepadApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .commands {
            // File 菜单项 - 替换默认的 Save 项以连接到我们的通知系统
            CommandGroup(replacing: .saveItem) {
                Button("Save") {
                    NotificationCenter.default.post(name: .saveDocument, object: nil)
                }
                .keyboardShortcut("s", modifiers: .command)

                Button("Save As...") {
                    NotificationCenter.default.post(name: .saveAsDocument, object: nil)
                }
                .keyboardShortcut("S", modifiers: [.command, .shift])
            }

            // Open 添加在 New 之后
            CommandGroup(after: .newItem) {
                Button("Open...") {
                    NotificationCenter.default.post(name: .openDocument, object: nil)
                }
                .keyboardShortcut("o", modifiers: .command)
            }

            // Edit 菜单 - 添加 Find 到 Edit 菜单末尾
            CommandGroup(after: .pasteboard) {
                Button("Find...") {
                    NotificationCenter.default.post(name: .showFind, object: nil)
                }
                .keyboardShortcut("f", modifiers: .command)
            }

            // 添加 Settings 到应用菜单
            CommandGroup(after: .appInfo) {
                Button("Settings...") {
                    NotificationCenter.default.post(name: .showPreferences, object: nil)
                }
                .keyboardShortcut(",", modifiers: .command)
            }
        }
    }
}

// Notification names for app-wide events
extension Notification.Name {
    static let openDocument = Notification.Name("openDocument")
    static let newDocument = Notification.Name("newDocument")
    static let saveDocument = Notification.Name("saveDocument")
    static let saveAsDocument = Notification.Name("saveAsDocument")
    static let showSavePanel = Notification.Name("showSavePanel")
    static let showFind = Notification.Name("showFind")
    static let showPreferences = Notification.Name("showPreferences")
}
