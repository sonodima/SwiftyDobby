# SwiftyDobby

Thin Swift wrapper for the
[Dobby](https://github.com/jmpews/Dobby) multi-platform and multi-architecture hooking framework.

## Requirements

- iOS 14+ or macOS 12+
- Swift 6.0+

## Installation (SwiftPM)

Add this package to your `Package.swift`:

```swift
dependencies: [
  .package(url: "https://github.com/sonodima/SwiftyDobby", branch: "main")
],
targets: [
  .target(name: "YourTarget", dependencies: ["SwiftyDobby"])
]
```

## Roadmap

- [ ] Add code-patching and import table hooking abstractions
- [ ] Migrate from `xcframework` to `artifactbundle` to support non-Apple platforms
