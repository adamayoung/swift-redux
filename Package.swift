// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftRedux",

    platforms: [
        .iOS(.v17),
        .macOS(.v14),
        .tvOS(.v17),
        .watchOS(.v10),
        .visionOS(.v1)
    ],

    products: [
        .library(name: "Redux", targets: ["Redux"])
    ],

    targets: [
        .target(name: "Redux"),
        .testTarget(name: "ReduxTests", dependencies: ["Redux"])
    ]

)
