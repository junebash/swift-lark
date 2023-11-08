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

import Lark

final class TestScene: Scene {
  let tank: TankEntity
  let truck: TruckEntity
  let assetStore: AssetStore

  @Proxy var isRunning: Bool

  @Environment(\.events) private var events

  init(
    assetStore: AssetStore,
    renderer: Renderer,
    registry: Registry,
    isRunning: Proxy<Bool>
  ) throws {
    self.assetStore = assetStore

    self._isRunning = isRunning
    try assetStore.addTexture(for: .tankSprite, with: renderer)
    try assetStore.addTexture(for: .truckSprite, with: renderer)


    self.tank = try registry.createEntity(TankEntity.self)
    self.truck = try registry.createEntity(TruckEntity.self)
  }

  deinit {
    // TODO: - isolated deinit
    Task { @MainActor [assetStore] in
      assetStore.clear(keepingCapacity: true)
    }
  }

  func update(deltaTime: LarkDuration) throws {
    for event in events() {
      switch event.kind {
      case .quit:
        isRunning = false
      case let .keyUp(info) where info.keyCode == .escape:
        isRunning = false
      default:
        break
      }
    }
  }
}
