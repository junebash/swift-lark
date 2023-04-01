public struct Size<Span: Numeric> {
    public var width: Span
    public var height: Span

    public init(width: Span, height: Span) {
        self.width = width
        self.height = height
    }
}
extension Size: Equatable where Span: Equatable {}
extension Size: Hashable where Span: Hashable {}

public typealias ISize = Size<Int32>
public typealias FSize = Size<Float>
