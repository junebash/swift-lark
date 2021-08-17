import Lark

let window = try Window(
  title: "It's a Window!",
  position: .centered,
  size: .init(x: 800, y: 600),
  options: []
)

let renderer = Renderer(window: window)
try Lark().run(SimpleGame(window: window), renderer: renderer)
