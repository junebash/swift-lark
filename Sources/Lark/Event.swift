import SDL2

public struct EventType: RawRepresentable, Equatable {
  private var sdlEventType: SDL_EventType

  public var rawValue: UInt32 {
    sdlEventType.rawValue
  }

  internal init(sdlEventType: SDL_EventType) {
    self.sdlEventType = sdlEventType
  }

  public init(rawValue: UInt32) {
    self.init(sdlEventType: .init(rawValue: rawValue))
  }

  public static var keyDown: EventType { .init(sdlEventType: SDL_KEYDOWN) }
  public static var keyUp: EventType { .init(sdlEventType: SDL_KEYUP) }
  public static var quit: EventType { .init(sdlEventType: SDL_QUIT) }
}

public enum Key {
  case left, right, escape

  internal var sdlKeyCode: SDL_KeyCode {
    switch self {
    case .left: return SDLK_LEFT
    case .right: return SDLK_RIGHT
    case .escape: return SDLK_ESCAPE
    }
  }

  init?(sdlKeyCode: SDL_KeyCode) {
    switch sdlKeyCode {
    case SDLK_LEFT: self = .left
    case SDLK_RIGHT: self = .right
    case SDLK_ESCAPE: self = .escape
    default: return nil
    }
  }
}


public struct Event {
  private var sdlEvent: SDL_Event

  public var type: EventType {
    EventType(rawValue: sdlEvent.type)
  }

  public var key: Key? {
    Key(sdlKeyCode: .init(UInt32(sdlEvent.key.keysym.sym)))
  }

  public init() {
    self.sdlEvent = .init()
  }

  internal init(sdlEvent: SDL_Event) {
    self.sdlEvent = sdlEvent
  }

  public static func poll() -> Event {
    var event = SDL_Event()
    SDL_PollEvent(&event)
    return Event(sdlEvent: event)
  }
}


public struct Events {
  private var sdlEvents: [SDL_Event] = []
}
