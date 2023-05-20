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

public struct Rect2<Value: Numeric> {
    public var origin: Point2<Value>
    public var size: Size2<Value>

    @inlinable
    public init(origin: Point2<Value>, size: Size2<Value>) {
        self.origin = origin
        self.size = size
    }

    @inlinable
    public init(x: Value, y: Value, width: Value, height: Value) {
        self.init(
            origin: .init(x: x, y: y),
            size: .init(width: width, height: height)
        )
    }

    @inlinable
    public init() {
        self.init(origin: .zero, size: .zero)
    }

    @inlinable
    public static var zero: Self { .init() }
}

extension Rect2: Equatable where Value: Equatable {}
extension Rect2: Hashable where Value: Hashable {}
extension Rect2: Sendable where Value: Sendable {}

public typealias IRect2 = Rect2<Int32>
public typealias FRect2 = Rect2<Float>
