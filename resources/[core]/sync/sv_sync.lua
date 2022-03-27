Main = Main or {}

--[[ Functions: Weather ]]--
function Main:NextWeather()
	local weather = Config.Weathers[self.weather]
	if not weather.Next then
		return
	end

	local day, month, year, hour, minute, second = self:GetTimes()
	
	-- local nextWeather = nil
	-- local isWinter = month >= Config.Winter.Start or month <= Config.Winter.End
	-- if isWinter then
	-- else
	-- end

	local nextWeather = self:GetRandomWeather(weather.Next)
	if nextWeather then
		self:SetWeather(nextWeather)
		return nextWeather
	end
end

function Main:GetRandomWeather(weathers)
	-- Add the total probability up.
	local total = 0.0
	for weather, chance in pairs(weathers) do
		total = total + chance
	end

	-- Find the weather within the probability.
	local random = math.random() * total
	for weather, chance in pairs(weathers) do
		if chance > random then
			return weather
		end
		random = random - chance
	end
end

function Main:SetWeather(weather)
	if self.weather == weather then
		return false
	end

	self.weather = weather

	TriggerClientEvent("sync:update", -1, "Weather", weather)

	return true
end

--[[ Functions: Time ]]--
function Main:GetTimeWithOffset()
	return os.time() + (self.timeOffset or 0)
end

function Main:GetTime()
	return os.time() * Config.TimeScale
end

function Main:SetTimeOfDay(hour, minute, second)
	local currentHour, currentMinute, currentSecond = self:GetHour(), self:GetMinute(), self:GetSecond()
	
	self.timeOffset = (
		(hour - currentHour) * (60.0 / Config.TimeScale) +
		(minute - currentMinute) * (1.0 / Config.TimeScale) +
		(second - currentSecond) * (0.016667 / Config.TimeScale)
	)

	self:SyncTime()
end

function Main:SyncTime()
	TriggerClientEvent("sync:update", -1, "Time", Main:GetTimeWithOffset())
end

--[[ Events ]]--
RegisterNetEvent("sync:ready", function()
	local source = source
	
	TriggerClientEvent("sync:update", -1, "Both", Main:GetTimeWithOffset(), Main.weather)
end)

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		Main:NextWeather()
		
		Citizen.Wait(1000 * 60 * math.random(10, 15))
	end
end)

Citizen.CreateThread(function()
	while true do
		Main:SyncTime()
		Citizen.Wait(1000 * 60)
	end
end)