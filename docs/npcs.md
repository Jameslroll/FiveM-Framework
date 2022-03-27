# Npcs

By importing the npcs scripts, you are able to create a mostly static npc and give it dynamic dialogue for the player to interact with.

## Manifest
Include the scripts and dependencies within the manifest:
```Lua
dependencies {
	'npcs',
	...
}

shared_scripts {
	'@grids/shared/grids.lua',
	...
}

client_scripts {
	'@npcs/client.lua',
	...
}

server_scripts {
	'@npcs/server.lua',
	...
}
```

## Objects

### Registering
`Npcs` is the controller for all npcs within your resource.

Register an npc by calling `Npcs:Register` with input data:
```Lua
local npc = Npcs:Register(info)
```

The default info structure:
```Lua
info = {
	id = "UNIQUE_ID-1", -- Required unique identifier.
	interact = "Talk", -- Interacting with the npc will open a dialogue by default.
	coords = vector4(0, 0, 0, 0), -- A vector4 to represent initial position and heading.
	appearance = json.decode(''), -- For using custom appearances, may be extrapolated from the apperance menu.
	features = json.decode(''), -- Same as appearance, but using the features field instead.
	animations = { -- Uses the normal emotes format.
		idle = {}, -- Default state.
		other = {}, -- Arbitrary states may be set via script.
	},
	options = {}, -- Default dialogue registered to npc, see dialogue for more.
}
```

### Npc
This meta-object represents your npc instance.

#### Dialogue
Options may be added real-time by calling `npc:AddOption(data)` on the `npc` instance.

When adding dialogue options, it must follow the following structure:
```Lua
data = {
	text = "This is an option.", -- The text displayed to the player.
	dialogue = "I am responding to you.", -- How the npc responds to the option.
	callback = function(self, index, option)
		-- Do something when the option is selected.
	end,
}
```

The `Npcs.NEVERMIND` provides a generic option to pass as a dialogue option.

#### Functions
Whether it's in the callback, or somewhere else in the script, functions that are part of the `Npc` meta-table may be invoked on the `npc` instance.

```Lua
Npc:Load()
Npc:Unload()
Npc:GetAnimation()
Npc:UpdateAnim()
Npc:SetState(state) -- Will try to use animations from the animations definition.
Npc:AddOption(p1, p2) -- May either be a formatted table (p1) or generic text value (p1) with response (p2).
Npc:GetOptions()
Npc:UpdateOptions()
Npc:SetOptions(options)
Npc:GoHome()
Npc:SelectOption(index)
Npc:AddDialogue(text, sent) -- The text to send, and whether the text is sent by the player or npc (true for player).
Npc:Interact()
```

There are also controller functions provided by the `Npcs` meta-object.

```Lua
local window = Npcs:OpenWindow(data)
Npcs:CloseWindow()
```

#### Locking
By setting `locked` as part of the `npc` instance, it will block all player input. This is good for creating temporary locks, like for pauses in dialogue.

For example:
```Lua
data = {
	text = "Can you help me?",
	dialogue = "Give me a second.",
	callback = function(self, index, option)
		-- Lock the npc.
		self.locked = true
	
		-- Wait 2 seconds.
		Citizen.Wait(2000)
	
		-- The npc responds.
		self:AddDialogue("Thanks for waiting.")
	
		-- Unlock the npc.
		self.locked = false
	end,
}
```

#### Options
Functions allow us to change dialogue at run-time.

For example:
```Lua
-- To avoid nesting too many callbacks, creating a function outside the option is a good idea.
local function doSomething(self, index, option)
	-- Lock the npc.
	self.locked = true

	-- The npc responds.
	self:AddDialogue(("You want to discuss topic %s?"):format(option.something))

	-- We wait 2 seconds.
	Citizen.Wait(2000)
	
	-- Unlock the npc.
	self.locked = false
	
	-- The npc responds.
	self:AddDialogue("Well, that topic is very interesting. That's all there is to it.")

	-- The player responds.
	self:AddDialogue("Alright.", true)
	
	-- Send the dialogue back to the start.
	self:GoHome()
end

npc:AddOption({
	text = "I would like to discuss something.",
	dialogue = "What's on your mind?",
	callback = function(self, index, option)
		-- Directly set the options.
		self:SetOptions({
			{
				text = "I want to discuss topic 1.",
				callback = doSomething,
				something = 1,
			},
			{
				text = "I want to discuss topic 2",
				callback = doSomething,
				something = 2,
			},
			Npcs.NEVERMIND,
		})
	end,
})
```