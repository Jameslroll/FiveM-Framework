CayoPerico = {}

function CayoPerico:SetActive(active)
	if self.active == active then return end
	self.active = active
	
	Citizen.InvokeNative("0x9A9D1BA639675CF1", "HeistIsland", active)
	Citizen.InvokeNative("0x5E1460624D194A38", active)
	Citizen.InvokeNative(0xF74B1FFA4A15FBEA, active)
	Citizen.InvokeNative(0x53797676AD34A9AA, not active)

	SetScenarioGroupEnabled("Heist_Island_Peds", active)
	SetAudioFlag("PlayerOnDLCHeist4Island", active)
	SetAmbientZoneListStatePersistent("AZL_DLC_Hei4_Island_Zones", true, true)
	SetAmbientZoneListStatePersistent("AZL_DLC_Hei4_Island_Disabled_Zones", false, true)
end

function CayoPerico:SetFog(active)
	if self.fog == active then return end
	self.fog = active

	local weather = nil
	if active then
		weather = "FOGGY"
	end

	exports.sync:SetWeather(weather)
end

function CayoPerico:UpdateState()
	local active = false
	local coords = GetFinalRenderedCamCoord()
	local dist = #(coords - Config.Center)

	self:SetActive(dist < Config.Radius)
	self:SetFog(dist > Config.Fog.Min and dist < Config.Fog.Max)
end

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		CayoPerico:UpdateState()
		Citizen.Wait(1000)
	end
end)