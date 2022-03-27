<template>
	<transition-group name="fade" class="toasts">
		<toast
			v-for="toast in toasts"
			:key="toast.key"
			:toast="toast"
		></toast>
	</transition-group>
</template>

<script>
import toast from "@/components/Toast.vue"

export default {
	name: "App",
	components: {
		toast
	},
	computed: {
		toasts: function() {
			return this.$store.state.toasts
		},
	},
}
</script>

<style scoped>
.toasts {
	display: flex;
	flex-direction: row;
	flex-wrap: wrap;

	user-select: none;
}
</style>
