import SDL2
import XPC

public struct LarkClock: Clock {
  public typealias Duration = LarkDuration

  public typealias Sleep = @Sendable (
    _ deadline: Instant,
    _ tolerance: LarkDuration?
  ) async throws -> Void

  public struct Instant: InstantProtocol {
    public typealias Getter = @Sendable () -> Instant
    public typealias Duration = LarkDuration

    public let offset: LarkDuration

    public init(offset: LarkDuration) {
      self.offset = offset
    }

    public func advanced(by duration: LarkDuration) -> Self {
      Instant(offset: offset + duration)
    }

    public func duration(to other: Self) -> LarkDuration {
      other.offset - offset
    }

    public static func < (lhs: LarkClock.Instant, rhs: LarkClock.Instant) -> Bool {
      lhs.offset < rhs.offset
    }
  }

  private let _now: Instant.Getter
  private let _sleep: Sleep

  public init(now: @escaping Instant.Getter, sleep: @escaping Sleep) {
    self._now = now
    self._sleep = sleep
  }

  public static let live: Self = {
    let now: Instant.Getter = { Instant(offset: .milliseconds(SDL_GetTicks64())) }
    return Self(
        now: now,
        sleep: { deadline, _ in SDL_Delay(UInt32(now().duration(to: deadline).milliseconds)) }
      )
  }()

  public var now: Instant { _now() }

  public var minimumResolution: LarkDuration { .zero }

  public func sleep(until deadline: Instant, tolerance: LarkDuration? = nil) async throws {
  }
}
