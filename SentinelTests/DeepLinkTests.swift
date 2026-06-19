import XCTest

final class DeepLinkTests: XCTestCase {
    func testSentinelURLsRoundTripPathsWithReservedCharacters() throws {
        let paths = [
            "/Applications/My App.app",
            "/Applications/Foo&Bar.app",
            "/Applications/Foo#Bar.app",
            "/Applications/O'Brien.app"
        ]

        for path in paths {
            let url = try XCTUnwrap(makeSentinelURL(forAppPath: path))
            XCTAssertEqual(parseSentinelAppPath(from: url), path)
        }
    }

    func testDirectFileURLParsesAsAppPath() {
        let url = URL(fileURLWithPath: "/Applications/My App.app")

        XCTAssertEqual(parseSentinelAppPath(from: url), "/Applications/My App.app")
    }
}
