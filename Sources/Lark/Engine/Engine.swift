import AsyncAlgorithms
import Clocks
import SDL2

@MainActor
public final class Engine<G: Game> {
    public var game: G

    @Environment(\.updateClock) var updateClock

    public init(game: G, options: EngineOptions = .everything) throws {
        self.game = game
        try withThrowingSDL {
            SDL_Init(options.rawValue)
        }
    }

    public func run() async {
        var updateTimer = AsyncTimerSequence(
            interval: .milliseconds(1000 / 60),
            clock: AnyClock(updateClock)
        ).makeAsyncIterator()

        while game.isRunning, let _ = await updateTimer.next() {
            game.update()
            game.draw()
        }

        quit()
    }

    internal func quit() {
        SDL_Quit()
    }
}
