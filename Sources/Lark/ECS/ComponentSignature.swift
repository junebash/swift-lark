import BitCollections

public struct ComponentSignature: Equatable, Configurable {
  public var components: Set<ObjectIdentifier> = []

  public init() {}

  public mutating func requireComponent<T: Component>(_: T.Type) {
    components.insert(T.objectID)
  }

  public mutating func removeComponent<T: Component>(_: T.Type) {
    components.remove(T.objectID)
  }

  public func hasComponent<T: Component>(_: T.Type) -> Bool {
    components.contains(T.objectID)
  }

  public func isSubset(of other: ComponentSignature) -> Bool {
    components.isSubset(of: other.components)
  }
}
