public struct EntityLifetimeManager {
  @Environment(\.logger) var logger

  private var entityCount: UInt64 = 0
  private var entitiesToBeAdded: [Entity] = []
  private var entitiesToBeRemoved: [Entity] = []

  public mutating func createEntity() -> Entity {
    defer { entityCount += 1 }

    let entity = Entity(id: entityCount)
    entitiesToBeAdded.append(entity)

    logger.log(level: .info, "Entity created with ID: \(entity.id)")

    return entity
  }

  public mutating func withEntitiesToAdd(_ operation: (_ toAdd: [Entity]) -> Void) {
    operation(entitiesToBeAdded)
    entitiesToBeAdded.removeAll(keepingCapacity: true)
  }

  public mutating func withEntitiesToRemove(_ operation: (_ toRemove: [Entity]) -> Void) {
    operation(entitiesToBeRemoved)
    entitiesToBeRemoved.removeAll(keepingCapacity: true)
  }

  public mutating func removeEntity(_ entity: Entity) {
    entitiesToBeRemoved.append(entity)
    logger.log(level: .info, "Removing entity with ID: \(entity.id)")
  }
}
