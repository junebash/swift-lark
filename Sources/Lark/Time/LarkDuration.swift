public struct LarkDuration: Hashable, Sendable {
  public var seconds: Float

  public var milliseconds: Float { seconds * 1000 }

  public init(seconds: Float) {
    self.seconds = seconds
  }

  public var swiftDuration: Duration {
    .seconds(Double(seconds))
  }
}

extension LarkDuration {
  @inlinable
  public static func seconds(_ seconds: some BinaryInteger) -> Self {
    Self(seconds: Float(seconds))
  }

  @inlinable
  public static func seconds(_ seconds: some BinaryFloatingPoint) -> Self {
    Self(seconds: Float(seconds))
  }

  @inlinable
  public static func milliseconds(_ milliseconds: some BinaryInteger) -> Self {
    Self(seconds: Float(milliseconds) * 0.001)
  }

  @inlinable
  public static func milliseconds(_ milliseconds: some BinaryFloatingPoint) -> Self {
    Self(seconds: Float(milliseconds) * 0.001)
  }

  public static let fps120: Self = .init(seconds: 1 / 120)
  public static let fps60: Self = .init(seconds: 1 / 60)
  public static let fps30: Self = .init(seconds: 1 / 30)
}

extension LarkDuration: Comparable {
  public static func < (lhs: LarkDuration, rhs: LarkDuration) -> Bool {
    lhs.seconds < rhs.seconds
  }
}

extension LarkDuration: AdditiveArithmetic {
  public static var zero: LarkDuration { .init(seconds: 0) }

  public static func - (lhs: LarkDuration, rhs: LarkDuration) -> LarkDuration {
    .init(seconds: lhs.seconds - rhs.seconds)
  }

  public static func + (lhs: LarkDuration, rhs: LarkDuration) -> LarkDuration {
    .init(seconds: lhs.seconds + rhs.seconds)
  }
}

extension LarkDuration: DurationProtocol {
  public static func / (lhs: LarkDuration, rhs: Int) -> LarkDuration {
    .init(seconds: lhs.seconds / Float(rhs))
  }

  public static func * (lhs: LarkDuration, rhs: Int) -> LarkDuration {
    .init(seconds: lhs.seconds * Float(rhs))
  }

  public static func / (lhs: LarkDuration, rhs: LarkDuration) -> Double {
    Double(lhs.seconds) / Double(rhs.seconds)
  }
}
