Main = Main or {}

--[[ Functions ]]--
function Main:Update()
	-- Update weather.
	if not self.overriding and self.nextWeather and self.weather ~= self.nextWeather then
		self:SetWeather(self.nextWeather)
		self.nextWeather = nil
	end

	-- Update time.
	local day, month, year, hour, minute, second = self:GetTimes()

	if self.night then
		hour = 0
	end

	NetworkOverrideClockTime(hour, minute, 0)
	SetClockDate(day, month, year)

	-- Force weather.
	if self.lastChange and GetGameTimer() - self.lastChange > 1000.0 * Config.TransitionTime then
		SetWeatherTypeNow(self.weather)
		SetWeatherTypeNowPersist(self.weather)
	end
end

function Main:SetBlackout(value)
	SetArtificialLightsState(value)
	SetArtificialLightsStateAffectsVehicles(false)
end

function Main:SetWeather(weather)
	self.weather = weather
	self.lastChange = GetGameTimer()
	
	print("set weather", weather)

	SetWeatherTypeOvertimePersist(weather, Config.TransitionTime)
end

function Main:GetTime()
	return self:GetServerTime() / 1000.0 * Config.TimeScale
end

function Main:GetServerTime()
	return GetGameTimer() - (self.syncTime or 0) + (self.serverTime or 0)
end

function Main:UpdateTime(time)
	self.syncTime = GetGameTimer()
	self.serverTime = time * 1000.0
end

function Main:UpdateWeather(weather)
	if self.overriding then
		self.overriding = weather
	else
		self.nextWeather = weather
	end
end

function Main:UpdateBoth(time, weather)
	self:UpdateTime(time)
	self:UpdateWeather(weather)
end

function Main:OverrideWeather(weather)
	if weather == nil then
		weather = self.overriding
		self.overriding = nil
	elseif not self.overriding then
		self.overriding = self.nextWeather or self.weather
	end
	
	if weather then
		self:SetWeather(weather)
	end
end

--[[ Events ]]--
RegisterNetEvent("sync:update", function(name, ...)
	local func = Main["Update"..name]
	if func then
		func(Main, ...)
	end
end)

--[[ Exports ]]--
exports("SetNighttime", function(value)
	Main.night = value
end)

exports("SetBlackout", function(value)
	Main:SetBlackout(value)
end)

exports("SetWeather", function(weather)
	Main:OverrideWeather(weather)
end)

exports("GetTimes", function()
	return { Main:GetTimes() }
end)

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		Main:Update()
		Citizen.Wait(20)
	end
end)