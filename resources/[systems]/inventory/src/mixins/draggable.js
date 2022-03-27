import interact from "interactjs"

export default {
	data: function() {
		return {
			draggableIndex: 1
		}
	},
	methods: {
		ondragmove: function(event) {
			var target = event.target
			var x = (parseFloat(target.getAttribute("data-x")) || 0) + event.dx
			var y = (parseFloat(target.getAttribute("data-y")) || 0) + event.dy

			target.setAttribute("data-x", x)
			target.setAttribute("data-y", y)
			
			target.style.transform = `translate(${x}px, ${y}px)`
		},
		focus: function() {
			var el = this.$el
			if (el == undefined) return

			var lastZ = el?.style.zIndex || 0
			var highestZ = this.getHighestZ()

			if (lastZ >= highestZ) {
				return
			}

			this.$setFocus(el)

			el.style.zIndex = highestZ + 1

			var event = new CustomEvent("unfocus", { detail: { el: el } })

			for (var id in window.draggables) {
				var _el = window.draggables[id]
				var zIndex = _el?.style.zIndex || 0

				if (_el && zIndex > lastZ) {
					_el.dispatchEvent(event)
					_el.style.zIndex--
				}
			}
		},
		getHighestZ: function() {
			var highestZ = 0

			for (var id in window.draggables) {
				var _el = window.draggables[id]
				var zIndex = _el?.style?.zIndex || 0

				highestZ = Math.max(highestZ, zIndex)
			}

			return highestZ
		},
	},
	mounted: function() {
		// Init draggable.
		interact(this.$el).draggable({
			inertia: false,
			autoScroll: false,
			modifiers: [
				interact.modifiers.restrictRect({
					restriction: "body",
					endOnly: true,
				}),
			],
			listeners: {
				move: this.ondragmove,
				end: this.ondragend
			}
		}).actionChecker(function(pointer, event, action, interactable, element, interaction) {
			if (!event?.target?.classList?.contains("header")) {
				return false
			}

			return action
		})

		// Cache draggable.
		var el = this.$el
		if (el?.style == undefined) return

		if (!window.draggables) {
			window.draggables = {}
			el.style.zIndex = 0
		} else {
			el.style.zIndex = this.getHighestZ() + 1
		}
		
		this.draggableIndex = (window.draggableIndexes || 0) + 1
		window.draggableIndexes = this.draggableIndex
		window.draggables[this.draggableIndex] = el

		// Add events.
		el.addEventListener("mousedown", this.focus)
	},
	beforeDestroy: function() {
		if (window.draggables) {
			window.draggables[this.draggableIndex] = undefined
		}
	},
}