Armor = {}

--[[ Functions: Armor ]]--
function Armor:Add(flag, amount)
	for boneId, settings in pairs(Config.Bones) do
		if settings.Armor and (settings.Armor & flag) ~= 0 then
			local bone = Main.bones[boneId]
			if bone then
				bone:AddArmor(amount or 1.0)
			end
		end
	end
end

--[[ Functions: Bone ]]--
function Bone:AddArmor(value)
	local armor = math.min(math.max((self.info.armor or 0.0) + value, 0.0), 1.0)
	if armor < 0.001 then
		armor = nil
	end

	self:SetInfo("armor", armor)
	self:UpdateInfo()
end

function Bone.process.damage:Armor(amount)
	if (self.info.armor or 0.0) > 0.001 then
		self:AddArmor(-amount)
		return false
	end
end

function Bone.process.bleed:Armor(amount)
	if (self.info.armor or 0.0) > 0.001 then
		return false
	end
end

--[[ Events ]]--
RegisterNetEvent("health:addArmor", function(flag, amount)
	Armor:Add(flag, amount)
end)

AddEventHandler("inventory:use", function(item, slot, cb)
	if not item.armor then return end

	cb(Config.Armor.Duration, Config.Armor.Anim)
end)

AddEventHandler("inventory:useFinish", function(item, slot)
	if not item.armor then return end

	Armor:Add(item.armor)
end)