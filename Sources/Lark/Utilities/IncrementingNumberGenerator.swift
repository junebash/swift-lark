public struct IncrementingNumberGenerator: RandomNumberGenerator {
  public var currentValue: UInt64

  public init(initialValue: UInt64 = 0) {
    self.currentValue = initialValue
  }

  public mutating func next() -> UInt64 {
    defer { currentValue &+= 1 }
    return currentValue
  }
}
