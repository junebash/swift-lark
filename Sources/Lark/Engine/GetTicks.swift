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

extension EnvironmentValues {
    public var getTicks32: Ticks {
        get { self[GetTicks32.self] }
        set { self[GetTicks32.self] = newValue }
    }

    public var getTicks64: Ticks {
        get { self[GetTicks64.self] }
        set { self[GetTicks64.self] = newValue }
    }
}
