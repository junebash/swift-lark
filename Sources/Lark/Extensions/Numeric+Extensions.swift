extension FloatingPoint {
    @inlinable
    public func clamped(to range: ClosedRange<Self>) -> Self {
        var newValue = self
        newValue.clamp(to: range)
        return newValue
    }

    @inlinable
    public mutating func clamp(to range: ClosedRange<Self>) {
        switch self {
        case range.upperBound...:
            self = range.upperBound
        case ..<range.lowerBound:
            self = range.lowerBound
        default:
            return
        }
    }
}

extension Float {
    @usableFromInline
    internal static let _uint8Max: Float = 255.0

    @usableFromInline
    internal static let _uint8MaxReciprocal: Float = 0.0039215686274509803921568627450980392156862745098039215686274509
}

extension Numeric {
    public var nonZero: Self? { self == .zero ? nil : self }
}

extension SignedNumeric where Self: Comparable {
    public var positive: Self? { self > .zero ? self : nil }
}
