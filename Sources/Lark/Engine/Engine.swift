// Copyright (c) 2023 June Bash
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

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

    public init(configuration: Configuration = .init()) {
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

public extension Engine {
    func run(configuration: EngineConfiguration) {}

    func run() {
        run(configuration: EngineConfiguration())
    }

    nonisolated func quit() {
        SDL_Quit()
        EnvironmentValues.current.logger.trace("Engine quit")
    }
}
