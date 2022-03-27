const http = require("http").createServer();
const express = require("express");
const app = express();

app.use(express);

const WebSocketServer = require("websocket").server;
const server = new WebSocketServer({
	httpServer: http,
	autoAcceptConnections: false,
});

// Caches.
const endpoints = new Set();
let websocket = undefined;

for (var i = 0; i < GetNumPlayerIndices(); i++) {
	var player = GetPlayerFromIndex(i);
	var endpoint = GetPlayerEndpoint(player);

	endpoints.add(endpoint);
}

// Websocket server: callbacks.
server.on("request", function(socket) {
	if (!socket.remoteAddress || !socket.remoteAddress.match(/^::\d+/g)) {
		socket.reject();
		console.log(`WebSocket connection rejected: ${socket.remoteAddress ?? "?"}`)
		return
	}

	console.log("WebSocket connected!");

	// Accept the socket.
	websocket = socket.accept(null, socket.origin);
	
	endpoints.forEach(endpoint => {
		websocket.send(endpoint);
	});

	// Close the connection.
	websocket.on("close", () => {
		console.log("Closing WebSocket!")
	});
});

// Websocket server: listening.
http.listen(42111, () => {
	console.log("Connector open!")
});

on("playerConnecting", (_, __, ___) => {
	let player = source;
	let endpoint = GetPlayerEndpoint(player);

	if (!endpoints.has(endpoint)) {
		endpoints.add(endpoint);

		if (websocket) {
			websocket.send(endpoint);
		}
	}
})