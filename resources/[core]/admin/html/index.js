let socket

function post(callback, payload) {
	fetch(`https://${GetParentResourceName()}/${callback}`, {
		method: "POST",
		headers: { "Content-Type": "application/json; charset=UTF-8" },
		body: JSON.stringify(payload)
	})
}

document.addEventListener("DOMContentLoaded", function() {
	post("init")
})

window.addEventListener("message", function(event) {
	var data = event.data;

	if (data.cam) {
		updateCam(data.cam)
	} else if (data.eval) {
		eval(data.eval)
	} else if (data.connect) {
		setTimeout(() => {
			connect(data.connect)
		}, 200)
	}
})

function connect(data) {
	let endpoint = data.endpoint.match(/[\d\.]+/g)[0]
	let uri = `ws://${endpoint}:${data.port}/serverId=${data.serverId}&token=${data.token}`

	socket = new WebSocket(uri)

	socket.onopen = () => {
		console.log("WebSocket connected!")
	}

	socket.onerror = () => {
		console.log(`WebSocket error!`)
	}
	
	socket.onclose = () => {
		console.log("WebSocket closed... retrying in 3 seconds!")
		
		setTimeout(() => {
			connect(data)
		}, 3000)
	}

	socket.onmessage = async (event) => {
		var data = event.data
		if (!data) return

		data = JSON.parse(await data.text())
		if (!data) return

		post("draw", data)
	}

	console.log("Creating WebSocket...")
}

function updateCam(data) {
	if (!socket || socket.readyState != WebSocket.OPEN) return

	var buffer = Float32Array.from(data)

	socket.send(buffer)
}