public typealias Point2<Value: Numeric> = Vector2<Value>
public typealias Point<Value: Numeric> = Vector2<Value>
public typealias Vector<Value: Numeric> = Vector2<Value>
public typealias IVector = Vector2<Int32>
public typealias IPoint = Vector2<Int32>
public typealias FVector = Vector2<Float>
public typealias FPoint = Vector2<Float>

public struct Vector2<Value: Numeric> {
    public let x: Value
    public let y: Value

    public init(x: Value, y: Value) {
        self.x = x
        self.y = y
    }
}

extension Vector2: Equatable where Value: Equatable {}
extension Vector2: Hashable where Value: Hashable {}
