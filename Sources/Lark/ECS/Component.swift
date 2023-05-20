public protocol Component {}

extension Component {
  @inlinable
  static var objectID: ObjectIdentifier { ObjectIdentifier(Self.self) }
}
