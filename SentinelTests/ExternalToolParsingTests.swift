import XCTest

final class ExternalToolParsingTests: XCTestCase {
    func testGatekeeperStatusParsing() {
        XCTAssertTrue(parseGatekeeperStatus(stdout: "assessments enabled\n", stderr: ""))
        XCTAssertFalse(parseGatekeeperStatus(stdout: "assessments disabled\n", stderr: ""))
        XCTAssertFalse(parseGatekeeperStatus(stdout: "", stderr: "assessments disabled\n"))
        XCTAssertFalse(parseGatekeeperStatus(stdout: "", stderr: "spctl: command not found\n"))
    }

    func testCodeSigningIdentityParsingFiltersDevelopmentCertificatesByDefault() {
        let output = """
          1) ABCDEF1234567890 "Developer ID Application: Example Corp (TEAMID)"
          2) 1234567890ABCDEF "Apple Development: Jane Developer (TEAMID)"
          3) FEDCBA0987654321 "Mac Developer: Legacy Cert (TEAMID)"
             3 valid identities found
        """

        XCTAssertEqual(
            parseCodeSigningIdentities(output: output, includeDevelopment: false),
            [
                "None",
                "Developer ID Application: Example Corp (TEAMID)",
                "Mac Developer: Legacy Cert (TEAMID)"
            ]
        )
        XCTAssertEqual(
            parseCodeSigningIdentities(output: output, includeDevelopment: true),
            [
                "None",
                "Developer ID Application: Example Corp (TEAMID)",
                "Apple Development: Jane Developer (TEAMID)",
                "Mac Developer: Legacy Cert (TEAMID)"
            ]
        )
    }
}
