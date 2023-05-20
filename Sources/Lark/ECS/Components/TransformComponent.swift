public struct TransformComponent: Hashable, Component {
  public var position: FVector2
  public var scale: FVector2
  public var rotation: Double

  public init(
    position: FVector2 = .zero,
    scale: FVector2 = .unit,
    rotation: Double = .zero
  ) {
    self.position = position
    self.scale = scale
    self.rotation = rotation
  }

  public init() {
    self.init(position: .zero, scale: .zero, rotation: .zero)
  }
}
