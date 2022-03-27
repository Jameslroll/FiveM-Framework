Phone = App:Register("phone", {
	enabled = true,
	name = "Phone",
	theme = "blue",
	component = "Phone",
	data = {
		tab = "keypad",
	},
})

--[[ Functions: Phone ]]--
function Phone:Activate(device)
	device:SetAppData(self.id, "number", self.number)
end

function Phone:Load(device)
	if not self.contacts then
		device:SetData(self.id, "isLoading", true)

		local contacts = Main:Fetch("LoadContacts")
		self.contacts = contacts

		device:SetData(self.id, "isLoading", false)
	end

	device:SetData(self.id, "contacts", self.contacts)
end

function Phone:Update()
	local phone = Main.devices["phone"]
	if not phone then return end

	local ped = PlayerPedId()
	local isIn = self.state == "in"
	
	-- Phone shoudl be up to ear.
	if not isIn then
		-- Emotes.
		if (not self.emote or not exports.emotes:IsPlaying(self.emote)) then
			self.emote = exports.emotes:Play(Config.Anims.Call)
			phone.emote = nil
		end
	end

	local state = (LocalPlayer or {}).state
	if not state then return end

	local shouldEnd = IsDisabledControlJustPressed(0, 82) or (not isIn and (
		IsPedFalling(ped) or
		IsPedArmed(ped, 1 | 2 | 4) or
		state.immobile or
		state.restrained or
		state.carrier
	))

	DisableControlAction(0, 81)
	DisableControlAction(0, 82)

	if IsDisabledControlJustPressed(0, 81) then
		phone:CallAnswer()
	elseif shouldEnd then
		phone:CallEnd()
	end
end

function Phone:GetContact(number)
	for k, contact in ipairs(Phone.contacts) do
		if contact.number == number then
			return contact
		end
	end
end

--[[ Functions: Contacts ]]--
function Device:SaveContact(...) Phone:SaveContact(self, ...) end
function Phone:SaveContact(device, data)
	if not self.contacts then
		self.contacts = {}
	end
	
	local saved = Main:Fetch("SaveContact", data)
	if not saved then
		print("server failed to save contact")
		return
	end
	
	local exists = false
	for k, contact in ipairs(self.contacts) do
		if contact.number == data.number then
			contact.avatar = data.avatar
			contact.color = data.color
			contact.name = data.name
			contact.notes = data.notes

			exists = true

			break
		end
	end

	if not exists then
		table.insert(self.contacts, data)
	end

	device:SetData("phone", "contacts", self.contacts)
end

function Device:DeleteContact(...) Phone:DeleteContact(self, ...) end
function Phone:DeleteContact(device, number)
	local saved = Main:Fetch("DeleteContact", number)
	if not saved then
		print("server failed to remove contact")
		return
	end

	for k, contact in ipairs(self.contacts) do
		if contact.number == number then
			table.remove(self.contacts, k)
			break
		end
	end

	device:SetData("phone", "contacts", self.contacts)
end

function Device:FavoriteContact(...) Phone:FavoriteContact(self, ...) end
function Phone:FavoriteContact(device, number, value)
	local saved = Main:Fetch("FavoriteContact", number, value)
	if not saved then
		print("server failed to favorite contact")
		return
	end

	for k, contact in ipairs(self.contacts) do
		if contact.number == number then
			contact.favorite = value
			break
		end
	end

	device:SetData("phone", "contacts", self.contacts)
end

--[[ Functions: Device ]]--
function Device:Call(number)
	if Phone.call then return end
	Phone.call = number
	Phone.state = "out"

	local response = Main:Fetch("Call", number)
	local contact = Phone:GetContact(number)

	if not response then
		self:AddNotification("call", {
			title = contact and contact.name or number,
			text = "Outgoing call.",
			avatar = {
				icon = contact and contact.avatar,
				name = contact and contact.name or "",
				color = contact and contact.color or "blue",
			},
			audio = "beeping",
			loopAudio = true,
			duration = 4000,
		})

		local self = self
		Citizen.SetTimeout(4000, function()
			self:LeaveCall()
		end)

		return
	end

	self:AddNotification("call", {
		title = contact and contact.name or number,
		text = "Outgoing call.",
		avatar = {
			icon = contact and contact.avatar,
			name = contact and contact.name or "",
			color = contact and contact.color or "blue",
		},
		hangup = true,
		audio = "outgoing_ring",
		loopAudio = true,
	})
end

function Device:ReceiveCall(number)
	Phone.call = number
	Phone.state = "in"

	local contact = Phone:GetContact(number)

	self:AddNotification("call", {
		title = contact and contact.name or number,
		text = "Incoming call.",
		avatar = {
			icon = contact and contact.avatar,
			name = contact and contact.name or "",
			color = contact and contact.color or "blue",
		},
		answer = true,
		hangup = true,
		audio = "ring0",
		loopAudio = true,
	})
end

function Device:JoinCall(number)
	Phone.call = number
	Phone.state = "active"

	local contact = Phone:GetContact(number)

	self:AddNotification("call", {
		title = contact and contact.name or number,
		text = "In call.",
		hangup = true,
		timer = true,
		avatar = {
			icon = contact and contact.avatar,
			name = contact and contact.name or "",
			color = contact and contact.color or "blue",
		},
	})

	local channel = self:GetChannel()
	if channel then
		self.voipChannel = channel
		exports.voip:JoinChannel(channel, "Automatic", "phone", 0.4)
	end
end

function Device:LeaveCall()
	if not Phone.call then return end

	-- Remove notification.
	self:RemoveNotification("call")
	
	-- Clear cache.
	Phone.call = nil
	Phone.state = nil

	-- Leave voip channel.
	local channel = self.voipChannel
	if channel then
		exports.voip:LeaveChannel(channel)
		self.voipChannel = nil
	end

	-- Stop emote.
	if Phone.emote then
		exports.emotes:Stop(Phone.emote)
		Phone.emote = nil

		if self.anim and self.open then
			self.emote = exports.emotes:Play(self.anim)
		end
	end
end

function Device:GetChannel()
	if not Phone.call then return end

	local localNumber = exports.character:Get("phone")
	if not localNumber then return end

	return tostring(math.min(tonumber(localNumber), tonumber(Phone.call)))
end

function Device:CallAnswer()
	self:LeaveCall()

	local number = Main:Fetch("CallAnswer")
	if number then
		self:JoinCall(number)
	end
end

function Device:CallEnd()
	Main:Fetch("CallEnd")
end

--[[ Functions: Recents ]]--
function Device:LoadRecentCalls(offset)
	local data = Main:Fetch("LoadRecentCalls", offset or 0)
	if not data then return end

	for k, item in ipairs(data) do
		item.direction = item.source_number == Phone.number
		item.number = item.direction and item.target_number or item.source_number

		local contact = Phone:GetContact(item.number)

		item.name = contact and contact.name or ""
		item.avatar = contact and contact.avatar
		item.color = contact and contact.color
	end

	return data
end

--[[ Hooks ]]--
Main:AddHook("LoadDevice", function(self, device)
	Phone.contacts = nil
	Phone:Load(device)
end)

--[[ Events ]]--
RegisterNetEvent("character:update", function(args)
	local number = args.phone
	if not number then return end

	Phone.number = number
end)

RegisterNetEvent(Main.event.."receiveCall", function(number)
	local phone = Main.devices["phone"]
	if not phone then return end

	phone:ReceiveCall(number)
end)

RegisterNetEvent(Main.event.."joinCall", function(number)
	local phone = Main.devices["phone"]
	if not phone then return end

	phone:JoinCall(number)
end)

RegisterNetEvent(Main.event.."endCall", function()
	local phone = Main.devices["phone"]
	if not phone then return end

	phone:LeaveCall()
end)

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		if Phone.call then
			Phone:Update()
		end
		
		Citizen.Wait(0)
	end
end)