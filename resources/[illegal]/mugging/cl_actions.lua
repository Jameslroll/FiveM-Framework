Actions = {}

--[[ Functions: Ped ]]--
function Ped:PerformAction(name)
	-- Get action.
	local action = Actions[name]
	if action == nil then return end

	-- Trigger event.
	TriggerServerEvent("mugging:performAction", self.netId, name)
	
	-- Invoke action.
	action(Actions, self, name)
end

function Ped:PlayAnimAction(anim, action)
	self:PlayAnim(anim)

	Citizen.Wait(200)

	while IsEntityPlayingAnim(self.entity, anim.Dict, anim.Name, 3) do
		Citizen.Wait(0)
	end

	self:CancelAction(action)
end

function Ped:CancelAction(name)
	if not DoesEntityExist(self.entity) then return end

	TriggerServerEvent("mugging:cancelAction", self.netId, name)
end

--[[ Functions: Actions ]]--
function Actions:Dance(ped, action)
	local dances = Config.Anims.Dances
	local dance = dances[GetRandomIntInRange(1, #dances)]

	ped:PlayAnimAction(dance, action)
end

function Actions:Knees(ped, action)
	ped:PlayAnimAction(Config.Anims.Knees, action)
end

function Actions:Rob(ped, action)
	local entity = ped.entity
	local playerPed = PlayerPedId()

	-- Boost confidence.
	ped.confidence = 2.0

	-- Wait.
	Citizen.Wait(GetRandomIntInRange(500, 1000))

	-- Face ped.
	if not IsPedFacingPed(entity, playerPed, 15.0) then
		WaitForAccess(entity)
		TaskTurnPedToFaceEntity(entity, playerPed, 3000)
		Citizen.Wait(2000)
	end
	
	-- Play anim.
	ped:PlayAnimAction(Config.Anims.Give, action)

	-- Check distance.
	local isValid, dist = Main:IsValidTarget(entity)
	if not isValid or dist > Config.RobDistance or GetGameTimer() - (Main.lastRob or 0.0) < 8000 then return end

	-- Finish robbing.
	TriggerServerEvent("mugging:rob", ped.netId)
	Main.lastRob = GetGameTimer()

	ped:CancelAction(action)
	ped:Destroy(true)
end

function Actions:Stay(ped, action)
	local entity = ped.entity
	WaitForAccess(entity)

	ClearPedTasks(entity)
	TaskStandStill(entity, 60 * 1000)
	ped:PlayAnim(Config.Anims.HandsUp)
end

function Actions:Follow(ped, action)
	local entity = ped.entity
	local _entity = Entity(entity)
	local startTime = GetGameTimer()

	while DoesEntityExist(entity) and GetGameTimer() - startTime < 8000 and _entity.state.action ~= "Follow" do
		Citizen.Wait(0)
	end
	
	WaitForAccess(entity)
	TaskFollowToOffsetOfEntity(entity, PlayerPedId(), 0.0, 0.0, 0.0, 1.0, -1, 5.0, 1)

	while _entity.state.action == "Follow" do
		Citizen.Wait(0)
	end

	ped:CancelAction(action)
end

function Actions:Flee(ped, action)
	local entity = ped.entity

	WaitForAccess(entity)

	ped:CancelAction(action)
	ped:Destroy(true)
end