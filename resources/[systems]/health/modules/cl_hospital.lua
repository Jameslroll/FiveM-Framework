local template = {
	interact = "Talk",
}

--[[ Functions ]]--
local function Dialogue_Pay(npc, index, option)
	local entity = Main:FindBed(npc.targets)
	if not entity then
		npc:AddDialogue("Sorry, your bed is no longer available. You will not be billed.")
		npc:GoHome()

		return
	end

	Main.npc = npc
	Main.bed = entity

	TriggerServerEvent("health:checkIn", option.ratio)

	npc.locked = true
	npc:GoHome()
end

local function Dialogue_CheckIn(npc, index, option)
	npc.locked = true

	Citizen.Wait(GetRandomIntInRange(1000, 2000))

	local entity = Main:FindBed(npc.targets)
	if entity then
		npc.locked = false

		local ratio = Main:GetTreatmentRatio()
		local min, max = table.unpack(Config.Hospital.Cost)
		local price = math.floor(Lerp(min, max, ratio))

		npc:AddDialogue(("There is a bed available. The bill will be <b>$%s</b>. Do you want to pay?"):format(price))
		
		npc:SetOptions({
			{
				text = "Yes, send me the bill.",
				callback = Dialogue_Pay,
				ratio = ratio,
			},
			Npcs.NEVERMIND,
		})
	else
		npc:AddDialogue("There aren't any beds available right now.")
		npc.locked = false
	end
end

--[[ Functions: Main ]]--
function Main:FindBed(targets)
	local entities = exports.chairs:FindAll("Medical")
	for _, entity in ipairs(entities) do
		if Config.Hospital.Beds[GetEntityModel(entity)] then
			local isValid = targets == nil

			for _, target in ipairs(targets or {}) do
				if #(target.coords - GetEntityCoords(entity)) < target.radius then
					isValid = true
					break
				end
			end

			if isValid then
				-- Citizen.CreateThread(function()
				-- 	for i = 1, 1000 do
				-- 		DrawLine(GetEntityCoords(Ped), GetEntityCoords(entity), 255, 0, 0, 255)
				-- 		Citizen.Wait(0)
				-- 	end
				-- end)
				return entity
			end
		end
	end
end

function Main:CheckIn(npc, entity)
	if not npc or not entity then return end

	-- Check chair.
	if not DoesEntityExist(entity) then
		Treatment:Heal()
		return
	end
	
	-- Lock in chair.
	exports.chairs:Lock(true)
	exports.chairs:Activate(entity, "Medical")

	-- Close dialogue.
	Npcs:CloseWindow()

	-- Wait a little.
	Citizen.Wait(GetRandomIntInRange(1000, 2000))

	-- Heal.
	Treatment:Heal(true)

	-- Notif.y
	TriggerEvent("chat:notify", {
		class = "inform",
		text = "You feel refreshed and may get up!",
	})

	-- Unlock chairs.
	exports.chairs:Lock(false)
end

function Main:RegisterNpc(info)
	local npc = Npcs:Register(info)

	npc:AddOption({
		text = "I would like to check in.",
		dialogue = "I'll see if a bed is available.",
		callback = Dialogue_CheckIn,
	})
end

function Main:GetTreatmentRatio()
	local ratio = 0.0

	for boneId, bone in pairs(self.bones) do
		local settings = bone:GetSettings()
		local health = bone.info.health

		if settings and health then
			local damage = 1.0 - health
			ratio = ratio + (damage * (settings.Modifier or 1.0)) / Config.Hospital.Limbs
		end
	end

	print(ratio)

	return math.min(math.max(ratio, 0.0), 1.0)
end

--[[ Events: Net ]]--
RegisterNetEvent("health:checkIn", function(success)
	-- Get cached.
	local bed = Main.bed
	local npc = Main.npc

	-- Check npc.
	if not npc then return end

	-- Uncache values.
	Main.bed = nil
	Main.npc = nil
	npc.locked = false

	-- The transaction failed.
	if not success then
		npc:AddDialogue("There was an issue with the transaction. I'm afraid there's nothing I can do.")
		return
	end

	-- Success, check in!
	Main:CheckIn(npc, bed)
end)

--[[ Events ]]--
AddEventHandler("health:clientStart", function()
	for k, info in ipairs(Config.Hospital.Receptionists) do
		for k, v in pairs(template) do
			info[k] = v
		end

		info.id = "HOSPITAL_RECEPTION-"..k

		Main:RegisterNpc(info)
	end
end)