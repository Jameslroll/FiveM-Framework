function Inventory:Initialize()
	while not self.initialized do
		self:RequestItems()
		Citizen.Wait(500)
	end

	self:InvokeHook("init")

	TriggerServerEvent(EventPrefix.."init")
end

function Inventory:UpdateInput()
	-- Disable weapon wheel.
	DisableControlAction(0, 37)
	
	-- Focus disables.
	if Menu.hasFocus then
		-- Disable all.
		DisableAllControlActions(0)

		-- Enable controls.
		for _, control in ipairs(Config.EnabledControls) do
			EnableControlAction(0, control)
		end

		-- Suppress interact.
		if GetResourceState("interact") == "started" then
			TriggerEvent("interact:suppress")
		end
	end
end

function Inventory:Subscribe(id)
	-- Subscribe to container.
	TriggerServerEvent(EventPrefix.."subscribe", id, true)

	-- Open inventory.
	Menu:Focus(true)
end
Inventory:Export("Subscribe")

function Inventory:Unsubscribe(id)
	-- Subscribe to container.
	TriggerServerEvent(EventPrefix.."subscribe", id, false)

	-- Open inventory.
	Menu:Focus(false)
end
Inventory:Export("Unsubscribe")

--[[ Events ]]--
AddEventHandler(EventPrefix.."clientStart", function()
	Inventory:Initialize()
end)