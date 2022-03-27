document.addEventListener("DOMContentLoaded", function() {
	post("ready");
});

window.addEventListener("message", (event) => {
	var data = event.data;

	if (data.method) {
		var func = window[data.method];
		if (func) {
			func(data.data);
		}
	}
});

function post(callback, payload) {
	fetch(`https://${GetParentResourceName()}/${callback}`, {
		method: "POST",
		headers: { "Content-Type": "application/json; charset=UTF-8" },
		body: JSON.stringify(payload)
	})
}