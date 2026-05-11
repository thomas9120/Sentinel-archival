# Sentinel

### Project Status: On Hold
> As you may have noticed, development on the app has basically stopped since end of 2025, so I wanted to provide some context.
>
> Between a new job, joining a friend who is building a SaaS company, and other life priorities, I no longer have the time needed to actively maintain or continue development on the project.
>
> Another major reason is that I previously relied on my work MacBook for development. After changing jobs, I no longer have access to a Mac device that I can use for personal development work, which means I’m currently unable to build, test, or release updates for the app.
>
> Because of that, issue responses, feature work, PR reviews, and new releases are effectively on hold indefinitely for now.
>
> The project is not abandoned entirely, and I’d still like to return to it someday if circumstances change. For now though, I want to be transparent that active development is no longer possible on my end.
>
> Thank you to everyone who has used the app, reported issues, submitted ideas, or contributed. I genuinely appreciate all of the support the project has received.


<p align="center">
  <img src="https://github.com/user-attachments/assets/dfea9f1c-d3ab-430e-93e4-c2da358db110" width="128" height="128" />
   <br />
   <strong>Status: </strong>On Hold 
   <br />
   <strong>Version: </strong>3.1.4
   <br />
   <a href="https://github.com/alienator88/Sentinel/releases"><strong>Download</strong></a>
    · 
   <a href="https://github.com/alienator88/Sentinel/commits">Commits</a>
   <br />
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

## Getting Sentinel

<details>
  <summary>Releases</summary>

> Pre-compiled, always up-to-date versions are available from my releases page.
</details>

<details>
  <summary>Homebrew</summary>
   
> Execute the following command to install via Homebrew:
```
brew install alienator88-sentinel
```
</details>


## License
> [!IMPORTANT]
> Sentinel is licensed under Apache 2.0 with [Commons Clause](https://commonsclause.com/). This means that you can do anything you'd like with the source, modify it, contribute to it, etc., but the license explicitly prohibits any form of monetization for Sentinel or any modified versions of it. See full license [HERE](https://github.com/alienator88/Sentinel/blob/main/LICENSE.md)
> 

## Thanks

Much appreciation to [Wynioux]([https://freemacsoft.net/appcleaner/](https://github.com/wynioux/macOS-GateKeeper-Helper)) for their Gatekeeper script used as inspiration.

## Some of my apps

[Pearcleaner](https://github.com/alienator88/Pearcleaner) - An opensource app cleaner with privacy in mind

[Sentinel](https://github.com/alienator88/Sentinel) - A GUI for controlling gatekeeper status on your mac

[Viz](https://github.com/alienator88/Viz) - Utility for extracting text from images, videos, qr/barcodes

[PearHID](https://github.com/alienator88/PearHID) - Remap your macOS keyboard with a simple SwiftUI frontend
