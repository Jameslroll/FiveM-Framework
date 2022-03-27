Npc = Npc or {}

function Npc:_Destroy()
	self:Unload()
end

function Npc:Load()
	self.loaded = true

	print("load", self.id)

	local coords = self.coords
	local ped = exports.customization:CreatePed({
		model = self.model,
		appearance = self.appearance,
		features = self.features,
	}, coords)
	
	self.ped = ped

	SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z)
	SetBlockingOfNonTemporaryEvents(ped, true)
	SetPedCanBeTargetted(ped, false)
	SetPedCanRagdoll(ped, false)
	SetEntityInvincible(ped, true)
	FreezeEntityPosition(ped, true)

	if self.interact then
		local interactId = "npc-"..self.id
		self.interactId = interactId
		
		exports.interact:Register({
			id = interactId,
			text = self.interact,
			event = "npc",
			entity = ped,
			npc = self.id,
		})
	end

	self:UpdateAnim()
end

function Npc:Unload()
	if not self.loaded then return end

	self.loaded = nil

	if self.ped and DoesEntityExist(self.ped) then
		DeleteEntity(self.ped)
		self.ped = nil
	end

	if self.interactId then
		exports.interact:Destroy(self.interactId)
		self.interactId = nil
	end

	print("unload", self.id)
end

function Npc:UncacheGrid()
	-- Get grid.
	local gridId = self.grid
	local grid = gridId and Npcs.grids[gridId]

	if not grid then return end

	-- Remove instance from grid.
	grid[self.id] = nil
	
	print(self.id, "uncached in", gridId)

	-- Remove empty grid.
	local next = next
	if next(grid) == nil then
		Npcs.grids[gridId] = nil
	end

	-- Uncache grid.
	self.grid = nil
end

function Npc:CacheGrid()
	-- Uncache old grid.
	if self.grid then
		self:UncacheGrid()
	end

	-- Check coords.
	if not self.coords then
		return
	end

	-- Get grid.
	local gridId = self.instance or Grids:GetGrid(self.coords, Npcs.Config.GridSize)
	local grid = Npcs.grids[gridId]
	if not grid then
		grid = {}
		Npcs.grids[gridId] = grid
	end

	grid[self.id] = true

	print(self.id, "cached in", gridId)

	-- Check if grid is loaded.
	if Npcs.cached[gridId] then
		self:Load()
	end
end

function Npc:GetAnimation()
	local anims = self.animations
	if not anims then return end

	return self.state and anims[self.state] or anims.idle
end

function Npc:_Update()
	if self.Update then
		self:Update()
	end
end

function Npc:UpdateAnim()
	local anim = self:GetAnimation()
	if self.anim == anim then return end

	if anim then
		exports.emotes:PlayOnPed(self.ped, anim)
	else
		exports.emotes:StopOnPed(self.ped)
	end

	self.anim = anim
end

function Npc:PlayAnim(name)
	local anims = self.animations
	if not anims then return end

	local anim = anims[name]
	if not anim then return end

	exports.emotes:PlayOnPed(self.ped, anim)
end

function Npc:SetState(state)
	self.state = state == "idle" and nil or state
	self:UpdateAnim()
end

function Npc:AddOption(p1, p2)
	local target = self.activeOptions or self.options
	if not target then
		target = {}
		self.options = target
	end

	p1Type = type(p1)
	p2Type = type(p2)

	local option
	if p1Type == "string" then
		option = {
			text = p1,
		}
	elseif p1Type == "table" then
		option = p1
	end

	if not option then return end

	option.dialogue = option.dialogue or (p2Type == "string" and p2 or nil)
	option.callback = option.callback or (p2Type == "function" and p2 or nil)

	table.insert(target, option)

	self:UpdateOptions()

	return #target
end

function Npc:GetOptions()
	return self.activeOptions or self.options or {}
end

function Npc:UpdateOptions()
	if not Npcs.window then return end
	Npcs.window:SetModel("options", self:GetOptions())
end

function Npc:SetOptions(options)
	self.activeOptions = options
	self:UpdateOptions()
end

function Npc:GoHome()
	self:SetOptions(self.options)
	self:SetState("idle")
end

function Npc:SelectOption(index)
	if self.locked then return end

	local options = self:GetOptions()
	local option = options[index]
	if not option or option.disabled then return false end

	if option.options then
		self.activeOptions = option.options
	elseif option.back then
		self.activeOptions = self.options
	end

	if option.text then
		self:AddDialogue(option.text, true)
	end

	if option.dialogue then
		self:AddDialogue(option.dialogue, false)
	end

	if option.callback then
		option.callback(self, index, option)
	end

	if option.once then
		option.disabled = true
	end
	
	self:UpdateOptions()

	return true
end

function Npc:AddDialogue(text, sent)
	sent = sent == true

	if not self.history then
		self.history = {}
	end

	local lastMessage = self.history[#self.history]
	local message

	if lastMessage and lastMessage.sent == sent then
		message = lastMessage
	else
		message = {
			sent = sent,
			text = {},
		}

		table.insert(self.history, message)
	end

	table.insert(message.text, text)

	if Npcs.window then
		Npcs.window:SetModel("messages", self.history)
	end
end

function Npc:Interact()
	if self.interact == "Talk" then
		self:OpenDialogue()
	end
end

function Npc:OpenDialogue()
	local name = self.name or "???"
	local history = self.history or {}
	local options = self:GetOptions()
	
	local window = Npcs:OpenWindow({
		type = "Window",
		title = name,
		class = "compact",
		style = {
			["width"] = "30vmin",
			["height"] = "50vmin",
			["left"] = "4vmin",
			["top"] = "50%",
			["transform"] = "translate(0%, -50%)",
		},
		defaults = {
			name = name,
			messages = history,
			options = #options > 0 and options,
		},
		components = {
			{
				type = "div",
				style = {
					["display"] = "flex",
					["flex-direction"] = "column",
					["height"] = "100%",
				},
				components = {
					{
						style = {
							["display"] = "flex",
							["flex-direction"] = "column-reverse",
							["flex-grow"] = 1,
							["overflow"] = "hidden",
							["overflow-y"] = "scroll",
							["padding"] = "2vmin",
						},
						template = [[
							<div>
								<q-chat-message
									v-for="(message, index) in this.$getModel('messages')"
									:key="index"
									:text="message.text"
									:sent="message.sent"
									text-color="white"
									:bg-color="message.sent ? 'blue' : 'red'"
								>
									<template v-slot:name>{{message.sent ? "me" : $getModel('name')}}</template>
								</q-chat-message>
							</div>
						]],
					},
					{
						condition = "this.$getModel('options')",
						type = "q-separator",
					},
					{
						condition = "this.$getModel('options')",
						style = {
							["flex-shrink"] = 1,
							["padding"] = "0%",
							["margin"] = "0.5vmin",
							["margin-top"] = "0.25vmin",
							["margin-bottom"] = "0.25vmin",
						},
						template = [[
							<div>
								<q-btn
									v-for="(option, index) in this.$getModel('options')"
									:key="index"
									:color="option.color ?? 'blue'"
									:label="option.text"
									@click="$invoke('selectOption', index)"
									class="full-width"
									align="evenly"
									style="padding: 0.1vmin; margin: 0.5vmin; margin-bottom: 0.25vmin; margin-top: 0.25vmin"
									ripple
									dense
									no-caps
								/>
							</div>
						]],
					},
				},
			},
		},
	})
	
	window:AddListener("selectOption", function(window, index)
		self:SelectOption(index + 1)
	end)
end