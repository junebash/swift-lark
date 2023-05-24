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

final class TankEntity: Entity {
  let id: EntityID
  let registry: Registry

  @ComponentProxy var transform: TransformComponent = .init(
    position: .init(10, 10),
    scale: .unit * 3,
    rotation: .degrees(45)
  )
  @ComponentProxy var rigidBody: RigidBodyComponent = .init(velocity: .init(1, 0))
  @ComponentProxy var sprite: SpriteComponent = .init(textureAssetID: Asset.tankSprite.id)

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
  @ComponentProxy var sprite: SpriteComponent = .init(textureAssetID: Asset.truckSprite.id)

  init(id: EntityID, registry: Registry) {
    self.id = id
    self.registry = registry
  }
}
