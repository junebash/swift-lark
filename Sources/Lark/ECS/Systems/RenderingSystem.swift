public final class RenderingSystem: System {
  public let componentSignature: ComponentSignature

  public init() {
    var sig = ComponentSignature()
    sig.requireComponent(<#T##Component.Protocol#>)
    self.componentSignature = sig
  }
}
