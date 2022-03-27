Main = {}

--[[ Functions: Chair ]]--
function Main:Init()
	for k, interact in ipairs(Config.Interactables) do
		interact.id = "bell-"..k
		interact.event = "bell"
		interact.text = interact.text or "Ring Bell"
		
		exports.interact:Register(interact)
	end
end

function Main:Ring(coords)
	if type(coords) ~= "vector3" then return end

	exports.emotes:Play(Config.Emote)

	Citizen.Wait(Config.Delay)

	TriggerServerEvent(EventName.."ring", coords)
end

--[[ Events ]]--
AddEventHandler(EventName.."clientStart", function()
	Main:Init()
end)

AddEventHandler("interact:on_bell", function(interactable)
	Main:Ring(interactable.entity and GetEntityCoords(interactable.entity) or interactable.coords)
end)