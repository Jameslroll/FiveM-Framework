<template>
	<div v-if="name" class="container crafting-root">
		<v-header></v-header>
		<v-content>
			<div class="crafting">
				<div class="search">
					<input placeholder="Search" id="search" size="" v-model="filter">
				</div>
				<div class="recipes">
					<div
						v-for="(recipe, index) in filteredRecipes" :key="index"
						:class="['recipe', crafting ? isCrafting(recipe.name) ? 'progress' : 'busy' : '']"
						:ref="recipe.name"
						@click.left="beginCrafting(recipe)"
						@click.right.prevent="clearCrafting(recipe)"
					>
						<div class="info">
							<div>
								<span class="title">{{recipe.name}}</span>
								<span class="queued" v-if="isCrafting(recipe.name)"> x{{crafting.quantity || 1}}</span>
							</div>
							<span class="duration" >{{(recipe.duration / 1000.0).toFixed(0)}}s</span>
						</div>
						<div v-if="recipe.input" class="items input">
							<item
								v-for="(input, index) in recipe.input" :key="index"
								:durability="input.durability"
								:preview="input.name"
							>{{input.quantity || 1}}</item>
						</div>
						<div v-if="recipe.output" class="items output">
							<item
								v-for="(output, index) in recipe.output" :key="index"
								:durability="output.durability"
								:preview="output.name"
							>{{output.quantity || 1}}</item>
							<v-icon class="arrow" name="chevrons-right"></v-icon>
						</div>
					</div>
				</div>
			</div>
		</v-content>
		<v-footer v-if="storage" class="storage">
			<div>
				<item
					v-for="(info, key) in storage"
					:slotId="key"
					:preview="info.name"
					:class="[info.locked ? 'locked' : '']"
					overrideContainer="station"
				>{{info.quantity}}</item>
			</div>
		</v-footer>
	</div>
</template>

<script>
import draggable from "@/mixins/draggable"
import item from "@/components/Item.vue"
import vContent from "@/components/Content.vue"
import vHeader from "@/components/Header.vue"
import vFooter from "@/components/Footer.vue"

export default {
	name: "Container",
	mixins: [ draggable ],
	components: {
		vHeader,
		vContent,
		vFooter,
		item
	},
	data: function() {
		return {
			expanded: true,
			selection: undefined,
			filter: "",
			interval: undefined,
		}
	},
	computed: {
		name: function() {
			return this.$store.state.station
		},
		isSelected: function() {
			return this.selection?.info != undefined
		},
		weight: function() {
			var weight = 0.0
			for (var slotId in this.info.slots) {
				var slot = this.info.slots[slotId]
				if (slot == undefined) continue

				if (slot.weight != undefined) {
					weight += slot.weight
					continue
				}

				var item = this.$store.getters.getItemById(slot.item_id)
				if (item == undefined) continue

				weight += (slot.quantity || 0.0) * (item.weight || 0.0)
			}

			return weight
		},
		recipeGroups: function() {
			return this.$store.state.recipes
		},
		filteredRecipes: function() {
			var recipes = this.recipes
			var filter = this.filter

			if (filter == "") {
				return recipes
			}

			return recipes.filter(function(value) {
				var name = value?.name
				return !name || name.toLowerCase().includes(filter)
			})
		},
		group: function() {
			return this.recipeGroups[this.currentGroup || 0]
		},
		recipes: function() {
			var station = this.$store.state.station
			return this.$store.state.recipes.filter(function(value) {
				return value?.stations.includes(station)
			})
		},
		crafting: function() {
			return this.$store.state.crafting
		},
		storage: function() {
			return this.$store.state.storage
		},
	},
	methods: {
		close: function() {
			this.$post("closeStation")
		},
		minimize: function() {
			this.expanded = false
		},
		maximize: function() {
			this.expanded = true
		},
		isCrafting: function(name) {
			var crafting = this.$store.state.crafting
			return crafting?.name == name
		},
		beginCrafting: function(recipe) {
			// Check busy.
			if (this.crafting && this.crafting.name != recipe.name) {
				return
			}

			// Post event.
			this.$post("beginCrafting", {
				name: recipe.name
			})

			// For testing purposes.
			if (this.$store.state.isDebug) {
				var quantity = this.crafting?.quantity ?? 0;

				this.$store.commit("beginCrafting", {
					name: recipe.name,
					quantity: quantity + 1,
				})

				this.$store.state.storage = recipe.output
			}
		},
		clearCrafting: function(recipe) {
			// Check crafting.
			if (!this.crafting) {
				return
			}

			// Post event.
			this.$post("clearCrafting", {
				name: recipe.name
			})
			
			// For testing purposes.
			if (this.$store.state.isDebug) {
				var quantity = this.crafting?.quantity ?? 0

				if (quantity <= 1) {
					this.$store.commit("clearCrafting")
					return
				}

				this.$store.commit("beginCrafting", {
					name: recipe.name,
					quantity: quantity - 1,
				})
			}
		},
		getItem: function(id) {
			return this.$store.getters.getItemById(id)
		},
	},
	mounted: function() {
		var el = this.$el
		if (el?.style == undefined) return

		var rect = el.getBoundingClientRect()
		
		el.style.left = `2vmin`
		el.style.top = `${document.body.clientHeight / 2 - rect.height / 2}px`

		this.$setFocus(el)
	},
	watch: {
		crafting: function(val, oldVal) {
			if (!val) {
				if (this.interval) {
					clearInterval(this.interval)
					delete this.interval
				}

				if (oldVal) {
					const el = this.$refs[oldVal?.name ?? ""][0]
					el.style.background = "transparent"
				}
			}

			if (this.interval) {
				return
			}

			const name = val?.name
			const el = name && this.$refs[name][0]
			
			const startTime = val?.time
			const recipe = this.$store.state.recipes.find(element => element.name == name)

			if (!recipe) return

			this.interval = setInterval(() => {
				const time = (new Date()).getTime()

				var percent = Math.min(((time - startTime) / recipe.duration) * 100.0, 100.0)
				if (percent > 99.99) {
					clearInterval(this.interval)
					delete this.interval
				}

				el.style.background = `linear-gradient(to right, rgba(50, 230, 50, 0.4), rgba(50, 230, 50, 0.8) ${percent}%, transparent ${percent}%)`
			}, 0)
		}
	}
}
</script>

<style>
.crafting-root .contents {
	max-height: 100%;
	padding: 0px;
}

.crafting-root .craftable {
	font-size: 0.8em;
	font-weight: 700;
	padding-left: 0.25vmin;
}

.crafting {
	display: flex;
	flex-direction: column;
	width: 60vmin;
	height: 57.2vmin;
}

.crafting .recipes {
	width: 100%;
	overflow-x: hidden;
	overflow-y: scroll;
	background: rgba(60, 60, 60, 0.5);
}

.crafting .search {
	position: sticky;
	display: flex;

	width: auto;
	height: auto;
}

.crafting #search {
	width: calc(100% - 1.0vmin);
	padding: 0.5vmin;

	border-radius: 0px;
	border: var(--item-border) solid rgba(0, 0, 0, 0.6);
	border-top: 0px;
}

.recipe {
	position: relative;
	display: flex;
	flex-direction: row;
	align-items: stretch;
	align-content: center;
	justify-content: flex-start;

	width: auto;
	font-size: 0.8em;
	padding: 0.5vmin;

	border-bottom: var(--item-border) solid rgba(0, 0, 0, 0.6);
}

.recipe.busy {
	opacity: 0.3;
}

.recipe .info {
	display: flex;
	flex-direction: column;
	align-items: flex-start;
	justify-content: center;
	padding-left: 1vmin;
	width: 35%;
}

.recipe .item {
	--item-width: 5vmin;
	--item-height: 5vmin;

	flex-shrink: 0;
}

.recipe .queued {
	color: rgba(50, 255, 50, 0.8);
	font-weight: 800;
	font-size: 0.8em;
}

.recipe .title {
	font-weight: 700;
}

.recipe .duration {
	font-size: 0.9em;
}

.recipe .arrow {
	position: absolute;
	color: rgba(255, 255, 255, 0.8);
	margin: 0px;
	padding: 0px;
	left: 0px;
	top: 50%;
	transform: translate(-50%, -50%);
}

.recipe .items {
	position: relative;
	display: flex;
	flex-direction: row;
	flex-wrap: wrap;
	flex-grow: 1;
	max-width: 29.5%;
	border-radius: calc(var(--border-radius) * 0.5);
}

.recipe .items.input {
	background: rgba(150, 100, 50, 0.4);
	border-top-right-radius: 0px;
	border-bottom-right-radius: 0px;
	padding-right: 1vmin;
}

.recipe .items.output {
	background: rgba(50, 100, 150, 0.4);
	border-top-left-radius: 0px;
	border-bottom-left-radius: 0px;
	padding-left: 1vmin;
}

.recipe .items:last-child {
	flex-direction: row-reverse;
}

.recipe:nth-child(2n) {
	background: rgba(50, 50, 50, 0.5);
}

.recipe:hover:not(.busy, .progress) {
	background: var(--primary-color);
}

.storage {
	display: flex;
	justify-content: center;
	align-items: center;
}

.storage > div {
	display: flex;
	flex-direction: row;
	flex-wrap: wrap;
	justify-content: center;
	align-items: center;
	max-width: 50vmin;
}

.storage .item {
	--item-width: 8vmin;
	--item-height: 8vmin;

	flex-shrink: 0;
}

.storage .locked {
	opacity: 0.5;
}

.storage .icon {
	margin-right: 2vmin;
}
</style>