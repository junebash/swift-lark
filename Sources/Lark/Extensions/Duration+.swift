extension Duration {
    @inlinable
    internal var fractionalSeconds: Double {
        Double(components.seconds) + (Double(components.attoseconds) * 0.000_000_000__000_000_001)
    }
}
