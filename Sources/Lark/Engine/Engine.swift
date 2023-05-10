import AsyncAlgorithms
import Clocks
import Foundation
import Logging
import SDL2

public struct EngineConfiguration: Equatable {
    public var initOptions: EngineInitOptions = .everything
    public var logFrameTiming: Bool = false
    public var frameDuration: Duration = .seconds(1.0 / 60.0)

    public init() {}
}

@MainActor
public protocol Engine<Game>: AnyObject {
    associatedtype Game: GameProtocol

    func run(configuration: EngineConfiguration) async

    nonisolated func quit()
}

extension Engine {
    public func run(configuration: EngineConfiguration) async {
        @Environment(\.logger) var logger
        @Environment(\.updateClock) var updateClock
        @Environment(\.ticks) var ticks

        logger.trace("Running game engine")
        defer {
            logger.trace("Engine finished running")
        }

        let gameState: Game
        do {
            try withThrowingSDL {
                SDL_Init(configuration.initOptions.rawValue)
            }
            gameState = try .init()
        } catch {
            logger.error("Error setting up engine: \(error)")
            return
        }

        var lastTime = updateClock.now
        var environment = EnvironmentValues.current

        logger.trace("Starting game loop")

        var t = Duration.zero
        var deltaTime = Duration.milliseconds(10)

        var currentTime = updateClock.now
        var accumulator = Duration.zero

        var currentState = gameState

        do {
            while gameState.isRunning {
                try EnvironmentValues.$current.withValue(environment) {
                    let newTime = updateClock.now
                    var frameTime = currentTime.duration(to: newTime)
                    if frameTime > .seconds(0.25) {
                        frameTime = .seconds(0.25)
                    }
                    currentTime = newTime

                    accumulator += frameTime
                    while accumulator >= deltaTime {
                        currentState.update(deltaTime: deltaTime)
                        t += deltaTime
                        accumulator -= deltaTime
                    }
                    try gameState.render()
                }
            }
        } catch {
            logger.error("Error in game loop: \(error)")
            return
        }
    }

    public func run() async {
        await self.run(configuration: EngineConfiguration())
    }

    public nonisolated func quit() {
        SDL_Quit()
        EnvironmentValues.current.logger.trace("Engine quit")
    }
}

@MainActor
public final class LarkEngine<Game: GameProtocol>: Engine {
    public init() {}

    deinit {
        quit()
    }
}
