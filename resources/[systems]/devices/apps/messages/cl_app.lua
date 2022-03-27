Messages = App:Register("messages", {
	enabled = true,
	name = "Messages",
	theme = "green",
	disposable = true,
}, {
	["phone"] = true,
})

--[[ Functions: Messages ]]--
function Messages:Activate(device)
	local data = Main:Fetch("LoadConversations")
	if not data then return end

	for k, item in ipairs(data) do
		local contact = Phone:GetContact(item.number)

		item.name = contact and contact.name
		item.avatar = contact and contact.avatar
		item.color = contact and contact.color
	end

	self.messages = data

	device:SetAppData(self.id, "messages", data)
end

function Messages:Deactivate(device)
	self.messages = nil
end

function Device:LoadMessages(number, offset)
	print("load", number, offset)
	
	local data = Main:Fetch("LoadMessages", number, offset)
	if not data then return end

	return data
end

--[[ Events ]]--
RegisterNetEvent(Main.event.."receiveMessage", function(number, scope, text)
	print("new message", number, scope, text)
	local phone = Main.devices["phone"]
	if not phone then return end
	
	-- Update messages app.
	if Messages.active then
		Messages:Invoke("phone", "add", number, text)
		return
	end

	-- Get contact.
	local contact = Phone:GetContact(number)

	-- Update dms app.
	if Dms.active and Dms.number == number then
		Dms:Invoke("phone", "add", {
			text = text,
		})

		return
	end

	-- Add notification.
	phone:AddNotification("message-"..GetGameTimer(), {
		title = contact and contact.name or number,
		text = text:len() > 128 and text:sub(1, 128) or text,
		avatar = {
			icon = contact and contact.avatar,
			name = contact and contact.name or "",
			color = contact and contact.color or "blue",
		},
		audio = "notify",
		duration = 8000,
	})
end)