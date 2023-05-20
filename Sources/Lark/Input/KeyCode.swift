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

import SDL2

public struct KeyCode: RawRepresentable, Hashable, Sendable {
  public var rawValue: UInt32

  public init(rawValue: UInt32) {
    self.rawValue = rawValue
  }

  internal init(_ sdlKeyCode: SDL_KeyCode) {
    self.rawValue = sdlKeyCode.rawValue
  }

  public static let backspace: Self = .init(SDLK_BACKSPACE)
  public static let tab: Self = .init(SDLK_TAB)
  public static let `return`: Self = .init(SDLK_RETURN)
  public static let escape: Self = .init(SDLK_ESCAPE)
  public static let space: Self = .init(SDLK_SPACE)
  public static let exclaim: Self = .init(SDLK_EXCLAIM)
  public static let doubleQuote: Self = .init(SDLK_QUOTEDBL)
  // TODO:
}
