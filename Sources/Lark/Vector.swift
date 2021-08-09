import SDL2

public struct Vector2 {
  public var x: Double
  public var y: Double

  public init(x: Double, y: Double) {
    self.x = x
    self.y = y
  }
}

extension Vector2: AdditiveArithmetic {
  public static var zero: Vector2 {
    Vector2(x: 0, y: 0)
  }

  public static func - (lhs: Vector2, rhs: Vector2) -> Vector2 {
    Vector2(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
  }

  public static func + (lhs: Vector2, rhs: Vector2) -> Vector2 {
    Vector2(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
  }
}

extension Vector2 {
  public var magnitude: Double {
    sqrt((x * x) + (y * y))
  }

  public static func * (lhs: Vector2, rhs: Vector2) -> Vector2 {
    Vector2(x: lhs.x * rhs.x, y: lhs.y * rhs.y)
  }

  public static func *= (lhs: inout Vector2, rhs: Vector2) {
    lhs = lhs * rhs
  }

  public static func * (vector: Vector2, magnitude: Double) -> Vector2 {
    Vector2(x: vector.x * magnitude, y: vector.y * magnitude)
  }
}

extension Vector2 {
  public static let centeredWindowPosition = Vector2(
    x: Double(SDL_WINDOWPOS_CENTERED_MASK),
    y: Double(SDL_WINDOWPOS_CENTERED_MASK)
  )
  public static let undefinedWindowPosition = Vector2(
    x: Double(SDL_WINDOWPOS_UNDEFINED_MASK),
    y: Double(SDL_WINDOWPOS_UNDEFINED_MASK)
  )
}

public typealias Size = Vector2
