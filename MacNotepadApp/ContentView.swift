import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    @StateObject private var viewModel = EditorViewModel()
    @State private var showFindReplace = false
    @State private var showPreferences = false
    @State private var showOpenPanel = false
    @State private var showSavePanel = false
    @State private var fontSize: CGFloat = 13
    @State private var fontName: String = "Menlo"
    @State private var textColor: NSColor = .textColor  // 默认文本颜色
    @State private var tabWidth: Int = 4
    @State private var lineEnding: PreferencesPanel.LineEnding = .lf
    @State private var defaultEncoding: String.Encoding = .utf8
    @State private var showUnsavedAlert = false
    @State private var pendingNewDocument = false
    @State private var selectedRange: NSRange = NSRange(location: 0, length: 0)
    @State private var errorMessage: String?

    var body: some View {
        VStack(spacing: 0) {
            // Editor - 直接显示编辑器，无工具栏
            CustomTextEditor(
                text: $viewModel.documentManager.content,
                isModified: $viewModel.documentManager.isModified,
                cursorPosition: $viewModel.cursorPosition,
                selectedRange: $selectedRange,
                font: NSFont(name: fontName, size: fontSize) ?? NSFont.systemFont(ofSize: fontSize),
                textColor: textColor,
                backgroundColor: .white,
                findQuery: viewModel.findQuery,
                caseSensitive: viewModel.caseSensitive
            )

            // Status bar
            StatusBar(
                cursorPosition: viewModel.cursorPosition,
                encoding: viewModel.documentManager.encoding,
                filePath: viewModel.documentManager.currentFile?.path,
                isModified: viewModel.documentManager.isModified
            )
        }
        .sheet(isPresented: $showFindReplace) {
            FindReplacePanel(
                isPresented: $showFindReplace,
                findQuery: $viewModel.findQuery,
                replaceQuery: $viewModel.replaceQuery,
                caseSensitive: $viewModel.caseSensitive,
                matchWholeWord: $viewModel.matchWholeWord,
                onFindNext: { viewModel.findNext() },
                onFindPrevious: { viewModel.findPrevious() },
                onReplace: { },
                onReplaceAll: { viewModel.replaceAll() }
            )
        }
        .sheet(isPresented: $showPreferences) {
            PreferencesPanel(
                isPresented: $showPreferences,
                fontSize: $fontSize,
                fontName: $fontName,
                textColor: $textColor,
                defaultEncoding: $defaultEncoding,
                tabWidth: $tabWidth,
                lineEnding: $lineEnding
            )
        }
        .fileImporter(
            isPresented: $showOpenPanel,
            allowedContentTypes: [.plainText, .text, .html, .json, .xml, .sourceCode],
            allowsMultipleSelection: false
        ) { result in
            if let url = try? result.get().first {
                viewModel.openDocument(url: url)
            }
        }
        .alert("Unsaved Changes", isPresented: $showUnsavedAlert) {
            Button("Save") {
                viewModel.saveDocument()
                if pendingNewDocument {
                    viewModel.newDocument()
                    pendingNewDocument = false
                }
            }
            Button("Don't Save", role: .destructive) {
                if pendingNewDocument {
                    viewModel.newDocument()
                    pendingNewDocument = false
                }
            }
            Button("Cancel", role: .cancel) {
                pendingNewDocument = false
            }
        } message: {
            Text("Do you want to save changes?")
        }
        .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
            Button("OK") {
                viewModel.errorMessage = nil
            }
        } message: {
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
            }
        }
        .fileExporter(
            isPresented: $showSavePanel,
            document: TextDocument(text: viewModel.documentManager.content),
            contentType: .plainText,
            defaultFilename: "untitled.txt"
        ) { result in
            if let url = try? result.get() {
                viewModel.saveDocumentAs(url: url)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .newDocument)) { _ in
            viewModel.newDocument()
        }
        .onReceive(NotificationCenter.default.publisher(for: .saveDocument)) { _ in
            viewModel.saveDocument()
        }
        .onReceive(NotificationCenter.default.publisher(for: .saveAsDocument)) { _ in
            showSavePanel = true
        }
        .onReceive(NotificationCenter.default.publisher(for: .showSavePanel)) { _ in
            showSavePanel = true
        }
        .onReceive(NotificationCenter.default.publisher(for: .showFind)) { _ in
            showFindReplace = true
        }
        .onReceive(NotificationCenter.default.publisher(for: .openDocument)) { _ in
            showOpenPanel = true
        }
        .onReceive(NotificationCenter.default.publisher(for: .showPreferences)) { _ in
            showPreferences = true
        }
    }
}

// Simple TextDocument for file export
struct TextDocument: FileDocument {
    var text: String

    static var readableContentTypes: [UTType] { [.plainText] }

    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents,
              let string = String(data: data, encoding: .utf8) else {
            throw CocoaError(.fileReadCorruptFile)
        }
        self.text = string
    }

    init(text: String) {
        self.text = text
    }

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        guard let data = text.data(using: .utf8) else {
            throw NSError(domain: NSCocoaErrorDomain, code: 513, userInfo: [NSLocalizedDescriptionKey: "Unable to encode text data"])
        }
        return FileWrapper(regularFileWithContents: data)
    }
}
