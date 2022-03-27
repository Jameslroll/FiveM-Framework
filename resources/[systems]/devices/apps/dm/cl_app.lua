Dms = App:Register("dm", {
	enabled = true,
	name = "Messages",
	theme = "green",
	disposable = true,
})

--[[ Functions: Dms ]]--
function Dms:Activate(device, data)
	local set = {
		messages = {},
	}

	if data.number and data.number ~= "" then
		self.number = data.number
		set.number = data.number
	elseif self.number then
		set.number = self.number
	end

	return set
end

--[[ Functions: Device ]]--
function Device:Message(number, text)
	return Main:Fetch("SendMessage", number, text)
end