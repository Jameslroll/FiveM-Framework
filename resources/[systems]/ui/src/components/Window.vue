<template>
	<div class="window">
		<div class="header" v-if="info && info.title">
			<span>{{info.title}}</span>
			<div class="header-slot" v-if="info.prepend">
				<slot name="prepend"></slot>
			</div>
		</div>
		<div class="container">
			<slot></slot>
		</div>
	</div>
</template>

<script>
import node from "./Node.vue"

export default {
	name: "Window",
	props: [ "info" ],
	components: {
		node,
	},
	data: function() {
		return {
			models: {},
		}
	},
	mounted: function() {
		if (this.info?.models) {
			this.models = this.info.models
			delete this.info.models
		}

		if (this.info?.id) {
			this.$store.state.windows[this.info.id] = this
		}
	},
	destroyed: function() {
		if (this.info?.id) {
			delete this.$store.state.windows[this.info.id]
		}
	},
}
</script>

<style scoped>
.window {
	position: absolute;

	width: auto;
	height: auto;
	left: auto;
	right: auto;
	top: auto;
	bottom: auto;
}

.window > :first-child {
	border-top-left-radius: var(--border-radius);
	border-top-right-radius: var(--border-radius);
}

.window > :last-child {
	border-bottom-left-radius: var(--border-radius);
	border-bottom-right-radius: var(--border-radius);
}

.container {
	display: flex;
	position: relative;
	flex-direction: column;

	width: 100%;
	height: 100%;
	padding: 1vmin;

	color: white;
	background: linear-gradient(to bottom, rgba(60, 60, 60, 0.9), rgba(40, 40, 40, 0.9));
	border: 1px solid rgba(20, 20, 20, 0.8);

	overflow: auto;
}

.compact .container {
	padding: 0px;
}

.transparent .container {
	background: transparent;
	border: none;
}

.horizontal .container {
	flex-direction: row;
}

.compact .container > :first-child {
	border-radius: 0px !important;
}

.header {
	position: absolute;
	display: flex;
	align-items: center;
	justify-content: flex-start;

	padding: 0.5vmin;
	width: 100%;
	height: auto;
	background: linear-gradient(to bottom, rgba(50, 50, 50, 1.0), rgba(40, 40, 40, 1.0));
	border: 1px solid rgba(20, 20, 20, 0.8);
	border-bottom: none;
	margin-bottom: -1px;
	font-size: 0.85em;
	font-weight: 700;

	bottom: 100%;
}

.header-slot {
	position: absolute;
	right: 0.5vmin;
}
</style>

<style>
.q-form {
	position: relative;
}

.q-form > * {
	position: relative;
	margin-bottom: 1vmin;
}

.q-form > *:last-child {
	margin-bottom: 0px;
}

.q-form > * > *:not(:last-child) {
	margin-right: 1vmin;
}

.q-btn-group > * {
	margin-right: 0px !important;
}

.q-field__control-container {
	overflow-y: auto;
	max-height: 20vmin;
}

.q-field__control-container::-webkit-scrollbar {
	display: none;
}

.q-tab-panels {
	background: transparent !important;
}

.dense .q-field, .dense .q-field__control, .dense .q-field__marginal, .dense .q-field__bottom {
	height: 30px !important;
}
</style>