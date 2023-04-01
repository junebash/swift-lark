public struct EnvironmentValues: Sendable {
    @TaskLocal static var current: EnvironmentValues = .init()

    internal var values: [ObjectIdentifier: any Sendable] = [:]

    public var events: Events = .init { Event.Poll() }
    public var updateClock: any Clock<Duration> = SuspendingClock()
}

@propertyWrapper
public struct Environment<Value> {
    public let keyPath: KeyPath<EnvironmentValues, Value>

    public var wrappedValue: Value {
        EnvironmentValues.current[keyPath: keyPath]
    }

    public init(_ keyPath: KeyPath<EnvironmentValues, Value>) {
        self.keyPath = keyPath
    }
}
