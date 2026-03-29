import XCTest
@testable import MacNotepadApp

class EditorViewModelTests: XCTestCase {
    var viewModel: EditorViewModel!

    override func setUp() {
        super.setUp()
        viewModel = EditorViewModel()
    }

    func testInitialState() {
        XCTAssertFalse(viewModel.showFindReplace)
        XCTAssertEqual(viewModel.findQuery, "")
        XCTAssertEqual(viewModel.replaceQuery, "")
    }

    func testToggleFindReplace() {
        viewModel.showFindReplace = true
        XCTAssertTrue(viewModel.showFindReplace)
    }
}
