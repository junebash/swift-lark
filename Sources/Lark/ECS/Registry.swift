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

public final class Registry {
  private var componentPools: [ObjectIdentifier: Any] = [:]
  private var systems: SystemsManager = .init()
  private var entityLifetime: EntityLifetimeManager = .init()
  private var entityComponentSignatures: [EntityID: ComponentSignature] = [:]

  @Environment(\.logger) var logger

  public nonisolated init() {}

  // MARK: - Public Methods

  public func createEntity<E: Entity>(_: E.Type) -> E {
    let entityID = entityLifetime.createEntityID()
    entityComponentSignatures[entityID] = .init()
    return E(id: entityID, registry: self)
  }

  public func removeEntity(_: some Entity) {}

  public func addComponent<C: Component>(_ component: C, for entity: EntityID) {
    pool(for: C.self).set(component, for: entity)
    entityComponentSignatures[entity, default: .init()].requireComponent(C.self)
    logger.info("Component \(C.self) added for entity \(entity)")
  }

  public func component<C: Component>(_: C.Type, for entity: EntityID) -> C? {
    pool(for: C.self).getComponent(for: entity)
  }

  public func withComponent<C: Component>(
    _: C.Type,
    for entity: EntityID,
    operation: (inout C) -> Void
  ) {
    pool(for: C.self).withComponent(for: entity, operation)
  }

  public func removeComponent<C: Component>(_: C.Type, for entityID: EntityID) {
    entityComponentSignatures[entityID]?.removeComponent(C.self)
//    pool(for: C.self).removeComponent(for: entity)
  }

  public func entity<C: Component>(_ entity: EntityID, hasComponent: C.Type) -> Bool {
    entityComponentSignatures[entity]?.hasComponent(C.self) ?? false
  }

  public func addSystem<S: System>(_: S.Type) {
    systems.addSystem(S())
  }

  public func removeSystem<S: System>(_: S.Type) {
    systems.removeSystem(S.self)
  }

  public func update(deltaTime: LarkDuration) {
    updateEntities()
    systems.update(deltaTime: deltaTime)
  }

  // MARK: - Private Methods

  private func updateEntities() {
    entityLifetime.withEntitiesToAdd { toAdd in
      for entityID in toAdd {
        guard let signature = entityComponentSignatures[entityID] else {
          assertionFailure("Entity \(entityID) created without signature")
          continue
        }
        systems.addEntity(entityID, toSystemsWithSignature: signature)
      }
    }
    entityLifetime.withEntitiesToRemove { toRemove in
      for _ in toRemove {
        // TODO: Remove the entities that are waiting to be removed from the active systems
      }
    }
  }

  private func addEntityToSystems(_ entityID: EntityID) {
    guard let signature = entityComponentSignatures[entityID] else { return }
    systems.addEntity(entityID, toSystemsWithSignature: signature)
  }

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
}

// MARK: - Environment

extension Registry: EnvironmentKey {
  public nonisolated static let defaultValue: Registry = .init()
}

public extension EnvironmentValues {
  var registry: Registry {
    get { self[Registry.self] }
    set { self[Registry.self] = newValue }
  }
}
