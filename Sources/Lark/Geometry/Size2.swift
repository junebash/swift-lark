public struct Size2<Span: Numeric> {
    public var width: Span
    public var height: Span

    @inlinable
    public init(width: Span, height: Span) {
        self.width = width
        self.height = height
    }

    @inlinable
    public init() {
        self.init(width: .zero, height: .zero)
    }

    @inlinable
    public static var zero: Self { .init() }
}

extension Size2: Equatable where Span: Equatable {}
extension Size2: Hashable where Span: Hashable {}
extension Size2: Sendable where Span: Sendable {}

public typealias ISize2 = Size2<Int32>
public typealias FSize2 = Size2<Float>
