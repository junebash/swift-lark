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
  public struct Configuration {
    public var initOptions: EngineInitOptions = .everything
    public var logFrameTiming: Bool = false
    public var targetFrameDuration: LarkDuration = .fps60
    public var updateClock: LarkClock = .live

    public init() {}
  }

  public let configuration: Configuration

  public let registry: Registry = .init()

  @Environment(\.logger) private var logger

  private var updateClock: LarkClock { configuration.updateClock }

  public init(configuration: Configuration = .init()) throws {
    self.configuration = configuration

    do {
      try withThrowingSDL {
        SDL_Init(configuration.initOptions.rawValue)
      }
    } catch {
      logger.critical("Error setting up engine: \(error)")
      throw error
    }

    logger.info("Game engine initialized")
  }

  public func run(_ game: __owned some GameProtocol) {
    logger.trace("Running game engine")
    defer {
      logger.trace("Engine finished running")
    }

    var lastUpdate = updateClock.now
    do {
      var currentState = game
      while currentState.isRunning {
        let frameStart = updateClock.now
        let deltaTime = lastUpdate.duration(to: frameStart)
        lastUpdate = frameStart
        try currentState.activeScene?.update(deltaTime: deltaTime)
        if let nextScene = currentState.activeScene?.nextScene() {
          currentState.activeScene = nil  // nil out previous scene first to free resources
          currentState.activeScene = try nextScene()
        }
        try registry.update(deltaTime: deltaTime)
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
      logger.critical("Error in game loop: \(error)")
    }
  }

  deinit {
    Self.quit()
  }

  private nonisolated static func quit() {
    SDL_Quit()
    EnvironmentValues.current.logger.trace("Engine quit")
  }
}
