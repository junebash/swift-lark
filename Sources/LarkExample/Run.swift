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

extension Asset where AssetType == Texture {
  static var tankSprite: Asset {
    Asset(id: "tankSprite", path: "/assets/images/tank-tiger-right.png")
  }

  static var truckSprite: Asset {
    Asset(id: "truckSprite", path: "/assets/images/truck-ford-down.png")
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

//  let registry: Registry
//  let assetStore: AssetStore
//
  var activeScene: (any Scene)?

  init(registry: Registry, assetStore: AssetStore) throws {
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

    self.activeScene = try TestScene(
      assetStore: assetStore,
      renderer: renderer,
      registry: registry,
      isRunning: Proxy(weak: self, \.isRunning)
    )
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
      let assetStore = AssetStore()
      try engine.run(ExampleGame(registry: engine.registry, assetStore: assetStore))
    }
  }
}
