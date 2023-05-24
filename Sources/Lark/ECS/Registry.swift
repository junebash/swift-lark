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
public final class Registry: Sendable {
  private var componentPools: ComponentPoolManager = .init()
  private var systems: SystemsManager = .init()
  private var entityLifetime: EntityLifetimeManager = .init()
  private var entityComponentSignatures: [EntityID: ComponentSignature] = [:]

  @Environment(\.logger) var logger

  public nonisolated init() {}

  // MARK: - Public Methods

  public func createEntity<E: Entity>(_: E.Type) throws -> E {
    let entityID = entityLifetime.createEntityID()
    entityComponentSignatures[entityID] = .init()
    let entity = E(id: entityID, registry: self)

    // initialize proxies
    let mirror = Mirror(reflecting: entity)
    for child in mirror.children {
      guard let proxy = child.value as? any _Proxy else { continue }
      _ = proxy.initializeStorage(instance: entity, registry: self)
    }

    return entity
  }

  public func removeEntity(_: some Entity) {}

  public func removeComponent<C: Component>(_: C.Type, for entityID: EntityID) {
    entityComponentSignatures[entityID]?.removeComponent(C.self)
//    pool(for: C.self).removeComponent(for: entity)
  }

  public func entity<C: Component>(_ entity: EntityID, hasComponent: C.Type) -> Bool {
    entityComponentSignatures[entity]?.hasComponent(C.self) ?? false
  }

  public func addSystem<S: System>(_ system: S) {
    systems.addSystem(system)
  }

  public func removeSystem<S: System>(_: S.Type) {
    systems.removeSystem(S.self)
  }

  public func update(deltaTime: LarkDuration) throws {
    updateEntities()
    try systems.update(registry: self, deltaTime: deltaTime)
  }

  // MARK: - Internal Methods

  internal subscript<C: Component>(
    _: C.Type,
    for entityID: EntityID
  ) -> C {
    _read { yield componentPools.pool(for: C.self)[entityID: entityID] }
    _modify { yield &componentPools.pool(for: C.self)[entityID: entityID] }
    set { componentPools.pool(for: C.self)[entityID: entityID] = newValue }
  }

  internal func addComponent<C: Component>(_ component: C, for entity: EntityID) {
    componentPools.pool(for: C.self).set(component, for: entity)
    entityComponentSignatures[entity, default: .init()].requireComponent(C.self)
    logger.info("Component \(C.self) added for entity \(entity)")
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
}
