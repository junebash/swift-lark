public actor ActorIsolated<Value> {
    public var value: Value

    @inlinable
    public init(_ value: Value) {
        self.value = value
    }

    @inlinable
    public func withValue<T>(_ operation: @Sendable (inout Value) -> T) async -> T {
        operation(&value)
    }
}
