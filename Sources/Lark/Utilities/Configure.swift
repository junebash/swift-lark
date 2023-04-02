public func configure<Entity>(
    _ entity: Entity,
    with apply: (inout Entity) -> Void
) -> Entity {
    var entity = entity
    apply(&entity)
    return entity
}
