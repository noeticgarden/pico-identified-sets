// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "IdentifiedSets",
    platforms: [
        // Identified is @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *).
        .macOS(.v10_15),
        .iOS(.v13),
        .watchOS(.v6),
        .tvOS(.v13),
        .visionOS(.v1),
    ],
    products: [
        .library(
            name: "IdentifiedSets",
            targets: ["IdentifiedSets"]),
    ],
    targets: [
        .target(
            name: "IdentifiedSets"
        ),
    ]
)
