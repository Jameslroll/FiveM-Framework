document.addEventListener("DOMContentLoaded", function() {
	// Debug.
	// setActive(true)
	// setPower(true)
	// setVolume(2, 3)
	// setChannel(1, "Cum Cave")

	// Init.
	post("init")
})

window.addEventListener("message", function(event) {
	var data = event.data

	if (data.commit) {
		var func = window[data.commit.type];
		if (func) {
			func(...data.commit.args)
		}
	}
})

window.addEventListener("keydown", function(event) {
	if (event.key == "Escape") {
		post("close")
	}
})

function post(callback, payload) {
	fetch(`https://${GetParentResourceName()}/${callback}`, {
		method: "POST",
		headers: { "Content-Type": "application/json; charset=UTF-8" },
		body: JSON.stringify(payload)
	})
}

function setActive(value) {
	var body = document.querySelector("body")
	body.style.display = value ? "block" : "none"
}

function setVolume(value, maxValue) {
	var volume = document.querySelector("#volume")
	var text = ""

	for (var i = 0; i < maxValue; i++) {
		if (i == value) {
			text += "<span style='opacity: 0.25'>"
		}

		text += "|"

		if (value < maxValue && i == maxValue - 1) {
			text += "</span>"
		}
	}

	volume.innerHTML = text
}

function setChannel(index, name) {
	var channelEl = document.querySelector("#content #channel")
	var nameEl = document.querySelector("#content #name")

	channelEl.textContent = index
	nameEl.textContent = name
}

function setPower(value) {
	var light = document.querySelector("#active-light")
	
	if (value) {
		light.classList.add("on")
	} else {
		light.classList.remove("on")
	}
}