local template = {
	interact = "Talk",
	animations = {
		idle = { Dict = "anim@amb@nightclub@peds@", Name = "rcmme_amanda1_stand_loop_cop", Flag = 49 },
		phone = { Dict = "cellphone@", Name = "cellphone_text_read_base", Flag = 49, Props = {
			{ Model = "prop_npc_phone_02", Bone = 28422, Offset = { 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 } },
		}},
	},
}

local npcs = {
	{
		id = "TEST_NPC",
		coords = vector4(328.5318603515625, -200.65306091308597, 54.2264404296875, 162.4396514892578),
		appearance = json.decode('{"makeupOverlays":[1,1,1,0.0,0.0,0.0,48,48,48,43,43,43],"props":[1,1,1,1,1,1,1,1],"hair":[17,5,5],"components":[1,1,21,1,1,1,434,1,3,108,118,1,1,1,1,1,1,12,1,1,1,1]}'),
		features = json.decode('{"eyeColor":6,"bodyType":1,"overlays":[],"faceFeatures":[0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0],"otherOverlays":[8,15,4,4,12,11,1.1152599841283879e-7,0.04518555730772,0.23188866919514,0.87820925209926,0.10999298095703,0.31008625030517,0.66308534145355],"hairOverlays":[2,25,5,0.24882134109423,0.99573175172895,0.90368604660034,4,4,4],"blendData":[33,17,18,17,2,35,0.54,0.76,0.76],"model":1}'),
		options = {
			{
				text = "Tell me about this place.",
				dialogue = "This is The Pink Cage, a motel.",
				once = true,
			}
		},
	},
}

Citizen.CreateThread(function()
	while not Npcs do
		Citizen.Wait(0)
	end

	for _, info in ipairs(npcs) do
		for k, v in pairs(template) do
			info[k] = v
		end
		local npc = Npcs:Register(info)

		npc:AddOption({
			text = "Are any rooms available?",
			dialogue = "Let me check.",
			callback = function(self, index, option)
				self.locked = true
				self:SetState("phone")

				Citizen.Wait(GetRandomIntInRange(1000, 2000)) -- TODO: replace with server event to check and wait for response.

				self.locked = false
				self:AddDialogue("It looks like we have one for you. How long will you be staying?")

				local function selectPayment(self, index, option)
					self.locked = true
					self:AddDialogue(("Paying in %s?"):format(option.payment))

					Citizen.Wait(GetRandomIntInRange(1000, 2000))
					
					self.locked = false
					
					self:AddDialogue("Here's your key.")
					self:AddDialogue("Thank you.", true)
					
					self:GoHome()
				end

				local function selectOption(self, index, option)
					local cost = (option.days or 1) * 20

					self:AddDialogue(("That'll be $%s. How would you like to pay?"):format(cost))
					self:SetOptions({
						{
							text = "Cash.",
							callback = selectPayment,
							payment = "cash",
						},
						{
							text = "Credit.",
							callback = selectPayment,
							payment = "credit",
						},
						Npcs.NEVERMIND,
					})
				end

				self:SetOptions({
					{
						text = "Just the night.",
						callback = selectOption,
						days = 1,
					},
					{
						text = "I'd like to stay for the week.",
						callback = selectOption,
						days = 7,
					},
					Npcs.NEVERMIND,
				})
			end
		})
	end
end)