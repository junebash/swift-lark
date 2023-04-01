import Lark

struct ExampleGame: Game {
    var isRunning: Bool = true
    
    let window: Window
    let renderer: Renderer

    @Environment(\.events) var events

    init() throws {
        let window = try Window(
            title: "Hi There!",
            position: .centered,
            size: .init(width: 800, height: 600),
            options: [.borderless]
        )
        let renderer = try Renderer(window: window)

        self.window = window
        self.renderer = renderer
    }

    mutating func update() {
        for event in events() {
            switch event.kind {
            case .quit:
                isRunning = false
            case .keyUp(let info) where info.keyCode == .escape:
                isRunning = false
            default:
                return
            }
        }
    }

    func draw() {

    }
}

@main
enum Run {
    static func main() async throws {
        let engine = try Engine(game: ExampleGame())
        await engine.run()
    }
}
