--[[ Initialization ]]--
for habitat, settings in pairs(Config.Habitats) do
	settings.TotalChance = 0.0
	for fish, chance in pairs(settings.Fish) do
		settings.TotalChance = settings.TotalChance + chance
	end
end

--[[ Functions ]]--
function GetRandomFish(habitat)
	local settings = Config.Habitats[habitat]
	if not settings then return end

	local totalChance = settings.TotalChance
	local seed = math.floor(os.clock() * 1000)
	for fish, chance in pairs(settings.Fish) do
		totalChance = totalChance - chance

		math.randomseed(seed)
		if chance > math.random() * totalChance then
			return fish
		end
		seed = seed + 1
	end
end

--[[ Events ]]--
RegisterNetEvent("fishing:catch", function(slotId, habitat)
	local source = source

	if type(slotId) ~= "number" or type(habitat) ~= "string" then return end

	-- Get fish.
	local fish = GetRandomFish(habitat)
	if not fish then return end

	-- Get player container id.
	local containerId = exports.inventory:GetPlayerContainer(source, true)
	if not containerId then return end

	-- Get item in slot.
	local item = exports.inventory:ContainerInvokeSlot(containerId, slotId, "GetItem")
	if not item or item.name ~= Config.Item then return end

	-- Decay item.
	if not exports.inventory:ContainerInvokeSlot(containerId, slotId, "Decay", GetRandomFloatInRange(table.unpack(Config.Decay))) then
		return
	end
	
	-- Give fish.
	local gaveItem, reason = table.unpack(exports.inventory:GiveItem(source, fish))
	if gaveItem then
		-- Log it.
		exports.log:Add({
			source = source,
			verb = "caught",
			noun = fish,
			extra = habitat,
			channel = "misc",
		})
	else
		-- Notify player.
		TriggerClientEvent("chat:notify", source, "You couldn't hold the fish, so it went back into the water!", "error")
	end
end)