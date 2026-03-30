# AGENTS.md - MacNotepadApp 开发指南

## 项目概述

macOS 原生记事本应用，使用 SwiftUI + AppKit 构建，基于 Swift Package Manager 管理。
- 语言：Swift（swift-tools-version: 5.9）
- 最低平台：macOS 13.0+
- IDE：Xcode 15+
- UI 框架：SwiftUI + NSViewRepresentable（桥接 AppKit NSTextView）

## 构建/测试/运行命令

### 构建
```bash
# SPM 构建（命令行可执行文件，非 .app 包）
swift build

# Release 构建 + 打包为 .app（推荐）
bash build.sh

# 构建后运行
open Notepad.app
```

### 测试
```bash
# 运行全部测试
swift test

# 运行单个测试文件（使用 --filter 匹配测试类名）
swift test --filter DocumentManagerTests
swift test --filter EditorViewModelTests

# 运行单个测试方法
swift test --filter DocumentManagerTests/testInitialState
swift test --filter EditorViewModelTests/testToggleFindReplace

# Release 模式测试
swift test -c release
```

### 类型检查
```bash
swift build 2>&1 | head -50
```

本项目无专门的 lint 工具，依赖 Swift 编译器进行类型检查和代码校验。

## 项目结构

```
MacNotepadApp/               # 源代码（executableTarget）
├── MacNotepadApp.swift      # App 入口 + Notification.Name 扩展
├── AppDelegate.swift        # NSApplicationDelegate，窗口管理
├── ContentView.swift        # 主视图 + TextDocument（FileDocument）
├── FindReplacePanel.swift   # 查找替换面板（Sheet）
├── PreferencesPanel.swift   # 设置面板（Sheet）
├── SimpleTest.swift         # 简易文本编辑器（备用组件）
├── ViewModels/
│   └── EditorViewModel.swift    # 编辑器视图模型（ObservableObject）
├── Models/
│   └── DocumentManager.swift    # 文档管理 + DocumentError 枚举
└── Components/
    ├── CustomTextEditor.swift   # NSTextView 的 NSViewRepresentable 包装
    └── StatusBar.swift          # 状态栏组件

MacNotepadAppTests/          # 单元测试
├── DocumentManagerTests.swift
└── EditorViewModelTests.swift
```

## 代码风格规范

### 导入
- 按框架分组，顺序：SwiftUI → AppKit/Cocoa → Foundation → 其他
- 测试文件：`import XCTest` 然后 `@testable import MacNotepadApp`
- 不要导入未使用的模块

### 命名约定
- **类型（Struct/Class/Enum）**：大驼峰（PascalCase）—— `EditorViewModel`、`DocumentManager`、`DocumentError`
- **函数/方法**：小驼峰（camelCase）—— `findNext()`、`openDocument(url:)`
- **变量/属性**：小驼峰 —— `findQuery`、`cursorPosition`
- **通知名**：静态属性放在 `Notification.Name` 扩展中，使用驼峰 —— `.saveDocument`、`.showFind`
- **枚举 case**：小驼峰 —— `.noFileSelected`、`.lf`
- **文件名**：与主类型名一致 —— `EditorViewModel.swift`、`StatusBar.swift`

### 格式化
- 缩进：4 个空格（非 Tab）
- 行宽：尽量控制在合理范围内，无严格限制
- 大括号：Allman 风格（`{` 不换行），与 K&R 一致
- `MARK` 注解使用 `// MARK: - Section Name` 格式
- 代码中的注释使用中文

### SwiftUI 视图结构
- View 结构体作为视图定义
- `@StateObject` 用于创建 ObservableObject
- `@State` 用于视图本地状态
- `@Binding` 用于父子视图间的双向绑定
- `@Published` 用于 ObservableObject 的可观察属性
- Sheet 使用 `.sheet(isPresented:)` 修饰符
- 事件传递使用 `NotificationCenter.default.publisher(for:)` + `.onReceive`

### NSViewRepresentable 模式
- 必须实现 `makeNSView`、`updateNSView`、`makeCoordinator`
- 使用 Coordinator 模式处理 AppKit 委托回调
- 使用 `isUpdatingText` 标志防止循环更新
- `textView` 引用使用 `weak var` 避免循环引用

### 错误处理
- 自定义错误使用枚举并遵循 `Error` + `LocalizedError`
- 提供 `errorDescription` 计算属性
- 使用 `do/try/catch` 处理文件操作
- 错误信息通过 `@Published var errorMessage: String?` 传递到 UI 层

### 测试约定
- 继承 `XCTestCase`
- 使用 `setUp()` 初始化被测对象
- 测试方法以 `test` 开头 —— `testInitialState`、`testNewDocument`
- 使用 `XCTAssert*` 系列断言：`XCTAssertEqual`、`XCTAssertTrue`、`XCTAssertNil` 等
- 每个测试类对应一个源文件，测试类名加 `Tests` 后缀

## 应用图标

图标源文件：`notepad.webp`（200x200）
图标文件：`Notepad.icns`（由 webp 转换生成）

重新生成图标：
```bash
sips -s format png notepad.webp --out /tmp/notepad_icon.png
# 生成 iconset 并转换为 icns（需包含 16/32/128/256/512 及 @2x 尺寸）
iconutil -c icns /tmp/Notepad.iconset -o Notepad.icns
```

build.sh 会自动将 `Notepad.icns` 复制到 `Notepad.app/Contents/Resources/`，
Info.plist 中 `CFBundleIconFile` 已设置为 `Notepad`。

## 注意事项

- 不要修改 `.gitignore` 中忽略的文件（`.build/`、`*.icns`、`*.app/` 等）
- `Package.swift` 的 `exclude` 包含 `Resources/Info.plist` 和 `Resources`，资源仅通过 `.process("Resources/Assets.xcassets")` 引入
- 编辑器核心基于 AppKit 的 `NSTextView`，不是 SwiftUI 的 `TextEditor`
- 文件编码自动检测顺序：UTF-8 → UTF-16 LE → ASCII → 默认 UTF-8
- 窗口关闭后应用会退出（`applicationShouldTerminateAfterLastWindowClosed` 返回 `true`）
