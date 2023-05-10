import Clocks

public struct EnvironmentValues: Sendable {
    @TaskLocal public static var current: EnvironmentValues = .init()

    @usableFromInline
    internal var values: [ObjectIdentifier: any Sendable] = [:]

    public init() {}

    @inlinable
    public subscript<Key: EnvironmentKey>(key: Key.Type) -> Key.Value {
        get { values[ObjectIdentifier(key)] as? Key.Value ?? key.defaultValue }
        set { values[ObjectIdentifier(key)] = newValue }
    }

    public static func withValues<R>(
        _ update: (inout EnvironmentValues) -> Void,
        perform operation: () throws -> R
    ) rethrows -> R {
        var values = Self.current
        update(&values)
        return try EnvironmentValues.$current.withValue(values, operation: operation)
    }

    public static func withValues<R>(
        _ update: (inout EnvironmentValues) -> Void,
        perform operation: () async throws -> R
    ) async rethrows -> R {
        var values = Self.current
        update(&values)
        return try await EnvironmentValues.$current.withValue(values, operation: operation)
    }
}
