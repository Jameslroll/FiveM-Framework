Parking = {}

function Parking:Init()
	local entities = {}
	local temp = {}
	-- local boatFlags = {
	-- 	[2415920736] = true,
	-- 	[2415922784] = true,
	-- 	[2415920993] = true,
	-- 	[2415923040] = true,
	-- }

	-- for flag, _ in pairs(boatFlags) do
	-- 	print(flag >> 12)
	-- end

	-- v.flags >> 12 ~= 589824

	for k, v in ipairs(CarGen) do
		local isBoat = v.flags >> 12 ~= 589824

		entities[k] = {
			id = "parking-"..tostring(v.id),
			name = "Parking Spot",
			coords = v.coords,
			radius = math.min(v.length, isBoat and 5.0 or 2.0),
			floor = isBoat,
			navigation = {
				id = "parking",
				text = "Parking",
				icon = "local_parking",
			},
		}

		local hash = GetHashKey(v.coords.x.."_"..v.coords.y.."_"..v.coords.z)
		if temp[hash] then
			print("collision", v.id, temp[hash])
		end
		temp[hash] = v.id
	end

	exports.entities:RegisterBulk(entities)
end

--[[ Listeners ]]--
AddEventHandler("garages:clientStart", function()
	Parking:Init()
end)

--[[ Commands ]]--
exports.chat:RegisterCommand("a:parkingtp", function(source, args, command, cb)
	local nearest, nearestDist = nil, 0.0
	local ped = PlayerPedId()
	local pedCoords = GetEntityCoords(ped)
	
	for k, v in ipairs(CarGen) do
		local dist = #(pedCoords - vector3(v.coords.x, v.coords.y, v.coords.z))
		if not nearest or dist < nearestDist then
			nearest = v.coords
			nearestDist = dist
		end
	end

	SetEntityCoords(ped, nearest.x, nearest.y, nearest.z, true)
end, {
	description = "Goto the nearest parking spot.",
}, "Dev")