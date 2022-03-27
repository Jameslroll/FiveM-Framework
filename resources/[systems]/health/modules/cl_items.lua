Items = Items or {}

function Items:Use(item, slot, cb)
	-- Check item is health item.
	local treatment = self.items[item.name]
	if not treatment then
		return
	end

	-- Make sure something can be treated.
	local usable = false
	for boneId, bone in pairs(Main.bones) do
		if bone.history then
			local groupName, groupSettings, groupBone = bone:GetGroup()
			for k, event in ipairs(bone.history) do
				local injury = Config.Injuries[event.name]
				if injury and treatment.Injuries[event.name] and groupBone and not groupBone:FindInHistory(treatment.Name) then
					usable = true
					break
				end
			end
		end
	end

	if not usable then
		return
	end

	-- Use stuff.
	cb(treatment.Usable, Config.Anims.Items)
end

function Items:Finish(item, slot)
	-- Get treatment form item.
	local treatment = self.items[item.name]
	if not treatment or not treatment.Injuries then
		return
	end

	-- Find something to treat.
	for boneId, bone in pairs(Main.bones) do
		if bone.history then
			local groupName, groupSettings, groupBone = bone:GetGroup()
			for k, event in ipairs(bone.history) do
				local injury = Config.Injuries[event.name]
				if injury and treatment.Injuries[event.name] and groupBone and not groupBone:FindInHistory(treatment.Name) then
					Treatment:Treat(0, groupName, treatment.Name)
					return
				end
			end
		end
	end
end

--[[ Events ]]--
AddEventHandler("health:clientStart", function()
	Items:Cache()
end)

AddEventHandler("inventory:use", function(...)
	Items:Use(...)
end)

AddEventHandler("inventory:useFinish", function(...)
	Items:Finish(...)
end)