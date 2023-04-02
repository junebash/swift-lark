import Logging

extension Logger {
    public init(label: String, level: Logger.Level) {
        self.init(label: label)
        self.logLevel = level
    }
}
