import SwiftUI
import AppKit

struct CustomTextEditor: NSViewRepresentable {
    @Binding var text: String
    @Binding var isModified: Bool
    @Binding var cursorPosition: (line: Int, column: Int)
    @Binding var selectedRange: NSRange
    var font: NSFont
    var textColor: NSColor = .black  // 默认黑色，确保可见
    var backgroundColor: NSColor = .white  // 背景颜色
    var findQuery: String = ""
    var caseSensitive: Bool = false

    func makeNSView(context: Context) -> NSScrollView {
        let scrollView = NSScrollView()
        let textView = NSTextView()

        textView.delegate = context.coordinator
        context.coordinator.textView = textView

        // 基本配置 - 使用简化版本的成功配置
        textView.string = text
        textView.font = font
        textView.textColor = textColor
        textView.backgroundColor = backgroundColor
        textView.isEditable = true
        textView.isSelectable = true
        textView.isRichText = false
        textView.allowsUndo = true
        textView.isAutomaticQuoteSubstitutionEnabled = false
        textView.isAutomaticDashSubstitutionEnabled = false
        textView.isAutomaticDataDetectionEnabled = false
        textView.isAutomaticLinkDetectionEnabled = false
        textView.isAutomaticTextReplacementEnabled = false

        // 简化滚动视图配置
        scrollView.documentView = textView
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalScroller = false

        return scrollView
    }

    func updateNSView(_ nsView: NSScrollView, context: Context) {
        guard let textView = nsView.documentView as? NSTextView else { return }

        // 使用 Coordinator 的标志来避免循环更新
        if !context.coordinator.isUpdatingText {
            // 只在文本真正不同时更新，避免覆盖用户输入
            if textView.string != text {
                let selectedRange = textView.selectedRange
                textView.string = text
                // 恢复光标位置
                if selectedRange.location <= text.count {
                    textView.setSelectedRange(selectedRange)
                }
            }
        }

        // 更新字体和颜色
        if textView.font != font {
            textView.font = font
        }

        if textView.textColor != textColor {
            textView.textColor = textColor
        }

        // Highlight find results
        if !findQuery.isEmpty {
            highlightFindResults(in: textView)
        } else {
            textView.textStorage?.removeAttribute(.backgroundColor, range: NSRange(location: 0, length: textView.textStorage?.length ?? 0))
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text, isModified: $isModified, cursorPosition: $cursorPosition, selectedRange: $selectedRange)
    }

    func highlightFindResults(in textView: NSTextView) {
        guard let textStorage = textView.textStorage else { return }

        // Clear previous highlights
        textStorage.removeAttribute(.backgroundColor, range: NSRange(location: 0, length: textStorage.length))

        let range = NSString(string: text).range(of: findQuery, options: caseSensitive ? [] : .caseInsensitive)
        if range.location != NSNotFound {
            textStorage.addAttribute(.backgroundColor, value: NSColor.yellow, range: range)
        }
    }

    class Coordinator: NSObject, NSTextViewDelegate {
        @Binding var text: String
        @Binding var isModified: Bool
        @Binding var cursorPosition: (line: Int, column: Int)
        @Binding var selectedRange: NSRange
        weak var textView: NSTextView?
        var isUpdatingText = false  // 防止循环更新 - 改为 public 以便 updateNSView 访问

        init(text: Binding<String>, isModified: Binding<Bool>, cursorPosition: Binding<(line: Int, column: Int)>, selectedRange: Binding<NSRange>) {
            self._text = text
            self._isModified = isModified
            self._cursorPosition = cursorPosition
            self._selectedRange = selectedRange
        }

        func textDidChange(_ notification: Notification) {
            guard let textView = notification.object as? NSTextView else { return }
            guard !isUpdatingText else { return }  // 避免循环更新

            isUpdatingText = true
            text = textView.string
            isModified = true
            updateCursorPosition(textView)
            isUpdatingText = false
        }

        private func updateCursorPosition(_ textView: NSTextView) {
            let location = textView.selectedRange().location
            let line = (textView.string as NSString).substring(to: location).components(separatedBy: .newlines).count
            let lastLine = (textView.string as NSString).substring(to: location).components(separatedBy: .newlines).last ?? ""
            let column = lastLine.count + 1
            cursorPosition = (line, column)
            selectedRange = textView.selectedRange()
        }

        func findNext(query: String, caseSensitive: Bool) {
            guard let textView = textView else { return }
            let options: String.CompareOptions = caseSensitive ? [] : .caseInsensitive
            let searchRange = NSRange(location: textView.selectedRange.location + textView.selectedRange.length, length: textView.string.count - (textView.selectedRange.location + textView.selectedRange.length))
            let range = (textView.string as NSString).range(of: query, options: options, range: searchRange)
            if range.location != NSNotFound {
                textView.setSelectedRange(range)
                textView.scrollRangeToVisible(range)
            }
        }
    }
}
