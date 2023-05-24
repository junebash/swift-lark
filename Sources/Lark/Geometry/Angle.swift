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

public struct Angle: Hashable {
  public var radians: Double

  public var degrees: Double {
    get { radians * Self.toDegreesMultiplier }
    set { radians = newValue * Self.toRadiansMultiplier }
  }

  private init(radians: Double) {
    self.radians = radians
  }

  public static func radians(_ value: Double) -> Angle {
    Angle(radians: value)
  }

  public static func degrees(_ value: Double) -> Angle {
    Angle(radians: value * Self.toRadiansMultiplier)
  }

  private static let toDegreesMultiplier: Double = 180.0 / .pi
  private static let toRadiansMultiplier: Double = .pi / 180.0
}

extension Angle: AdditiveArithmetic {
  public static let zero: Angle = .radians(0)

  public static func + (lhs: Angle, rhs: Angle) -> Angle {
    .radians(lhs.radians + rhs.radians)
  }

  public static func - (lhs: Angle, rhs: Angle) -> Angle {
    .radians(lhs.radians - rhs.radians)
  }

  public static func += (lhs: inout Angle, rhs: Angle) {
    lhs.radians += rhs.radians
  }

  public static func -= (lhs: inout Angle, rhs: Angle) {
    lhs.radians -= rhs.radians
  }
}

extension Angle {
  public static func * (angle: Angle, multiplier: Double) -> Angle {
    .radians(angle.radians * multiplier)
  }

  public static func * (angle: Angle, multiplier: some BinaryInteger) -> Angle {
    .radians(angle.radians * Double(multiplier))
  }
}
