import Foundation
import Combine
import AppKit

class EditorViewModel: ObservableObject {
    @Published var documentManager = DocumentManager()
    @Published var showFindReplace: Bool = false
    @Published var findQuery: String = ""
    @Published var replaceQuery: String = ""
    @Published var caseSensitive: Bool = false
    @Published var matchWholeWord: Bool = false
    @Published var cursorPosition: (line: Int, column: Int) = (1, 1)
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()

    init() {
        setupDocumentObserver()
    }

    private func setupDocumentObserver() {
        documentManager.$content
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }

    // MARK: - Document Operations

    func newDocument() {
        documentManager.new()
    }

    func openDocument(url: URL) {
        do {
            try documentManager.open(url: url)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func saveDocument() {
        do {
            try documentManager.save()
        } catch DocumentError.noFileSelected {
            // 没有关联文件，触发保存面板
            NotificationCenter.default.post(name: .showSavePanel, object: nil)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func saveDocumentAs(url: URL) {
        do {
            try documentManager.saveAs(url: url)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    // MARK: - Find/Replace

    var findResults: [NSTextRange] {
        guard !findQuery.isEmpty,
              let textView = NSApp.keyWindow?.contentViewController?.view.subviews.first(where: { $0 is NSTextView }) as? NSTextView else {
            return []
        }
        // Find logic will be implemented in text editor component
        return []
    }

    func findNext() {
        // Implemented in CustomTextEditor
    }

    func findPrevious() {
        // Implemented in CustomTextEditor
    }

    func replaceAll() {
        if !findQuery.isEmpty {
            documentManager.content = documentManager.content.replacingOccurrences(of: findQuery, with: replaceQuery, options: caseSensitive ? [] : .caseInsensitive)
        }
    }
}
