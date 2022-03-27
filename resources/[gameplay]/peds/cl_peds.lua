Main = {
	peds = {},
	debug = false,
}

--[[ Functions ]]--
function Main:UpdateCache()
	local cache = {}

	for ped in EnumeratePeds() do
		if self:IsPedValid(ped) then
			if not self.peds[ped] then
				TriggerEvent("pedCreated", ped)

				self.peds[ped] = {
					events = {},
				}
			end

			cache[ped] = true
		end
	end

	for ped, info in pairs(self.peds) do
		if not cache[ped] then
			TriggerEvent("pedRemoved", ped)

			self.peds[ped] = nil

			if info.text then
				exports.interact:RemoveText(info.text)
			end
		end
	end
end

function Main:UpdatePeds()
	for ped, info in pairs(self.peds) do
		self:UpdatePed(ped, info)
	end
end

function Main:UpdatePed(ped, info)
	for eventName, eventId in pairs(Config.Events) do
		local isResponding = eventId ~= -1 and IsPedRespondingToEvent(ped, eventId)
		local isCached = info.events[eventName]

		if isResponding and not isCached then
			TriggerEvent("pedStartRespondingToEvent", ped, eventName, eventId)

			info.events[eventName] = true
			
			if self.debug then
				local coords = GetEntityCoords(ped)
				
				info.text = exports.interact:AddText({
					text = eventName,
					entity = ped,
					offset = vector3(0.0, 0.0, 2.0),
				})
			end
		elseif not isResponding and isCached then
			TriggerEvent("pedStopRespondingToEvent", ped, eventName, eventId)

			info.events[eventName] = nil

			if info.text then
				exports.interact:RemoveText(info.text)
				info.text = nil
			end
		end
	end
end

function Main:IsPedValid(ped)
	return (
		not IsPedDeadOrDying(ped) and
		IsPedHuman(ped) and
		not IsPedAPlayer(ped) and
		NetworkGetEntityIsNetworked(ped)
	)
end

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		Main:UpdateCache()
		Citizen.Wait(1000)
	end
end)

Citizen.CreateThread(function()
	while true do
		Main:UpdatePeds()
		Citizen.Wait(1000)
	end
end)

--[[ Commands ]]--
exports.chat:RegisterCommand("a:peddebug", function(source, args, command, cb)
	Main.debug = not Main.debug

	cb("inform", ("Debug mode for peds %s!"):format(Main.debug and "enabled" or "disabled"))
end, {
	description = "Toggle debug mode for ped events.",
}, "Dev")