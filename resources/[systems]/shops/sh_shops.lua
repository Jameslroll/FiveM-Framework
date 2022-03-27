--[[ Metatables ]]--
Main = {}
Main.shops = {}

Shop = {}
Shop.__index = Shop

--[[ Functions: Main ]]--
function Main:Init()
	if self._Init then
		self:_Init()
	end

	for id, shop in pairs(Config.Shops) do
		self:RegisterShop(id, shop)
	end
end

function Main:RegisterShop(id, info)
	local shop = Shop:Create(id, info)

	if self._RegisterShop then
		self:_RegisterShop(shop)
	end
end

--[[ Functions: Shop ]]--
function Shop:Create(id, info)
	-- Check info.
	if not info then
		info = {}
	end

	-- Create shop.
	self = setmetatable({
		info = info
	}, Shop)
	self.id = id

	-- Create clerks.
	if info.Clerks then
		for k, clerk in ipairs(info.Clerks) do
			clerk.id = "SHOP_"..id.."-"..k
			self:RegisterNpc(clerk)
		end
	end

	-- Load shop.
	if self.Load then
		self:Load()
	end

	-- Cache shop.
	Main.shops[id] = self

	return self
end

function Shop:Destroy()
	Main.shops[self.id] = nil
end

function Shop:RegisterNpc(info)
	for k, v in pairs(Templates.npc) do
		info[k] = info[k] or v
	end

	local npc = Npcs:Register(info)
	local shop = self

	function npc:Interact(...)
		shop:Interact(self, ...)
	end
end