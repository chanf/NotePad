import SwiftUI

struct PreferencesPanel: View {
    @Binding var isPresented: Bool
    @Binding var fontSize: CGFloat
    @Binding var fontName: String
    @Binding var textColor: NSColor
    @Binding var backgroundColor: NSColor
    @Binding var selectedTheme: ColorTheme?
    @Binding var textMargin: CGFloat
    @Binding var defaultEncoding: String.Encoding
    @Binding var tabWidth: Int
    @Binding var lineEnding: LineEnding

    @State private var showMoreThemes = false

    enum LineEnding: String, CaseIterable {
        case lf = "LF"
        case crlf = "CRLF"
        case cr = "CR"
    }

    var body: some View {
        VStack(spacing: 16) {
            Text("Preferences")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)

            Divider()

            VStack(alignment: .leading, spacing: 8) {
                Text("Font")
                    .font(.subheadline)
                    .bold()

                HStack {
                    Text("Size:")
                    Slider(value: $fontSize, in: 9...72, step: 1)
                    Text("\(Int(fontSize))pt")
                        .frame(width: 40)
                }

                HStack {
                    Text("Color:")
                    ColorPicker("", selection: Binding(
                        get: { Color(textColor) },
                        set: { textColor = NSColor($0) }
                    ))
                    .frame(width: 40)
                }
            }

            Divider()

            VStack(alignment: .leading, spacing: 8) {
                Text("Editor")
                    .font(.subheadline)
                    .bold()

                // 背景颜色设置
                VStack(alignment: .leading, spacing: 8) {
                    Text("Background:")
                        .frame(maxWidth: .infinity, alignment: .leading)

                    // 常用主题网格
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 40), spacing: 8)], spacing: 8) {
                        ForEach(ColorTheme.popularThemes) { theme in
                            ThemeColorButton(
                                theme: theme,
                                isSelected: selectedTheme?.id == theme.id,
                                onTap: {
                                    selectedTheme = theme
                                    backgroundColor = theme.backgroundColor
                                    textColor = theme.textColor
                                }
                            )
                        }
                    }

                    // 更多主题和自定义
                    DisclosureGroup("More Themes & Custom") {
                        VStack(alignment: .leading, spacing: 8) {
                            // 更多主题下拉菜单
                            Picker("All Themes:", selection: Binding(
                                get: { selectedTheme?.id ?? "" },
                                set: { newValue in
                                    if let theme = ColorTheme.presetThemes.first(where: { $0.id == newValue }) {
                                        selectedTheme = theme
                                        backgroundColor = theme.backgroundColor
                                        textColor = theme.textColor
                                    }
                                }
                            )) {
                                Text("None").tag("")
                                ForEach(ColorTheme.presetThemes) { theme in
                                    Text(theme.name).tag(theme.id)
                                }
                            }

                            // 自定义颜色
                            HStack {
                                Text("Custom:")
                                    .frame(width: 70, alignment: .leading)
                                VStack(alignment: .leading, spacing: 4) {
                                    HStack {
                                        Text("BG:")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                        ColorPicker("", selection: Binding(
                                            get: { Color(backgroundColor) },
                                            set: {
                                                backgroundColor = NSColor($0)
                                                selectedTheme = nil
                                            }
                                        ))
                                        .frame(width: 30)
                                    }
                                    HStack {
                                        Text("Text:")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                        ColorPicker("", selection: Binding(
                                            get: { Color(textColor) },
                                            set: {
                                                textColor = NSColor($0)
                                                selectedTheme = nil
                                            }
                                        ))
                                        .frame(width: 30)
                                    }
                                }
                            }
                        }
                        .padding(.leading, 8)
                    }
                }

                // Tab width
                HStack {
                    Text("Tab width:")
                    Stepper("\(tabWidth)", value: $tabWidth, in: 1...8)
                }

                // Text margin
                HStack {
                    Text("Margin:")
                    Slider(value: $textMargin, in: 0...50, step: 2)
                    Text("\(Int(textMargin))pt")
                        .frame(width: 40)
                }

                // Line ending
                Picker("Line ending:", selection: $lineEnding) {
                    ForEach(LineEnding.allCases, id: \.self) { ending in
                        Text(ending.rawValue).tag(ending)
                    }
                }
            }

            Divider()

            HStack {
                Spacer()
                Button("Close") {
                    isPresented = false
                }
                .keyboardShortcut(.escape)
            }
        }
        .padding(20)
        .frame(width: 350)
        .background(Color(NSColor.windowBackgroundColor))
    }
}
