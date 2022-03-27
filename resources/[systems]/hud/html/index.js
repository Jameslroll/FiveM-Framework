class Progress {
	constructor(id, from, to) {
		this.el = document.querySelector(`#${id}`)
		this.from = from
		this.to = to

		// setInterval(() => {
		// 	var rect = this.el.getBoundingClientRect()
		// 	var width = Math.round(rect.width)
			
		// 	if (width != this.width) {
		// 		this.width = width
		// 		this.init(rect.width * 0.5)
		// 	}
		// }, 200)
	}
	
	init(radius) {
		this.radius = radius
		this.circumference = radius * 2.0 * Math.PI
		
		console.log("INIT", radius)
		
		this.el.style.display = "block"
		this.el.style.strokeDasharray = `${this.circumference} ${this.circumference}`
		this.el.style.strokeDashoffset = `${this.circumference}`

		this.set(this.from ?? 0.0, this.to ?? 1.0)
	}
	
	set(from, to) {
		this.from = from
		this.to = to

		var el = this.el
		const offset = this.circumference - (to - from) * this.circumference
		el.style.strokeDashoffset = offset
		el.style.transform = `rotate(${from * 360.0 - 90.0}deg)`
	}
}

var FuelBackground = null
var FuelBar = null

document.addEventListener("DOMContentLoaded", function() {
	document.querySelector("#vehicle").style.display = "none"
	document.querySelector("#content").style.display = "none"

	FuelBackground = new Progress("fuel-background", 0.25, 0.45)
	FuelBar = new Progress("fuel-bar", 0.25, 0.45)

	post("ready")
})

window.addEventListener("message", function(event) {
	var data = event.data

	if (data.commit) {
		var func = window[data.commit.type]
		if (func) {
			func(data.commit.data)
		}
	}
})

function post(callback, payload) {
	fetch(`https://${GetParentResourceName()}/${callback}`, {
		method: "POST",
		headers: { "Content-Type": "application/json; charset=UTF-8" },
		body: JSON.stringify(payload)
	})
}

function setAnchor(anchor) {
	var width = window.screen.width
	var height = window.screen.height

	var element = document.querySelector("#minimap")
	element.style.width = `${anchor.height * height}px`
	element.style.height = `${anchor.height * height}px`
	
	element.style.left = `${anchor.left * width}px`
	element.style.bottom = `${anchor.bottom * height}px`

	element.style.top = `auto`
	element.style.right = `auto`

	var radius = anchor.height * height / 2.0 * 0.8

	FuelBackground.init(radius)
	FuelBar.init(radius)
}

function setBearing(data) {
	var compass = document.querySelector("#minimap #spinner")
	if (compass) {
		compass.style.transform = `rotate(${data.heading}deg)`
	}
	var bearing = document.querySelector("#bearing")
	if (bearing) {
		bearing.textContent = `${Math.floor(360.0 - data.heading)}°`
	}
}

function setText(data) {
	var element = document.querySelector(`#${data.element}`)
	if (element) {
		element.innerHTML = data.text
	}
}

function setFuel(value) {
	value = Math.min(Math.max(value, 0.0), 1.0)

	var min = 0.25
	var max = 0.45
	var isLow = value < 0.05
	
	if (isLow && !FuelBar.el.classList.contains("low")) {
		FuelBar.el.classList.add("low")
	} else if (!isLow && FuelBar.el.classList.contains("low")) {
		FuelBar.el.classList.remove("low")
	}

	FuelBar.el.style.display = value < 0.001 ? "none" : "block"
	FuelBar.set(max - (max - min) * value, max)
}

function addIcon() {
	
}

function setDisplay(data) {
	document.querySelector(`#${data.target}`).style.display = data?.value ? (data.target == "air" ? "flex" : "block") : "none"
}

function setUnderwater(value) {
	var root = document.querySelector("#content")
	if (value) {
		root.classList.add("underwater")
	} else {
		root.classList.remove("underwater")
	}
}