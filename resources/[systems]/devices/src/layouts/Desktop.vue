<template>
	<div class="root">
		<transition name="fade">
			<div
				class="content"
				:name="device.name"
			/>
		</transition>
		<div class="menu">
			<q-btn>
				<img src="https://winaero.com/blog/wp-content/uploads/2019/12/Linux-Mint-Linuxmint-Logo-Icon-New.png" />
			</q-btn>
			<q-btn flat icon="home" />
			<q-btn flat icon="menu" />
		</div>
	</div>
</template>

<script>
import { defineComponent } from "vue"

export default defineComponent({
	name: "Mobile",
	props: [
		"name",
	],
	components: {
	},
	computed: {
		device() {
			return this.$device
		},
	}
})
</script>

<style scoped>
.root {
	display: flex;
	flex-direction: column;
	color: white;
	max-height: 100%;
}

.content {
	position: relative;
	flex-grow: 1;
	height: 0%;
}

.menu {
	position: relative;
	display: flex;
	width: 100%;
	background: rgba(0, 0, 0, 0.8);
	padding: 0vmin;
}

.menu .q-btn {
	width: 1vmin;
	height: 1vmin;
	margin: 0.5vmin;
}

.menu .q-btn img {
	position: absolute;

	width: 100%;
	height: 100%;

	object-fit: contain;
}
</style>