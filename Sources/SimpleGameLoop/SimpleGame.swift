import Lark


struct Ball: GameObject {
  var rect = Rectangle(
    x: 20,
    y: 20,
    width: 15,
    height: 15
  )
  var velocity = Vector2(x: 300, y: 300)

  mutating func update(deltaTime: Double) {
    rect.origin += velocity * deltaTime
    rect.origin.x += velocity.x * deltaTime
    rect.origin.y += velocity.y * deltaTime
  }

  func draw(renderer: Renderer) {
    renderer
      .setDrawColor(.white)
      .fill(rect: rect)
  }
}


struct Paddle: GameObject {
  var rect: Rectangle
  var velocity: Vector2 = .zero

  init(window: Window) {
    let size = Size(x: 100, y: 20)
    rect = Rectangle(
      origin: Vector2(
        x: (window.size.x / 2) - (size.x / 2),
        y: window.size.y - 40
      ),
      size: size
    )
  }

  mutating func processEvents(_ event: Event) {
    switch (event.type, event.key) {
    case (.keyDown, .left):
      velocity.x = -500
    case (.keyDown, .right):
      velocity.x = 500
    case (.keyUp, .right), (.keyUp, .left):
      velocity = .zero
    default: return
    }
  }

  mutating func update(deltaTime: Double) {
    rect.origin += velocity * deltaTime
  }

  func draw(renderer: Renderer) {
    renderer.setDrawColor(.white)
      .fill(rect: rect)
  }
}


struct SimpleGame: Game {
  var isRunning: Bool = true
  var ball = Ball()
  var paddle: Paddle
  var count = 0

  init(window: Window) {
    self.paddle = Paddle(window: window)
  }

  mutating func processEvents(_ event: Event) {
    if event.key == .escape || event.type == .quit {
      isRunning = false
    }
    ball.processEvents(event)
    paddle.processEvents(event)
  }

  mutating func update(deltaTime: Double) {
    paddle.update(deltaTime: deltaTime)
    ball.update(deltaTime: deltaTime)
  }

  func draw(renderer: Renderer) {
    renderer
      .setDrawColor(.defaultBG)
      .clear()
      .draw(paddle, ball)
      .present()
  }
}

extension Color {
  static var defaultBG: Color {
    Color(red: 10, green: 10, blue: 10, alpha: 255)
  }
}
