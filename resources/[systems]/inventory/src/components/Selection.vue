<template>
	<div
		class="container"
		v-if="isSelected"
	>
		<v-content>
			<div
				class="bar"
				ref="bar"
				@mousedown="beginSlide"
			>
				<div class="inner-bar" :style="`right: ${100.0 - quantity * 100.0}%`"></div>
				<span>{{(quantity * selection.info.quantity).toFixed(0)}}</span>
				<span>{{selection.info.quantity}}</span>
			</div>
			<div style="margin-bottom: 6px">
				<img class="icon" draggable=false :src="selection.imagePath" @error="selection.fallbackSrc">
				<span class="name">{{selection.item.name}}</span>
				<span> — {{(selection.item.weight * 1000).toFixed(0)}} g</span>
			</div>
			<div v-if="selection.item.description" class="description">{{selection.item.description}}.</div>
			<div v-if="extraText" v-html="extraText"></div>
		</v-content>
	</div>
</template>

<script>
import item from "@/components/Item.vue"
import vContent from "@/components/Content.vue"

export default {
	name: "Selection",
	props: [ "selection", "quantity" ],
	components: {
		vContent,
		item
	},
	data: function() {
		return {
			sliding: false,
		}
	},
	computed: {
		name: function() {
			return this.selection?.item?.name || "Unknown"
		},
		isSelected: function() {
			return this.selection?.item != undefined
		},
		extraText: function() {
			var fields = this.selection?.item?.fields
			if (fields == undefined) return

			var fieldInfo = this.selection?.info?.fields
			if (fieldInfo == undefined) return

			var text = ""
			for (var key in fields) {
				var field = fields[key]
				if (field?.hidden) continue

				var value = fieldInfo[key] || field?.alternative
				if (!value) continue

				var name = field?.name ?? key

				if (text != "") {
					text = `${text}<div style="margin-top: 1vmin"></div>`
				}

				text = `${text}<span style="font-weight: 800">${name}</span><br><span style="user-select: all">${value}</span>`
			}

			return text
		},
	},
	methods: {
		format: function(text) {
			text = JSON.stringify(text).replaceAll("\"", "")
			text = text.substring(1, text.length - 1)

			return text
		},
		updateSlider: function(event) {
			if (!this.sliding) {
				return
			}

			var rect = this.$refs.bar?.getBoundingClientRect()
			var quantity = this.selection?.info?.quantity ?? 1
			var value = Math.min(Math.max(Math.round((event.clientX - rect.left) / rect.width * quantity), 1), quantity) / quantity

			this.$parent.quantity = value
		},
		beginSlide: function(event) {
			this.sliding = true
			this.updateSlider(event)
		},
		endSlide: function() {
			this.sliding = false
		},
	},
	mounted: function() {
		document.addEventListener("mouseup", this.endSlide)
		document.addEventListener("mousemove", this.updateSlider)
	},
}
</script>

<style scoped>
.container {
	width: 35vmin;

	top: 10vmin;
	left: 2vmin;

	background: rgba(0, 0, 0, 0.5);
	z-index: 1000;
}

.contents {
	position: relative;
	display: inline-block;
	flex-direction: row;
	justify-content: space-between;
	align-items: flex-start;
	height: auto;
	padding: 1vmin;
	font-size: 0.75em;
	word-break: break-word;
}

.icon {
	vertical-align: top;
	width: 1.75em;
	height: 1.75em;
	object-fit: contain;
	padding: 0px;
	margin: 0px;
	margin-right: 0.75vmin;
}

.name {
	font-size: 1.25em;
	font-weight: 800;
}

.description:not(:last-child) {
	margin-bottom: 1vmin;
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
	margin-bottom: 0.5vmin;
	padding: 2px;

	overflow: hidden;

	border-top-left-radius: var(--border-radius) !important;
	border-top-right-radius: var(--border-radius) !important;
}

.bar span {
	pointer-events: none;
}

.inner-bar {
	position: absolute;
	background: var(--primary-color);
	left: 0%;
	right: 50%;
	top: 0%;
	bottom: 0%;
}
</style>