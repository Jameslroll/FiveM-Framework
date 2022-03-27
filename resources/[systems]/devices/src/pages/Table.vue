<template>
	<div>
		
	</div>
</template>

<script>
import { defineComponent } from "vue";

export default defineComponent({
	name: "Options",
	props: [
		"app",
		"device",
	],
	computed: {
		template() {
			return this.app.template;
		},
	},
	methods: {
	},
})
</script>

<style scoped>

</style>