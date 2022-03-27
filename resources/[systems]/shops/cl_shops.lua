--[[ Functions: Main ]]--
function Main:_RegisterShop(shop)
	shop:Update()
end

--[[ Functions: Shop ]]--
function Shop:Update()
	local storage = self.info.Storage
	if storage and self:CanAccessStorage() then
		local id = "shop-"..self.id
		self.storage = id

		exports.entities:Register({
			id = id,
			name = "Shop "..self.id,
			coords = storage.Coords,
			radius = storage.Radius,
			navigation = {
				id = "shop",
				icon = "store",
				text = "Shop",
				sub = {
					{
						id = "shopStorage",
						text = "Storage",
						icon = "inventory_2",
						shop = self.id,
					},
					{
						id = "shopSettings",
						text = "Manage",
						icon = "settings",
						shop = self.id,
					},
				},
			},
		})
	elseif self.storage then
		exports.entities:Destroy(self.storage)
		self.storage = nil
	end
end

function Shop:CanAccessStorage()
	return exports.user:IsAdmin()
end

function Shop:Interact(npc)
	-- Make npc do anim.
	npc:PlayAnim("hand")
	
	-- Clear cart.
	self.cart = {}

	-- Generate template.
	local template = Templates.window

	template.defaults = {
		items = {},
		cart = {},
		cartAmount = "0",
		totalPrice = "0.00",
		paymentType = "Cash",
		loading = true,
		cash = exports.inventory:CountMoney() or 0.0,
	}
	
	-- Create window.
	local window = Window:Create(template, true)
	
	function window:OnDestroy()
		self.window = nil
	end

	-- Add listeners
	window:AddListener("addToCart", function(window, name, amount)
		local cart = math.min(math.max((self.cart[name] or 0) + amount, 0), self.stock[name] or 0)
		if cart == 0 then
			cart = nil
		end

		self.cart[name] = cart

		local cartAmount = 0
		local totalPrice = 0.0

		-- Calculate sum of cart.
		for itemName, quantity in pairs(self.cart) do
			local item = exports.inventory:GetItem(itemName)
			if item and item.value then
				totalPrice = totalPrice + quantity * item.value
			end
			cartAmount = cartAmount + quantity
		end
		
		-- Update model.
		window:SetModel({
			cart = self.cart,
			cartAmount = math.floor(cartAmount),
			totalPrice = ("%.2f"):format(totalPrice),
		})
	end)
	
	-- Cache window.
	self.window = window
	UI:Focus(true)
end

function Shop:Load(stock)
	local window = self.window
	if not window then return end

	self.stock = {}
	local items = {}
	
	-- Convert stock.
	for itemId, quantity in pairs(stock) do
		local item = exports.inventory:GetItem(itemId)
		if not item or not item.value then
			print(("item '%s' is in stock, but does not have a value"):format(item.name))
			goto skipItem
		end

		-- Add for model.
		items[#items + 1] = {
			name = item.name,
			icon = item.name:gsub("%s+", ""),
			stock = quantity,
			price = item.value,
		}

		-- Cache stock.
		self.stock[item.name] = quantity

		::skipItem::
	end

	table.sort(items, function(a, b)
		return a.name > b.name
	end)

	-- Set models.
	window:SetModel({
		loading = false,
		items = items,
	})
end

--[[ Events: Net ]]--
RegisterNetEvent("shops:loadShop", function(id, stock)
	local shop = Main.shops[id or false]
	if not shop then
		error(("receiving stock for invalid shop (%s)"):format(id))
	end

	shop:Load(stock or {})
end)

--[[ Events ]]--
AddEventHandler("shops:clientStart", function()
	Main:Init()
end)

AddEventHandler("interact:onNavigate_shopStorage", function(option)
	local shop = Main.shops[option.shop or false]
	if not shop or not shop:CanAccessStorage() then return end

	TriggerServerEvent("shops:openStorage", shop.id)
end)