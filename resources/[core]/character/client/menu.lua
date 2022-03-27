Menu = {}

function Menu:Init()
	self:Build()
end

function Menu:Destroy(name)
	local menu = self[name]
	if menu then
		menu:Destroy()
		self[name] = nil
	end
end

function Menu:ToggleSelection(value)
	-- Wait for characters.
	while not IsUiReady or not Main.loaded do
		Citizen.Wait(0)
	end
	
	-- Focus NUI.
	UI:Focus(value)

	-- Check window already exists.
	if value and self.characters and self.selection then
		return
	end

	-- Destroy old windows.
	self:Destroy("characters")
	self:Destroy("selection")

	-- Check toggle.
	if not value then
		return
	end

	-- Create window.
	local charactersWindow = Window:Create(Templates.Characters)
	local selectionWindow = Window:Create(Templates.Selection)

	-- Cache windows.
	self.characters = charactersWindow
	self.selection = selectionWindow

	-- Set characters.
	function charactersWindow:UpdateList()
		local characters = Main.characters
		local _characters = {}
		
		for _, character in pairs(characters) do
			_characters[#_characters + 1] = character
		end

		table.sort(_characters, function(a, b)
			return a.id < b.id
		end)

		self:SetModel("characters", _characters)
	end

	charactersWindow:UpdateList()

	-- Window model listener.
	charactersWindow:OnUpdateModel("selection", function(self, value, oldValue)
		if not value then return end
		local character = Main:GetCharacterById(value)

		if not character then
			selectionWindow:SetModel("name", false)
			return
		end

		local hours = character:GetHours()
	
		local details = ([[
			DOB: %s (%s years)<br>
			Gender: %s<br>
			Bank: $%s<br>
			Time Played: %.2f hours<br>
		]]):format(
			character.dob,
			character.age,
			character.gender,
			character.bank,
			hours
		)
		
		selectionWindow.characterId = character.id

		selectionWindow:SetModel({
			name = character:GetName(),
			biography = (character.biography or "No biography..."),
			canDelete = hours < 2.0,
			details = details,
		})

		selectionWindow:OnClick("play", function(self)
			local id = self.characterId
			if not id then return end

			Main:SelectCharacter(id)
		end)
	end)

	-- Window click listener.
	charactersWindow:OnClick("create", function(self)
		Menu:ToggleCreate(true)
	end)
end

function Menu:ToggleCreate(value)
	self:Destroy("characters")
	self:Destroy("selection")

	local create = Window:Create(Templates.Create)
	self.create = create

	create:OnClick("cancel", function(self)
		Menu:Destroy("create")
		Menu:ToggleSelection(true)
	end)

	create:OnClick("create", function(self)
		Main:CreateCharacter(self.models)
	end)
end

--[[ Events ]]--
AddEventHandler("spawning:loaded", function()
	Menu:ToggleSelection(true)
end)

AddEventHandler("character:start", function()
	if GetResourceState("spawning") == "started" and not exports.spawning:HasSpawned() then
		Menu:ToggleSelection(true)
	end
end)

RegisterNetEvent(Main.event.."created")
AddEventHandler(Main.event.."created", function(success, result)
	if Menu.create then
		Menu.create:SetModel("creating", false)
	end

	if success then
		Menu:Destroy("create")
		Menu:ToggleSelection(true)
		Main:RegisterCharacter(result)
	else
		UI:Notify({
			color = "red",
			message = result or "Error"
		})
	end
end)