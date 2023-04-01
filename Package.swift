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
        .package(url: "https://github.com/pointfreeco/xctest-dynamic-overlay", from: .init(0, 6, 0)),
        .package(url: "https://github.com/pointfreeco/swift-clocks", from: .init(0, 2, 0))
    ],
    targets: [
        .target(
            name: "Lark",
            dependencies: [
                "SDL2",
                .product(name: "XCTestDynamicOverlay", package: "xctest-dynamic-overlay"),
                .product(name: "AsyncAlgorithms", package: "swift-async-algorithms"),
                .product(name: "Clocks", package: "swift-clocks")
            ],
            swiftSettings: [.unsafeFlags(["-Xfrontend", "-warn-concurrency"])]
        ),

        .executableTarget(name: "LarkExample", dependencies: ["Lark"]),

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

        .testTarget(
            name: "LarkTests",
            dependencies: ["Lark"],
            swiftSettings: [.unsafeFlags(["-Xfrontend", "-warn-concurrency"])]
        ),
    ]
)
