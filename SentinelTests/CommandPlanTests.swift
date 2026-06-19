import XCTest

final class CommandPlanTests: XCTestCase {
    func testShellQuotedEscapesApostrophes() {
        XCTAssertEqual(shellQuoted("/tmp/O'Brien.app"), "'/tmp/O'\\''Brien.app'")
    }

    func testDropCommandQuotesUnsafePaths() {
        let path = "/Applications/O'Brien & Sons.app"

        XCTAssertEqual(
            makeDropCommand(
                commandPrefix: "xattr -rd com.apple.quarantine",
                path: path,
                clearsExistingAttributes: false
            ),
            "xattr -rd com.apple.quarantine \(shellQuoted(path))"
        )
    }

    func testDeveloperSigningCommandQuotesIdentityAndPath() {
        let identity = "Developer ID Application: O'Brien & Sons"
        let path = "/Applications/Foo#Bar.app"
        let prefix = codeSignCommandPrefix(identity: identity)

        XCTAssertEqual(
            prefix,
            "codesign -f -s \(shellQuoted(identity)) --deep --options runtime"
        )
        XCTAssertEqual(
            makeDropCommand(commandPrefix: prefix, path: path, clearsExistingAttributes: true),
            "xattr -cr \(shellQuoted(path)) && \(prefix) \(shellQuoted(path))"
        )
    }

    func testAdHocSigningCommandKeepsDashIdentity() {
        XCTAssertEqual(codeSignCommandPrefix(identity: "None"), "codesign -f -s - --deep")
    }
}
