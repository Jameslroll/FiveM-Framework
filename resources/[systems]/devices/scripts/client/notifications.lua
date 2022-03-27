--[[ Functions: Device ]]--
function Device:AddNotification(id, data)
	if not self.notifications then
		self.notifications = {}
	end

	local notification = self.notifications[id]
	if not notification then
		self.notificationCount = (self.notificationCount or 0) + 1
	end
	
	self.notifications[id] = data
	self:Invoke("addNotification", false, true, id, data)

	if data.duration then
		local device = self
		Citizen.CreateThread(function()
			Citizen.Wait(data.duration)
			device:RemoveNotification(id)
		end)
	end
end

function Device:RemoveNotification(id)
	local notification = self.notifications and self.notifications[id]
	if not notification then
		return
	end

	self.notificationCount = (self.notificationCount or 1) - 1
	self.notifications[id] = nil

	self:Invoke("removeNotification", false, false, id)

	if self.notificationCount == 0 and not self.open then
		self:Toggle(false)
	end
end

--[[ Hooks ]]--
Device:AddHook("Toggle", function(self, value)
	if (self.notificationCount or 0) > 0 then
		return true, true
	end
end)