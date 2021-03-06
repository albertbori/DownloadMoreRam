// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DownloadMoreRam",
    platforms: [
        .macOS(.v10_11)
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.2.0"),
        .package(url: "https://github.com/scinfu/SwiftSoup.git", from: "1.7.4")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "DownloadMoreRam",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                "DownloadMoreRamCore",
                "SwiftSoup"
            ]),
        .target(
            name: "DownloadMoreRamCore",
            dependencies: [
                "SwiftSoup"
            ]),
        .testTarget(
            name: "DownloadMoreRamTests",
            dependencies: ["DownloadMoreRam"]),
    ]
)
