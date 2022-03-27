# Entities
Low level abstract entities may be created from other scripts. If you're looking for higher level entities, then it might be best to use [Decorations]().

## Exports

### Registering

Entities can be registered using the `Register` export.

#### Navigation
An entity can be created that holds a navigation register within it. When the player enters the radius, the navigation option will be added, and removed when they leave it.
```Lua
exports.entities:Register({
	id = "entity-1",
	name = "Entity 1",
	coords = coords,
	radius = radius,
	navigation = navigation,
})
```

Creating a simple object attached to the entity is also possible.
```Lua
exports.entities:Register({
	id = "entity-1",
	name = "Entity 1",
	coords = coords,
	rotation = rotation,
	model = model,
})
```

Other options.
- `floor`: when set to true, the coordinates will snap to the ground.

### Destroying
```Lua
exports.entities:Destroy(id)
```