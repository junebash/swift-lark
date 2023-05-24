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

public final class RenderingSystem: System {
  public var entityIDs: EntityIDStore = .init()
  public let componentSignature: ComponentSignature

  private let renderer: Renderer
  private let assetStore: AssetStore

  public init(renderer: Renderer, assetStore: AssetStore) {
    self.componentSignature = ComponentSignature {
      $0.requireComponent(TransformComponent.self)
      $0.requireComponent(SpriteComponent.self)
    }
    self.renderer = renderer
    self.assetStore = assetStore
  }

  public func update(registry: __shared Registry, deltaTime: __shared LarkDuration) throws {
    renderer.setColor(Color(red: 0, green: 0.1, blue: 0.1))
    try renderer.clear()

    for entityID in entityIDs {
      @SystemComponentProxy(registry: registry, entityID: entityID)
      var transform: TransformComponent

      @SystemComponentProxy(registry: registry, entityID: entityID)
      var sprite: SpriteComponent

      let texture = try assetStore.texture(for: sprite.textureAssetID).orThrow()

      try renderer.renderCopy(
        texture,
        source: sprite.source,
        destination: Rect(
          origin: transform.position,
          size: FSize2(texture.size) * transform.scale
        ),
        rotation: transform.rotation,
        center: sprite.rotationCenter,
        flip: sprite.flip
      )
    }

    renderer.present()
  }
}
