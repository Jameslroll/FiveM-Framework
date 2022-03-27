<template>
	<div>

	</div>
</template>

<script>
import { defineComponent } from "vue";

export default defineComponent({
	name: "Chat",
	props: [
		"device",
		"app",
	],
	data() {
		return {
			chatType: undefined,
		}
	},
	computed: {
		messages() {
			let messages = this.$getData(self.app.name, "messages") || []

			return messages
		}
	},
	methods: {
		
	}
})
</script>

<style scoped>

</style>