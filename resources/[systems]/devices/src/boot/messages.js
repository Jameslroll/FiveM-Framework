import { boot } from "quasar/wrappers"

export default boot(async ({ app, router, store }) => {
	window.addEventListener("message", function(e) {
		var data = e.data

		if (data.setter) {
			store.state[data.setter.key] = data.setter.value
		} else if (data.commit) {
			store.commit(data.commit.type, data.commit.payload, data.commit.options)
		}
	})
	app.config.globalProperties.$post = function(callback, payload, resource) {
		console.log("post", callback, JSON.stringify(payload), resource)

		if (window["GetParentResourceName"] == undefined) {
			return new Promise((resolve) => {
				resolve()
			})
		}

		return fetch(`https://${resource ?? GetParentResourceName()}/${callback}`, {
			method: "POST",
			headers: { "Content-Type": "application/json; charset=UTF-8" },
			body: JSON.stringify(payload)
		}).then(resp => resp.json())
	}
	app.config.globalProperties.$copyToClipboard = function(text) {
		var input = document.createElement("input")
		input.value = text
		
		input.style.top = "0"
		input.style.left = "0"
		input.style.position = "fixed"
	  
		document.body.appendChild(input)

		input.focus()
		input.select()
	  
		try {
			document.execCommand("copy")
		} catch {}
	  
		input.remove()
	}
	app.config.globalProperties.$colors = [
		"blue",
		"cyan",
		"teal",
		"red",
		"pink",
		"purple",
		"indigo",
		"green",
		"light-green",
		"lime",
		"yellow",
		"amber",
		"orange",
		"deep-orange",
		"brown",
		"grey",
		"blue-grey",
	]
})
