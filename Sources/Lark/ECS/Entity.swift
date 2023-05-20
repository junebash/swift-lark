public struct Entity: Identifiable, Hashable {
  public typealias ID = UInt64

  public let id: ID

  public init(id: ID) {
    self.id = id
  }
}
