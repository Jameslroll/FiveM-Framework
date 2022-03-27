Main = {
	hasLoaded = false,
	hasSpawned = false,
}

--[[ Functions ]]--
function Main:Init()
	-- Get ped.
	local ped = PlayerPedId()
	if not ped or not DoesEntityExist(ped) then return end

	-- Update ped.
	SetEntityVisible(ped, false)
	SetEntityCollision(ped, false, false)
	SetBlockingOfNonTemporaryEvents(ped, true)
	FreezeEntityPosition(ped, true)
	SetEntityCoords(ped, 0.0, 0.0, 0.0)

	-- Shutdown loading screen.
	ShutdownLoadingScreen()
	ShutdownLoadingScreenNui()

	-- Set states.
	self.hasLoaded = true
	self.hasSpawned = false

	-- Start preview.
	Preview:Init()

	-- Trigger event.
	TriggerEvent("spawning:loaded")
end

function Main:Spawn(coords, static, exact)
	-- Find nearest haven.
	if not coords then
		coords = vector3(0.0, 0.0, 0.0)
	end

	-- Fade out.
	DoScreenFadeOut(1000)
	Citizen.Wait(1000)

	-- Stop preview.
	Preview:Destroy()

	-- Update coords.
	if exact then
		self:SpawnAtCoords(coords, nil)
	else
		self:SpawnAtHaven(coords, static)
	end

	-- Get ped.
	local ped = PlayerPedId()
	if not ped or not DoesEntityExist(ped) then return end

	-- Entity stuff.
	SetEntityVisible(ped, true)
	SetEntityCollision(ped, true, true)
	SetBlockingOfNonTemporaryEvents(ped, false)
	FreezeEntityPosition(ped, false)

	-- Set states.
	self.hasSpawned = true

	-- Trigger events.
	TriggerEvent("spawning:spawned")
end

function Main:Update()
	if not self.hasLoaded and self.characters then
		self:Init()
	end
end

function Main:HasLoaded()
	return self.hasLoaded
end

function Main:HasSpawned()
	return self.hasSpawned
end

function Main:FindNearestHaven(coords)
	local nearestDist, nearestHaven = 0.0, nil
	for _, haven in ipairs(Config.Havens) do
		local havenCoords = haven.Static.Coords
		local dist = #(vector3(havenCoords.x, havenCoords.y, havenCoords.z) - vector3(coords.x, coords.y, coords.z))
		if not nearestHaven or dist < nearestDist then
			nearestDist = dist
			nearestHaven = haven
		end
	end

	return nearestHaven
end

function Main:SpawnAtHaven(coords, static)
	local haven = self:FindNearestHaven(coords)
	if not haven then return end

	local pose = (static and haven.Static) or haven.Poses[GetRandomIntInRange(1, #haven.Poses + 1)]

	self:SpawnAtCoords(pose.Coords, pose.Anim)
end

function Main:SpawnAtCoords(coords, anim)
	local startTime = GetGameTimer()
	local ped = PlayerPedId()

	-- Switch out.
	SwitchOutPlayer(ped, 1, 2)
	DoScreenFadeIn(1000)

	-- Set coords.
	SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, true)
	
	-- Set heading.
	if type(coords) == "vector4" then
		SetEntityHeading(ped, coords.w)
	end

	-- Switch in.
	Citizen.Wait(2000)

	ped = PlayerPedId()

	SwitchOutPlayer(ped, 255, 3)
	SwitchInPlayer(ped)

	-- Wait for transition.
	while GetPlayerSwitchState() <= 8 do
		Citizen.Wait(0)
	end

	-- Wait for ground to load.
	WaitForGround()
	
	-- Play emote.
	if anim then
		exports.emotes:Play(anim)
	end
end

--[[ Exports ]]--
for k, v in pairs(Main) do
	if type(v) == "function" then
		exports(k, function(...)
			return Main[k](Main, ...)
		end)
	end
end

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		Main:Update()
		Citizen.Wait(0)
	end
end)

--[[ Events ]]--
RegisterNetEvent("spawning:start", function()
	if GetResourceState("character") == "started" then
		Main.characters = exports.character:GetCharacters()
	end
end)

RegisterNetEvent("character:load", function(characters)
	Main.characters = characters
end)