public struct SystemsManager {
  private var systems: [ObjectIdentifier: any System] = [:]

  internal init() {}

  public subscript<S: System>(type: S.Type) -> S? {
    _read { yield systems[S.typeID] as? S }
  }

  public subscript<S: System>(type: S.Type, default defaultValue: @autoclosure () -> S) -> S {
    mutating get {
      if let system = self.system(S.self) {
        return system
      } else {
        let system = defaultValue()
        setSystem(system)
        return system
      }
    }
    _modify {
      var system = self.system() ?? defaultValue()
      yield &system
      self.setSystem(system)
    }
    set {
      self.setSystem(newValue)
    }
  }

  public func system<S: System>(_: S.Type = S.self) -> S? {
    systems[S.typeID] as? S
  }

  public mutating func setSystem<S: System>(_ system: S) {
    systems[S.typeID] = system
  }

  public func hasSystem<S: System>(_: S.Type) -> Bool {
    systems.keys.contains(ObjectIdentifier(S.self))
  }

  public mutating func removeSystem<S: System>(_: S.Type) {
    systems.removeValue(forKey: ObjectIdentifier(S.self))
  }

  public mutating func addEntity(
    _ entity: Entity,
    toSystemsWithSignature signature: ComponentSignature
  ) {
    for system in systems.values where system.canOperate(on: signature) {
      system.entities.add(entity)
    }
  }
}
