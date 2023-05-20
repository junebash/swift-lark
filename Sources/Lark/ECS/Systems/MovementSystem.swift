public final class MovementSystem: System {
  public let componentSignature: ComponentSignature
  
  public var entities: Entities = .init()

  public init() {
    var sig = ComponentSignature()
    sig.requireComponent(TransformComponent.self)
    sig.requireComponent(<#T##Component.Protocol#>)

    self.componentSignature = sig
  }

  public func update(deltaTime: LarkDuration) {
    // loop entities that system is interested in
    // for entity in entities
    // update position based on velocity
  }
}
