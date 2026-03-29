import SwiftUI
import AppKit

struct SimpleTextEditor: NSViewRepresentable {
    @Binding var text: String

    func makeNSView(context: Context) -> NSScrollView {
        let scrollView = NSScrollView()
        let textView = NSTextView()

        textView.string = text
        textView.font = NSFont.systemFont(ofSize: 13)
        textView.textColor = .black  // 明确设置为黑色
        textView.backgroundColor = .white
        textView.isEditable = true
        textView.isSelectable = true
        textView.isRichText = false

        scrollView.documentView = textView
        scrollView.hasVerticalScroller = true

        return scrollView
    }

    func updateNSView(_ nsView: NSScrollView, context: Context) {
        guard let textView = nsView.documentView as? NSTextView else { return }
        // 简化更新逻辑
        if textView.string != text {
            textView.string = text
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text)
    }

    class Coordinator: NSObject, NSTextViewDelegate {
        @Binding var text: String

        init(text: Binding<String>) {
            self._text = text
        }

        func textDidChange(_ notification: Notification) {
            guard let textView = notification.object as? NSTextView else { return }
            text = textView.string
        }
    }
}

struct SimpleContentView: View {
    @State private var text = "请在这里输入文字...\n测试中文输入\nTest English"

    var body: some View {
        VStack {
            Text("简单文本编辑器测试")
                .font(.headline)
                .padding()

            SimpleTextEditor(text: $text)
                .frame(minHeight: 200)

            Button("显示文本内容") {
                print("当前文本: \(text)")
                Swift.print("当前文本: \(text)")
            }
            .padding()
        }
        .frame(minWidth: 400, minHeight: 300)
    }
}
