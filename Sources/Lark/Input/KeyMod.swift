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

public struct KeyMod: OptionSet, Sendable, Hashable {
    public var rawValue: UInt32

    public init(rawValue: UInt32) {
        self.rawValue = rawValue
    }

    public static let leftShift: Self = .init(rawValue: 0x0001)
    public static let rightShift: Self = .init(rawValue: 0x0002)
    public static let leftControl: Self = .init(rawValue: 0x0040)
    public static let rightControl: Self = .init(rawValue: 0x0080)
    public static let leftAlt: Self = .init(rawValue: 0x0100)
    public static let rightAlt: Self = .init(rawValue: 0x0200)
    public static let leftGUI: Self = .init(rawValue: 0x0400)
    public static let rightGUI: Self = .init(rawValue: 0x0800)
    public static let numLock: Self = .init(rawValue: 0x1000)
    public static let capsLock: Self = .init(rawValue: 0x2000)
    public static let mode: Self = .init(rawValue: 0x4000)
    public static let scroll: Self = .init(rawValue: 0x8000)

    public static let control: Self = .init(rawValue: leftControl.rawValue | rightControl.rawValue)
    public static let shift: Self = .init(rawValue: leftShift.rawValue | rightShift.rawValue)
    public static let alt: Self = .init(rawValue: leftAlt.rawValue | rightAlt.rawValue)
    public static let gui: Self = .init(rawValue: leftGUI.rawValue | rightGUI.rawValue)
}
