import SwiftUI

struct StatusBar: View {
    var cursorPosition: (line: Int, column: Int)
    var encoding: String.Encoding
    var filePath: String?
    var isModified: Bool

    var encodingName: String {
        switch encoding {
        case .utf8: return "UTF-8"
        case .utf16LittleEndian: return "UTF-16 LE"
        case .ascii: return "ASCII"
        default: return "UTF-8"
        }
    }

    var body: some View {
        HStack(spacing: 16) {
            HStack(spacing: 4) {
                Text("Ln \(cursorPosition.line)")
                Text("Col \(cursorPosition.column)")
            }
            .font(.system(size: 11))

            Divider()
                .frame(height: 12)

            Text(encodingName)
                .font(.system(size: 11))

            if let path = filePath {
                Divider()
                    .frame(height: 12)

                Text((path as NSString).lastPathComponent + (isModified ? " •" : ""))
                    .font(.system(size: 11))
                    .foregroundColor(isModified ? .orange : .primary)
            }

            Spacer()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(Color(NSColor.controlBackgroundColor))
    }
}
