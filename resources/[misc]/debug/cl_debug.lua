local canOpen = false
local open = false
local focus = false

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		while not canOpen do
			Citizen.Wait(5000)
		end

		if IsControlJustPressed(1, 10) then
			ToggleMenu()
		elseif IsControlJustPressed(1, 11) and open then
			ToggleCursor()
		end
		
		if open then
			local ped = PlayerPedId()
			local pedCoords = GetEntityCoords(ped)
			local pedHeading = GetEntityHeading(ped)
			local input = {
				{ id = "player-coords", value = ("vector4(%s, %s, %s, %s)"):format(pedCoords.x, pedCoords.y, pedCoords.z, pedHeading) }
			}

			SendNUIMessage({ input = input })
		end
	end
end)

function CanOpen(user)
	if not user then
		user = exports.user:GetUser(PlayerId())
	end
	if not user then return false end

	return exports.user:IsGroup(user, "Support")
end

function ToggleCursor()
	focus = not focus
	SetNuiFocus(focus, focus)
	SetNuiFocusKeepInput(false)
	SetPlayerControl(PlayerPedId(), not focus, 0)
end

function ToggleMenu()
	open = not open
	SendNUIMessage( { open = open } )

	if not open and focus then
		ToggleCursor()
	end
end

RegisterNetEvent("user:ready")
AddEventHandler("user:ready", function(user)
	canOpen = CanOpen(user)
end)

RegisterNetEvent("onResourceStart")
AddEventHandler("onResourceStart", function()
	canOpen = CanOpen()
end)

RegisterNUICallback("toggleCursor", function(data) ToggleCursor() end)
RegisterNUICallback("toggleMenu", function(data) ToggleMenu() end)