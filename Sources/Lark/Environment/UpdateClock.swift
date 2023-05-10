import Clocks
import SDL2

extension EnvironmentValues {
    public var updateClock: AnyClock<Duration> {
        get { self[UpdateClockKey.self] }
        set { self[UpdateClockKey.self] = newValue }
    }

    public var start: AnyClock<Duration>.Instant {
        self[StartKey.self]
    }

    public var ticks: Ticks {
        get { self[Ticks.self] }
        set { self[Ticks.self] = newValue }
    }
}

private enum UpdateClockKey: EnvironmentKey {
    static let defaultValue: AnyClock<Duration> = .init(SuspendingClock())
}

private enum StartKey: EnvironmentKey {
    static let defaultValue: AnyClock<Duration>.Instant = EnvironmentValues.current
        .updateClock.now
        .advanced(by: .nanoseconds(SDL_GetTicks64()) * -1)
}

@usableFromInline
enum DeltaTimeKey: EnvironmentKey {
    @usableFromInline
    static let defaultValue: Duration = .zero
}

extension Ticks: EnvironmentKey {
    public static let defaultValue: Ticks = .sdl64()
}
