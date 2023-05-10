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

    var tankImage: Texture
    var tankPosition: FVector2 = .init(x: 10, y: 10)
    var tankVelocity: FVector2 = .init(x: 10, y: 10)

    private let tankSize: FSize2 = .init(width: 32, height: 32)

    @Environment(\.events) var events
    @Environment(\.logger) var logger

    init() throws {
        let resourcePath = Bundle.module.resourcePath ?? ""
        windowSize = ISize2(width: 800, height: 600)
        window = try Window(
            title: "Hi There!",
            position: .centered,
            size: windowSize,
            options: []
        )
//        try window.setFullScreen()
        renderer = try Renderer(window: window, options: [.accelerated, .presentVSync, .targetTexture])

        // draw image
        let tankSurface = try Surface(path: resourcePath + "/assets/images/tank-tiger-right.png")
        let tankTexture = try Texture(renderer: renderer, surface: tankSurface)
        tankImage = tankTexture
    }

    func update(deltaTime: Duration) {
        tankPosition += tankVelocity * deltaTime.fractionalSeconds
        print(deltaTime.formatted(.time(pattern: .hourMinuteSecond(padHourToLength: 0, fractionalSecondsLength: 4))))
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

    func render() throws {
        renderer.setColor(Color(red: 21, green: 21, blue: 21))
        try renderer.clear()
        try renderer.renderCopy(
            tankImage,
            destination: FRect2(origin: tankPosition, size: tankSize)
        )
        renderer.present()
    }
}


@MainActor
@main
enum Run {
    static func main() async throws {
        await EnvironmentValues.withValues {
            $0.logger = Logger(label: "LarkExample", level: .trace)
        } perform: {
            var configuration = EngineConfiguration()
            configuration.logFrameTiming = true
            await LarkEngine<ExampleGame>().run(configuration: configuration)
        }
    }
}
