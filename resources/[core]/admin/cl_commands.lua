Locations = {}

exports.chat:RegisterCommand("a:tp", function(source, args, command, cb)
	local x, y, z, w = table.unpack(args)

	x = x and x:gsub(",", "")
	y = y and y:gsub(",", "")
	z = z and z:gsub(",", "")
	w = w and w:gsub(",", "")

	if tonumber(x) then
		x = tonumber(x)
		y = tonumber(y)
		z = tonumber(z)
		w = tonumber(w)
	elseif x then
		local pin = Locations[x]
		if pin then
			x = pin.x
			y = pin.y
			z = pin.z
			w = pin.w
		end
	end

	if not x or not y or not z then
		cb("error", "Invalid vector (XYZ) or name!")
		return
	end
	
	local ped = PlayerPedId()
	SetEntityCoordsNoOffset(ped, x + 0.0, y + 0.0, z + 0.0, true)

	if w then
		SetEntityHeading(ped, w)
	end
end, {
	description = "Teleport to XYZ coordinates."
}, "Mod")

exports.chat:RegisterCommand("a:pin", function(source, args, command, cb)
	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped, true)
	local heading = GetEntityHeading(ped)

	local name = args[1]
	if not name then
		cb("error", "Missing name!")
		return
	end

	Locations[name] = vector4(coords.x, coords.y, coords.z, heading)

	SetResourceKvp("AdminLocations", json.encode(Locations))

	cb("success", ("Saved pin '%s' at '%s'!"):format(name, coords))
end, {
	description = "Pin your current location for 'a:tp'."
}, "Mod")

exports.chat:RegisterCommand("a:unpin", function(source, args, command, cb)
	local name = args[1]
	if not name then
		cb("error", "Missing name!")
		return
	end

	if not Locations[name] then
		cb("error", "Pin does not exist!")
		return
	end

	Locations[name] = nil

	SetResourceKvp("AdminLocations", json.encode(Locations))

	cb("success", ("Removed pin '%s'!"):format(name))
end, {
	description = "Remove a pinned location."
}, "Mod")

exports.chat:RegisterCommand("a:pins", function(source, args, command, cb)
	local str = ""
	for name, coords in pairs(Locations) do
		if str ~= "" then
			str = str.."<br>"
		end
		str = str..("%s (%.4f, %.4f, %.4f, %.4f)"):format(name, coords.x, coords.y, coords.z, coords.w)
	end

	if str == "" then
		cb("inform", "You have no pins!")
		return
	end

	TriggerEvent("chat:addMessage", {
		title = "Pins",
		html = str,
		class = "system",
	})
end, {
	description = "View your current pins."
}, "Mod")

AddEventHandler(Admin.event.."clientStart", function()
	local locationsKvp = GetResourceKvpString("AdminLocations")
	if locationsKvp then
		Locations = json.decode(locationsKvp)
	end
end)