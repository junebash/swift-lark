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

public typealias Point2<Value: Numeric> = Vector2<Value>
public typealias IVector2 = Vector2<Int32>
public typealias IPoint2 = Vector2<Int32>
public typealias FVector2 = Vector2<Float>
public typealias FPoint2 = Vector2<Float>

public struct Vector2<Value: Numeric> {
  public var x: Value
  public var y: Value

  @inlinable
  public init(x: Value = .zero, y: Value = .zero) {
    (self.x, self.y) = (x, y)
  }

  @inlinable
  public init(_ x: Value, _ y: Value) {
    self.init(x: x, y: y)
  }
}

extension Vector2: Equatable where Value: Equatable {}
extension Vector2: Hashable where Value: Hashable {}
extension Vector2: Sendable where Value: Sendable {}

extension Vector2: AdditiveArithmetic {
  @inlinable
  public static var zero: Self { Self(.zero, .zero) }

  @inlinable
  public static var unit: Self { Self(1, 1) }

  @inlinable
  public static func - (lhs: Vector2<Value>, rhs: Vector2<Value>) -> Vector2<Value> {
    Vector2(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
  }

  @inlinable
  public static func + (lhs: Vector2<Value>, rhs: Vector2<Value>) -> Vector2<Value> {
    Vector2(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
  }
}

public extension Vector2 {
  static func * (vec: Vector2, value: Value) -> Vector2 {
    Vector2(x: vec.x * value, y: vec.y * value)
  }

  static func *= (vec: inout Vector2, value: Value) {
    vec.x *= value
    vec.y *= value
  }

  // TODO:
}
