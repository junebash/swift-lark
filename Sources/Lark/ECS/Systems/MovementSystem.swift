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

@MainActor
public final class MovementSystem: System {
  public let componentSignature: ComponentSignature

  public var entityIDs: EntityIDStore = .init()

  @Environment(\.logger) private var logger

  public init() {
    self.componentSignature = ComponentSignature {
      $0.requireComponent(TransformComponent.self)
      $0.requireComponent(RigidBodyComponent.self)
    }
  }

  public func update(registry: __shared Registry, deltaTime: __shared LarkDuration) {
    for entityID in entityIDs {
      @SystemComponentProxy(registry: registry, entityID: entityID)
      var transform: TransformComponent

      @SystemComponentProxy(registry: registry, entityID: entityID)
      var rigidBody: RigidBodyComponent

      transform.position += rigidBody.velocity
      logger.trace("Position for \(entityID) is now \(transform.position)")
    }
  }
}
