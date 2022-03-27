<template>
	<div
		:class="[
			'item',
			isSelected ? 'selected' : '',
			isFrisk && !isHidden ? 'frisk' : '',
			isBroken ? 'broken' : '',
			bind ? 'bound' : '',
		]"
		@click="select"
		@click.right.prevent="use"
		@mouseenter="activate"
		@mouseleave="deactivate"
	>
		<div
			v-if="durability || (info && info.durability)"
			:style="durabilityStyle"
			class="durability"
		></div>
		<div
			v-if="useTime || (info && info.use_time)"
			class="using"
			:style="`animation-duration: ${useTime ? useTime : info.use_time}ms; animation-delay: -${info && info.use_start ? (new Date().getTime()) - info.use_start : 0}ms`"
		>
		</div>
		<div v-if="!isEmpty" class="details">
			<img class="icon" draggable=false :src="imagePath" @error="fallbackSrc">
			<div class="name" v-if="!isFrisk">
				<span>{{name}}</span>
				<span v-if="info.nested_container_id" style="opacity: 0.75; font-size: 75%">({{info.nested_container_id}})</span>
			</div>
			<div class="info" v-if="!isFrisk">
				<span v-if="item">{{formatNumber(info.quantity)}}</span>
				<span v-if="weight * info.quantity > 0.0001">{{(weight * info.quantity).toFixed(2)}}</span>
				<slot></slot>
			</div>
		</div>
		<div v-if="isEmpty" class="empty">
			<img v-if="preview" class="icon" draggable=false :src="getPath(preview)" @error="fallbackSrc">
			<div class="info">
				<slot></slot>
			</div>
		</div>
		<div v-if="action" class="action">
			{{action}}
		</div>
		<span
			class="bind"
			v-if="bind"
		>
			{{bind.key}}
		</span>
	</div>
</template>

<script>
import interact from "interactjs"

export default {
	name: "item",
	props: [
		"abstract",
		"action",
		"bind-id",
		"durability",
		"preview",
		"slot-id",
		"use-time",
		"override-container",
	],
	data: function() {
		return {
			container: undefined,
		}
	},
	computed: {
		inventory: function() {
			var parent = this.$parent
			while (parent) {
				if (parent.$options._componentTag == "inventory") {
					return parent
				}
				parent = parent.$parent
			}
		},
		info: function() {
			return this.container?.info?.slots[this.slotId]
		},
		item: function() {
			return this.$store.getters.getItemById(this.info?.item_id)
		},
		weight: function() {
			return this.info?.weight ?? this.item.weight
		},
		bind: function() {
			if (this.bindId != undefined || !this.container?.info?.isSelf) {
				return undefined
			}

			for (var bindSlot in this.$store.state.binds) {
				var bind = this.$store.state.binds[bindSlot]
				if (bind?.slot == this.slotId) {
					return bind
				}
			}
		},
		isEmpty: function() {
			return this.info == undefined || this.item == undefined
		},
		isSelected: function() {
			return !this.isEmpty && this.inventory?.selection == this
		},
		isHidden: function() {
			if (this.isFrisk) {
				return this.item?.category != "Weapon" && this.item?.visible != 1
			} else {
				return false
			}
		},
		isFrisk: function() {
			return this.container?.info?.frisk && this.item?.visible != 2
		},
		isBroken: function() {
			return (this.info?.durability ?? 1) < 0.001
		},
		name: function() {
			var name = this.item?.name ?? "Unknown"
			if (typeof this.item?.decay === "object" && this.isBroken) {
				if (this.item.decay.prefix) {
					name = this.item.decay.prefix + " " + name
				}
				if (this.item.decay.suffix) {
					name = name + " " + this.item.decay.suffix
				}
			}
			return name
		},
		imagePath: function() {
			if (this.isHidden) {
				return this.getPath("NONE")
			}

			return this.getPath(this.item?.name)
		},
		durabilityStyle: function() {
			var background = ""
			var durability = this.durability ?? this.info.durability
			
			if ((durability || 1.0) > 0.99) {
				background = "transparent"
			}

			background = `hsla(${durability * 120}, 100%, 50%, 0.2)`

			return `background: ${background}; right: ${100.0 - durability * 100.0}%;`
		},
	},
	methods: {
		getPath: function(name) {
			return `../icons/${name.replaceAll(/\.|:|'|\s/g, "")}.png`
		},
		moveSlot: function(data) {
			// Post event.
			this.$post("moveSlot", data)
			
			// For testing purposes.
			if (this.$store.state.isDebug) {
				// Create the drop container.
				if (data.to == "drop") {
					var debugDropId = -1
					var debugDropContainer = this.$store.state.containers[debugDropId]

					if (!debugDropContainer) {
						debugDropContainer = {
							id: debugDropId,
							name: "Test Drop",
							type: "drop",
							width: 4,
							height: 4,
							slots: {},
							maxWeight: 20.0,
						}

						this.$store.commit("addContainer", debugDropContainer)
					}

					// Set target container to be the drop.
					data.to = {
						container: debugDropId,
						slot: this.$countSlots(debugDropContainer) || 0,
					}
				}

				// Get containers.
				var fromContainer = this.$store.state.containers[data.from.container]
				var toContainer = this.$store.state.containers[data.to.container]

				// Get slots.
				const cachedToSlot = toContainer?.slots[data.to.slot]
				const cachedFromSlot = fromContainer?.slots[data.from.slot]

				// Switch target slots with source slots.
				if (toContainer && !toContainer.isAbstract) {
					this.$store.commit("setSlot", {
						container: data.to.container,
						slot: data.to.slot,
						info: cachedFromSlot,
					})
				}

				// Switch source slots with target slots.
				if (fromContainer && !fromContainer.isAbstract) {
					this.$store.commit("setSlot", {
						container: data.from.container,
						slot: data.from.slot,
						info: cachedToSlot,
					})
				}
			}
		},
		select: function() {
			if (this.isFrisk) {
				return
			}

			if (!this.inventory || (!this.container?.isAbstract && "Control" in window.keys)) {
				this.moveSlot({
					from: {
						container: this.overrideContainer ?? this.container?.info?.id,
						slot: this.slotId,
					},
					to: "send",
					quantity: Math.round((this.inventory?.quantity || 1) * (this.info?.quantity || 1)),
				})

				return
			}

			this.inventory.select(this.isEmpty || this.inventory.selection == this ? undefined : this)
		},
		use: function() {
			if (this.bindId != undefined) {
				this.container.bindSlot(this)
			} else {
				if (this.$store.state.isDebug) {
					var info = this.info
					if (info) {
						info.use_time = 4000
					}

					this.$store.commit("setSlot", {
						container: this.container?.info?.id,
						slot: this.slotId,
						info: info,
					})

					// this.$forceUpdate()
				}

				this.$post("use", {
					container: this.container?.info?.id,
					slot: this.slotId,
				})
			}
		},
		ondragstart: function(event) {
			// Remove last preview.
			if (window.dragPreview) {
				window.dragPreview.remove()
				window.dragPreview = undefined
			}

			// No moving while frisking.
			if (this.container?.info?.frisk) {
				return
			}
			
			// Create preview.
			var preview = document.createElement("img")
			var icon = event.target.querySelector(".icon")

			if (!icon) {
				return
			}

			var rect = icon.getBoundingClientRect()

			rect.x += event.client.x - rect.x - rect.width / 2
			rect.y += event.client.y - rect.y - rect.height / 2

			preview.src = icon.src

			preview.style.position = "absolute"
			preview.style.objectFit = "contain"
			preview.style.zIndex = 1000
			preview.style.top = rect.top + "px"
			preview.style.left = rect.left + "px"
			preview.style.width = rect.width + "px"
			preview.style.height = rect.height + "px"
			preview.style.pointerEvents = "none"

			document.body.querySelector(".inventory").appendChild(preview)

			// Caches.
			window.dragSlot = this
			window.dragPreview = preview
		},
		ondragmove: function(event) {
			var target = window.dragPreview

			if (!target) {
				return
			}

			var x = (parseFloat(target.getAttribute("data-x")) || 0) + event.dx
			var y = (parseFloat(target.getAttribute("data-y")) || 0) + event.dy

			target.setAttribute("data-x", x)
			target.setAttribute("data-y", y)

			target.style.transform = `translate(${x}px, ${y}px)`
		},
		ondragend: function() {
			var dragSlot = window.dragSlot
			var dragTarget = window.dragTarget
			var isTargetSlot = typeof dragTarget === "object"

			if (dragSlot != this) {
				return
			}

			// Clear drag preview.
			window.dragPreview.remove()
			window.dragPreview = undefined

			// Clear drag slot.
			window.dragSlot = undefined

			// Check target.
			if (!dragTarget) return

			// Events.
			this.$emit("moveslot", this, dragTarget, true)

			if (isTargetSlot) {
				dragTarget.$emit("moveslot", this, dragTarget, false)
			}

			// Check abstract.
			if (this.abstract || (isTargetSlot && dragTarget.abstract)) {
				dragTarget = undefined
				return
			}

			// Get containers.
			var fromContainer = dragSlot?.container?.info || {}
			if (!fromContainer) return

			var toContainer = dragTarget?.container?.info || {}
			if (!toContainer || toContainer.isAbstract) return

			// Move slot.
			this.moveSlot({
				from: fromContainer.isAbstract ? {
					container: fromContainer.id,
					slot: dragSlot?.slotId,
					item: dragSlot?.item.id,
				} : {
					container: this.overrideContainer ?? fromContainer.id,
					slot: dragSlot?.slotId,
				},
				to: typeof dragTarget !== "string" ? {
					container: toContainer.id,
					slot: dragTarget?.slotId,
				} : dragTarget,
				quantity: Math.round((this.inventory?.quantity || 1) * (this.info?.quantity || 1)),
			})

			// Select target slot.
			if (this.inventory != undefined) {
				var quantity = this.inventory.quantity
				
				this.inventory.select(dragTarget)
				this.inventory.quantity = quantity
			}

			// Clear target.
			dragTarget = undefined
		},
		activate: function() {
			if (this.container?.info?.frisk) {
				return
			}

			window.dragTarget = this
		},
		deactivate: function(event) {
			if (window.dragTarget?.$el == event.target) {
				window.dragTarget = undefined
			}
		},
		formatNumber: function(number) {
			return this.$formatNumber(number)
		},
		fallbackSrc(event) {
			event.target.src = '../icons/NONE.png'
		},
	},
	mounted: function() {
		// Assign container.
		var parent = this.$parent
		while (parent) {
			if (parent?.$el?.classList?.contains("container")) {
				this.container = parent
				break
			}
			parent = parent.$parent
		}

		// Draggable.
		interact(this.$el).draggable({
			inertia: false,
			autoScroll: false,
			listeners: {
				start: this.ondragstart,
				move: this.ondragmove,
				end: this.ondragend,
			}
		})
	},
}
</script>

<style scoped>
.item {
	position: relative;

	width: var(--item-width);
	height: var(--item-height);

	color: white;
	background: rgba(20, 20, 20, 0.4);

	font-size: 0.7em;
	text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.8);

	margin: calc(var(--item-padding) / 2);
	border: var(--item-border) solid rgba(0, 0, 0, 0.6);
}

.item.selected {
	border-color: var(--primary-color);
}

.item.bound {
	background: rgb(240, 220, 30, 0.4);
}

.item.broken {
	background: rgba(255, 0, 0, 0.4);
}

.item.broken img {
	filter: sepia(80%);
}

.item.frisk img {
	filter: blur(0.4vmin) brightness(100.0);
}

.item .details {
	position: relative;

	width: 100%;
	height: 100%;
}

.item .empty {
	position: relative;
	
	width: 100%;
	height: 100%;
}

.item .icon {
	--padding: 20%;
	
	position: absolute;
	display: block;
	top: var(--padding);
	left: var(--padding);
	width: calc(100% - var(--padding) * 2);
	height: calc(100% - var(--padding) * 2);
	margin: 0px;
	object-fit: contain;
}

.item .name {
	position: absolute;
	display: block;
	text-align: left;
	left: 0.5vmin;
	right: 0.5vmin;
	bottom: 0.15vmin;
	width: auto;
	opacity: 0.5;
	font-size: 0.9em;
}

.item:hover .name {
	opacity: 1.0;
}

.item .name span {
	padding-right: 0.3em;
}

.item .info {
	position: absolute;
	display: flex;
	flex-direction: column;
	justify-content: center;
	align-items: flex-end;
	top: 0.15vmin;
	right: 0.5vmin;
}

.item .bind {
	position: absolute;
	top: 0.15vmin;
	left: 0.5vmin;
}

.item .durability {
	position: absolute;

	top: 0%;
	bottom: 0%;
	left: 0%;
	right: 0%;

	width: auto;
	height: auto;
	/* background: rgba(0, 255, 0, 0.3); */
}

.item .action {
	display: block;
	position: absolute;
	background: rgba(128, 16, 16, 0.5);
	padding: 0.4vmin;
	padding-left: 0.8vmin;
	padding-right: 0.8vmin;
	width: auto;
	left: 0%;
	right: 0%;
	text-align: center;
	bottom: 0vmin;
}

.item .using {
	position: absolute;
	display: block;
	left: 0%;
	right: 50%;
	height: 100%;
	background: rgba(27, 183, 255, 0.8);

	animation-name: progress_bar;
	/* animation-duration: 2s; */
	animation-fill-mode: forwards;
	animation-iteration-count: 1;
	animation-timing-function: linear;
}

@keyframes progress_bar {
	0% {
		right: 100%;
	}
	90% {
		right: 0%;
		opacity: 1.0;
	}
	100% {
		right: 0%;
		opacity: 0.0;
	}
}
</style>