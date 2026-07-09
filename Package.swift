// swift-tools-version: 6.0
import PackageDescription

let swiftSettings: [SwiftSetting] = [
    .enableUpcomingFeature("ExistentialAny")
]

let package = Package(
    name: "elementary",
    platforms: [
        .macOS(.v14),
        .iOS(.v15),
        .tvOS(.v17),
        .watchOS(.v10),
    ],
    products: [
        .library(
            name: "Elementary",
            targets: ["Elementary"]
        ),
        .library(
            name: "ElementarySVG",
            targets: ["ElementarySVG"]
        )
    ],
    targets: [
        .target(
            name: "Elementary",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "ElementarySVG",
            dependencies: ["Elementary"],
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "ElementaryTests",
            dependencies: ["Elementary"],
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "ElementarySVGTests",
            dependencies: ["Elementary", "ElementarySVG"],
            swiftSettings: swiftSettings
        ),
    ]
)
