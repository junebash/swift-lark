public struct Rect2<Value: Numeric> {
    public var origin: Point2<Value>
    public var size: Size2<Value>

    @inlinable
    public init(origin: Point2<Value>, size: Size2<Value>) {
        self.origin = origin
        self.size = size
    }

    @inlinable
    public init(x: Value, y: Value, width: Value, height: Value) {
        self.init(
            origin: .init(x: x, y: y),
            size: .init(width: width, height: height)
        )
    }

    @inlinable
    public init() {
        self.init(origin: .zero, size: .zero)
    }

    @inlinable
    public static var zero: Self { .init() }
}

extension Rect2: Equatable where Value: Equatable {}
extension Rect2: Hashable where Value: Hashable {}
extension Rect2: Sendable where Value: Sendable {}

public typealias IRect2 = Rect2<Int32>
public typealias FRect2 = Rect2<Float>
