import Clocks

public struct EnvironmentValues: Sendable {
  @TaskLocal public static var current: EnvironmentValues = .init()

  @usableFromInline
  internal var values: [ObjectIdentifier: any Sendable] = [:]

  public init() {}

  @inlinable
  public subscript<Key: EnvironmentKey>(key: Key.Type) -> Key.Value {
    get { values[ObjectIdentifier(key)] as? Key.Value ?? key.defaultValue }
    set { values[ObjectIdentifier(key)] = newValue }
  }

  public static func withValues<R>(
    _ update: (inout EnvironmentValues) -> Void,
    perform operation: () throws -> R
  ) rethrows -> R {
    var values = Self.current
    update(&values)
    return try EnvironmentValues.$current.withValue(values, operation: operation)
  }

  public static func withValues<R>(
    _ update: (inout EnvironmentValues) -> Void,
    perform operation: () async throws -> R
  ) async rethrows -> R {
    var values = Self.current
    update(&values)
    return try await EnvironmentValues.$current.withValue(values, operation: operation)
  }
}

/*
public struct Components: Sendable {
  @usableFromInline
  internal struct Key: Hashable, Sendable {
    let entityID: EntityID
    let componentObjectID: ObjectIdentifier

    @usableFromInline
    init(entityID: EntityID, componentObjectID: ObjectIdentifier) {
      self.entityID = entityID
      self.componentObjectID = componentObjectID
    }
  }

  @TaskLocal public static var current: Components = .init()

  @usableFromInline
  internal var values: [Key: any Sendable] = [:]

  public func getComponent<K: ComponentKey>(
    _ componentKey: K.Type,
    for entityID: EntityID
  ) -> K.Value {
    let key = Key(entityID: entityID, componentObjectID: ObjectIdentifier(K.self))
    if let component = values[key] as? K.Value {
      return component
    } else {

    }
  }

  public func removeComponent<K: ComponentKey>(
    _ componentKey: K.Type,
    for entityID: EntityID
  ) -> K.Value {

  }
}
*/
