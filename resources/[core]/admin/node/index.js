const Cfx = require("fivem-js")
const http = require("http")
const crypto = require("crypto")
const ws = require("ws")
const Grids = require("./node/grids.js")

const players = new Object()
const ready = new Set()
const grids = new Object()

const GRID_SIZE = 3
const EVENT_NAME = GetCurrentResourceName() + ":"

let server = undefined
let port = undefined
let wss = undefined

// Server functions.
function startServer(_port) {
	server = http.createServer({})
	wss = new ws.WebSocketServer({ noServer: true })
	
	port = _port ?? 30000 + Math.floor(Math.random() * 10000)
	// port = 30125 // TODO: remove & fix firewall

	// Server callbacks.
	server.on("error", (e) => {
		console.log(`Couldn't create server on port ${port}... retrying in 3 seconds!`)
		
		setTimeout(() => {
			startServer()
		}, 3000)
	})

	wss.on("connection", (socket, serverId) => {
		if (!serverId) return

		let player = players[serverId]
		if (!player) return

		socket.on("message", (data) => {
			if (!data || data.length != 4 * 6 || !ready.has(serverId)) return

			var array = []

			try {
				var buffer = new ArrayBuffer(data.length)
				var view = new DataView(buffer)
	
				data.forEach((b, i) => {
					view.setUint8(i, b)
				})
	
				for (var i = 0; i < data.length; i += 4) {
					array[i / 4] = view.getFloat32(i, true)
				}
			} catch {
				// Do nothing.
			} finally {
				// Camera transformation.
				player.camera = array

				// Update grid.
				var grid = Grids.GetGrid(new Cfx.Vector3(array[0], array[1], array[2]), GRID_SIZE)

				if (player.grid != grid) {
					if (player.grid != null) {
						removeFromGrid(serverId, player.grid)
					}

					addToGrid(serverId, grid)

					player.grid = grid
				}
			}
		})

		player.socket = socket
	})

	server.on("upgrade", (req, socket, head) => {
		var serverId = authenticateConnection(req, socket, head)
		if (!serverId) {
			socket.write('HTTP/1.1 401 Unauthorized\r\n\r\n')
			socket.destroy()
			return
		}

		var client = req.client
		if (!client) return

		wss.handleUpgrade(req, socket, head, function done(socket) {
			wss.emit("connection", socket, serverId)
		})
	})
	
	server.listen(port, () => {
		console.log(`Server is listening on port ${port}!`)

		// for (let i = 0; i < GetNumPlayerIndices(); i++) {
		// 	const player = parseInt(GetPlayerFromIndex(i))
		// 	if (!player) continue

		// 	setupPlayer(player)
		// }
	})
}

function authenticateConnection(req, socket, head) {
	var url = req.url
	if (!url) return false

	// Get token.
	var token = url.match(/token=([^&]*)/)[1]
	if (!token) return false

	// Get server id.
	var serverId = parseInt(url.match(/serverId=([^&]*)/)[1])
	if (!serverId || isNaN(serverId)) return false

	// Get host.
	// var _endpoint = get ip but idk how lol
	// if (!_endpoint) return false

	// Validate _endpoint.
	// var endpoint = GetPlayerEndpoint(parseInt(serverId))
	
	// if (_endpoint != endpoint) {
	// 	console.log("Endpoints not matching", _endpoint, endpoint)
	// 	return false
	// }

	// Validate token.
	var client = ready.has(serverId) && players[serverId]
	if (!client || client.token != token) {
		console.log("Invalid token", serverId, token)
		return false
	}

	return serverId
}

function setupPlayer(source) {
	if (typeof source != "number" || players[source] || !ready.has(source)) return
	
	if (!port) {
		console.log("Cannot setup player yet... waiting for server.")
	}

	crypto.randomBytes(32, (_, buffer) => {
		if (players[source]) return

		// Get token hex.
		let token = buffer.toString("hex")
		if (!token) return
		
		// Cache client's token.
		players[source] = {
			token: token,
		}

		// Send info to client
		emitNet(EVENT_NAME + "auth", source, port, token)

		// Debug.
		console.log(`Set up player: ${source}, ${token}`)
	})
}

// Grid stuff.
function addToGrid(source, gridId) {
	var grid = grids[gridId]

	if (!grid) {
		grid = new Set()
		grids[gridId] = grid
	} else if (grid.has(source)) {
		return false
	}

	grid.add(source)

	return true
}

function removeFromGrid(source, gridId) {
	var grid = grids[gridId]
	if (!grid) return false

	if (!grid.has(source)) {
		return false
	}

	grid.delete(source)

	if (grid.size == 0) {
		delete grids[gridId]
	}
}

function spectate(source, target) {
	// Get player.
	var player = players[source]
	if (!player) return

	// if (player.watch) {
	// 	var lastPlayer = players[player.watch]
	// 	if (lastPlayer) {
			
	// 	}
	// }

	// Get target.
	var _player = target && players[target]
	if (_player && player.watch != target) {
		player.watch = target
	} else {
		target = undefined
		delete player.watch
	}

	emitNet(EVENT_NAME + "spectate", source, target)
}

// Start the server.
setTimeout(() => {
	startServer()
}, 0)

// Net events.
onNet(EVENT_NAME + "ready", () => {
	ready.add(source)
	setupPlayer(source)
})

onNet(EVENT_NAME + "invokeHook", (_type, message, value) => {
	// Get player.
	var player = players[source]
	if (!player) return

	// Check input.
	if (_type != "toggle" || message != "viewCams" || typeof value != "boolean") return

	// Check user group.
	if (!exports.user.IsAdmin(source)) return

	// Update player.
	player.viewing = value
})

// Normal events.
on("playerDropped", (_) => {
	var player = players[source]
	if (player) {
		if (player.grid) {
			removeFromGrid(player.grid)
		}

		delete players[source]
	}

	if (ready.has(source)) {
		ready.delete(source)
	}
})

// Commands.
RegisterCommand("a:s", (source, args, _) => {
	// Check user group.
	if (!exports.user.IsAdmin(source)) return

	// Parase target.
	var target = parseInt(args[0] ?? "")
	if (!target || isNaN(target)) {
		target = undefined
	}

	// Spectate.
	spectate(source, target)
})

// Threads.
setInterval(() => {
	for (var serverId in players) {
		var player = players[serverId]
		var socket = player.socket
		var payload = undefined

		if (socket?.readyState != ws.OPEN || !player.grid) continue

		if (player.viewing) {
			payload = {}
			
			var nearbyGrids = Grids.GetNearbyGrids(player.grid, GRID_SIZE)
			nearbyGrids.forEach(gridId => {
				var grid = grids[gridId]
				if (!grid) return

				for (var _serverId of grid) {
					if (serverId == _serverId || player.watch == _serverId) continue

					var _player = players[_serverId]
					if (!_player) continue

					payload[_serverId.toString()] = _player.camera
				}
			})
		}

		if (player.watch) {
			if (!payload) {
				payload = {}
			}

			var _player = players[player.watch]
			if (_player) {
				payload[player.watch.toString()] = _player.camera
			}
		}
		
		if (payload) {
			socket.send(Buffer.from(JSON.stringify(payload)))
		}
	}
}, 100)