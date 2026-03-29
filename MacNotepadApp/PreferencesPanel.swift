import SwiftUI

struct PreferencesPanel: View {
    @Binding var isPresented: Bool
    @Binding var fontSize: CGFloat
    @Binding var fontName: String
    @Binding var textColor: NSColor
    @Binding var defaultEncoding: String.Encoding
    @Binding var tabWidth: Int
    @Binding var lineEnding: LineEnding

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

                HStack {
                    Text("Tab width:")
                    Stepper("\(tabWidth)", value: $tabWidth, in: 1...8)
                }

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
