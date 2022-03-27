Cache = {
	Blips = {},
	BlipCount = 0,
	TextEntries = {}
}

function CreateBlip(coords, data, id)
	id = id or Cache.BlipCount

	local oldBlip = Cache.Blips[id]
	if oldBlip and DoesBlipExist(oldBlip) then
		RemoveBlip(oldBlip)
		Cache.Blips[id] = nil
	end

	local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
	SetBlipSprite(blip, data.id or 66)
	SetBlipAsShortRange(blip, true)
	SetBlipScale(blip, data.scale or 1.0)
	SetBlipColour(blip, data.color or 0)

	local label = data.name or "Unknown"
	local key = "Markers_"..label

	if not Cache.TextEntries[label] then
		Cache.TextEntries[key] = label
		AddTextEntry(key, label)
	end

	BeginTextCommandSetBlipName(key)
	EndTextCommandSetBlipName(blip)

	Cache.BlipCount = Cache.BlipCount + 1
	Cache.Blips[id] = blip

	return blip
end
exports("CreateBlip", CreateBlip)

AddEventHandler("blips:clientStart", function()
	for _, location in ipairs(Locations) do
		CreateBlip(location[2], Blips[location[1]])
	end
end)