Debugger = {}

--[[ Functions ]]--
function Debugger:Init(vehicle)
	self.vehicle = vehicle
	self.labels = {}

	local boneCache = {}
	for _, boneName in ipairs(Bones) do
		local boneIndex = GetEntityBoneIndexByName(vehicle, boneName)
		if boneIndex ~= -1 then
			boneCache[boneIndex] = boneName
		end
	end

	local boneCount = GetEntityBoneCount(vehicle)
	for i = 0, boneCount - 1 do
		local coords = GetEntityBonePosition_2(vehicle, i)
		local name = boneCache[i]

		self.labels[#self.labels + 1] = exports.interact:AddText({
			text = name or tostring(i),
			entity = vehicle,
			bone = i,
		})
	end
end

function Debugger:Destroy()
	self.vehicle = nil

	for _, label in ipairs(self.labels) do
		exports.interact:RemoveText(label)
	end
end

--[[ Commands ]]--
exports.chat:RegisterCommand("a:vehbones", function(source, args, command, cb)
	if Debugger.vehicle and DoesEntityExist(Debugger.vehicle) then
		Debugger:Destroy()
	else
		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)
		local vehicle = GetNearestVehicle(coords)

		Debugger:Init(vehicle)
	end
end, {
	description = "Visualize the nearest vehicle's information.",
}, "Dev")