import Foundation

class DocumentManager: ObservableObject {
    @Published var currentFile: URL?
    @Published var content: String = "" {
        didSet {
            if content != oldValue {
                isModified = true
            }
        }
    }
    @Published var isModified: Bool = false
    @Published var encoding: String.Encoding = .utf8

    func new() {
        currentFile = nil
        content = ""
        isModified = false
        encoding = .utf8
    }

    func open(url: URL) throws {
        let data = try Data(contentsOf: url)
        encoding = detectEncoding(data: data)
        content = String(data: data, encoding: encoding) ?? ""
        currentFile = url
        isModified = false
    }

    func save() throws {
        guard let file = currentFile else {
            throw DocumentError.noFileSelected
        }
        try saveAs(url: file)
    }

    func hasFile() -> Bool {
        return currentFile != nil
    }

    func saveAs(url: URL) throws {
        guard let data = content.data(using: encoding) else {
            throw DocumentError.encodingFailed
        }
        try data.write(to: url)
        currentFile = url
        isModified = false
    }

    private func detectEncoding(data: Data) -> String.Encoding {
        // Try UTF-8 first
        if let _ = String(data: data, encoding: .utf8) {
            return .utf8
        }
        // Try UTF-16 LE
        if let _ = String(data: data, encoding: .utf16LittleEndian) {
            return .utf16LittleEndian
        }
        // Try ASCII
        if let _ = String(data: data, encoding: .ascii) {
            return .ascii
        }
        return .utf8 // Default fallback
    }
}

enum DocumentError: Error, LocalizedError {
    case noFileSelected
    case encodingFailed
    case fileNotFound
    case permissionDenied

    var errorDescription: String? {
        switch self {
        case .noFileSelected:
            return "No file selected"
        case .encodingFailed:
            return "Failed to encode content"
        case .fileNotFound:
            return "File not found"
        case .permissionDenied:
            return "Permission denied"
        }
    }
}
