extension Duration {
    @inlinable
    public var fractionalSeconds: Float {
        Float(components.seconds) + (Float(components.attoseconds) * 0.000_000_000__000_000_001)
    }
}
