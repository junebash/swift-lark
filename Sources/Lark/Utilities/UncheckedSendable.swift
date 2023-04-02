internal struct UncheckedSendable<Value>: @unchecked Sendable {
    @usableFromInline
    internal var value: Value

    @inlinable
    init(_ value: Value) {
        self.value = value
    }
}
