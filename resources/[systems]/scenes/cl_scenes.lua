Scene = {}
Scene.__index = Scene

function Scene:Create(data)
	-- Get id.
	local id = data.id
	if not id then
		id = (Main.lastId or 0) - 1
		Main.lastId = id
	end

	-- Create instance.
	local scene = setmetatable(data or {}, self)
	scene.id = id
	scene.width = scene.width or 0.1
	scene.height = scene.height or 0.1
	scene.visible = true

	-- Cache instance.
	if scene.grid then
		local grid = Main.grids[scene.grid]
		if not grid then
			grid = {}
			Main.grids[scene.grid] = grid
		end

		grid[id] = scene
	end

	-- Return instance.
	return scene
end

function Scene:Destroy()
	-- Remove interactable.
	if self.interactable then
		exports.interact:RemoveText(self.interactable)
	end

	-- Remove from grid.
	local grid = self:GetGrid()
	if grid then
		grid[self.id] = nil
	end
end

function Scene:GetGrid()
	return self.grid and Main.grids[self.grid]
end

function Scene:CreateInteractable()
	local text = ""
	local divStyle = "position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); text-align: center; font-size: 1em !important"

	if self.type == "Text" then
		text = ("<div style='%s'>%s</div>"):format(divStyle.."; width: 100%; height: auto; word-break: break-all", MarkdownToHtml(self.text))
	elseif self.type == "Image" then
		local imgStyle = "width: 100%; height: 100%; object-fit: contain !important"
		text = ("<div style='%s'><img style='%s' src='%s' alt='Image'/></div>"):format(divStyle.."; width: auto; height: auto", imgStyle, self.text)
	end

	self.interactable = exports.interact:AddText({
		text = text,
		useCanvas = true,
		fit = true,
		transparent = true,
		width = self.width,
		height = self.height,
		coords = self.coords,
		rotation = self.rotation,
	})

	return self.interactable
end

function MarkdownToHtml(text)
	local markdown = false
	local marking = nil
	local currentMarkdown = ""
	local result = ""

	for char in text:gmatch(".") do
		if char == "(" then
			if marking then
				result = result.."</"..marking..">"
			end

			markdown = true
		elseif char == ")" then
			local markdownStyle = Config.Markdown.Styles[currentMarkdown]
			marking = Config.Markdown.Tags[currentMarkdown] or "span"

			if markdownStyle then
				result = result..("<%s style='%s'>"):format(marking, markdownStyle)
			else
				result = result..("<%s>"):format(marking)
			end

			currentMarkdown = ""
			markdown = false
		elseif markdown then
			currentMarkdown = currentMarkdown..char
		else
			result = result..char
		end
	end

	if marking then
		result = result.."</"..marking..">"
	end

	return result:gsub("&br;", "<br>")
end

-- function Scene:SetContent(html)
-- 	print("setting")
	
-- 	SendNUIMessage({
-- 		method = "getImageData",
-- 		data = {
-- 			scene = self.id,
-- 			width = self.width,
-- 			height = self.height,
-- 			html = html,
-- 		},
-- 	})

-- 	-- local width = 512
-- 	-- local height = 512
-- 	-- local name = "scene"..self.id

-- 	-- local duiObject = CreateDui("https://cfx-nui-scenes/html/index.html", width, height)
-- 	-- local dui = GetDuiHandle(duiObject)
-- 	-- local texture = CreateRuntimeTextureFromDuiHandle(Main.runtimeDict, name, dui)

-- 	-- self.textureName = name
-- end

-- function Scene:CreateTexture(buffer)
-- 	local name = "scene"..self.id
-- 	local width, height = 512, 512
-- 	local texture = CreateRuntimeTexture(Main.runtimeDict, "scene"..self.id, width, height)

-- 	for i = 1, width * height do
-- 		local x = width - math.floor(i % width)
-- 		local y = height - math.floor(i / width)

-- 		local r = buffer[i * 4]
-- 		local g = buffer[i * 4 + 1]
-- 		local b = buffer[i * 4 + 2]
-- 		local a = buffer[i * 4 + 3]

-- 		if r and g and b and a then
-- 			SetRuntimeTexturePixel(texture, x, y, math.floor(r), math.floor(g), math.floor(b), math.floor(a))
-- 		end

-- 		if i % 1024 == 0 then
-- 			Citizen.Wait(0)
-- 		end
-- 	end

-- 	CommitRuntimeTexture(texture)
	
-- 	self.textureName = name
-- 	-- self.runtimeTexture = texture

-- 	collectgarbage("collect")
-- end

-- function Scene:SetRotation(rotation, ignoreUpdate)
-- 	self.rotation = rotation

-- 	self.forward = FromRotation(rotation)
-- 	self.right = Cross(self.forward, vector3(0, 0, 1))
-- 	self.up = Cross(self.forward, self.right)

-- 	if not ignoreUpdate then
-- 		self:UpdateFace()
-- 	end
-- end

-- function Scene:SetPosition(position)
-- 	self.position = position

-- 	self:UpdateFace()
-- end

-- function Scene:SetSize(width, height)
-- 	self.width = width
-- 	self.height = height

-- 	self:UpdateFace()
-- end

-- function Scene:UpdateFace()
-- 	self.p1 = -self.right * self.width + self.up * self.height + self.position
-- 	self.p2 = self.right * self.width + self.up * self.height + self.position
-- 	self.p3 = self.right * self.width - self.up * self.height + self.position
-- 	self.p4 = -self.right * self.width - self.up * self.height + self.position
-- end

-- function Scene:Render(position)
-- 	if not self.p1 then return end

-- 	local name = self.textureName
-- 	if not name then return end

-- 	local p1 = self.p1
-- 	local p2 = self.p2
-- 	local p3 = self.p3
-- 	local p4 = self.p4

-- 	DrawSpritePoly(
-- 		p3.x, p3.y, p3.z,
-- 		p2.x, p2.y, p2.z,
-- 		p1.x, p1.y, p1.z,
-- 		255, 255, 255, 255,
-- 		"scenes", name,
-- 		1.0, 1.0, 1.0,
-- 		1.0, 0.0, 1.0,
-- 		0.0, 0.0, 1.0
-- 	)

-- 	DrawSpritePoly(
-- 		p1.x, p1.y, p1.z,
-- 		p4.x, p4.y, p4.z,
-- 		p3.x, p3.y, p3.z,
-- 		255, 255, 255, 255,
-- 		"scenes", name,
-- 		0.0, 0.0, 1.0,
-- 		0.0, 1.0, 1.0,
-- 		1.0, 1.0, 1.0
-- 	)
-- end

-- RegisterNUICallback("receiveImageData", function(data, cb)
-- 	cb(true)

-- 	local scene = Main.scenes[data.scene]
-- 	if not scene then return end

-- 	scene:CreateTexture(data.buffer)
-- end)

-- Citizen.CreateThread(function()
-- 	Citizen.Wait(1000)

-- 	for k, c in ipairs({
-- 		vector3(236.6602117919922, -1001.23779296875, -98.74269561767578),
-- 		vector3(236.6602117919922, -994.5341796875, -98.80197296142578),
-- 	}) do
-- 		local r = exports.misc:ToRotation(vector3(1.00000011920928, 0, 0))
	
-- 		local scene = Scene:Create({
-- 			position = c,
-- 			rotation = r,
-- 			width = 1.0,
-- 			height = 1.5,
-- 		})
	
-- 		scene:SetContent([[
-- 			<img
-- 				style='width: 100%; height: 100%; object-fit: contain'
-- 				src='https://www.pngarts.com/files/8/Anime-Girl-Face-Meme-PNG-Transparent-Image.png'
-- 			/>
-- 		]])
-- 	end

-- 	while true do
-- 		for id, scene in pairs(Main.scenes) do
-- 			scene:Render()
-- 		end

-- 		Citizen.Wait(0)
-- 	end
-- end)