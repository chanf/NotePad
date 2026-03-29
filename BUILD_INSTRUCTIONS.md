# Building MacNotepadApp

## Option 1: Using Xcode (Recommended)

1. Open Xcode
2. File > New > Project > macOS > App
3. Product Name: MacNotepadApp
4. Interface: SwiftUI
5. Language: Swift
6. Save to: /Users/feng/Work/tmp/3322/MacNotepadApp/
7. Replace the generated ContentView.swift with our implementation
8. Add all files from MacNotepadApp/ directory to the project

## Option 2: Using Swift Package Manager (Limited)

```bash
cd /Users/feng/Work/tmp/3322/MacNotepadApp
swift build
swift run
```

Note: SPM builds command-line executables, not app bundles.

## Features

- Create, open, and save text files
- Find and replace functionality
- Undo/redo support
- Multiple encoding support (UTF-8, UTF-16, ASCII)
- Status bar showing cursor position and file info
- Customizable font and editor settings
