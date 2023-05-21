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

final class TankEntity: Entity {
  let id: EntityID
  let registry: Registry

  @ComponentProxy var transform: TransformComponent = .init(position: .init(10, 10))
  @ComponentProxy var rigidBody: RigidBodyComponent = .init(velocity: .init(1, 0))

  init(id: EntityID, registry: Registry) {
    self.id = id
    self.registry = registry
    _ = transform
    _ = rigidBody
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

  var tank: TankEntity

  init() throws {
    @Environment(\.registry) var registry

    //        let resourcePath = Bundle.module.resourcePath ?? ""
    self.windowSize = ISize2(width: 800, height: 600)
    self.window = try Window(
      title: "Hi There!",
      position: .centered,
      size: windowSize,
      options: [.openGL]
    )
    self.renderer = try Renderer(window: window, options: [.accelerated, .presentVSync, .targetTexture])

    self.tank = registry.createEntity(TankEntity.self)
  }

  func update(deltaTime: LarkDuration) {
    for event in events() {
//      logger.trace("\(event)")
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

    renderer.setColor(Color(red: 0, green: 0.8, blue: 0.8))
    try! renderer.clear()
  }
}

@MainActor
@main
enum Run {
  @Environment(\.registry) private static var registry

  static func main() async throws {
    try EnvironmentValues.withValues {
      $0.logger.logLevel = .trace
    } perform: {
      let engine = try Engine()
      registry.addSystem(MovementSystem.self)
      try engine.run(ExampleGame())
    }
  }
}
