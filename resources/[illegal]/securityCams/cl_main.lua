--[[ Functions ]]--
function Main:Init()
	for id, site in ipairs(Config.Sites) do
		self:RegisterSite(id, site)
	end
end

function Main:RegisterSite(id, site)
	for k, access in ipairs(site.Access) do
		exports.interact:Register({
			siteId = id,
			id = "securityCam-"..id.."-"..k,
			text = site.Text or "Cameras ("..site.Name..")",
			coords = access.Coords,
			radius = access.Radius,
			event = "securityCam",
		})
	end
end

function Main:Update()
	if self.site == nil then return end

	-- Update site.
	self.site:Update()

	-- Controls.
	for _, control in ipairs(Config.DisabledControls) do
		DisableControlAction(0, control)
	end
	
	-- Exiting.
	if IsDisabledControlJustPressed(0, 200) or IsDisabledControlJustPressed(0, 202) then
		self:ExitSite()

		-- Disable pause for a second.
		Citizen.CreateThread(function()
			for i = 1, 60 do
				DisableControlAction(0, 200)
				Citizen.Wait(0)
			end
		end)
	end

	-- Input.
	if IsDisabledControlJustPressed(0, 36) then
		Menu:Focus(not Menu.hasFocus)
	end
	
	-- Suppress interact.
	if GetResourceState("interact") == "started" then
		TriggerEvent("interact:suppress")
	end
end

function Main:EnterSite(id)
	-- Create camera.
	self:CreateCamera()

	-- Check site.
	if self.site ~= nil and self.site.id == id then
		-- Activate site.
		self.site:Activate()
	else
		-- Create site.
		local site = Site:Create(id)
		self.site = site
		
		-- Activate site.
		site:Activate()
	end

	-- Audio scene.
	StartAudioScene(Config.AudioScene)
end

function Main:ExitSite()
	-- Check site.
	if self.site == nil then return end

	-- Destroy camera.
	self:DestroyCamera()

	-- Deactivate site.
	self.site:Deactivate()

	-- Uncache site.
	self.site = nil

	-- Fades.
	if IsScreenFadedOut() then
		Menu:SetLoading(false)
		DoScreenFadeIn(0)
	end

	-- Audio scene.
	StopAudioScene(Config.AudioScene)

	-- Disable UI.
	Menu:Toggle(false)
	Menu:SetLoading(false)
end

function Main:IsViewing()
	return self.site ~= nil
end

function Main:CreateCamera()
	if self.camera ~= nil or not DoesCamExist(self.camera) then
		self.camera = CreateCam("DEFAULT_SCRIPTED_CAMERA", false)
	end
end

function Main:DestroyCamera()
	if self.camera ~= nil and DoesCamExist(self.camera) then
		DestroyCam(self.camera)
	end

	RenderScriptCams(false, false, 0, 1, 0)
	ClearTimecycleModifier()
	ClearFocus()

	self.camera = nil
end

function Main:UpdateCamera(coords, rotation, fov)
	local camera = self.camera

	-- Make sure camera is rendering.
	if not IsCamActive(camera) then
		SetCamActive(camera, true)
		RenderScriptCams(true, false, 0, 1, 0)
	end

	-- Update transformations.
	if coords then
		SetCamCoord(camera, coords)
		SetFocusPosAndVel(coords.x, coords.y, coords.z, 0.0, 0.0, 0.0)
	end

	if rotation then
		SetCamRot(camera, rotation)
	end

	if fov then
		SetCamFov(camera, fov)
	end
end

--[[ Events ]]--
AddEventHandler("interact:on_securityCam", function(interactable)
	if GlobalState.powerDisabled then return end

	local id = interactable.siteId or 0
	if id == nil then return end

	Main:EnterSite(id)
end)

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		if Main:IsViewing() then
			Main:Update()

			Citizen.Wait(0)
		else
			Citizen.Wait(200)
		end
	end
end)

--[[ Events ]]--
AddEventHandler(EventName.."clientStart", function()
	Main:Init()
end)

AddEventHandler(EventName.."stop", function()
	Main:ExitSite()

	for id, site in ipairs(Config.Sites) do
		for k, access in ipairs(site.Access) do
			exports.interact:Destroy("securityCam-"..id.."-"..k)
		end
	end
end)


RegisterNetEvent("powerDeactivated")
AddEventHandler("powerDeactivated", function()
	if Main:IsViewing() then
		Main:ExitSite()
	end
end)

--[[ Exports ]]--
exports("IsViewing", function()
	return Main:IsViewing()
end)

exports("EnterSite", function(id)
	Main:EnterSite(id)
end)

exports("ExitSite", function()
	Main:ExitSite()
end)