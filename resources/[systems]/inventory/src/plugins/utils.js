export default {
	install: function(Vue, options) {
		// Messaging.
		Vue.prototype.$post = function(callback, payload) {
			console.log("post", callback, payload)
			
			if (window["GetParentResourceName"] == undefined) {
				return
			}

			fetch(`https://${GetParentResourceName()}/${callback}`, {
				method: "POST",
				headers: { "Content-Type": "application/json; charset=UTF-8" },
				body: JSON.stringify(payload)
			})
		},
		Vue.prototype.$commit = function(type, payload, options) {
			this.$store.commit(type, payload, options)
		},
		// Item stuff.
		Vue.prototype.$setFocus = function(el) {
			if (window.primaryFocus != el) {
				window.secondaryFocus = window.primaryFocus
				window.primaryFocus = el

				this.$post("updateFocus", {
					primary: window.primaryFocus?.id,
					secondary: window.secondaryFocus?.id,
				})
			}
		},
		Vue.prototype.$itemSlots = {},
		Vue.prototype.$countSlots = function(container) {
			if (!container?.slots) {
				return 0
			}

			var count = 0
			for (var _ in container.slots) {
				count++
			}

			return count
		},
		// Number stuff.
		Vue.prototype.$formatNumber = function(number) {
			return number.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",")
		}
	}
}