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

public extension FloatingPoint {
    @inlinable
    func clamped(to range: ClosedRange<Self>) -> Self {
        var newValue = self
        newValue.clamp(to: range)
        return newValue
    }

    @inlinable
    mutating func clamp(to range: ClosedRange<Self>) {
        switch self {
        case range.upperBound...:
            self = range.upperBound
        case ..<range.lowerBound:
            self = range.lowerBound
        default:
            return
        }
    }
}

extension Float {
    @usableFromInline
    static let _uint8Max: Float = 255.0

    @usableFromInline
    static let _uint8MaxReciprocal: Float = 0.0039215686274509803921568627450980392156862745098039215686274509
}

public extension Numeric {
    var nonZero: Self? { self == .zero ? nil : self }
}

public extension SignedNumeric where Self: Comparable {
    var positive: Self? { self > .zero ? self : nil }
}
