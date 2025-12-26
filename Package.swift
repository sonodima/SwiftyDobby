// swift-tools-version: 6.0
import PackageDescription

let package = Package(
  name: "SwiftyDobby",
  platforms: [.iOS(.v14), .macOS(.v12)],
  products: [
    .library(name: "SwiftyDobby", targets: ["SwiftyDobby"]),
    // .executable(name: "Example", targets: ["Example"]),
  ],
  targets: [
    .binaryTarget(name: "CDobby", path: "Vendor/CDobby.xcframework"),
    .target(name: "SwiftyDobby", dependencies: ["CDobby"]),
    // .executableTarget(name: "Example", dependencies: ["SwiftyDobby"]),
  ]
)
