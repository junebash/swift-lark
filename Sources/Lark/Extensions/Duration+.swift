extension Duration {
  @inlinable
  public func fractionalSeconds<T: BinaryFloatingPoint>(_: T.Type = Float.self) -> T {
    T(components.seconds) + (T(components.attoseconds) * 0.000_000_000__000_000_001)
  }
}
