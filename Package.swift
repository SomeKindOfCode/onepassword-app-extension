// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "OnePassword",
    platforms: [
        .iOS(.v10)
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "OnePassword",
            targets: ["OnePassword"]
        ),
        .library(
            name: "OnePasswordUI",
            targets: ["OnePasswordUI"]
        ),
    ],
    dependencies: [
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "OnePassword",
            dependencies: [],
            path: "./OnePassword"
        ),
        .target(
            name: "OnePasswordUI",
            dependencies: [
                "OnePassword"
            ],
            path: "./OnePasswordUI"
        )
    ]
)
