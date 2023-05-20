import SDL2

public struct EngineInitOptions: OptionSet {
  public private(set) var rawValue: UInt32
  
  public init(rawValue: UInt32) {
    self.rawValue = rawValue
  }
  
  public static let timer: Self = .init(rawValue: SDL_INIT_TIMER)
  public static let audio: Self = .init(rawValue: SDL_INIT_AUDIO)
  public static let video: Self = .init(rawValue: SDL_INIT_VIDEO)
  public static let joystick: Self = .init(rawValue: SDL_INIT_JOYSTICK)
  public static let haptic: Self = .init(rawValue: SDL_INIT_HAPTIC)
  public static let gameController: Self = .init(rawValue: SDL_INIT_GAMECONTROLLER)
  public static let events: Self = .init(rawValue: SDL_INIT_EVENTS)
  public static let sensor: Self = .init(rawValue: SDL_INIT_SENSOR)
  public static let everything: Self = [.timer, .audio, .haptic, .gameController, .events, .sensor, .video]
}
