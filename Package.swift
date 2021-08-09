// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Lark",
  platforms: [.macOS(.v11)],
  products: [
    // Products define the executables and libraries a package produces, and make them visible to other packages.
    .executable(name: "SimpleGameLoop", targets: ["SimpleGameLoop"]),
    .library(name: "Lark", targets: ["Lark"])
  ],
  dependencies: [
    .package(
      url: "https://github.com/ctreffs/SwiftSDL2.git",
      from: "1.2.0"
    )
  ],
  targets: [
    // Targets are the basic building blocks of a package. A target can define a module or a test suite.
    // Targets can depend on other targets in this package, and on products in packages this package depends on.

    .target(
      name: "Lark",
      dependencies: [
        .product(name: "SDL2", package: "SwiftSDL2")
      ]
    ),
    .executableTarget(
      name: "SimpleGameLoop",
      dependencies: [
        "Lark"
      ]
    ),
    .testTarget(
      name: "SimpleGameLoopTests",
      dependencies: ["SimpleGameLoop"]
    ),
  ]
)
