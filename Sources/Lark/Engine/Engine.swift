import AsyncAlgorithms
import Clocks
import Foundation
import Logging
import SDL2

@MainActor
public final class Engine {
  public struct Configuration: Equatable {
    public var initOptions: EngineInitOptions = .everything
    public var logFrameTiming: Bool = false
    public var targetFrameDuration: LarkDuration = .fps60

    public init() {}
  }

  public let registry: Registry = .init()
  public let configuration: Configuration

  public init(configuration: Configuration) {
    self.configuration = configuration
  }

  public func run(_ game: __owned some GameProtocol) {
    @Environment(\.logger) var logger
    @Environment(\.updateClock) var updateClock

    logger.trace("Running game engine")
    defer {
      logger.trace("Engine finished running")
    }

    do {
      try withThrowingSDL {
        SDL_Init(configuration.initOptions.rawValue)
      }
    } catch {
      logger.error("Error setting up engine: \(error)")
      return
    }

    var lastUpdate = updateClock.now
    var currentState = game

    logger.trace("Starting game loop")
    do {
      while currentState.isRunning {
        let frameStart = updateClock.now
        let deltaTime = lastUpdate.duration(to: frameStart)
        lastUpdate = frameStart
        currentState.update(deltaTime: deltaTime)

        // movementSystem.update()
        // collisionSystem.update()
        // damageSystem.update()
//        let frameEnd = updateClock.now
//        let leftoverTime = configuration.targetFrameDuration - frameStart.duration(to: frameEnd)
//        if leftoverTime > .zero {
//          updateClock.sleep(for: leftoverTime)
//        }
      }
    } catch {
      logger.error("Error in game loop: \(error)")
      return
    }
  }

  deinit {
    quit()
  }
}

extension Engine {
  public func run(configuration: EngineConfiguration) {

  }

  public func run() {
    self.run(configuration: EngineConfiguration())
  }

  public nonisolated func quit() {
    SDL_Quit()
    EnvironmentValues.current.logger.trace("Engine quit")
  }
}
