//
//  DeepLink.swift
//  Sentinel
//
//  Created by Alin Lupascu on 7/28/25.
//

import Foundation
import AlinFoundation

func handleDeepLinkedApps(url: URL, appState: AppState) {
    guard let path = parseSentinelAppPath(from: url) else {
        printOS("DLM: URL does not match expected format")
        return
    }

    guard FileManager.default.fileExists(atPath: path) else {
        printOS("DLM: sent path doesn't exist: \(path)")
        return
    }

    updateOnMain {
        appState.status = "Attempting to remove app from quarantine"
        appState.isLoading = true
    }
    Task {
        _ = await CmdRunDrop(cmd: "xattr -rd com.apple.quarantine", path: path, type: .quarantine, appState: appState)
    }
}
