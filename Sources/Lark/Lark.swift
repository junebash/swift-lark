import SDL2

public final class Lark {
  public var framesPerSecond: UInt32
  public var targetMSPerFrame: UInt32 { 1000 / framesPerSecond }
  public private(set) var lastFrameTime: UInt32 = 0

  public init(framesPerSecond: UInt32 = 60) throws {
    try Result(code: SDL_Init(SDL_INIT_EVERYTHING)).get()
    self.framesPerSecond = framesPerSecond
  }

  deinit {
    SDL_Quit()
  }

  public func run<G: Game>(_ game: G, renderer: Renderer) {
    var game = game
    lastFrameTime = SDL_GetTicks()

    while game.isRunning {
      game.processEvents(Event.poll())

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
      game.draw(renderer: renderer)
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
