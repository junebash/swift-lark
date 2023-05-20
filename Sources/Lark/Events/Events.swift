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

public struct Events: Sequence, Sendable {
    public typealias Element = Event

    public struct Iterator: IteratorProtocol, Sendable {
        @usableFromInline
        internal var getEvent: (@Sendable () -> Event?)?

        @inlinable
        init(getEvent: (@Sendable () -> Event?)?) {
            self.getEvent = getEvent
        }

        @inlinable
        public mutating func next() -> Element? {
            guard let getEvent else { return nil }
            if let event = getEvent() {
                return event
            } else {
                self.getEvent = nil
                return nil
            }
        }
    }

    @usableFromInline
    internal let getEvent: @Sendable () -> Event?

    @inlinable
    public init(_ getEvent: @escaping @Sendable () -> Event?) {
        self.getEvent = getEvent
    }

    @inlinable
    public static func poll() -> Self {
        let poll = Event.Poll()
        return .init { poll.next() }
    }

    @inlinable
    public func makeIterator() -> Iterator {
        Iterator(getEvent: getEvent)
    }
}
