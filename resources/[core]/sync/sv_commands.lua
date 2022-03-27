exports.chat:RegisterCommand("a:weather", function(source, args, rawCommand, cb)
	-- Get weather and check.
	local weather = args[1]:upper()
	if not weather or not Config.Weathers[weather] then
		cb("error", ("Weather '%s' does not exist!"):format(weather or "NONE"))
		return
	end

	-- Check current weather.
	local lastWeather = Main.weather
	if lastWeather == weather then
		cb("error", ("Weather is already set to '%s'!"):format(weather))
		return
	end

	-- Log it.
	exports.log:Add({
		source = source,
		verb = "set",
		noun = "weather",
		extra = ("%s to %s"):format(lastWeather, weather),
		channel = "admin",
	})
	
	-- Set weather.
	Main:SetWeather(weather)

	-- Callback.
	cb("success", ("Weather '%s' set to '%s'!"):format(lastWeather, weather))
end, {
	description = "Change the weather!",
	parameters = {
		{ name = "Weather", description = "Weather types: EXTRASUNNY, CLEAR, NEUTRAL, SMOG, FOGGY, OVERCAST, CLOUDS, CLEARING, RAIN, THUNDER, SNOW, BLIZZARD, SNOWLIGHT, XMAS, HALLOWEEN" },
	}
}, "Admin")

exports.chat:RegisterCommand("a:time", function(source, args, rawCommand, cb)
	local hour, minute, second = tonumber(args[1]) or 12, tonumber(args[2]) or 0, tonumber(args[3]) or 0
	local timeText = ("%02d:%02d:%02d"):format(hour, minute, second)

	Main:SetTimeOfDay(hour, minute, second)

	exports.log:Add({
		source = source,
		verb = "set",
		noun = "time",
		extra = timeText,
		channel = "admin",
	})

	cb("success", ("Time set to %s!"):format(timeText))
end, {
	description = "Change the time instantly.",
	parameters = {
		{ name = "Hour", description = "Hour of day (1-24)" },
		{ name = "Minute", description = "Minute of day (0-60)" },
		{ name = "Second", description = "Second of day (0-60)" },
	}
}, "Admin")