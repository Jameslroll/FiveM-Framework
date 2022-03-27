Main = Main or {}
Main.weather = "EXTRASUNNY"

--[[ Functions ]]--
function Main:GetHour()
	return math.floor((self:GetTime() / 60.0) % 24.0)
end

function Main:GetMinute()
	return math.floor(self:GetTime() % 60.0)
end

function Main:GetSecond()
	return math.floor((self:GetTime() * 60.0) % 60.0)
end

function Main:GetTimes()
	serverTime = self:GetTime()

	return
		math.floor((serverTime / 1440) % 31), -- day
		math.floor((serverTime / 44640) % 12), -- month
		math.floor(serverTime / 535680), -- year
		math.floor((serverTime / 60) % 24), -- hour
		math.floor(serverTime % 60), -- minute
		math.floor((serverTime * 60) % 60) -- second
end