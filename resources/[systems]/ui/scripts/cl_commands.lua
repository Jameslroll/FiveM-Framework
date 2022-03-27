-- TODO: move to admin resource.
local editor = {}

function editor:Enable()
	UI:Focus(true)

	local left = 5
	local width = 80
	local vertical = 10
	
	self.window = CodeEditor:Create({
		kvp = "WindowEditor",
		style = {
			["width"] = width.."vmin",
			["height"] = "auto",
			["top"] = vertical.."vmin",
			["bottom"] = vertical.."vmin",
			["left"] = left.."vmin",
			["z-index"] = 100,
		},
	}, function(window, code)
		local result, data = pcall(load("return {"..code.."}"))
		if not result then
			error(data)
		end
	
		if self.preview then
			self.preview:Destroy()
		end
	
		if not data.style then
			data.style = {}
		end
	
		data.style.left = (left + width + 1).."vmin"
		data.style.top = vertical.."vmin"
		data.style.bottom = "auto"
	
		local window = Window:Create(data)
		self.preview = window
	end, function(window)
		editor:Disable()
	end)
end

function editor:Disable()
	UI:Focus(false)

	if self.preview then
		self.preview:Destroy()
		self.preview = nil
	end

	if self.window then
		self.window:Destroy()
		self.window = nil
	end
end

function editor:Toggle()
	if self.window then
		self:Disable()
	else
		self:Enable()
	end
end

exports.chat:RegisterCommand("ui:editor", function(source, args, command)
	editor:Toggle()
end, {
	description = "Open a visual editor to create menus."
}, "Dev")

local injector = {}

function injector:Enable()
	UI:Focus(true)

	local left = 5
	local width = 80
	local vertical = 10
	
	self.window = CodeEditor:Create({
		kvp = "CodeEditor",
		style = {
			["width"] = width.."vmin",
			["height"] = "auto",
			["top"] = vertical.."vmin",
			["bottom"] = vertical.."vmin",
			["left"] = left.."vmin",
			["z-index"] = 100,
		},
	}, function(window, code)
		_G.ped = PlayerPedId()
		_G.vehicle = GetVehiclePedIsIn(ped, false)
		
		local result, data = pcall(load(code))

		if not result then
			error(data)
		end
	end, function(window)
		injector:Disable()
	end)
end

function injector:Disable()
	UI:Focus(false)
	
	if self.window then
		self.window:Destroy()
		self.window = nil
	end
end

function injector:Toggle()
	if self.window then
		self:Disable()
	else
		self:Enable()
	end
end

exports.chat:RegisterCommand("ui:injector", function(source, args, command)
	injector:Toggle()
end, {
	description = "Open a visual editor to execute code."
}, "Dev")

-- Keep this here.
RegisterCommand("ui:focus", function(source, args, command)
	local value = args[1]
	
	if ({
		["1"] = true,
		["on"] = true,
		["true"] = true,
	})[value] then
		value = true
	elseif ({
		["0"] = true,
		["off"] = true,
		["false"] = true,
	})[value] then
		value = false
	else
		value = not UI.hasFocus
	end

	UI:Focus(value)
end)