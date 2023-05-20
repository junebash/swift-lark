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
import XPC

public struct LarkClock: Clock {
  public typealias Duration = LarkDuration

  public typealias Sleep = @Sendable (
    _ deadline: Instant,
    _ tolerance: LarkDuration?
  ) async throws -> Void

  public struct Instant: InstantProtocol {
    public typealias Getter = @Sendable () -> Instant
    public typealias Duration = LarkDuration

    public let offset: LarkDuration

    public init(offset: LarkDuration) {
      self.offset = offset
    }

    public func advanced(by duration: LarkDuration) -> Self {
      Instant(offset: offset + duration)
    }

    public func duration(to other: Self) -> LarkDuration {
      other.offset - offset
    }

    public static func < (lhs: LarkClock.Instant, rhs: LarkClock.Instant) -> Bool {
      lhs.offset < rhs.offset
    }
  }

  private let _now: Instant.Getter
  private let _sleep: Sleep

  public init(now: @escaping Instant.Getter, sleep: @escaping Sleep) {
    self._now = now
    self._sleep = sleep
  }

  public static let live: Self = {
    let now: Instant.Getter = { Instant(offset: .milliseconds(SDL_GetTicks64())) }
    return Self(
      now: now,
      sleep: { deadline, _ in SDL_Delay(UInt32(now().duration(to: deadline).milliseconds)) }
    )
  }()

  public var now: Instant { _now() }

  public var minimumResolution: LarkDuration { .zero }

  public func sleep(until deadline: Instant, tolerance: LarkDuration? = nil) async throws {}
}
