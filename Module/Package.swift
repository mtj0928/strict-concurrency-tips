// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Module",
    platforms: [.iOS(.v16)],
    products: [
        .library(name: "Module", targets: ["Module"]),
    ],
    targets: [
        .target(name: "Module", swiftSettings: [.swiftLanguageMode(.v5), .enableUpcomingFeature("StrictConcurrency")]),
    ]
)
