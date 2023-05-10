@MainActor
public protocol GameProtocol {
    var isRunning: Bool { get }

    init() throws

    mutating func update(deltaTime: Duration)

    func render() throws
}
