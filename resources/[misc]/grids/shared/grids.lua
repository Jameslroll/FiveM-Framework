Grids = {
	Size = vector2(8992, 12992),
	Offset = vector2(4480, 4480),
	PlayerGridSize = 4,
	Deltas = {
		vector2(-1.0, -1.0),
		vector2(-1.0, 0.0),
		vector2(-1.0, 1.0),
		vector2(0.0, -1.0),
		vector2(0.0, 1.0),
		vector2(1.0, -1.0),
		vector2(1.0, 0.0),
		vector2(1.0, 1.0),
	},
	Sizes = {
		16,
		32,
		64,
		128,
	},
}

--[[ Functions ]]--
local function round(number)
	if number % 1.0 >= 0.5 then
		return math.ceil(number)
	else
		return math.floor(number)
	end
end

--[[ Functions: Grids ]]--
function Grids:GetWidth(size)
	return math.ceil(self.Size.x / size)
end

function Grids:GetGrid(coords, size, keepSize)
	coords = vector3(math.min(math.max(coords.x + self.Offset.x, 0), self.Size.x), math.min(math.max(coords.y + self.Offset.y, 0), self.Size.y), coords.z)
	if not keepSize then
		size = self.Sizes[size]
	end
	local width = self:GetWidth(size)
	return math.floor(coords.x / size) + math.floor(coords.y / size) * width
end

function Grids:GetCoords(grid, size, keepSize)
	if not keepSize then
		size = self.Sizes[size]
	end
	local width = self:GetWidth(size)
	return vector3(math.floor(grid % width) * size - self.Offset.x + size / 2.0, math.floor(grid / width) * size - self.Offset.y + size / 2.0, 0)
end

function Grids:GetNearbyGrids(coords, size, keepSize)
	if not size then return {} end
	if not keepSize then
		size = self.Sizes[size]
	end

	local width = self:GetWidth(size)
	if type(coords) == "vector3" then
		coords = self:GetGrid(coords, size, true)
	end

	local grid = coords
	
	return {
		grid,
		grid - 1,
		grid + 1,
		grid - width,
		grid - width - 1,
		grid - width + 1,
		grid + width,
		grid + width - 1,
		grid + width + 1
	}
end

function Grids:GetImmediateGrids(coords, size, keepSize)
	if not size then return {} end
	if not keepSize then
		size = self.Sizes[size]
	end

	if type(coords) == "vector4" then
		coords = vector3(coords.x, coords.y, coords.z)
	end

	local grid = self:GetGrid(coords, size, true)
	local cache = { [grid] = true }
	local grids = { grid }
	local edgeSize = size * 0.5

	for _, delta in ipairs(self.Deltas) do
		local _grid = self:GetGrid(coords + vector3(delta.x, delta.y, 0.0) * edgeSize, size, true)
		if not cache[_grid] then
			cache[_grid] = true
			grids[#grids + 1] = _grid
		end
	end

	return grids
end