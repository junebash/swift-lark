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
public final class Registry {
  private var componentPools: [ObjectIdentifier: Any] = [:]
  public var systemsManager: SystemsManager = .init()
  private var entityLifetime: EntityLifetimeManager = .init()
  private var entityComponentSignatures: [Entity: ComponentSignature] = [:]

  public init() {}

  private func pool<C: Component>(for componentKey: C.Type) -> ComponentPool<C> {
    let key = ObjectIdentifier(C.self)
    if let pool = componentPools[key] as? ComponentPool<C> {
      return pool
    } else {
      let pool = ComponentPool<C>()
      componentPools[key] = pool
      return pool
    }
  }

  public func createEntity() -> Entity {
    let entity = entityLifetime.createEntity()
    entityComponentSignatures[entity] = .init()
    return entity
  }

  public func removeEntity(_: Entity) {}

  public func addComponent<C: Component>(_ component: C, for entity: Entity) {
    pool(for: C.self).set(component, for: entity)
    entityComponentSignatures[entity, default: .init()].requireComponent(C.self)
  }

  public func component<C: Component>(_: C.Type, for entity: Entity) -> C {
    fatalError()
  }

  public func removeComponent<C: Component>(_: C.Type, for entity: Entity) {
    entityComponentSignatures[entity]?.removeComponent(C.self)
//    pool(for: C.self).removeComponent(for: entity)
  }

  public func entity<C: Component>(_ entity: Entity, hasComponent: C.Type) -> Bool {
    entityComponentSignatures[entity]?.hasComponent(C.self) ?? false
  }

  private func addEntityToSystems(_ entity: Entity) {
    guard let signature = entityComponentSignatures[entity] else { return }
  }

  internal func update() {
    entityLifetime.withEntitiesToAdd { toAdd in
      for entity in toAdd {
        guard let signature = entityComponentSignatures[entity] else {
          assertionFailure("Entity \(entity.id) created without signature")
          continue
        }
        systemsManager.addEntity(entity, toSystemsWithSignature: signature)
      }
    }
    entityLifetime.withEntitiesToRemove { toRemove in
      for _ in toRemove {
        // TODO: Remove the entities that are waiting to be removed from the active systems
      }
    }
  }
}
