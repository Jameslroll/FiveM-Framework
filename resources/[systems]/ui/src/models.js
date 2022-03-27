import Vue from "vue"

Vue.use({
	install: function(Vue, store) {
		Vue.prototype.$getModel = function(model) {
			return this.$window?.models[model]
		}

		Vue.prototype.$setModel = function(model, value) {
			if (typeof model !== "string") return

			var window = this.$window
			if (!window) return

			var models = window?.models
			if (!models) return

			window.$set(models, model, value)

			this.$invoke("updateModel", model, value, new Date().getTime())
		}

		Vue.prototype.$copyToClipboard = function(text) {
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

		Vue.mixin({
			created: function() {
				var parent = this.$parent
				while (parent) {
					if (parent.$options.name == "Window") {
						this.$window = parent
						break
					}

					parent = parent.$parent
				}
			}
		})
	}
})