// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "mi-casa",
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/Bouke/HAP.git", .branch("master")),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "mi-casa",
            dependencies: []),
        .testTarget(
            name: "mi-casaTests",
            dependencies: ["mi-casa"]),
    ]
)
