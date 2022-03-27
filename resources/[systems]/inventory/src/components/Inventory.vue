<template>
	<div
		class="inventory"
		@mouseover="mouseHover"
	>
		<container
			v-for="container in containers"
			:key="container.id"
			:info="container"
		></container>
		<selection
			:selection="selection"
			:quantity="quantity"
		></selection>
		<crafting></crafting>
		<!-- <trade></trade> -->
	</div>
</template>

<script>
import crafting from "@/components/Crafting.vue"
import container from "@/components/Container.vue"
import selection from "@/components/Selection.vue"
import trade from "@/components/Trade.vue"

import { mapMutations, mapState } from "vuex"

export default {
	name: "Inventory",
	components: {
		crafting,
		container,
		selection,
		trade,
	},
	data: function() {
		return {
			selection: undefined,
			quantity: 1.0,
		}
	},
	computed: {
		...mapState([ "containers" ]),
		...mapMutations([ "addContainer" ]),
		selectionInfo: function() {
			return this.selection?.info
		},
	},
	methods: {
		mouseHover: function(event) {
			if (event.currentTarget == event.target) {
				window.dragTarget = "drop"
			} else if (window.dragTarget == "drop") {
				window.dragTarget = undefined
			}
		},
		select: function(item) {
			this.quantity = 1.0
			this.selection = item
		},
	},
}
</script>

<style>
* {
	--item-width: 10vmin;
	--item-height: 10vmin;
	--item-padding: 0.5vmin;
	--item-border: 1px;

	--primary-color: rgb(0, 150, 255);
	--warning-color: rgb(206, 36, 36);

	--border-radius: 0.6vmin;

	scrollbar-width: thin;
}

.inventory {
	display: block;
	position: relative;

	width: 100%;
	height: 100%;
}

button {
	background: rgba(0, 0, 0, 0.4);
	color: white;
	padding: 0.5vmin;
	border: none;
	outline: none;
	border-radius: var(--border-radius);
}

button:hover {
	background: rgba(20, 20, 20, 0.8);
}

input {
	border: none;
	outline: none;
	border-radius: var(--border-radius);
	background: rgb(240, 240, 240, 0.9);
	padding: 0.5vmin;
	font-size: 0.8em;
}

input:active {
	border: none;
	outline: none;
}

::-webkit-scrollbar {
	width: 6px;
}

::-webkit-scrollbar-track {
	background: rgba(20, 20, 20, 0.6);
}

::-webkit-scrollbar-thumb {
	background: rgba(255, 255, 255, 0.8);
}
</style>