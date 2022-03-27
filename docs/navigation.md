# Navigation
The navigation wheel may be opened by the player and are presented options in radial order. Options are sorted alphabetically within the menu, first by icon, and then by the displayed text. Options may be embedded into sub-menus.

## Exports

### Adding
An option within the interact wheel may be added through exports.
```Lua
exports.interact:AddOption({
	id = "option",
	text = "Text",
	icon = "person", -- https://fonts.google.com/icons
	sub = {
		{
			id = "suboption-1",
			text = "Sub Text",
			icon = "person",
			sub = sub,
		},
	},
})
```

### Removing
Remove options by passing the id.
```Lua
exports.interact:RemoveOption(id)
```