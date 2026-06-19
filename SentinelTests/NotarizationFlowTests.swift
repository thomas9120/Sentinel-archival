import XCTest

final class NotarizationFlowTests: XCTestCase {
    func testNotarizationStopsAndCleansUpWhenZipFails() {
        let harness = NotarizationHarness(outputs: [
            SentinelCommandOutput(standardOutput: "", standardError: "ditto failed")
        ])

        let status = harness.run()

        XCTAssertEqual(status, NotarizationStatusMessage.zippingFailed)
        XCTAssertEqual(harness.commands.count, 1)
        XCTAssertEqual(harness.statuses, [NotarizationStatusMessage.zippingFailed])
        XCTAssertEqual(harness.removedPaths, [harness.expectedZipPath])
    }

    func testNotarizationStopsAndCleansUpWhenSubmitFails() {
        let harness = NotarizationHarness(outputs: [
            SentinelCommandOutput(standardOutput: "", standardError: ""),
            SentinelCommandOutput(standardOutput: "", standardError: "notarytool failed")
        ])

        let status = harness.run()

        XCTAssertEqual(status, NotarizationStatusMessage.notarizationFailed)
        XCTAssertEqual(harness.commands.count, 2)
        XCTAssertEqual(harness.statuses, [NotarizationStatusMessage.notarizationFailed])
        XCTAssertEqual(harness.removedPaths, [harness.expectedZipPath])
    }

    func testNotarizationStopsAndCleansUpWhenAppleReportsInvalidStatus() {
        let harness = NotarizationHarness(outputs: [
            SentinelCommandOutput(standardOutput: "", standardError: ""),
            SentinelCommandOutput(standardOutput: "status: Invalid", standardError: "")
        ])

        let status = harness.run()

        XCTAssertEqual(status, NotarizationStatusMessage.notarizationFailed)
        XCTAssertEqual(harness.commands.count, 2)
        XCTAssertTrue(harness.logs.contains { $0.contains("Apple Development certificate") })
        XCTAssertEqual(harness.removedPaths, [harness.expectedZipPath])
    }

    func testNotarizationDoesNotReportSuccessWhenStapleFails() {
        let harness = NotarizationHarness(outputs: [
            SentinelCommandOutput(standardOutput: "", standardError: ""),
            SentinelCommandOutput(standardOutput: "status: Accepted", standardError: ""),
            SentinelCommandOutput(standardOutput: "", standardError: "staple failed")
        ])

        let status = harness.run()

        XCTAssertEqual(status, NotarizationStatusMessage.staplingFailed)
        XCTAssertEqual(harness.commands.count, 3)
        XCTAssertEqual(harness.statuses, [NotarizationStatusMessage.staplingFailed])
        XCTAssertEqual(harness.removedPaths, [harness.expectedZipPath])
    }

    func testNotarizationRunsAllStepsAndCleansUpOnSuccess() {
        let harness = NotarizationHarness(outputs: [
            SentinelCommandOutput(standardOutput: "", standardError: ""),
            SentinelCommandOutput(standardOutput: "status: Accepted", standardError: ""),
            SentinelCommandOutput(standardOutput: "", standardError: "")
        ])

        let status = harness.run()

        XCTAssertEqual(status, NotarizationStatusMessage.signedAndNotarized)
        XCTAssertEqual(harness.commands.count, 3)
        XCTAssertEqual(harness.statuses, [NotarizationStatusMessage.signedAndNotarized])
        XCTAssertEqual(harness.removedPaths, [harness.expectedZipPath])
    }
}

private final class NotarizationHarness {
    private let outputs: [SentinelCommandOutput]
    private(set) var commands: [String] = []
    private(set) var logs: [String] = []
    private(set) var removedPaths: [String] = []
    private(set) var statuses: [String] = []

    let path = "/Applications/O'Brien & Sons.app"
    let profile = "Developer Profile #1"
    let appSupportDirectory = URL(fileURLWithPath: "/tmp/SentinelTests/Application Support")
    let bundleName = "Sentinel"

    var expectedZipPath: String {
        makeNotarizationCommandPlan(
            path: path,
            profile: profile,
            appSupportDirectory: appSupportDirectory,
            bundleName: bundleName
        ).zipPath
    }

    init(outputs: [SentinelCommandOutput]) {
        self.outputs = outputs
    }

    func run() -> String {
        runNotarization(
            path: path,
            profile: profile,
            appSupportDirectory: appSupportDirectory,
            bundleName: bundleName,
            runCommand: { command in
                self.commands.append(command)
                return self.outputs[self.commands.count - 1]
            },
            fileExists: { $0 == self.expectedZipPath },
            removeFile: { self.removedPaths.append($0) },
            setStatus: { self.statuses.append($0) },
            log: { self.logs.append($0) }
        )
    }
}
