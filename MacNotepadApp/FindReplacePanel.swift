import SwiftUI

struct FindReplacePanel: View {
    @Binding var isPresented: Bool
    @Binding var findQuery: String
    @Binding var replaceQuery: String
    @Binding var caseSensitive: Bool
    @Binding var matchWholeWord: Bool
    let onFindNext: () -> Void
    let onFindPrevious: () -> Void
    let onReplace: () -> Void
    let onReplaceAll: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Find:")
                    .frame(width: 50, alignment: .leading)
                TextField("", text: $findQuery)
                    .textFieldStyle(.roundedBorder)
            }

            HStack {
                Text("Replace:")
                    .frame(width: 50, alignment: .leading)
                TextField("", text: $replaceQuery)
                    .textFieldStyle(.roundedBorder)
            }

            HStack(spacing: 8) {
                Toggle("Case sensitive", isOn: $caseSensitive)
                Toggle("Match whole word", isOn: $matchWholeWord)
            }

            HStack(spacing: 8) {
                Button("Find Previous") {
                    onFindPrevious()
                }
                Button("Find Next") {
                    onFindNext()
                }
                Button("Replace") {
                    onReplace()
                }
                Button("Replace All") {
                    onReplaceAll()
                }
                Button("Close") {
                    isPresented = false
                }
                .keyboardShortcut(.escape)
            }

            Spacer()
        }
        .padding(16)
        .frame(width: 400, height: 200)
        .background(Color(NSColor.windowBackgroundColor))
    }
}
