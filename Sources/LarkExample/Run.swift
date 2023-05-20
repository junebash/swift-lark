import Foundation
import Lark
import Logging
import SDL2

@MainActor
final class ExampleGame: GameProtocol {
  var isRunning: Bool = true

  var window: Window
  var renderer: Renderer
  var windowSize: ISize2

  init() throws {
    let resourcePath = Bundle.module.resourcePath ?? ""
    windowSize = ISize2(width: 800, height: 600)
    window = try Window(
      title: "Hi There!",
      position: .centered,
      size: windowSize,
      options: []
    )
    renderer = try Renderer(window: window, options: [.accelerated, .presentVSync, .targetTexture])
  }

  func update(deltaTime: LarkDuration) {

  }

  func render() throws {

  }
}

@MainActor
@main
enum Run {
  static func main() async throws {
    EnvironmentValues.withValues {
      $0.logger.logLevel = .trace
    } perform: {
      engine.run()
    }
  }
}
