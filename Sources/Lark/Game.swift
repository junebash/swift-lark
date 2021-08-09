public protocol Game: GameObject, Identifiable
where ID == GameID {
  var isRunning: Bool { get set }
}

public struct GameID: Hashable {}

extension Game {
  public var id: ID { GameID() }
}
