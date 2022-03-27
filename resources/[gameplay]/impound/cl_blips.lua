Blips = {
	entities = {},
}

function Blips:Add(netId, coords)
	-- Check duty and entity.
	if not exports.jobs:IsOnDuty(Config.Marking.Faction) or self.entities[netId] ~= nil then
		return
	end

	-- Create blip.
	local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
	SetBlipSprite(blip, 317)
	SetBlipColour(blip, 49)
	SetBlipScale(blip, 1.0)
	SetBlipAsShortRange(blip, true)

	-- Set blip label.
	if not self.label then
		self.label = "IMPOUND_BLIP"
		AddTextEntry(self.label, "Impound Request")
	end

	BeginTextCommandSetBlipName(self.label)
	EndTextCommandSetBlipName(blip)

	-- Cache blip.
	self.entities[netId] = blip
end

function Blips:Remove(netId)
	local blip = self.entities[netId]
	if blip == nil then return end

	if DoesBlipExist(blip) then
		RemoveBlip(blip)
	end
	self.entities[netId] = nil
end

function Blips:Update(netId, coords)
	local blip = self.entities[netId]
	if blip == nil then return end

	if DoesBlipExist(blip) then
		SetBlipCoords(blip, coords.x, coords.y, coords.z)
	else
		self.entities[netId] = nil
	end
end

function Blips:Clear()
	for entity, blip in pairs(self.entities) do
		if DoesBlipExist(blip) then
			RemoveBlip(blip)
		end
	end
	self.entities = {}
end