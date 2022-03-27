<template>
	<div :class="['message', message.class ? message.class : '']">
		<span v-if="message.title" class="title">{{message.title}}</span>
		<span v-if="message.text">{{message.text}}</span>
		<div
			v-if="message.html"
			v-html="message.html"
		>
		</div>
		<img
			v-if="message.image"
			:src="message.image"
		>
	</div>
</template>

<script>
export default {
	name: "App",
	props: [ "message" ],
	mounted: function() {
	},
}
</script>

<style scoped>
.message {
	position: relative;
	display: flex;
	flex-direction: column;

	background: var(--background-color);
	color: white;

	width: auto;
	padding: 0.6vmin;
	margin-bottom: 0.5vmin;
	border-radius: var(--border-radius);
}

.message > * {
	width: auto;
}

.message img {
	width: 50%;
	object-fit: contain;
	user-select: none;
	pointer-events: none;
}

.title {
	margin-bottom: 0.2vmin;
	font-size: 0.8em;
	font-weight: 600;
}

.advert {
	--background-color: #3498db;
}

.server {
	--background-color: #2c3e50;
}

.system {
	--background-color: #e67e22;
}

.emergency {
	--background-color: #e74c3c;
}

.nonemergency {
	--background-color: #c0392b;
}

.transparent {
	--background-color: transparent;
}
</style>
