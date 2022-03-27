--[[ Functions: Slots ]]--
function Slots:Init()

end

function Slots:Activate(entity)
	if not DoesEntityExist(entity) then
		error("no machine")
	end

	local entityModel = GetEntityModel(entity)
	local machineIndex = self.config.machines[entityModel]
	if not machineIndex then
		error("invalid model")
	end

	local coords = GetEntityCoords(entity)
	local rotation = GetEntityRotation(entity)

	self.spinners = {}

	for k, offset in ipairs(self.config.spinners) do
		local model = self:GetSpinnerModel(machineIndex)

		while not HasModelLoaded(model) do
			RequestModel(model)
			Citizen.Wait(0)
		end

		local spinnerCoords = GetOffsetFromEntityInWorldCoords(entity, offset.x, offset.y, offset.z)
		local spinner = CreateObject(model, spinnerCoords.x, spinnerCoords.y, spinnerCoords.z, true, true, false)
		local netId = ObjToNet(spinner)

		SetNetworkIdCanMigrate(netId, false)
		SetEntityRotation(spinner, rotation.x, rotation.y, rotation.z)

		self.spinners[k] = spinner
	end

	self.entity = entity
	self.active = true
end

function Slots:Deactivate()
	self.active = nil
	self.entity = nil

	if self.spinners then
		for k, spinner in ipairs(self.spinners) do
			Delete(spinner)
		end
	end
end

function Slots:Update()
	-- Get delta time.
	local now = GetGameTimer()
	local deltaTime = (now - (self.lastUpdate or now)) / 1000.0
	self.lastUpdate = now

	-- Keybinds.
	if IsControlJustReleased(0, 203) then
		self:PlayAnim("pull_spin_a")
		Citizen.Wait(1300)
		TriggerServerEvent("casino:spinSlots")
	end

	-- Check entity.
	local entity = self.entity
	if not entity or not DoesEntityExist(entity) then return end

	-- Check is spinning.
	if not self.values then return end

	-- Update spinners.
	for k, spinner in ipairs(self.spinners) do
		while not NetworkHasControlOfEntity(spinner) do
			NetworkRequestControlOfEntity(spinner)
			Citizen.Wait(0)
		end

		local angle = self.angles[k] or 0.0
		local value = self.values[k] or 0.0
		local speed = self.speeds[k] or 0.0
		local threshold = self.thresholds[k]
		local target = (value / self.config.sides) * 360.0 + (360.0 * self.spins)

		if angle > target - threshold then
			speed = (target - angle) / threshold
		else
			speed = math.min(speed + (angle > target - 360.0 and -1.0 or 1.0) * deltaTime * 0.4, 1.0)
		end

		angle = math.min(angle + deltaTime * 360.0 * speed, target)

		self.angles[k] = angle
		self.speeds[k] = speed

		local rotation = GetEntityRotation(entity) + vector3(angle, 0.0, 0.0)

		SetEntityRotation(spinner, rotation.x, rotation.y, rotation.z)
	end
end

function Slots:SetValues(values)
	-- Get entity.
	local entity = self.entity
	if not entity or not DoesEntityExist(entity) then return end
	
	-- Cache values.
	self.spins = GetRandomIntInRange(5, 7)
	self.angles = {}
	self.speeds = {}
	self.thresholds = {}
	self.values = values
	
	-- Cache current rotations.
	local rotation = GetEntityRotation(entity)
	for k, spinner in ipairs(self.spinners) do
		local _rotation = GetEntityRotation(spinner)
		local start = (_rotation - rotation).x

		self.angles[k] = start
		self.speeds[k] = 0.0
		self.thresholds[k] = GetRandomFloatInRange(360.0, 2.0 * 360.0)
	end
end

function Slots:PlayAnim(name)
	exports.emotes:Play({
		Dict = "anim_casino_a@amb@casino@games@slots@male",
		Name = name,
		Flag = 48
	})

	-- local dict = "anim_casino_a@amb@casino@games@slots@female"
	-- while not HasAnimDictLoaded(dict) do
	-- 	RequestAnimDict(dict)
	-- 	Citizen.Wait(0)
	-- end

	-- local ped = PlayerPedId()
	-- local entity = self.entity
	-- local coords = GetEntityCoords(entity)
	-- local rotation = GetEntityRotation(entity, 2)
	-- local model = GetEntityModel(entity)

	-- netScene = NETWORK::NETWORK_CREATE_SYNCHRONISED_SCENE(coords, rot, 2, Local_2112.f_17, Local_2112.f_16, 1f, 0f, 1f);
	-- NETWORK::NETWORK_ADD_PED_TO_SYNCHRONISED_SCENE(PLAYER::PLAYER_PED_ID(), netScene, func_328(), &Local_2112, 2f, -1.5f, 13, 16, 1000f, 0);
	-- StringCopy(&cVar0, "vw_prop_casino_slot_0", 24);
	-- StringIntConCat(&cVar0, Local_219[iLocal_2131 /*21*/].f_17, 24);
	-- StringConCat(&cVar0, "a", 24);
	-- iVar6 = MISC::GET_HASH_KEY(&cVar0);
	-- StringConCat(&Local_2112, "_SLOTMACHINE", 64);
	-- NETWORK::_0x45F35C0EDC33B03B(netScene, iVar6, coords, func_328(), &Local_2112, 2f, -1.5f, 13);
	-- NETWORK::NETWORK_START_SYNCHRONISED_SCENE(netScene);

	-- local netScene = CreateSynchronizedScene(coords.x, coords.y, coords.z, rotation.x, rotation.y, rotation.z, 2, 0, 1, 1.0, 0.0, 1.0)
	-- -- NetworkAddPedToSynchronisedScene(ped, netScene, dict, name, 2.0, -1.5, 13, 16, 1000.0, 0)
	-- NetworkAddEntityToSynchronisedScene(entity, netScene, dict, name.."_SLOTMACHINE", 1.0, 1.0, 0)
	-- N_0x45f35c0edc33b03b(netScene, model, coords.x, coords.y, coords.z, dict, name.."_slotmachine", 2.0, -1.5, 13)
	-- NetworkAddEntityToSynchronisedScene(entity, netScene, dict, name.."_slotmachine", 1.0, 1.0, 1)
	-- NetworkStartSynchronisedScene(netScene)

	-- PlaySynchronizedEntityAnim(
	-- 	entity,
	-- 	netScene,
	-- 	name.."_slotmachine",
	-- 	dict,
	-- 	1.0,
	-- 	false,
	-- 	false,
	-- 	true,
	-- 	0.0,
	-- 	0x4000
	-- )
end

--[[ Events ]]--
AddEventHandler("chairs:activate", function(entity)
	if not entity then return end

	local model = GetEntityModel(entity)
	if Slots.config.machines[model] then
		Casino:Activate("Slots", entity)
	end
end)

AddEventHandler("chairs:deactivate", function(entity)
	if not Slots.active then return end

	Casino:Deactivate()
end)

--[[ Events: Net ]]--
RegisterNetEvent("casino:spinSlots", function(values)
	Slots:SetValues(values)
end)