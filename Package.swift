// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "swift-lark",
    platforms: [.iOS(.v16), .macOS(.v13), .tvOS(.v16)],
    products: [
        .library(
            name: "swift-lark",
            targets: ["Lark"]
        ),
        .executable(name: "LarkExample", targets: ["LarkExample"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-async-algorithms", from: .init(0, 0, 3)),
        .package(url: "https://github.com/apple/swift-log", from: .init(1, 5, 2)),
        .package(url: "https://github.com/pointfreeco/xctest-dynamic-overlay", from: .init(0, 6, 0)),
        .package(url: "https://github.com/pointfreeco/swift-clocks", from: .init(0, 2, 0))
    ],
    targets: [
        .target(
            name: "Lark",
            dependencies: [
                "SDL2",
                "SDL2Image",
                .product(name: "XCTestDynamicOverlay", package: "xctest-dynamic-overlay"),
                .product(name: "AsyncAlgorithms", package: "swift-async-algorithms"),
                .product(name: "Clocks", package: "swift-clocks"),
                .product(name: "Logging", package: "swift-log")
            ],
            swiftSettings: [.unsafeFlags(["-Xfrontend", "-warn-concurrency"])]
        ),

        .executableTarget(
            name: "LarkExample",
            dependencies: ["Lark"],
            resources: [.process("assets")]
        ),

        .target(
            name: "SDL2",
            dependencies: [
                "CSDL2"
            ]
        ),
        .systemLibrary(
            name: "CSDL2",
            pkgConfig: "sdl2",
            providers: [
                .brew(["sdl2"]),
                .apt(["libsdl2-dev"]),
            ]
        ),

        .target(
            name: "SDL2Image",
            dependencies: ["CSDL2Image"]
        ),
        .systemLibrary(
            name: "CSDL2Image",
            path: "Sources/CSDL2Image",
            pkgConfig: "SDL2_image",
            providers: [
                .brew(["SDL2_image"]),
                .apt(["libsdl2-image-dev"])
            ]
        ),

        .testTarget(
            name: "LarkTests",
            dependencies: ["Lark"],
            swiftSettings: [.unsafeFlags(["-Xfrontend", "-warn-concurrency"])]
        ),
    ]
)
