public protocol GameObject {
  mutating func processEvents(_ event: Event)
  mutating func update(deltaTime: Double)
  func draw(renderer: Renderer)
}

public extension GameObject {
  mutating func processEvents(_ event: Event) {}
  mutating func update(deltaTime: Double) {}
  func draw(renderer: Renderer) {}
}
