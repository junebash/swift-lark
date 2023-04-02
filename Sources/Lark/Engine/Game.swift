public protocol Game {
    var isRunning: Bool { get }

    @MainActor
    mutating func setUp() throws

    mutating func update()

    @MainActor
    func render() throws
}

extension Game {
    @MainActor
    public mutating func setUp() throws {}
}
