import Lark

final class JungleTilemap: Entity {
  var id: EntityID
  var registry: Registry

  @ComponentProxy var sprite: SpriteComponent

  init(id: EntityID, registry: Registry) {
    self.id = id
    self.registry = registry
  }
}
