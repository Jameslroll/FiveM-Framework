Main = {
	trains = {},
}

--[[ Functions ]]--
function Main:SpawnTrain(x, y, z, trackIndex)
	self:LoadModels()

	local track = Tracks[trackIndex]
	if not track then return end

	local trainType = track.Type == 1 and GetRandomIntInRange(0, 24) or 25
	if track.Type == 1 and trainType == 21 then
		trainType = 1
	end

	local train = CreateMissionTrain(trainType, x, y, z, track.Direction or false)
	-- SetTrainCruiseSpeed(train, 50.0)
end

function Main:Update()
	local delta = (self.lastUpdate and GetGameTimer() - self.lastUpdate or 0) / 1000.0
	self.lastUpdate = GetGameTimer()

	for netId, train in pairs(self.trains) do
		local blip = train.blip
		if blip and DoesBlipExist(blip) then
			SetBlipCoords(blip, train.coords.x, train.coords.y, train.coords.z)
			SetBlipRotation(blip, math.ceil(train.heading))
		end

		train.coords = train.coords + train.velocity * delta
	end
end

function Main:LoadModels()
	for k, model in ipairs(Config.Models) do
		while not HasModelLoaded(model) do
			RequestModel(model)
			Citizen.Wait(0)
		end
	end
end

function Main:UpdateTrain(netId, coords, heading, velocity)
	local train = self.trains[netId]
	if not train then
		train = {}
		self.trains[netId] = train
	end

	train.coords = coords or vector3(0.0, 0.0, 0.0)
	train.heading = heading or 0.0
	train.velocity = velocity or vector3(0.0, 0.0, 0.0)

	local blip = train.blip
	if not blip or not DoesBlipExist(blip) then
		blip = AddBlipForCoord(coords.x, coords.y, coords.z)
		SetBlipSprite(blip, 795)
		SetBlipAlpha(blip, 64)
		SetBlipAsShortRange(blip, true)
		SetBlipHiddenOnLegend(blip, true)
		SetBlipColour(blip, 26)
		SetBlipScale(blip, 0.6)
		SetBlipShrink(blip, false)
		SetBlipHighDetail(blip, false)
		SetBlipDisplay(blip, 8)

		train.blip = blip
	end
end

function Main:RemoveTrain(netId)
	local train = self.trains[netId]
	if not train then return end

	if train.blip then
		RemoveBlip(train.blip)
	end

	self.trains[netId] = nil
end

--[[ Events: Net ]]--
RegisterNetEvent("trains:spawn", function(node)
	Main:SpawnTrain(node.x, node.y, node.z, node.w)
end)

RegisterNetEvent("trains:sync", function(...)
	Main:UpdateTrain(...)
end)

RegisterNetEvent("trains:remove", function(netId)
	Main:RemoveTrain(netId)
end)

Citizen.CreateThread(function()
	while true do
		Main:Update()
		Citizen.Wait(30)
	end
end)