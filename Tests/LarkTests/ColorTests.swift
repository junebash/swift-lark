@testable import Lark
import XCTest

final class ColorTests: XCTestCase {
    func test_normalizeComponent() {
        XCTAssertEqual(Color._normalizeComponent(1), 255)
        XCTAssertEqual(Color._normalizeComponent(84849), 255)
        XCTAssertEqual(Color._normalizeComponent(0), 0)
        XCTAssertEqual(Color._normalizeComponent(-937458), 0)
        XCTAssertEqual(Color._normalizeComponent(0.5), 127)
    }

    func test_denormalizeComponent() {
        XCTAssertEqual(Color._denormalizeComponent(255), 1)
        XCTAssertEqual(Color._denormalizeComponent(0), 0)
        XCTAssertEqual(Color._denormalizeComponent(127), 0.5, accuracy: 0.01)
    }
}
