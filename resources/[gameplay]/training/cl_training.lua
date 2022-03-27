Main = {}

--[[ Functions ]]--
function Main:Init()
	for k, portal in ipairs(Config.Portals) do
		exports.interact:Register({
			id = "trainingPortal-"..k,
			text = Config.Text,
			radius = Config.Radius,
			coords = portal.In,
			event = "trainingPortal",
			portal = k,
		})
	end
end

--[[ Events ]]--
AddEventHandler("training:clientStart", function()
	Main:Init()
end)

AddEventHandler("interact:on_trainingPortal", function(interactable)
	local portal = Config.Portals[interactable.portal or false]
	if not portal then return end

	if not exports.user:IsMod() then -- TODO: add job check.
		TriggerEvent("chat:notify", {
			class = "error",
			text = Config.Message.Error,
		})
		
		return
	end

	TriggerServerEvent("training:enter", interactable.portal)
end)

--[[ Events: Net ]]--
RegisterNetEvent("training:enter", function(id, isEntering)
	local portal = Config.Portals[id]
	if not portal then return end

	TriggerEvent("instances:join")
	TriggerEvent("chat:notify", Config.Message[isEntering and "Enter" or "Exit"])

	local ped = PlayerPedId()
	local coords = portal.Out

	SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, true)
end)