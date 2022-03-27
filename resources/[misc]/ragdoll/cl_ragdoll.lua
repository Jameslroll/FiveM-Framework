Main = {}

--[[ Functions ]]--
function Main:Toggle(value)
	self.value = value
end

function Main:Update()
	if not self.value then
		Citizen.Wait(200)
		return
	end

	local state = (LocalPlayer or {}).state
	if not state then return end

	local ped = PlayerPedId()
	local ragdoll = IsPedRagdoll(ped) and not IsPedGettingUp(ped)

	if not ragdoll and (
		not IsPedFalling(ped) and
		IsControlEnabled(0, 51) and
		IsControlEnabled(0, 52) and
		not state.restrained and
		not state.immobile and
		not state.carrier and
		not state.following
	) then
		SetPedToRagdoll(ped, 2000, 1000, 0)
	end
end

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		Main:Update()
		Citizen.Wait(0)
	end
end)

--[[ Commands ]]--
RegisterCommand("+roleplay_ragdoll", function()
	Main:Toggle(true)
end, true)

RegisterCommand("-roleplay_ragdoll", function()
	Main:Toggle(false)
end, true)

RegisterKeyMapping("+roleplay_ragdoll", "Ragdoll", "keyboard", "o")