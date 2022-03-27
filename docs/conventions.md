# General
**Syntax**
- Use tabs for indentation.
- Use `PascalCasing` for functions or variables outside function scopes.
- Use `camelCasing` inside function scopes.
- Use underscore-prefixed `_camelCasing` for system variables or taken names.
- Use padding inside tables (but not for the keys): `{ [key] = value }`
- Use no padding in string concatenation: `someVar.."my string"`
- Use sentences with stops when writing comments (it will be easier to distinguish from normal code): `-- This is a comment.`

**Resources**
- Prefix client, server, and shared scripts `cl_`, `sv_`, and `sh_`, respectively, followed by the script name, resource name, or `config`.
- Large resources (more than 5 scripts) can be split into folders named `server/*.lua`, `client/*.lua`, and `shared/*.lua` without prefixes.
- Resource categories are wrapped with `[]`.

## Comments
- Categorize groups within the global namespace under comments.
```Lua
--[[ Functions ]]--
--[[ Threads ]]--
--[[ Events ]]--
```

- Try to annotate localized code using (mostly) complete sentences.
```Lua
local source = source

-- Check player is active.
if not self.active[source] then return end

-- Set player no longer active.
self.active[source] = nil
```

## Configuration
- Acceptable structures:
	- `resource/sh_config.lua`
	- `resource/shared/config.lua`
	- `resource/config/something.lua`
```Lua
Config = {
	FloatVar = 1.0,
	IntVar = 1,
	TableVar = {
		{ Name = "Test1", OtherVar = true },
		{ Name = "Test2", OtherVar = true },
	},
}
```

## Metatables
- Use pascal casing for metatables and their functions.
- Use camel casing for nested objects within a metatable.
- [Learn more about metatables](https://www.tutorialspoint.com/lua/lua_metatables.htm)
```Lua
Main = {
	process = {}
}

function Main.process:Heal() end
function Main.process:Kill() end
function Main.process:Revive() end

function Main:Update() end
```