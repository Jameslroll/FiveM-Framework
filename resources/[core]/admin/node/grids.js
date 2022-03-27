const Cfx = require("fivem-js")

module.exports = {
	Size: new Cfx.Vector3(8992, 12992, 0),
	Offset: new Cfx.Vector3(4480, 4480, 0),
	PlayerGridSize: 4,

	Deltas: [
		new Cfx.Vector3(-1.0, -1.0, 0),
		new Cfx.Vector3(-1.0, 0.0, 0),
		new Cfx.Vector3(-1.0, 1.0, 0),
		new Cfx.Vector3(0.0, -1.0, 0),
		new Cfx.Vector3(0.0, 1.0, 0),
		new Cfx.Vector3(1.0, -1.0, 0),
		new Cfx.Vector3(1.0, 0.0, 0),
		new Cfx.Vector3(1.0, 1.0, 0),
	],

	Sizes: [
		16,
		32,
		64,
		128,
	],

	GetWidth(size) {
		return Math.ceil(this.Size.x / size)
	},

	GetGrid(coords, size, keepSize) {
		coords = new Cfx.Vector3(Math.min(Math.max(coords.x + this.Offset.x, 0), this.Size.x), Math.min(Math.max(coords.y + this.Offset.y, 0), this.Size.y), coords.z)
		if (!keepSize) {
			size = this.Sizes[size]
		}

		var width = this.GetWidth(size)
		return Math.floor(coords.x / size) + Math.floor(coords.y / size) * width
	},

	GetCoords(grid, size, keepSize) {
		if (!keepSize) {
			size = this.Sizes[size]
		}

		var width = this.GetWidth(size)
		return new Cfx.Vector3(Math.floor(grid % width) * size - this.Offset.x + size / 2.0, Math.floor(grid / width) * size - this.Offset.y + size / 2.0, 0)
	},

	GetNearbyGrids(coords, size, keepSize) {
		if (!size) return {}
		if (!keepSize) {
			size = this.Sizes[size]
		}

		var width = this.GetWidth(size)
		if (typeof coords == "new Cfx.Vector3") {
			coords = this.GetGrid(coords, size, true)
		}

		var grid = coords

		return [
			grid,
			grid - 1,
			grid + 1,
			grid - width,
			grid - width - 1,
			grid - width + 1,
			grid + width,
			grid + width - 1,
			grid + width + 1
		]
	},

	GetImmediateGrids(coords, size, keepSize) {
		if (!size) return {}
		if (!keepSize) {
			size = this.Sizes[size]
		}

		if (typeof coords == "vector4") {
			coords = new Cfx.Vector3(coords.x, coords.y, coords.z)
		}

		var grid = this.GetGrid(coords, size, true)
		var cache = { [grid]: true }
		var grids = [ grid ]
		var edgeSize = size * 0.5

		this.Deltas.forEach(delta => {
			var _grid = this.GetGrid(coords + new Cfx.Vector3(delta.x, delta.y, 0.0) * edgeSize, size, true)
			if (!cache[_grid]) {
				cache[_grid] = true
				grids[grids.length + 1] = _grid
			}
		})

		return grids
	},
}