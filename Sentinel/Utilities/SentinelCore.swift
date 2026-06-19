//
//  SentinelCore.swift
//  Sentinel
//
//  Small pure helpers shared by the app, Finder extension, and tests.
//

import Foundation

enum NotarizationStatusMessage {
    static let zippingFailed = "Notarization zipping failed, check Debug console for more info (CMD+D)"
    static let notarizationFailed = "Notarization failed, check Debug console for more info (CMD+D)"
    static let staplingFailed = "Notarization staple failed, check Debug console for more info (CMD+D)"
    static let signedAndNotarized = "App has been signed and notarized successfully"
}

struct SentinelCommandOutput: Equatable {
    let standardOutput: String
    let standardError: String
}

struct NotarizationCommandPlan: Equatable {
    let zipPath: String
    let zipCommand: String
    let submitCommand: String
    let stapleCommand: String
}

func shellQuoted(_ value: String) -> String {
    "'\(value.replacingOccurrences(of: "'", with: "'\\''"))'"
}

func makeSentinelURL(forAppPath appPath: String) -> URL? {
    var components = URLComponents()
    components.scheme = "sentinel"
    components.host = "com.alienator88.Sentinel"
    components.queryItems = [
        URLQueryItem(name: "path", value: appPath)
    ]
    return components.url
}

func parseSentinelAppPath(from url: URL) -> String? {
    if url.isFileURL {
        return url.path
    }

    guard
        let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
        components.scheme == "sentinel"
    else {
        return nil
    }

    return components.queryItems?.first { $0.name == "path" }?.value
}

func makeDropCommand(commandPrefix: String, path: String, clearsExistingAttributes: Bool) -> String {
    let quotedPath = shellQuoted(path)
    if clearsExistingAttributes {
        return "xattr -cr \(quotedPath) && \(commandPrefix) \(quotedPath)"
    }
    return "\(commandPrefix) \(quotedPath)"
}

func codeSignCommandPrefix(identity: String) -> String {
    if identity == "None" {
        return "codesign -f -s - --deep"
    }
    return "codesign -f -s \(shellQuoted(identity)) --deep --options runtime"
}

func parseGatekeeperStatus(stdout: String, stderr: String) -> Bool {
    let output = "\(stdout)\n\(stderr)".lowercased()
    if output.contains("disabled") {
        return false
    }
    return output.contains("enabled")
}

func parseCodeSigningIdentities(output: String, includeDevelopment: Bool) -> [String] {
    let identities = output.split(separator: "\n").compactMap { line -> String? in
        let parts = line.split(separator: "\"", omittingEmptySubsequences: false)
        guard parts.count >= 3 else {
            return nil
        }

        let identity = String(parts[1])
        if !includeDevelopment && identity.starts(with: "Apple Development") {
            return nil
        }

        return identity
    }

    return ["None"] + identities
}

func makeNotarizationCommandPlan(
    path: String,
    profile: String,
    appSupportDirectory: URL,
    bundleName: String
) -> NotarizationCommandPlan {
    let zipDir = appSupportDirectory.appendingPathComponent(bundleName)
    let zipPath = zipDir.appendingPathComponent((path as NSString).lastPathComponent + ".zip").path

    return NotarizationCommandPlan(
        zipPath: zipPath,
        zipCommand: "ditto -c -k --keepParent \(shellQuoted(path)) \(shellQuoted(zipPath))",
        submitCommand: "xcrun notarytool submit \(shellQuoted(zipPath)) --keychain-profile \(shellQuoted(profile)) --wait",
        stapleCommand: "xcrun stapler staple \(shellQuoted(path))"
    )
}

@discardableResult
func runNotarization(
    path: String,
    profile: String,
    appSupportDirectory: URL,
    bundleName: String,
    runCommand: (String) -> SentinelCommandOutput,
    fileExists: (String) -> Bool,
    removeFile: (String) throws -> Void,
    setStatus: (String) -> Void,
    log: (String) -> Void
) -> String {
    let plan = makeNotarizationCommandPlan(
        path: path,
        profile: profile,
        appSupportDirectory: appSupportDirectory,
        bundleName: bundleName
    )

    let zipResult = runCommand(plan.zipCommand)
    log(zipResult.standardOutput)
    log(zipResult.standardError)
    if !zipResult.standardError.isEmpty {
        setStatus(NotarizationStatusMessage.zippingFailed)
        cleanupZipIfNeeded(zipPath: plan.zipPath, fileExists: fileExists, removeFile: removeFile, log: log)
        return NotarizationStatusMessage.zippingFailed
    }

    let notaryResult = runCommand(plan.submitCommand)
    log(notaryResult.standardOutput)
    log(notaryResult.standardError)
    if !notaryResult.standardError.isEmpty {
        setStatus(NotarizationStatusMessage.notarizationFailed)
        cleanupZipIfNeeded(zipPath: plan.zipPath, fileExists: fileExists, removeFile: removeFile, log: log)
        return NotarizationStatusMessage.notarizationFailed
    }

    if notaryResult.standardOutput.contains("status: Invalid") {
        log("Make sure you did not sign using an Apple Development certificate as those are only for local testing and cannot notarize an application.")
        setStatus(NotarizationStatusMessage.notarizationFailed)
        cleanupZipIfNeeded(zipPath: plan.zipPath, fileExists: fileExists, removeFile: removeFile, log: log)
        return NotarizationStatusMessage.notarizationFailed
    }

    let stapleResult = runCommand(plan.stapleCommand)
    log(stapleResult.standardOutput)
    log(stapleResult.standardError)
    if !stapleResult.standardError.isEmpty {
        setStatus(NotarizationStatusMessage.staplingFailed)
        cleanupZipIfNeeded(zipPath: plan.zipPath, fileExists: fileExists, removeFile: removeFile, log: log)
        return NotarizationStatusMessage.staplingFailed
    }

    cleanupZipIfNeeded(zipPath: plan.zipPath, fileExists: fileExists, removeFile: removeFile, log: log)
    setStatus(NotarizationStatusMessage.signedAndNotarized)
    return NotarizationStatusMessage.signedAndNotarized
}

private func cleanupZipIfNeeded(
    zipPath: String,
    fileExists: (String) -> Bool,
    removeFile: (String) throws -> Void,
    log: (String) -> Void
) {
    guard fileExists(zipPath) else {
        return
    }

    do {
        try removeFile(zipPath)
    } catch {
        log("Failed to remove zip file at path \(zipPath): \(error)")
    }
}
