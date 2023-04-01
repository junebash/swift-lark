public protocol Send<Value>: Sendable {
    associatedtype Value

    func callAsFunction(_ value: Value) async
}
