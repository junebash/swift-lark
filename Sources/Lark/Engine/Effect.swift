public protocol Effect<Value>: Sendable {
    associatedtype Value

    func run(_ send: some Send<Value>) async
}

public struct Run<Value>: Effect {
    private let _run: @Sendable (any Send<Value>) async -> Void

    public init(_ run: @escaping @Sendable (any Send<Value>) async -> Void) {
        self._run = run
    }

    public func run(_ send: some Send<Value>) async {
        await _run(send)
    }
}

public struct None<Value>: Effect {
    public func run(_ send: some Send<Value>) {}
}
