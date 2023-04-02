import Lark
import Logging
import SDL2

final class ExampleGame: Game {
    var isRunning: Bool = true
    
    var window: Window!
    var renderer: Renderer!
    var windowSize: ISize2!

    @Environment(\.events) var events
    @Environment(\.deltaTime) var deltaTime
    @Environment(\.logger) var logger

    init() {}

    @MainActor
    func setUp() throws {
        windowSize = ISize2(width: 800, height: 600)
        window = try Window(
            title: "Hi There!",
            position: .centered,
            size: windowSize,
            options: [.resizable]
        )
        try window.setFullScreen()
        renderer = try Renderer(window: window, options: [.accelerated, .presentVSync, .targetTexture])
    }

    func update() {
        for event in events {
            logger.info("\(event)")
            switch event.kind {
            case .quit:
                isRunning = false
            case .keyUp(let info) where info.keyCode == .escape:
                isRunning = false
            case .window(_, let windowEvent):
                switch windowEvent {
                case .resized(let newSize):
                    self.windowSize = newSize
                default:
                    break
                }
            default:
                break
            }
        }
    }

    @MainActor
    func render() throws {
        renderer.setColor(Color(red: 21, green: 21, blue: 21))
        do {
            try renderer.clear()
        } catch {
            logger.error("Render error clearing screen: \(error)")
        }

        // draw player rect
        renderer.setColor(Color(red: 0, green: 0.8, blue: 0.8))
        try renderer.fillRect(IRect2(x: 10, y: 10, width: 20, height: 20))

        renderer.present()
    }
}


@MainActor
@main
enum Run {
    static func main() async throws {
        var environment = EnvironmentValues.current
        environment.logger = Logger(label: "LarkExample", level: .notice)

        try EnvironmentValues.$current.withValue(environment) {
            let game = ExampleGame()
            let engine = try Engine(game: game)
            engine.run()
        }
    }
}
