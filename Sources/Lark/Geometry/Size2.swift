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

public struct Size2<Span: Numeric> {
  public var width: Span
  public var height: Span

  @inlinable
  public init(width: Span, height: Span) {
    self.width = width
    self.height = height
  }

  @inlinable
  public init() {
    self.init(width: .zero, height: .zero)
  }

  @inlinable
  public static var zero: Self { .init() }
}

extension Size2 where Span: BinaryFloatingPoint {
  @inlinable
  public init<OtherSpan: BinaryInteger>(_ other: Size2<OtherSpan>) {
    self.init(width: Span(other.width), height: Span(other.height))
  }

  @inlinable
  public init<OtherSpan: BinaryFloatingPoint>(_ other: Size2<OtherSpan>) {
    self.init(width: Span(other.width), height: Span(other.height))
  }
}

extension Size2 where Span: BinaryInteger {
  @inlinable
  public init<OtherSpan: BinaryInteger>(_ other: Size2<OtherSpan>) {
    self.init(width: Span(other.width), height: Span(other.height))
  }

  @inlinable
  public init<OtherSpan: BinaryFloatingPoint>(_ other: Size2<OtherSpan>) {
    self.init(width: Span(other.width), height: Span(other.height))
  }
}

extension Size2: Equatable where Span: Equatable {}
extension Size2: Hashable where Span: Hashable {}
extension Size2: Sendable where Span: Sendable {}

extension Size2 {
  public static func * (size: Size2, scale: Vector2<Span>) -> Size2 {
    Size2(
      width: size.width * scale.x,
      height: size.height * scale.y
    )
  }
}

public typealias ISize2 = Size2<Int32>
public typealias FSize2 = Size2<Float>
