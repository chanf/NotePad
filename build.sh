#!/bin/bash
# MacNotepadApp 构建脚本

set -e

echo "🔨 构建 MacNotepadApp..."

# 清理旧的构建
echo "🧹 清理旧构建..."
rm -rf .build
rm -rf Notepad.app

# 构建 release 版本
echo "📦 编译 release 版本..."
swift build -c release

# 创建 .app 包结构
echo "📱 创建应用包..."
mkdir -p Notepad.app/Contents/MacOS
mkdir -p Notepad.app/Contents/Resources

# 复制可执行文件
cp .build/arm64-apple-macosx/release/MacNotepadApp Notepad.app/Contents/MacOS/MacNotepadApp
chmod +x Notepad.app/Contents/MacOS/MacNotepadApp

# 创建 Info.plist
cat > Notepad.app/Contents/Info.plist << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>MacNotepadApp</string>
    <key>CFBundleIdentifier</key>
    <string>com.example.Notepad</string>
    <key>CFBundleName</key>
    <string>Notepad</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0</string>
    <key>CFBundleVersion</key>
    <string>1</string>
    <key>LSMinimumSystemVersion</key>
    <string>13.0</string>
    <key>NSPrincipalClass</key>
    <string>NSApplication</string>
    <key>CFBundleIconFile</key>
    <string>Notepad</string>
</dict>
</plist>
EOF

# 复制资源（如果有）
if [ -d "MacNotepadApp/Resources/Assets.xcassets" ]; then
    echo "🎨 复制资源文件..."
    cp -r MacNotepadApp/Resources/Assets.xcassets Notepad.app/Contents/Resources/
fi

# 复制 icon
if [ -f "Notepad.icns" ]; then
    echo "🎨 复制应用图标..."
    cp Notepad.icns Notepad.app/Contents/Resources/
fi

echo "✅ 构建完成！"
echo "📦 应用位置: $(pwd)/Notepad.app"
echo ""
echo "运行方式："
echo "  open Notepad.app"
echo "  或双击 Notepad.app"
