Actions = {}

--[[ Functions: Main ]]--
function Main:PerformAction(ped, name)
	-- Get action.
	local action = Actions[name]
	if action == nil then return end
	
	-- Check entity.
	if not DoesEntityExist(ped) then return end
	
	local entity = Entity(ped)
	if not entity or entity.mugged then return end

	-- Set action.
	entity.state.action = name
	action(Action, ped)
end

function Main:CancelAction(ped, action)
	-- Check entity.
	if not DoesEntityExist(ped) then return end
	
	local entity = Entity(ped)
	if not entity then return end

	-- Compare action.
	if entity.state.action ~= action then return end

	-- Clear action.
	entity.state.action = nil
	print("cancel action")
end

function Main:Rob(source, ped)
	-- Check entity.
	if not DoesEntityExist(ped) then return end
	
	local entity = Entity(ped)
	if not entity or entity.state.mugged or entity.state.action then return end

	-- Cooldowns.
	local robDelta = os.clock() - (Main.cooldowns[source] or 0.0)
	if robDelta < 7.0 then
		exports.sv_test:Report(source, ("robbing two npcs in %s seconds"):format(tostring(robDelta)), true)
		return
	end

	Main.cooldowns[source] = os.clock()

	-- Destroy.
	self:Destroy(ped)

	-- Get money.
	local amount = math.floor(GetRandomFloatInRange(Config.Cash.Min, Config.Cash.Max) * 100.0) / 100.0

	-- Log event.
	exports.log:Add({
		source = source,
		verb = "mugged",
		extra = ("$%.2f"):format(amount),
	})

	-- Give money.
	exports.inventory:GiveMoney(source, amount)

	-- Give items.
	for _, item in ipairs(Config.Items) do
		if GetRandomFloatInRange(0.0, 1.0) < item.chance then
			exports.inventory:GiveItem(source, item.name)
			break
		end
	end
end

--[[ Functions: Dance ]]--
function Actions:Dance(ped) end
function Actions:Flee(ped) end
function Actions:Follow(ped) end
function Actions:Keys(ped) end
function Actions:Knees(ped) end
function Actions:Rob(ped) end
function Actions:Stay(ped) end