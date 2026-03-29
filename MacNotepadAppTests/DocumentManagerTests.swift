import XCTest
@testable import MacNotepadApp

class DocumentManagerTests: XCTestCase {
    var manager: DocumentManager!

    override func setUp() {
        super.setUp()
        manager = DocumentManager()
    }

    func testInitialState() {
        XCTAssertNil(manager.currentFile)
        XCTAssertEqual(manager.content, "")
        XCTAssertFalse(manager.isModified)
    }

    func testNewDocument() {
        manager.new()
        XCTAssertNil(manager.currentFile)
        XCTAssertEqual(manager.content, "")
        XCTAssertFalse(manager.isModified)
    }

    func testContentUpdateSetsModified() {
        manager.content = "test"
        XCTAssertTrue(manager.isModified)
    }
}
