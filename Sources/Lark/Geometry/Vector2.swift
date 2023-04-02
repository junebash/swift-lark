public typealias Point2<Value: Numeric> = Vector2<Value>
public typealias IVector2 = Vector2<Int32>
public typealias IPoint2 = Vector2<Int32>
public typealias FVector2 = Vector2<Float>
public typealias FPoint2 = Vector2<Float>

public struct Vector2<Value: Numeric> {
    public var x: Value
    public var y: Value

    @inlinable
    public init(x: Value, y: Value) {
        (self.x, self.y) = (x, y)
    }

    @inlinable
    public init() {
        self.init(x: .zero, y: .zero)
    }

    @inlinable
    public static var zero: Self { .init() }
}

extension Vector2: Equatable where Value: Equatable {}
extension Vector2: Hashable where Value: Hashable {}
extension Vector2: Sendable where Value: Sendable {}
