--[[ Functions: Main ]]--
function Main.update:Bleeding()
	local blood = self:GetEffect("Blood") or 0.0
	if blood > 0.8 then
		self.walkstyle = "drunk3"
	elseif blood > 0.6 then
		self.walkstyle = "drunk2"
	elseif blood > 0.4 then
		self.walkstyle = "drunk"
	end

	local scene = (blood > 0.7 and "MP_BLUR_PRE_CELEB_SCREEN_SCENE") or (blood > 0.2 and "DH2A_PREPARE_DETONATION") or nil
	if self.bloodScene ~= scene then
		if self.bloodScene then
			StopAudioScene(self.bloodScene)
		end

		if scene then
			StartAudioScene(scene)
		end

		self.bloodScene = scene
	end
end

--[[ Functions: Bone ]]--
function Bone.process.update:Bleeding()
	local bleed = self.info.bleed or 0.0
	
	if bleed > 0.001 then
		-- Get group.
		local groupName, groupSettings = self:GetGroup()
		if not groupSettings then return end

		local groupBone = Main:GetBone(groupSettings.Part) or {}
		if not groupBone then return end

		-- Calculate rate.
		local rate = (groupBone.bleedRate or 1.0) * (BleedRate or 1.0)
		local bloodLoss = bleed * rate * 0.04

		-- Add effects.
		Main:AddEffect("Blood", BloodLoss)
		Main:AddEffect("Health", -bleed * rate * 0.01)

		BloodLoss = (BloodLoss or 0.0) + bloodLoss
		
		-- Clotting.
		bleed = math.max(bleed - (1.0 / 3600.0) * (groupBone.clotRate or 1.0) * (ClotRate or 1.0), 0.0)
		if bleed < 0.001 then
			bleed = nil
		end

		self.bloodLoss = bloodLoss
		self:SetInfo("bleed", bleed)
	else
		self.bloodLoss = nil
	end
end

function Bone:ApplyBleed(amount)
	for name, func in pairs(self.process.bleed) do
		local result = func(self, amount)
		if result == false then
			return
		elseif type(result) == "number" then
			amount = result
		end
	end

	self:SetInfo("bleed", math.min((self.info.bleed or 0.0) + 0.1, 1.0))
end