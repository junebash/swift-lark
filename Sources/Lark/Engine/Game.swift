public protocol Game {
    var isRunning: Bool { get }

    mutating func update()
    func draw()
}
