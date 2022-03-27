AddEventHandler("emotes:clientStart", function()
	local expressions = {}

	for k, expression in ipairs(Config.Expressions) do
		if expression.Icon then
			expressions[#expressions + 1] = {
				id = "expression-"..tostring(k),
				text = expression.Name,
				icon = expression.Icon,
			}
		end
	end

	exports.interact:AddOption({
		id = "emotesRoot",
		text = "Emotes",
		icon = "gesture",
		sub = {
			{
				id = "emotes",
				text = "Emote",
				icon = "accessibility",
			},
			{
				id = "walkstyles",
				text = "Walkstyle",
				icon = "directions_run",
			},
			{
				id = "cancelEmote",
				text = "Cancel",
				icon = "not_interested",
			},
			{
				id = "expressions",
				text = "Expression",
				icon = "mood",
				sub = expressions,
			},
		},
	})
end)

AddEventHandler("interact:onNavigate", function(id)
	if not id then return end

	local key, value = id:match("([^-]+)-([^-]+)")
	if key ~= "expression" then return end

	local index = tonumber(value)
	if not index then return end

	local expression = Config.Expressions[index]
	if not expression then return end

	Main:Play(expression.Anim)
end)

AddEventHandler("interact:onNavigate_emotes", function()
	Navigation:Close()

	local options = {}

	for _, group in ipairs(Config.Groups) do
		local subOptions = {}
		
		for name, emote in pairs(group.Emotes) do
			subOptions[#subOptions + 1] = {
				label = name,
				emote = true,
			}
		end

		table.sort(subOptions, function(a, b)
			return a.label < b.label
		end)

		options[#options + 1] = {
			label = group.Name,
			icon = group.Icon,
			options = subOptions,
		}
	end

	Navigation:Open("Emotes", options)

	function Navigation:OnSelect(option)
		if option.emote then
			Main:Play(option.label)
		end
	end
end)

AddEventHandler("interact:onNavigate_walkstyles", function()
	Navigation:Close()

	local options = {}

	for name, walkstyle in pairs(Config.Walkstyles) do
		options[#options + 1] = {
			label = name,
		}
	end

	table.sort(options, function(a, b)
		return a.label < b.label
	end)

	Navigation:Open("Walkstyles", options)

	function Navigation:OnSelect(option)
		if option.label then
			Main:SetWalkstyle(option.label)
		end
	end
end)

AddEventHandler("interact:onNavigate_cancelEmote", function()
	Main:Stop()
end)