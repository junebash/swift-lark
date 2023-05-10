private enum EventsKey: EnvironmentKey {
    static let defaultValue: Events = .poll()
}

extension EnvironmentValues {
    public var events: Events {
        get { self[EventsKey.self] }
        set { self[EventsKey.self] = newValue }
    }
}
