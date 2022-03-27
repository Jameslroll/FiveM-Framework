Main = {}

--[[ Functions ]]--
function Main:Init()
	SetRoutingBucketPopulationEnabled(1, false)
end

function Main:Enter(source, portal)
	local bucket = GetPlayerRoutingBucket(source)
	local isEntering = bucket == 0

	exports.log:Add({
		source = source,
		verb = isEntering and "entered" or "exited",
		noun = "training server",
		extra = ("portal: %s"):format(portal),
	})

	SetPlayerRoutingBucket(source, isEntering and 1 or 0)

	TriggerClientEvent("training:enter", source, portal, isEntering)
end

--[[ Events ]]--
AddEventHandler("training:start", function()
	Main:Init()
end)

--[[ Events: Net ]]--
RegisterNetEvent("training:enter", function(portal)
	local source = source

	if not Config.Portals[portal] then return end
	
	Main:Enter(source, portal)
end)