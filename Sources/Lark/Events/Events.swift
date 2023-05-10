import SDL2

extension Event {
    @usableFromInline
    internal struct Poll: Sequence, IteratorProtocol, Sendable {
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
