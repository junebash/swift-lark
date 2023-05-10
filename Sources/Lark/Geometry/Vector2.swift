public typealias Point2<Value: Numeric> = Vector2<Value>
public typealias IVector2 = Vector2<Int32>
public typealias IPoint2 = Vector2<Int32>
public typealias FVector2 = Vector2<Float>
public typealias FPoint2 = Vector2<Float>

public struct Vector2<Value: Numeric> {
    public var x: Value
    public var y: Value

    @inlinable
    public init(x: Value = .zero, y: Value = .zero) {
        (self.x, self.y) = (x, y)
    }

    @inlinable
    public init(_ x: Value, _ y: Value) {
        self.init(x: x, y: y)
    }

    @inlinable
    public init() {
        self.init(x: .zero, y: .zero)
    }
}

extension Vector2: Equatable where Value: Equatable {}
extension Vector2: Hashable where Value: Hashable {}
extension Vector2: Sendable where Value: Sendable {}

extension Vector2: AdditiveArithmetic {
    @inlinable
    public static var zero: Self { .init() }

    @inlinable
    public static func - (lhs: Vector2<Value>, rhs: Vector2<Value>) -> Vector2<Value> {
        Vector2(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }

    @inlinable
    public static func + (lhs: Vector2<Value>, rhs: Vector2<Value>) -> Vector2<Value> {
        Vector2(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
}

extension Vector2 {
    public static func * (vec: Vector2, value: Value) -> Vector2 {
        Vector2(x: vec.x * value, y: vec.y * value)
    }

    public static func *= (vec: inout Vector2, value: Value) {
        vec.x *= value
        vec.y *= value
    }

    // TODO
}
