// swift-tools-version: 6.3

import PackageDescription

let package = Package(
    name: "aliastools",
    targets: [
        .executableTarget(
            name: "readalias",
            path: "Sources/readalias"
        ),
        .executableTarget(
            name: "mkalias",
            path: "Sources/mkalias"
        ),
    ],
    swiftLanguageModes: [.v6]
)
