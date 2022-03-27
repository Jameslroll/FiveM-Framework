Impound = {
	cooldowns = {},
}

--[[ Functions ]]--
function Impound:Finish(source, entity)
	-- Check cooldown.
	if os.clock() - (self.cooldowns[source] or 0.0) < Config.Impounding.Anim.Duration / 1000.0 then
		return
	end

	-- Get marked.
	local marked = Marking.objects[entity]
	print("marked?", marked)
	if marked == nil then return false end

	-- Cooldowns.
	self.cooldowns[source] = os.clock()
	
	-- Destroy entity.
	marked:Destroy()
	DeleteEntity(entity)

	-- Reward.
	local amount = Config.Impounding.Reward

	exports.character:AddBank(source, amount, true)

	-- Return.
	return true
end

--[[ Events ]]--
RegisterNetEvent("impound:finish")
AddEventHandler("impound:finish", function(netId, siteId)
	local source = source

	print(netId, siteId)

	-- Check input.
	if type(netId) ~= "number" then return end

	-- Check entity.
	local entity = NetworkGetEntityFromNetworkId(netId)
	print(netId, siteId)
	if not DoesEntityExist(entity) then return end

	-- Impound.
	if Impound:Finish(source, entity, siteId) then
		exports.log:Add({
			source = source,
			verb = "impounded",
			noun = "vehicle",
			extra = ("net id: %s"):format(netId),
		})
	end
end)