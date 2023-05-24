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

public struct Ticks: Sendable {
  @usableFromInline
  let getTicks: @Sendable () -> Duration

  @inlinable
  internal init(getTicks: @escaping @Sendable () -> Duration) {
    self.getTicks = getTicks
  }

  @inlinable
  internal static func sdl32() -> Self {
    Self { .milliseconds(SDL_GetTicks()) }
  }

  @inlinable
  internal static func sdl64() -> Self {
    Self { .milliseconds(SDL_GetTicks64()) }
  }

  @inlinable
  public func callAsFunction() -> Duration {
    getTicks()
  }

  @inlinable
  public func get() -> Duration {
    getTicks()
  }
}

private enum GetTicks32: EnvironmentKey {
  static let defaultValue: Ticks = .sdl32()
}

private enum GetTicks64: EnvironmentKey {
  static let defaultValue: Ticks = .sdl64()
}

public extension EnvironmentValues {
  var getTicks32: Ticks {
    get { self[GetTicks32.self] }
    set { self[GetTicks32.self] = newValue }
  }

  var getTicks64: Ticks {
    get { self[GetTicks64.self] }
    set { self[GetTicks64.self] = newValue }
  }
}