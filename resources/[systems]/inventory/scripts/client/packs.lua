AddEventHandler("inventory:use", function(item, slot, cb)
	-- Check item.
	local pack = item.pack
	if pack == nil then return end

	-- Get settings.
	local settings = Config.Packs[pack]
	if settings == nil then return end

	-- Callback.
	cb(settings.Anim.Duration or 1000, settings.Anim)
end)