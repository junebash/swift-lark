import AsyncAlgorithms
import Clocks
import Logging
import SDL2

@MainActor
public final class Engine<G: Game> {
    public struct Configuration: Equatable {
        public var initOptions: EngineInitOptions = .everything
        public var logFrameTiming: Bool = false

        public init() {}
    }

    public var game: G

    public let configuration: Configuration

    @Environment(\.logger) var logger
    @Environment(\.updateClock) var updateClock

    public init(
        game: G,
        configuration: Configuration = Configuration()
    ) throws {
        self.game = game
        self.configuration = configuration
        try withThrowingSDL {
            SDL_Init(configuration.initOptions.rawValue)
        }
    }

    deinit {
        quit()
    }

    public func run() {
        logger.trace("Running game engine")
        defer {
            logger.trace("Engine finished running")
        }

        do {
            try self.game.setUp()
        } catch {
            let error = LarkError.gameSetup(error)
            logger.error("Error setting up game: \(error)")
            return
        }

        var lastTime = updateClock.now
        var environment = EnvironmentValues.current

        logger.trace("Starting game loop")
        while game.isRunning {
            if configuration.logFrameTiming {
                let now = updateClock.now
                defer { lastTime = now }
                let dt = lastTime.duration(to: now)
                environment.deltaTime = dt
                let dtDouble = dt.fractionalSeconds
                let fps = 1.0 / dtDouble
                logger.trace("Delta Time: \(dtDouble.formatted(.number.precision(.fractionLength(4))))")
                logger.trace("FPS: \(fps.formatted(.number.precision(.fractionLength(2))))")
            }

            game.update()
            do {
                try game.render()
            } catch {
                logger.error("Error rendering the game: \(error)")
                return
            }
        }
    }

    public nonisolated func quit() {
        SDL_Quit()
        EnvironmentValues.current.logger.trace("Engine quit")
    }
}
