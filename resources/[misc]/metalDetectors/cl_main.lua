Main = {}

function Main:Init()
	for k, zone in ipairs(Zones) do
		exports.entities:Register({
			id = "metalDetector-"..k,
			event = "metalDetector",
			name = "Metal Detector",
			coords = zone.Coords,
			radius = zone.Radius,
		})
	end
end

function Main:Trigger()
	if self:ShouldActivate() then
		TriggerServerEvent("playSound3D", "metaldetector", 1.0, 0.5)
	end
end

function Main:ShouldActivate()
	local container = exports.inventory:GetPlayerContainer()
	if not container then return false end

	for slotId, slot in pairs(container.slots) do
		local item = exports.inventory:GetItem(slot.item_id)
		if item and item.category == "Gun" then
			return true
		end
	end

	return false
end

--[[ Events ]]--
AddEventHandler(GetCurrentResourceName()..":clientStart", function()
	Main:Init()
end)

AddEventHandler("entities:onEnter", function(id, event)
	if event ~= "metalDetector" then return end

	Main:Trigger()
end)