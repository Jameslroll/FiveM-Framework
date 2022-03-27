Marked = {}
Marked.__index = Marked

function Marked:Create(entity)
	-- Find bone.
	local bone = -1
	for _, boneName in ipairs({ "windscreen", "petroltank", "engine", "handlebars" }) do
		bone = GetEntityBoneIndexByName(entity, boneName)
		if bone ~= -1 then
			break
		end
	end
	
	-- Get coords.
	local coords = GetWorldPositionOfEntityBone(entity, bone)
	local offset = GetOffsetFromEntityGivenWorldCoords(entity, coords)

	-- Register text.
	local text = exports.interact:AddText({
		text = "<img style='width: 6vmin' src='assets/impound.png'>",
		entity = entity,
		transparent = true,
		offset = offset,
	})

	-- Register interactable.
	local interactable = "impoundMarked-"..entity
	exports.interact:Register({
		id = interactable,
		text = "Remove Sticker",
		entity = entity,
		event = "unmarkImpound",
	})

	-- Return instance.
	return setmetatable({
		entity = entity,
		text = text,
		interactable = interactable,
	}, Marked)
end

function Marked:Destroy()
	-- Stop impounding.
	if self.impound then
		self:StopImpound()
	end

	-- Destroy interactables.
	exports.interact:RemoveText(self.text)
	exports.interact:Destroy(self.interactable)

	-- Uncache.
	Marking.objects[self.entity] = nil
end

function Marked:Unmark()
	local netId = VehToNet(self.entity)
	TriggerServerEvent("impound:unmark", netId)
end