import Clocks
import Logging

public struct EnvironmentValues: Sendable {
    @TaskLocal public static var current: EnvironmentValues = .init()

    @usableFromInline
    internal var values: [ObjectIdentifier: any Sendable] = [:]

    public let start: AnyClock<Duration>.Instant
    public var events: Events = .poll()
    public var updateClock: AnyClock<Duration> = AnyClock(SuspendingClock())
    public var getTicks: Ticks = .sdl64()

    public internal(set) var deltaTime: Duration = .zero

    public var logger: Logger = Logger(label: "Lark", level: .notice)

    public init() {
        start = updateClock.now
    }
}

extension EnvironmentValues {
    @inlinable
    public var fps: Double { 1.0 / deltaTime.fractionalSeconds }

    @inlinable
    public subscript<Key: EnvironmentKey>(key: Key.Type) -> Key.Value {
        get { values[ObjectIdentifier(key)] as? Key.Value ?? key.defaultValue }
        set { values[ObjectIdentifier(key)] = newValue }
    }
}

@propertyWrapper
public struct Environment<Value: Sendable>: @unchecked Sendable {
    public let keyPath: KeyPath<EnvironmentValues, Value>

    public var wrappedValue: Value {
        EnvironmentValues.current[keyPath: keyPath]
    }

    public init(_ keyPath: KeyPath<EnvironmentValues, Value>) {
        self.keyPath = keyPath
    }
}

public protocol EnvironmentKey<Value>: Sendable {
    associatedtype Value: Sendable

    static var defaultValue: Value { get }
}
