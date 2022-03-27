<template>
	<transition-group class="preview" name="fade">
		<item
			v-for="preview in previews" :key="preview.key"
			:preview="preview.name"
			:action="getActionText(preview.change)"
			:use-time="preview.use_time"
			abstract=true
		></item>
	</transition-group>
</template>

<script>
import item from "@/components/Item.vue"

export default {
	name: "Inventory",
	components: {
		item,
	},
	data: function() {
		return {
		}
	},
	computed: {
		previews: function() {
			return this.$store.state.previews
		},
	},
	methods: {
		getActionText: function(change) {
			var value = null
			
			if (typeof change == "number") {
				value = this.$formatNumber(change)
				
				if (change > 0) {
					value = `+${value}`
				}
			}

			return value ?? change
		},
	},
}
</script>

<style>
.preview {
	position: absolute;
	display: flex;
	flex-direction: row-reverse;
	flex-wrap: wrap-reverse;
	justify-content: flex-end;

	width: auto;
	height: auto;

	top: 10vmin;
	right: 5vmin;
	max-width: 90vw;

	user-select: none;
	pointer-events: none;
}

.fade-enter-active, .fade-leave-active {
	transition: opacity 1s;
}
.fade-enter, .fade-leave-to {
	opacity: 0;
}
</style>