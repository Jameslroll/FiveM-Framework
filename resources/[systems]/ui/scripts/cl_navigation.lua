--[[ Metatables ]]--
Navigation = {
	controls = {
		back = 202,
		down = 187,
		enter = 201,
		left = 189,
		right = 190,
		up = 188,
	},
	maxPerPage = 12,
}

--[[ Functions: Navigation ]]--
function Navigation:Open(title, options)
	self.isOpen = true

	local window = Window:Create({
		type = "window",
		title = title,
		class = "compact",
		style = {
			["width"] = "40vmin",
			["right"] = "4vmin",
			["top"] = "12vmin",
		},
		defaults = {
			selection = 0,
			options = {},
			pages = 0,
			page = 0,
		},
		components = {
			{
				template = [[
					<q-list>
						<q-item
							v-for="(tab, key) in $getModel('options')"
							:key="key"
							:active="$getModel('selection') == key"
							active-class="bg-blue-6 text-white"
						>
							<q-item-section v-if="tab.icon" avatar>
								<q-icon :name="tab.icon"></q-icon>
							</q-item-section>
							<q-item-section>
								<q-item-label>{{tab.label}}</q-item-label>
								<q-item-label caption v-if="tab.caption">{{tab.caption}}</q-item-label>
							</q-item-section>
							<q-item-section v-if="tab._checkbox" side>
								<q-checkbox :value="$getModel(tab._checkbox)"></q-checkbox>
							</q-item-section>
						</q-item>
					</q-list>
				]]
			},
			{
				template = [[
					<q-item
						v-if="$getModel('pages')"
					>
						<q-item-section side>
							<q-icon name="chevron_left"></q-icon>
						</q-item-section>
						<q-item-section>
							<q-item-label caption>Page {{$getModel('page')}}/{{$getModel('pages')}}</q-item-label>
						</q-item-section>
						<q-item-section side>
							<q-icon name="chevron_right"></q-icon>
						</q-item-section>
					</q-item>
				]]
			},
		}
	})

	self.window = window
	
	self.tree = self:CreateBranch()
	self:ConvertOptions(self.tree, options)
	self:SetBranch(self.tree)
end

function Navigation:Close()
	self.isOpen = false

	-- Callback.
	if self.OnClose then
		self:OnClose()
	end

	-- Destroy window.
	if self.window then
		self.window:Destroy()
		self.window = nil
	end

	-- Clear cache.
	self.dir = nil
	self.options = nil
	self.page = nil
	self.checkbox = nil
end

function Navigation:SetOptions(options)
	if not self.dir then
		self.dir = {}
	end

	local branch = self:CreateBranch(self.branch)
	self:ConvertOptions(branch, options)

	table.insert(self.dir, self.branch)
	self:SetBranch(branch)
end

function Navigation:ConvertOptions(branch, options)
	branch.options = options
	
	for index, option in ipairs(options) do
		if option.options then
			option.tree = self:CreateBranch(branch)
			self:ConvertOptions(option.tree, option.options)
		end
	end
end

function Navigation:CreateBranch(parent)
	return {
		options = {},
		page = 0,
		selection = 0,
	}
end

function Navigation:SetBranch(branch)
	local checkboxes = {}

	for index, option in ipairs(branch.options) do
		if option.checkbox ~= nil and not option._checkbox then
			self.checkbox = (self.checkbox or 0) + 1
			option.value = option.checkbox == true
			option._checkbox = "checkbox-"..tostring(self.checkbox)
		end

		if option._checkbox then
			checkboxes[option._checkbox] = option.value
		end
	end

	if self.window then
		self.window:SetModel(checkboxes)
	end

	self.branch = branch
	self:SetPage(branch.page or 0)
end

function Navigation:SetPage(page)
	local branch = self.branch
	if not branch then return end

	-- Calculate pages.
	local maxPages = math.ceil(#branch.options / self.maxPerPage)

	-- Set page.
	page = math.min(math.max(page, 0), maxPages - 1)
	print(page, maxPages, #branch.options)

	-- Create model.
	local model = {
		options = {},
		page = page + 1,
		pages = maxPages,
		selection = branch.selection or 0,
	}

	-- Set page options.
	for i = 1, self.maxPerPage do
		local k = i + page * self.maxPerPage
		local option = branch.options[k]

		if option then
			table.insert(model.options, option)
		else
			break
		end
	end

	-- Cache page.
	branch.page = page
	self.pageOptions = model.options

	-- Update model.
	if self.window then
		self.window:SetModel(model)
	end
end

function Navigation:GetSelection()
	return self.pageOptions[(self.branch and self.branch.selection or 0)+ 1]
end

function Navigation:SetSelection(index)
	local branch = self.branch
	if not branch then return end

	-- Clamp index.
	if index < 0 then
		index = #self.pageOptions - 1
	elseif index >= #self.pageOptions then
		index = 0
	end
	
	-- Set index.
	branch.selection = index
	
	-- Update model.
	if self.window then
		self.window:SetModel("selection", index)
	end
end

function Navigation:Cancel()
	local dirNum = self.dir and #self.dir or 0
	if dirNum == 0 then
		self:Close()
		return
	end

	self:SetBranch(self.dir[dirNum])
	table.remove(self.dir, dirNum)
end

function Navigation:Select()
	-- Get option.
	local option = self:GetSelection()
	if not option then return end

	-- Option event.
	if option.func then
		option.func()
	end

	-- Navigation event.
	if self.OnSelect then
		self:OnSelect(option)
	end

	-- Other events.
	if option._checkbox then
		option.value = not option.value

		if self.window then
			self.window:SetModel(option._checkbox, option.value)
		end

		if option.OnValueChange then
			option:OnValueChange(option.value)
		end
	elseif option.options then
		if not self.dir then
			self.dir = {}
		end
		
		table.insert(self.dir, self.branch)
		self:SetBranch(option.tree)
	end
end

function Navigation:Update()
	if IsControlJustPressed(0, self.controls.back) then
		self:Cancel()
	elseif IsControlJustPressed(0, self.controls.enter) then
		self:Select()
	elseif IsControlJustPressed(0, self.controls.left) then
		self:SetPage((self.branch and self.branch.page or 0) - 1)
	elseif IsControlJustPressed(0, self.controls.right) then
		self:SetPage((self.branch and self.branch.page or 0) + 1)
	elseif IsControlJustPressed(0, self.controls.up) or (IsControlPressed(0, self.controls.up) and GetGameTimer() - (self.lastScroll or 0) > 150) then
		self.lastScroll = GetGameTimer()
		self:SetSelection((self.branch and self.branch.selection or 0) - 1)
	elseif IsControlJustPressed(0, self.controls.down) or (IsControlPressed(0, self.controls.down) and GetGameTimer() - (self.lastScroll or 0) > 150) then
		self.lastScroll = GetGameTimer()
		self:SetSelection((self.branch and self.branch.selection or 0) + 1)
	end
end

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		if Navigation.isOpen then
			Navigation:Update()
			Citizen.Wait(0)
		else
			Citizen.Wait(200)
		end
	end
end)

--[[ Events ]]--
AddEventHandler("ui:navigation", function()
	if Navigation.isOpen then
		Navigation:Close()
	end
end)

-- Test
-- Citizen.CreateThread(function()
-- 	Citizen.Wait(1000)

-- 	local options = {}

-- 	for i = 1, 95 do
-- 		options[i] = {
-- 			label = "Option "..i,
-- 			caption = "Caption",
-- 			icon = "person",
-- 			options = {
-- 				{
-- 					label = "Sub Option 1",
-- 					options = {
-- 						{
-- 							label = "Sub-sub Option"
-- 						}
-- 					},
-- 				},
-- 				{
-- 					label = "Sub Option 2",
-- 				},
-- 				{
-- 					label = "Sub Option 3",
-- 				},
-- 			},
-- 		}
-- 	end

-- 	options[1].checkbox = true
-- 	options[2].checkbox = false

-- 	options[1].OnValueChange = function(self, value)
-- 		print("change", value)
-- 	end

-- 	Navigation:Open("Auto-generated Options", options)
-- end)