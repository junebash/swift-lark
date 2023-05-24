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

import Foundation
import SDL2

public struct Events: Sendable {
  private var _getEvents: @Sendable () -> [Event]

  public init(getEvents: @escaping @Sendable () -> [Event]) {
    self._getEvents = getEvents
  }

  public func callAsFunction() -> [Event] {
    autoreleasepool { _getEvents() }
  }
}

extension EnvironmentValues {
  public var events: Events {
    get { self[EventsKey.self] }
    set { self[EventsKey.self] = newValue }
  }
}

private enum EventsKey: EnvironmentKey {
  typealias Value = Events

  static let defaultValue: Events = Events { Array(Event.Poll()) }
}

extension Event {
  @usableFromInline
  struct Poll: Sequence, IteratorProtocol, Sendable {
    @inlinable
    internal init() {}

    @inlinable
    internal func next() -> Event? {
      var sdlEvent = SDL_Event()
      guard SDL_PollEvent(&sdlEvent) == 1 else { return nil }
      return Event(event: sdlEvent)
    }
  }
}
