Injury = {
	state = "None",
	override = "Writhes",
	options = {
		{
			id = "injury-passout",
			text = "Passout",
			icon = "healing",
			anim = "Deaths",
		},
		{
			id = "injury-writhe",
			text = "Writhe",
			icon = "personal_injury",
			anim = "Writhes",
		},
		{
			id = "injury-situp",
			text = "Sit Up",
			icon = "chair",
			anim = "Sit",
			func = function()
				return not Main:IsInjuryPresent({
					["Gunshot"] = true,
					["Stab"] = true,
					["Fracture"] = true,
					["2nd Degree Burn"] = true,
					["3rd Degree Burn"] = true,
				})
			end,
		},
	}
}

--[[ Functions: Injury ]]--
function Injury:Update()
	-- Check native death.
	if IsPedDeadOrDying(Ped) then
		local startTime = GetGameTimer()
		local timer = 0
		
		while (GetEntitySpeed(Ped) > 0.2 or timer < 3000) and timer < 16000 do
			timer = GetGameTimer() - startTime
			Citizen.Wait(0)
		end
		
		local vehicle = GetVehiclePedIsIn(Ped)
		local seatIndex = FindSeatPedIsIn(Ped)

		ResurrectPed(Ped)
		ClearPedTasksImmediately(Ped)

		Citizen.Wait(0)

		if vehicle and DoesEntityExist(vehicle) and seatIndex then
			SetPedIntoVehicle(Ped, vehicle, seatIndex)
		end
	end

	-- Get player state.
	local state = LocalPlayer.state or {}

	-- Get ped stuff.
	local isRestrained = state.restrained
	local inVehicle = IsPedInAnyVehicle(Ped)
	local inWater = IsEntityInWater(Ped)
	local isMoving = GetEntitySpeed(Ped) > 0.2
	local isRagdoll = IsPedRagdoll(Ped)

	-- Get health values.
	local health = Main.effects["Health"] or 1.0
	local isDead = health < 0.001
	
	-- Cache and set state.
	if self.isDead ~= isDead then
		self.isDead = isDead

		Main:BuildNavigation()

		state:set("immobile", isDead, true)

		if isDead then
			self.state = "None"
			self.override = "Writhes"
			self.deadTime = GetGameTimer()
			
			SetEntityHealth(Ped, 0)
			
			return
		else
			Menu:Invoke(false, "setHtml", "#respawn", "")
		end
	end

	-- Determine anim state.
	local animState = (
		(isDead and inVehicle and "Vehicle") or
		((not isDead or IsEntityAttached(Ped) or isMoving) and "None") or
		(inWater and "Water") or
		"Normal"
	)

	-- Update anim state.
	if animState ~= self.state or isRestrained ~= self.restrained then
		-- Get anim.
		local anim = Config.Anims[animState]

		-- Additional states.
		if anim then
			-- Restrained variant.
			anim = anim[isRestrained and "Restrained" or "Normal"] or anim

			-- Overrides.
			if self.override then
				anim = anim[self.override] or anim
			end

			-- Random anims.
			if #anim > 0 then
				anim = anim[GetRandomIntInRange(1, #anim)]
			end
		end

		-- Set anim.
		self:SetAnim(anim, self.state ~= "None")

		-- Cache state.
		self.state = animState
		self.restrained = isRestrained

		-- Other ped stuff.
		ClearPedTasks(Ped)
		SetPedCanRagdoll(Ped, not isDead or (isMoving and not inWater))
		SetBlockingOfNonTemporaryEvents(Ped, isDead)
		SetEntityProofs(Ped, isDead, isDead, isDead, isDead, isDead, isDead, isDead, isDead)
	end

	-- Replay anim.
	if self.emote and not exports.emotes:IsPlaying(self.emote, true) and not inWater then
		-- self:SetAnim(self.anim)
	end

	-- Suppress interact.
	if isDead then
		TriggerEvent("interact:suppress")

		local respawnTimer = self:GetRespawnTimer()

		Menu:Invoke(false, "setHtml", "#respawn",
			respawnTimer > 0.001 and
			("<span class='negative'>%s seconds until respawn...</span>"):format(math.ceil(respawnTimer)) or
			"<span class='positive'>Respawn is available!</span> (/respawn)"
		)
	end
end

function Injury:GetRespawnTimer()
	local timeSinceDead = (GetGameTimer() - (self.deadTime or GetGameTimer())) / 1000.0
	local respawnTimer = math.max(Config.Respawn.Time - timeSinceDead, 0.0)

	return respawnTimer
end

function Injury:UpdateFrame()
	if not self.isDead then return end

	-- Disable controls.
	for i = 0, 360 do
		if not Config.EnableControls[i] then
			DisableControlAction(0, i)
		end
	end

	-- Prevent getting up.
	if IsPedGettingUp(Ped) then
		ClearPedTasksImmediately(Ped)
		self:Update()
	end

	-- Water up.
	if GetEntitySubmergedLevel(Ped) > 0.9 then
		SetEntityVelocity(Ped, 0.0, 0.0, 2.0)
	end
end

function Injury:SetAnim(anim, revive)
	if self.emote then
		exports.emotes:Stop(self.emote, IsPedInAnyVehicle(Ped))
	end

	if anim then
		anim.Locked = true
	end

	print("set", json.encode(anim))

	self.anim = anim
	self.emote = anim and exports.emotes:Play(anim) or nil

	if not anim and revive and not IsPedInAnyVehicle(Ped) and not IsEntityInWater(Ped) then
		exports.emotes:Play(Config.Anims.Revive)
	end
end

--[[ Listeners ]]--
Main:AddListener("BuildNavigation", function(options)
	if not Injury.isDead then return end
	
	for k, option in ipairs(Injury.options) do
		if option.anim ~= Injury.override and (not option.func or option.func()) then
			options[#options + 1] = {
				id = option.id,
				text = option.text,
				icon = option.icon,
			}
		end
	end
end)

--[[ Events ]]--
AddEventHandler("health:stop", function()
	if Injury.isDead then
		Injury:SetAnim()
	end
end)

AddEventHandler("interact:onNavigate", function(id)
	if id:sub(1, ("injury"):len()) ~= "injury" then
		return
	end

	for k, option in ipairs(Injury.options) do
		if option.id == id and Injury.override ~= option.anim then
			Injury.override = option.anim
			Injury.state = nil

			Main:BuildNavigation()
			
			break
		end
	end
end)

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		if Main.isLoaded then
			Injury:Update()
		end

		Citizen.Wait(50)
	end
end)

Citizen.CreateThread(function()
	while true do
		if Main.isLoaded then
			Injury:UpdateFrame()
		end
		Citizen.Wait(0)
	end
end)