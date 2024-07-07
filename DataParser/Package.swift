// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DataParser",
    platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6), .macCatalyst(.v13)],
    products: [
        .library(
            name: "DataParser",
            targets: ["DataParser"]),
    ],
    targets: [
        .target(
            name: "DataParser"),
        .testTarget(
            name: "DataParserTests",
            dependencies: ["DataParser"],
            resources: [
                .copy("data")
            ]
        ),
    ]
)
