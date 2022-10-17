// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RZUtilsTouch",
    platforms: [
        .iOS(.v13)
    ],

    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library( name: "RZUtilsTouch", targets: ["RZUtilsTouch", "RZUtilsTouchSwift"]),
        .library( name: "RZUtilsTestInfra", targets: ["RZUtilsTestInfra"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(name: "RZUtils", url: "https://github.com/roznet/rzutils", from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "RZUtilsTouch",
            dependencies: [
                //"RZUtils"
                .product(name: "RZUtils", package: "RZUtils"),
                .product(name: "RZUtilsUniversal", package: "RZUtils")
            ]),
        .target(
            name: "RZUtilsTouchHealthKit",
            dependencies: [
                //"RZUtils"
                .product(name: "RZUtils", package: "RZUtils"),
            ]),
        .target(
            name: "RZUtilsTouchSwift",
            dependencies: [
                //"RZUtils"
                .product(name: "RZUtils", package: "RZUtils"),
                .product(name: "RZUtilsUniversal", package: "RZUtils")
            ]),
        .target(
            name: "RZUtilsTestInfra",
            dependencies: [
                .product(name: "RZUtils", package: "RZUtils"),
                "RZUtilsTouch",
            ]),
        .testTarget(
            name: "RZUtilsTouchTests",
            dependencies: ["RZUtilsTouch"]),
        .testTarget(
            name: "RZUtilsTouchObjCTests",
            dependencies: ["RZUtilsTouch"]),
    ]
)
