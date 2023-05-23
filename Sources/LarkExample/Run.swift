// Copyright (c) 2023 June Bash
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Foundation
import Lark
import Logging
import SDL2

extension AssetID where AssetType == Texture {
  static var tankSprite: AssetID { "tankSprite" }
  static var truckSprite: AssetID { "truckSprite" }
}

final class TankEntity: Entity {
  let id: EntityID
  let registry: Registry

  @ComponentProxy var transform: TransformComponent = .init(
    position: .init(10, 10),
    scale: .unit * 3,
    rotation: .degrees(45)
  )
  @ComponentProxy var rigidBody: RigidBodyComponent = .init(velocity: .init(1, 0))
  @ComponentProxy var sprite: SpriteComponent = .init(textureAssetID: .tankSprite)

  init(id: EntityID, registry: Registry) {
    self.id = id
    self.registry = registry
  }
}

final class TruckEntity: Entity {
  let id: EntityID
  let registry: Registry

  @ComponentProxy var transform: TransformComponent = .init(position: .init(10, 10))
  @ComponentProxy var rigidBody: RigidBodyComponent = .init(velocity: .init(0, 0.5))
  @ComponentProxy var sprite: SpriteComponent = .init(textureAssetID: .truckSprite)

  init(id: EntityID, registry: Registry) {
    self.id = id
    self.registry = registry
  }
}

@MainActor
final class ExampleGame: GameProtocol {
  var isRunning: Bool = true

  var window: Window
  var renderer: Renderer
  var windowSize: ISize2

  @Environment(\.logger) private var logger
  @Environment(\.events) private var events

  let tank: TankEntity
  let truck: TruckEntity

  init() throws {
    @Environment(\.registry) var registry
    @Environment(\.assetStore) var assetStore

    self.windowSize = ISize2(width: 800, height: 600)
    self.window = try Window(
      title: "Hi There!",
      position: .centered,
      size: windowSize,
      options: [.openGL]
    )
    self.renderer = try Renderer(
      window: window,
      options: [.accelerated, .presentVSync, .targetTexture]
    )
    registry.addSystem(MovementSystem())
    registry.addSystem(RenderingSystem(renderer: renderer, assetStore: assetStore))

    try assetStore.addTexture(
      at: "/assets/images/tank-tiger-right.png",
      for: .tankSprite,
      with: renderer
    )
    try assetStore.addTexture(
      at: "/assets/images/truck-ford-down.png",
      for: .truckSprite,
      with: renderer
    )
    self.tank = try registry.createEntity(TankEntity.self)
    self.truck = try registry.createEntity(TruckEntity.self)
  }

  func update(deltaTime: LarkDuration) {
    for event in events() {
      switch event.kind {
      case .quit:
        isRunning = false
      case let .keyUp(info) where info.keyCode == .escape:
        isRunning = false
      case let .window(_, windowEvent):
        switch windowEvent {
        case let .resized(newSize):
          windowSize = newSize
        default:
          break
        }
      default:
        break
      }
    }
  }
}

@MainActor
@main
enum Run {
  static func main() async throws {
    try EnvironmentValues.withValues {
      $0.logger.logLevel = .info
      $0.resourcePath = Bundle.module.resourcePath
    } perform: {
      let engine = try Engine()
      try engine.run(ExampleGame())
    }
  }
}
