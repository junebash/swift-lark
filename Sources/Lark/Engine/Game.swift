@MainActor
public protocol GameProtocol {
  var isRunning: Bool { get }

  init() throws

  func setup(with engine: )

  mutating func update(deltaTime: LarkDuration)

  func render() throws
}
