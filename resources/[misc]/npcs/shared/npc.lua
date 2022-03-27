Npc = Npc or {}
Npc.__index = Npc

function Npc:Create(data)
	-- Check data.
	if not data then
		error("npc missing data")
	end

	-- Check id.
	if not data.id then
		error("npc missing id")
	end

	-- Create instance.
	local npc = setmetatable(data, Npc)

	-- Cache instance.
	Npcs.npcs[data.id] = npc

	-- Npcs callbacks.
	if Npcs._Register then
		Npcs:_Register(npc)
	end

	-- Return instance.
	return npc
end

function Npc:Destroy()
	-- Uncache instance.
	Npcs.npcs[self.id] = nil

	-- Destroy callback.
	if self._Destroy then
		self:_Destroy()
		TriggerEvent("npcs:onDestroy", self.id)
	end
end