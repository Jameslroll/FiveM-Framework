<template>
	<div
		:class="['container', info.isSelf ? 'self' : '']"
		:id="info.id"
	>
		<v-header></v-header>
		<v-content>
			<div class="row" v-for="y in info.height" :key="y">
				<div class="col" v-for="x in info.width" :key="x">
					<item :slot-id="(x - 1) + (y - 1) * info.width"></item>
				</div>
			</div>
		</v-content>
		<v-footer>
			<div
				:class="['bar', weight < 0.001 ? 'empty' : '']"
				v-if="info.maxWeight"
			>
				<div class="weight-bar" :style="`right: ${100.0 - weight / info.maxWeight * 100.0}%`"></div>
				<span>{{weight.toFixed(2)}}</span>
				<span>{{info.maxWeight.toFixed(2)}}</span>
			</div>
			<div
				class="quick-slots"
				v-if="info.isSelf"
			>
				<div
					v-for="(quickSlot, key) in $store.state.binds" :key="key"
				>
					<item
						:abstract="true"
						:preview="getPreview(quickSlot.slot)"
						:bind-id="key"
						@moveslot="bindSlot"
					>
						{{quickSlot.key}}
					</item>
				</div>
			</div>
		</v-footer>
	</div>
</template>

<script>
import draggable from "@/mixins/draggable"
import item from "@/components/Item.vue"
import vContent from "@/components/Content.vue"
import vFooter from "@/components/Footer.vue"
import vHeader from "@/components/Header.vue"

export default {
	name: "Container",
	props: [ "info" ],
	mixins: [ draggable ],
	components: {
		vHeader,
		vContent,
		vFooter,
		item
	},
	data: function() {
		return {
			selection: undefined,
			expanded: true,
		}
	},
	computed: {
		name: function() {
			var container = this.info
			var name = container?.name || "Container"

			return name
		},
		isSelected: function() {
			return this.selection?.info != undefined
		},
		weight: function() {
			var weight = 0.0
			for (var slotId in this.info.slots) {
				var slot = this.info.slots[slotId]
				if (slot == undefined) continue

				if (slot.weight != undefined) {
					weight += slot.weight
					continue
				}

				var item = this.$store.getters.getItemById(slot.item_id)
				if (item == undefined) continue

				weight += (slot.quantity || 0.0) * (item.weight || 0.0)
			}

			return weight
		},
	},
	methods: {
		getSlot: function(x, y) {
			var id = (x - 1) + (y - 1) * this.info.width
			// var slot = this.info.slots[id] ?? {}
			// slot.id = slot.id ?? id
			// slot.container = this.info.id

			return id
		},
		close: function() {
			if (this.$store.state.isDebug && this.info?.isSelf) {
				this.$store.state.isEnabled = false

				setTimeout(() => {
					this.$store.state.isEnabled = true
				}, 1000)
			}

			this.$post("subscribe", {
				container: this.info.id,
				value: false,
			})
		},
		minimize: function() {
			this.expanded = false
		},
		maximize: function() {
			this.expanded = true
		},
		bindSlot: function(from, to, isOrigin) {
			if (!from.container.info.isSelf) return

			var binding = to?.bindId != undefined
			var unbinding = from?.bindId != undefined || to == undefined
			
			if (binding && unbinding) {
				if (!isOrigin) return

				var fromBind = this.$store.state.binds[from.bindId]
				var toBind = this.$store.state.binds[to.bindId]

				this.$post("bind", {
					bind: to.bindId,
					slot: fromBind.slot,
				})

				this.$post("bind", {
					bind: from.bindId,
					slot: toBind.slot,
				})

				if (this.$store.state.isDebug) {
					const toSlot = toBind.slot
					this.$set(this.$store.state.binds[to.bindId], "slot", fromBind.slot)
					this.$set(this.$store.state.binds[from.bindId], "slot", toSlot)
				}
			}
			else if (binding) {
				this.$post("bind", {
					bind: to.bindId,
					slot: from.slotId,
				})

				if (this.$store.state.isDebug) {
					this.$set(this.$store.state.binds[to.bindId], "slot", from.slotId)
				}
			}
			else if (unbinding) {
				this.$post("bind", {
					bind: from.bindId,
					slot: undefined,
				})

				if (this.$store.state.isDebug) {
					this.$delete(this.$store.state.binds[from.bindId], "slot")
				}
			}
		},
		getPreview: function(slot) {
			var itemId = this.info.slots[slot]?.item_id
			if (!itemId) {
				return ""
			}

			return this.$store.getters.getItemById(itemId)?.name
		},
	},
	mounted: function() {
		var el = this.$el
		if (el?.style == undefined) return

		var rect = el.getBoundingClientRect()
		var cached = this.info?.cached

		if (cached != undefined) {
			el.setAttribute("data-x", cached.x)
			el.setAttribute("data-y", cached.y)
			
			el.style.transform = `translate(${cached.x}px, ${cached.y}px)`
		}
		
		if (el.classList.contains("self")) {
			// el.style.left = `${document.body.clientWidth / 2 - rect.width / 2}px`
			el.style.right = `2vmin`
			el.style.top = `${document.body.clientHeight / 2 - rect.height / 2}px`
		} else {
			el.style.left = `${document.body.clientWidth / 2 - rect.width / 2}px`
			// el.style.left = `2vmin`
			el.style.top = `${document.body.clientHeight / 2 - rect.height / 2}px`
		}

		this.$setFocus(el)
	},
	beforeDestroy: function() {
		var info = this.info
		if (info == undefined) return

		var el = this.$el
		if (el?.style == undefined) return
		
		info.cached = {
			x: el.getAttribute("data-x"),
			y: el.getAttribute("data-y"),
		}
	},
}
</script>

<style>
.container {
	display: flex;
	position: absolute;

	flex-direction: column;
	align-content: stretch;
	align-items: stretch;
	
	width: auto;
	height: auto;

	overflow: hidden;

	border-radius: var(--border-radius);

	color: white;
	/* backdrop-filter: blur(6px); */
	box-shadow: 0.4vmin 0.4vmin 0.8vmin rgb(0, 0, 0, 0.6);
	touch-action: none;
}

.contents {
	padding: calc(var(--item-padding) / 2);
	max-height: calc((var(--item-height) + var(--item-border) * 2 + var(--item-padding)) * 5);
}

.bar {
	position: relative;
	flex-direction: row;
	display: flex;
	align-items: center;
	justify-content: space-between;

	color: white;
	background: rgba(20, 20, 20, 0.5);
	border: 1px solid rgba(0, 0, 0, 0.4);
	padding: 0.2vmin;

	overflow: hidden;
}

.bar.empty {
	background: var(--warning-color);
	opacity: 0.5;
}

.bar span {
	position: relative;
	display: block;

	color: white;
	
	margin-left: 8px;
	margin-right: 8px;

	font-size: 0.75em;
	font-weight: 800;
}

.weight-bar {
	position: absolute;
	background: var(--primary-color);
	left: 0%;
	right: 50%;
	top: 0%;
	bottom: 0%;
}

.quick-slots {
	display: flex;
	flex-direction: row;
	justify-content: space-around;
	margin-top: 0.5vmin;
	padding: 1.0vmin;
}

.quick-slots .item {
	width: 6.5vmin;
	height: 6.5vmin;
}
</style>