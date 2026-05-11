// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "macOS-alias-utils",
    targets: [
        .target(
            name: "config",
            path: "Sources/config"
        ),
        .executableTarget(
            name: "readalias",
            dependencies: ["config"],
            path: "Sources/readalias"
        ),
        .executableTarget(
            name: "mkalias",
            dependencies: ["config"],
            path: "Sources/mkalias"
        ),
    ],
    swiftLanguageModes: [.v6]
)
