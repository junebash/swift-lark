import IdentifiedCollections

public protocol System: AnyObject {
  var componentSignature: ComponentSignature { get }
  var entities: Entities { get set }

  init()
}

extension System {
  @inlinable
  internal static var typeID: ObjectIdentifier { ObjectIdentifier(Self.self) }

  @inlinable
  public func canOperate(on otherSignature: ComponentSignature) -> Bool {
    self.componentSignature.isSubset(of: otherSignature)
  }
}

public struct Entities {
  public private(set) var values: Set<Entity> = []

  public init() {}

  public mutating func add(_ entity: Entity) {
    values.insert(entity)
  }

  public mutating func remove(_ entity: Entity) {
    values.remove(entity)
  }
}
