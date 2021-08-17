public protocol Game: GameObject, Identifiable {
  var isRunning: Bool { get set }
}

public struct GameID: Hashable {}

extension Game where ID == GameID {
  public var id: ID { GameID() }
}
