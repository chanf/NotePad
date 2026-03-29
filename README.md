# Notepad

使用 SwiftUI 构建的原生 macOS 记事本应用。

## 功能特性

- 创建、打开和保存文本文件
- 查找和替换功能
- 支持撤销/重做
- 支持多种编码格式（UTF-8、UTF-16、ASCII）
- 状态栏显示光标位置和文件信息
- 可自定义字体和编辑器设置

## 构建要求

需要 Xcode 15+ 和 macOS 13.0+

### 方式一：使用构建脚本（推荐）

```bash
bash build.sh
```

构建完成后，会生成 `Notepad.app`，可以直接运行或双击打开。

### 方式二：Swift Package Manager

```bash
swift build
swift run
```

## 使用说明

- Cmd+N: 新建文档
- Cmd+O: 打开文件
- Cmd+S: 保存
- Cmd+Shift+S: 另存为
- Cmd+F: 查找
- Cmd+,: 打开设置

## 项目结构

```
MacNotepadApp/
├── MacNotepadApp/           # 源代码文件
│   ├── MacNotepadApp.swift  # 应用入口
│   ├── AppDelegate.swift    # 窗口管理
│   ├── ContentView.swift    # 主视图
│   ├── FindReplacePanel.swift      # 查找替换面板
│   ├── PreferencesPanel.swift      # 设置面板
│   ├── ViewModels/          # 视图模型
│   ├── Models/              # 数据模型
│   └── Components/          # UI 组件
└── MacNotepadAppTests/      # 单元测试
```

## 开发状态

- [x] 项目结构
- [x] 应用入口
- [x] 文档管理模型
- [x] 编辑器视图模型
- [x] 自定义文本编辑器组件
- [x] 状态栏组件
- [x] 主视图
- [x] 查找替换面板
- [x] 设置面板
- [x] 单元测试
- [x] 构建通过
- [x] 所有测试通过

## 许可证

MIT License
