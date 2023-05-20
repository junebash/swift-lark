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

public struct Color: Sendable {
  @usableFromInline
  internal var sdlColor: SDL_Color

  @inlinable
  internal init(sdlColor: SDL_Color) {
    self.sdlColor = sdlColor
  }

  @inlinable
  internal static func _normalizeComponent(_ value: Float) -> UInt8 {
    UInt8(value.clamped(to: 0.0 ... 1.0) * ._uint8Max)
  }

  @inlinable
  internal static func _denormalizeComponent(_ value: UInt8) -> Float {
    Float(value) * ._uint8MaxReciprocal
  }
}

extension Color: Equatable {
  public static func == (lhs: Color, rhs: Color) -> Bool {
    return lhs.sdlColor.r == rhs.sdlColor.r
      && lhs.sdlColor.g == rhs.sdlColor.g
      && lhs.sdlColor.b == rhs.sdlColor.b
      && lhs.sdlColor.a == rhs.sdlColor.a
  }
}

extension Color: Hashable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(sdlColor.r)
    hasher.combine(sdlColor.g)
    hasher.combine(sdlColor.b)
    hasher.combine(sdlColor.a)
  }
}

public extension Color {
  @inlinable
  var red: UInt8 {
    _read { yield sdlColor.r }
    _modify { yield &sdlColor.r }
    set { sdlColor.r = newValue }
  }

  @inlinable
  var green: UInt8 {
    _read { yield sdlColor.g }
    _modify { yield &sdlColor.g }
    set { sdlColor.g = newValue }
  }

  @inlinable
  var blue: UInt8 {
    _read { yield sdlColor.b }
    _modify { yield &sdlColor.b }
    set { sdlColor.b = newValue }
  }

  @inlinable
  var alpha: UInt8 {
    _read { yield sdlColor.a }
    _modify { yield &sdlColor.a }
    set { sdlColor.a = newValue }
  }

  struct Floats {
    @usableFromInline
    internal let _or, _og, _ob, _oa: Float

    @usableFromInline
    internal var _nr, _ng, _nb, _na: Float?

    public var red: Float {
      _read { yield _nr ?? _or }
      set { _nr = newValue }
    }

    public var green: Float {
      _read { yield _ng ?? _og }
      set { _ng = newValue }
    }

    public var blue: Float {
      _read { yield _nb ?? _ob }
      set { _nb = newValue }
    }

    public var alpha: Float {
      _read { yield _na ?? _oa }
      set { _na = newValue }
    }

    @inlinable
    internal init(red: Float, green: Float, blue: Float, alpha: Float) {
      self._or = red
      self._og = green
      self._ob = blue
      self._oa = alpha
    }
  }

  @inlinable
  var floats: Floats {
    _read {
      yield Floats(
        red: Color._denormalizeComponent(red),
        green: Color._denormalizeComponent(green),
        blue: Color._denormalizeComponent(blue),
        alpha: Color._denormalizeComponent(alpha)
      )
    }
    set(newFloats) {
      if let red = newFloats._nr {
        self.red = Color._normalizeComponent(red)
      }
      if let green = newFloats._ng {
        self.green = Color._normalizeComponent(green)
      }
      if let blue = newFloats._nb {
        self.blue = Color._normalizeComponent(blue)
      }
      if let alpha = newFloats._na {
        self.alpha = Color._normalizeComponent(alpha)
      }
    }
  }

  init(red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8 = .max) {
    self.init(sdlColor: .init(r: red, g: green, b: blue, a: alpha))
  }

  @_disfavoredOverload
  init(red: Float, green: Float, blue: Float, alpha: Float = 1.0) {
    self.init(
      red: Color._normalizeComponent(red),
      green: Color._normalizeComponent(green),
      blue: Color._normalizeComponent(blue),
      alpha: Color._normalizeComponent(alpha)
    )
  }

  init(white: UInt8, alpha: UInt8 = .max) {
    self.init(red: white, green: white, blue: white, alpha: alpha)
  }

  @_disfavoredOverload
  init(white: Float, alpha: Float = 1.0) {
    self.init(red: white, green: white, blue: white, alpha: alpha)
  }
}
