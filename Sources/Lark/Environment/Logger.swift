import Logging

extension Logger: EnvironmentKey {
    public static let defaultValue: Self = Logger(label: "Lark", level: .notice)
}

extension EnvironmentValues {
    public var logger: Logger {
        get { self[Logger.self] }
        set { self[Logger.self] = newValue }
    }
}
