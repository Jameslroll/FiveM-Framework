<template>
	<div class="container draggable">
		<window-header></window-header>
		<div class="contents">
			<div v-for="side in 2" :key="side">
				<div class="row" v-for="x in 3" :key="x">
					<div class="col" v-for="y in 3" :key="y">
						<item></item>
					</div>
				</div>
			</div>
		</div>
	</div>
</template>

<script>
import windowHeader from "@/components/Header.vue"
import item from "@/components/Item.vue"
import container from "@/components/Container.vue"

export default {
	name: "Trade",
	components: {
		windowHeader,
		container,
		item,
	},
	data: function() {
		return {
			dev: this.$store.state.dev || {}
		}
	},
	computed: {
		getDebugContainer: function() {
			// Get items.
			var items = this.$store.state.items

			// Sort items.
			var sortedItems = []

			for (var name in items) {
				sortedItems.push(items[name])
			}
			
			sortedItems.sort(function(a, b) {
				var nameA = (a.name || "").toUpperCase()
				var nameB = (b.name || "").toUpperCase()

				if (nameA < nameB) {
					return -1
				} else if (nameA > nameB) {
					return 1
				} else {
					return 0
				}
			})

			// Create slots.
			var slots = []

			for (var item of sortedItems) {
				slots.push({ item: item.name, quantity: 1 })
			}

			// Return container.
			var width = 4

			return {
				id: 0,
				name: "Spawner",
				width: width,
				height: Math.min(Math.ceil(slots.length / width)),
				slots: slots,
			}
		},
	}
}
</script>

<style scoped>
.container {
	top: 5vmin;
	left: 5vmin;
}

.contents {
	display: flex;
	flex-direction: row;
}

.contents > div:first-child {
	margin-right: 10vmin;
}

.row {
	display: flex;
	flex-direction: row;
	justify-content: space-between;
}
</style>