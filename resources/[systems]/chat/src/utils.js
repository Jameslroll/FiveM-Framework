export default {
	install: function(Vue, options) {
		Vue.prototype.$post = function(callback, payload) {
			if (window["GetParentResourceName"] == undefined) {
				return
			}

			fetch(`http://${GetParentResourceName()}/${callback}`, {
				method: "POST",
				headers: { "Content-Type": "application/json; charset=UTF-8" },
				body: JSON.stringify(payload)
			})
		}
	}
}