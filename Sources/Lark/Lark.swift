import SDL2
import OSLog

public final class Lark {
  public var framesPerSecond: UInt32
  public var targetMSPerFrame: UInt32 { 1000 / framesPerSecond }
  public private(set) var lastFrameTime: UInt32 = 0
  public let logger: Logger

  public init(framesPerSecond: UInt32 = 60, logger: Logger = Logger()) throws {
    do {
      try Result(code: SDL_Init(SDL_INIT_EVERYTHING)).get()
    } catch {
      logger.critical("Error initializing Lark engine: \(error.localizedDescription)")
      throw error
    }
    self.framesPerSecond = framesPerSecond
    self.logger = logger
  }

  deinit {
    SDL_Quit()
  }

  public func run<G: Game>(_ game: G, renderer: Renderer?) {
    var game = game
    lastFrameTime = SDL_GetTicks()
    let render: (G) -> Void = renderer.map({ renderer in { renderer.draw($0) } })
      ?? { _ in }

    while game.isRunning {
      let events = Event.polled()
      for event in events {
        game.processEvent(event)
      }

      // TODO: use async/await
      let (timeToWait, overflow) = targetMSPerFrame
        .subtractingReportingOverflow(SDL_GetTicks() - lastFrameTime)
      if !overflow && timeToWait <= targetMSPerFrame {
        SDL_Delay(timeToWait)
      }

      let ticks = SDL_GetTicks()
      let deltaTime = Double(ticks - lastFrameTime) / 1000.0
      lastFrameTime = ticks

      game.update(deltaTime: deltaTime)
      render(game)
    }
  }
}

let SDL_INIT_EVERYTHING: UInt32 = SDL_INIT_TIMER
  | SDL_INIT_AUDIO
  | SDL_INIT_VIDEO
  | SDL_INIT_EVENTS
  | SDL_INIT_JOYSTICK
  | SDL_INIT_HAPTIC
  | SDL_INIT_GAMECONTROLLER
  | SDL_INIT_SENSOR
