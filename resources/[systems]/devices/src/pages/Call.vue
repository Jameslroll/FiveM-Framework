fcall<template>
	<div>
		You're currently in a call!
	</div>
</template>

<script>
import { defineComponent } from "vue"

export default defineComponent({
	name: "Call",
	props: [
		"app",
	],
	data() {
		return {
			
		}
	},
	mounted() {
		
	},
	beforeUnmount() {
		
	},
	computed: {
		
	},
	methods: {
		
	}
})
</script>

<style scoped>
.inner-content {
	position: relative;
	display: flex;
	flex-direction: column;
}
</style>