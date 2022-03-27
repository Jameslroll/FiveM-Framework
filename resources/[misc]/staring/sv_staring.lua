RegisterNetEvent("stare", function()
	local source = source

	exports.log:Add({
		source = source,
		verb = "stared",
	})
end)