public final class ComponentPool<C: Component> {
  public private(set) var values: [Entity: C] = [:]

  public var count: Int { values.count }

  public init() {}

  public func set(_ component: C, for entity: Entity) {
    values[entity] = component
  }

  public func getComponent(for entity: Entity) -> C? {
    values[entity]
  }

  public func removeComponent(for entity: Entity) {
    values.removeValue(forKey: entity)
  }

  public func clear() {
    values.removeAll(keepingCapacity: true)
  }
}
