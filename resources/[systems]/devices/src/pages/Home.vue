<template>
	<div class="apps">
		<div
			class="app cursor-pointer"
			clickable
			v-for="(app, key) in device.filteredApps"
			:key="key"
			@click="$emit('setApp', app.id, app.data)"
		>
			<img
				:src="getIcon(app.id)"
			/>
			<span>{{app.name}}</span>
		</div>
	</div>
</template>

<script>
import { defineComponent } from "vue";

export default defineComponent({
	name: "Home",
	computed: {
		device() {
			return this.$device
		},
	},
	methods: {
		getIcon(id) {
			try {
				return require(`assets/icons/${id}.png`)
			} catch {
				return require("assets/icons/unknown.png")
			}
		},
	},
})
</script>

<style scoped>
.apps {
	display: flex;
	flex-direction: row;
	flex-wrap: wrap;
	align-content: flex-start;
	justify-content: center;
}

.app {
	display: flex;
	flex-direction: column;
	align-content: center;
	align-items: center;
	justify-content: flex-start;
	width: 5.5vmin;
	height: 9vmin;
	color: white;
	text-align: center;
	font-size: 1em;
	margin: 0.6vmin;
	padding: 0.5vmin;
}

.app img {
	height: auto;
	width: 5vmin;
	object-fit: contain;
	margin-bottom: 0.6vmin;
}
</style>