import SDL2

public struct Rectangle {
  public var origin: Vector2
  public var size: Size

  public var x: Double { origin.x }
  public var y: Double { origin.y }
  public var width: Double { size.x }
  public var height: Double { size.y }

  public init(origin: Vector2, size: Size) {
    self.origin = origin
    self.size = size
  }

  public init(x: Double, y: Double, width: Double, height: Double) {
    self.init(origin: .init(x: x, y: y), size: .init(x: width, y: height))
  }

  init(sdlRect: SDL_Rect) {
    self.init(
      origin: Vector2(x: Double(sdlRect.x), y: Double(sdlRect.y)),
      size: Size(x: Double(sdlRect.w), y: Double(sdlRect.h))
    )
  }
}
