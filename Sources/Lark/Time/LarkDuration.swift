// Copyright (c) 2023 June Bash
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

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

public extension LarkDuration {
  @inlinable
  static func seconds(_ seconds: some BinaryInteger) -> Self {
    Self(seconds: Float(seconds))
  }

  @inlinable
  static func seconds(_ seconds: some BinaryFloatingPoint) -> Self {
    Self(seconds: Float(seconds))
  }

  @inlinable
  static func milliseconds(_ milliseconds: some BinaryInteger) -> Self {
    Self(seconds: Float(milliseconds) * 0.001)
  }

  @inlinable
  static func milliseconds(_ milliseconds: some BinaryFloatingPoint) -> Self {
    Self(seconds: Float(milliseconds) * 0.001)
  }

  static let fps120: Self = .init(seconds: 1 / 120)
  static let fps60: Self = .init(seconds: 1 / 60)
  static let fps30: Self = .init(seconds: 1 / 30)
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
