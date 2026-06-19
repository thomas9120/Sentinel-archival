

<p align="center">
  <img src="https://github.com/user-attachments/assets/dfea9f1c-d3ab-430e-93e4-c2da358db110" width="128" height="128" />
   <br />
   <strong>Status: </strong>Archived
   <br />
   <strong>Version: </strong>3.1.4
   <br />
</p>
</br>

A GUI for controlling Gatekeeper, unquarantining apps and signing apps.


## Features
- 100% Swift
- Can drop an app in the drop target to unquarantine and optionally auto-open the app after it is unquarantined
- Can drop an app in the drop target to ad-hoc self sign and replace the certificate
- Finder extension to easily right click apps and unquarantine
- Custom auto-updater that pulls latest release notes and binaries from GitHub Releases (Sentinel should be ran from /Applications folder to avoid permission issues)



## Screenshots

<img src="https://github.com/user-attachments/assets/3cc90bd1-7d9d-43ed-8a0f-7105d72d5eab" align="center" width="400" />

## Requirements
| macOS Version | Codename | Supported |
|---------------|----------|-----------|
| 13.x          | Ventura  | ✅        |
| 14.x          | Sonoma   | ✅        |
| 15.x          | Sequoia  | ✅        |
| 26.x          | Tahoe    | ✅        |
| TBD           | Beta     | ❌        |
> Versions prior to macOS 13.0 are not supported due to missing Swift/SwiftUI APIs required by the app.



## License
> [!IMPORTANT]
> Sentinel is licensed under Apache 2.0 with [Commons Clause](https://commonsclause.com/). This means that you can do anything you'd like with the source, modify it, contribute to it, etc., but the license explicitly prohibits any form of monetization for Sentinel or any modified versions of it. See full license [HERE](https://github.com/alienator88/Sentinel/blob/main/LICENSE.md)
> 
