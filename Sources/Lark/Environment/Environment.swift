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
