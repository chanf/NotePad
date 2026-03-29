# MacNotepadApp

A native macOS Notepad application built with SwiftUI.

## Features

- Create, open, and save text files
- Find and replace functionality
- Undo/redo support
- Multiple encoding support (UTF-8, UTF-16, ASCII)
- Status bar showing cursor position and file info
- Customizable font and editor settings

## Building

Requires Xcode 15+ and macOS 13.0+

### Option 1: Xcode (Recommended)

1. Create a new macOS App project in Xcode
2. Add all source files from MacNotepadApp/MacNotepadApp/
3. Build and Run (Cmd+R)

### Option 2: Swift Package Manager

```bash
cd MacNotepadApp
swift build
swift run
```

## Usage

- Cmd+N: New document
- Cmd+O: Open file
- Cmd+S: Save
- Cmd+F: Find
- Cmd+Z: Undo
- Cmd+Shift+Z: Redo

## Project Structure

```
MacNotepadApp/
├── MacNotepadApp/           # Main source files
│   ├── MacNotepadApp.swift  # App entry point
│   ├── AppDelegate.swift    # Window management
│   ├── ContentView.swift    # Main view
│   ├── FindReplacePanel.swift
│   ├── PreferencesPanel.swift
│   ├── ViewModels/          # View models
│   ├── Models/              # Data models
│   └── Components/          # UI components
└── MacNotepadAppTests/      # Unit tests
```

## Development Status

- [x] Project structure
- [x] App entry point
- [x] DocumentManager model
- [x] EditorViewModel
- [x] CustomTextEditor component
- [x] StatusBar component
- [x] ContentView with toolbar
- [x] FindReplacePanel
- [x] PreferencesPanel
- [x] Tests
- [x] Build passing
- [x] All tests passing

## License

MIT License
