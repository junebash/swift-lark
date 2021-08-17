public protocol GameObject: Drawable {
  mutating func processEvent(_ event: Event)
  mutating func update(deltaTime: Double)
}

public extension GameObject {
  mutating func processEvent(_ event: Event) {}
  mutating func update(deltaTime: Double) {}
  func draw(renderer: Renderer) {}
}
