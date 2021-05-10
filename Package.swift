// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "micasa",
  products: [
    .executable(name: "micasa", targets: ["micasa"]),
    .library(name: "micasaLib", targets: ["micasaLib"])
  ],
  dependencies: [
    // Dependencies declare other packages that this package depends on.
    .package(url: "https://github.com/MiCasa-HomeKit/MiCasaPlugin.git", .branch("main")),
    //.package(url: "https://github.com/MiCasa-HomeKit/HAP.git", .branch("master")),
    .package(url: "https://github.com/Bouke/HAP", .branch("master")),
    .package(url: "https://github.com/MiCasa-HomeKit/swift-log.git", .branch("master")),
    .package(url: "https://github.com/apple/swift-argument-parser.git", from: "0.3.1"),
    .package(url: "https://github.com/Flight-School/AnyCodable.git", from: "0.3.0"),
    .package(url: "https://github.com/Quick/Quick.git", from: "2.0.0"),
    .package(url: "https://github.com/Quick/Nimble.git", from: "8.0.0"),
    .package(url: "https://github.com/realm/SwiftLint", from: "0.40.3")
  ],
  targets: [
    // Targets are the basic building blocks of a package. A target can define a module or a test suite.
    // Targets can depend on other targets in this package, and on products in packages this package depends on.
    .target(
      name: "micasa",
      dependencies: [
        "micasaLib",
        .product(name: "ArgumentParser", package: "swift-argument-parser")
      ]),
    .target(
      name: "micasaLib",
      dependencies: [
        "HAP",
        "AnyCodable",
        "MiCasaPlugin",
        .product(name: "Logging", package: "swift-log"),
      ]),
    .testTarget(
      name: "micasaTests",
      dependencies: ["Quick", "Nimble", "micasaLib"],
      resources: [
        .copy("resources/simple.conf"),
        .copy("resources/complex.conf")
      ]),
  ]
)
