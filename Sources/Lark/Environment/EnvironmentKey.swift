public protocol EnvironmentKey<Value>: Sendable {
    associatedtype Value: Sendable = Self

    static var defaultValue: Value { get }
}
