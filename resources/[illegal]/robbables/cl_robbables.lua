--[[ Threads ]]--
Citizen.CreateThread(function()
	for k, robbable in ipairs(Config.Robbables) do
		for _k, model in ipairs(robbable.Models) do
			local id = ("robbable-%s-%s"):format(k, _k)
			
			exports.interact:Register({
				id = id,
				text = robbable.Text,
				items = robbable.Items,
				model = model
			})
	
			AddEventHandler("interact:on_"..id, function(...)
				print("rob", k, _k)
			end)
		end
	end
end)