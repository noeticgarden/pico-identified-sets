// swift-tools-version: 6.2

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
    traits: [
        .default(enabledTraits: ["SwiftCollections"]),
        .trait(name: "SwiftCollections"),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-collections.git", from: "1.3.0"),
    ],
    targets: [
        .target(
            name: "IdentifiedSets",
            dependencies: [
                .product(name: "Collections", package: "swift-collections", condition: .when(traits: ["SwiftCollections"])),
            ],
        ),
    ]
)
