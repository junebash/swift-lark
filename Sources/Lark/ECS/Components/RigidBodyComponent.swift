public struct RigidBodyComponent: Hashable, Component {
  public var velocity: FVector2

  public init(velocity: FVector2) {
    self.velocity = velocity
  }

  public init() {
    self.velocity = .zero
  }
}
