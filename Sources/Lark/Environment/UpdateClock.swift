import Clocks
import SDL2

extension EnvironmentValues {
    public var updateClock: LarkClock {
        get { self[UpdateClockKey.self] }
        set { self[UpdateClockKey.self] = newValue }
    }
}

private enum UpdateClockKey: EnvironmentKey {
  static let defaultValue: LarkClock = .live
}
