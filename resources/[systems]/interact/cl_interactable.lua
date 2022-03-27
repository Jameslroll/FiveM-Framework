Interactable = {}
Interactable.__index = Interactable

function Interactable:Create(data)
	local interactable = data or {}
	setmetatable(interactable, Interactable)
	return interactable
end

function Interactable:UpdateConditions()
	local isVisible, canUse = true, true
	local extraText = ""

	-- Faction check.
	if self.factions then
		local hasFaction = false
		
		for _, faction in ipairs(self.factions) do
			if exports.character:HasFaction(faction) then
				hasFaction = true
				break
			end
		end

		if not hasFaction then
			isVisible = false
			canUse = false
		end
	end

	-- Property check.
	if self.property and not exports.properties:HasProperty(self.property) then
		isVisible = false
		canUse = false
	end

	-- Item check.
	if isVisible and canUse and self.items then
		local hasItems = true

		for _, item in ipairs(self.items) do
			local amount = item.amount or 1
			local hasItem = (exports.inventory:CountItem(item.name) or 0) >= amount

			if not item.hidden then
				if extraText ~= "" then
					extraText = extraText..", "
				end
				if item.name == "Bills" then
					extraText = extraText..("$%s"):format(amount)
				else
					extraText = extraText..("x%s %s"):format(amount, item.name)
				end
			end

			if not hasItem then
				hasItems = false
				canUse = false
			end
		end
	end
	
	-- Override text.
	if extraText ~= "" then
		self.overrideText = ("%s (%s)"):format(self.text, extraText)
	else
		self.overrideText = nil
	end
	
	if not canUse then
		self.overrideText = ("<span class='inactive'>%s</span>"):format(self.overrideText or self.text)
	elseif extraText == "" then
		self.overrideText = nil
	end

	return isVisible, canUse
end