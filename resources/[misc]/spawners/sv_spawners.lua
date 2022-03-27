Spawners = {}
LastSpawnerId = 0

Spawner = {}
Spawner.__index = Spawner

function Spawner:Create(data)
	local id = LastSpawnerId + 1

	data = data or {}
	data.id = id
	data.pedCount = 0
	data.peds = {}

	local instance = setmetatable(data, Spawner)

	LastSpawnerId = id
	Spawners[id] = instance

	return instance
end

function Spawner:Destroy()
	Spawners[self.id] = nil
end

function Spawner:Update()
	for ped, _ in pairs(self.peds) do
		if not DoesEntityExist(ped) then
			self.peds[ped] = nil
			self.pedCount = self.pedCount - 1
		end
	end

	if self.pedCount < (self.limit or 5) then
		local coords = self:GetPoint()
		self:CreatePed(0, self.model, coords.x, coords.y, coords.z, GetRandomFloatInRange(0.0, 360.0), true, true)
	end
end

function Spawner:CreatePed(...)
	local ped = CreatePed(...)

	print(ped)
	
	self.peds[ped] = true
	self.pedCount = self.pedCount + 1
end

function Spawner:GetPoint()
	local coords = self.coords

	if self.radius then
		local rad = GetRandomFloatInRange(0.0, 2.0 * math.pi)
		local dist = GetRandomFloatInRange(0.0, self.radius)

		coords = coords + vector3(math.cos(rad) * dist, math.sin(rad) * dist, 0.0)
	end

	return coords
end

Spawner:Create({
	coords = vector3(1460.3175048828125, 1111.9207763671875, 114.33841705322266),
	radius = 15.0,
	limit = 4,
	model = `a_c_cow`,
})

Spawner:Create({
	coords = vector3(1449.7451171875, 1067.480712890625, 114.33392333984376),
	radius = 10.0,
	limit = 4,
	model = `a_c_hen`,
})

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		for id, spawner in pairs(Spawners) do
			spawner:Update()
		end

		Citizen.Wait(1000)
	end
end)

--[[ Events ]]--
AddEventHandler(GetCurrentResourceName()..":stop", function()
	for id, spawner in pairs(Spawners) do
		for ped, _ in pairs(spawner.peds) do
			if DoesEntityExist(ped) then
				DeleteEntity(ped)
			end
		end
	end
end)