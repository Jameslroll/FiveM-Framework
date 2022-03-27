<template>
	<div>
		<q-form
			class="q-pa-sm q-gutter-sm"
			@submit="save"
			@reset="reset"
			greedy
		>
			<q-expansion-item
				label="Info"
				dense
				default-opened
			>
				<div class="q-gutter-sm q-pa-sm">
					<q-input
						v-model="name"
						label="Name"
						filled
						dense
						lazy-rules
						hide-bottom-space
						maxlength=32
						:counter="(name && name.length > 16) || false"
						:rules="[ val => val && val.length > 0 || 'Name required' ]"
					>
						<template v-slot:prepend>
							<q-icon name="person" size="small" />
						</template>
					</q-input>
					<q-input
						v-model="number"
						label="Phone"
						mask="(###) ### - ####"
						unmasked-value
						filled
						dense
						fill-mask
						lazy-rules
						hide-bottom-space
						:rules="[ val => val && val.match(/\d+/g) || 'Number required' ]"
					>
						<template v-slot:prepend>
							<q-icon name="phone" size="small" />
						</template>
					</q-input>
					<q-input
						v-model="notes"
						label="Notes"
						filled
						dense
						autogrow
						hide-bottom-space
						maxlength=255
						:counter="(notes && notes.length > 128) || false"
					/>
				</div>
			</q-expansion-item>
			<q-expansion-item
				label="Avatar"
				dense
			>
				<div class="q-gutter-sm q-pa-sm">
					<q-input
						v-model="avatar"
						label="Icon"
						filled
						dense
						hide-bottom-space
						maxlength=1024
						:counter="(avatar && avatar.length > 1024) || false"
					>
						<template v-slot:before>
							<q-avatar :color="$colors[color] ?? 'blue'">
								<q-img :src="avatar" v-if="avatar" style="object-fit: cover;" />
								<q-item-label v-if="!avatar" class="text-white">{{$root.formatName(name ?? '')}}</q-item-label>
							</q-avatar>
						</template>
					</q-input>
					<q-item-label class="q-ma-sm">Color</q-item-label>
					<div class="colors">
						<q-avatar
							v-for="(_color, key) in $colors"
							:key="key"
							:color="_color"
							style="width: 4vmin; height: 4vmin; border-radius: 100%; margin: 2px"
							clickable
							@click="color = key"
						>
							<q-icon v-if="key == color" color="white" name="check" />
						</q-avatar>
					</div>
				</div>
			</q-expansion-item>
			<q-separator spaced />
			<div style="display: flex">
				<q-btn label="Save" type="submit" color="primary"/>
				<q-btn label="Reset" type="reset" color="primary" flat class="q-ml-sm" />
				<div style="flex-grow: 1" />
				<q-btn label="Remove" @click="remove" color="red" flat class="q-ml-sm" />
			</div>
		</q-form>
	</div>
</template>

<script>
import { defineComponent } from "vue"

export default defineComponent({
	name: "Contact",
	props: [
		"device",
		"app",
	],
	data() {
		return {
			avatar: "",
			number: "",
			name: "",
			notes: "",
			color: 0,
		}
	},
	methods: {
		save() {
			if (this.number == "") return

			this.$device.post("SaveContact", {
				avatar: this.avatar,
				color: this.color,
				name: this.name,
				notes: this.notes,
				number: this.number,
			}).then(response => this.$emit("goBack"))
		},
		reset() {
			this.avatar = ""
			this.color = 0
			this.name = ""
			this.notes = ""
			this.number = ""
		},
		remove() {
			if (this.number == "") return

			this.$device.post("DeleteContact", this.number).then(response => this.$emit("goBack"))
		},
	},
	computed: {},
})
</script>

<style scoped>
.colors {
	display: flex;
	flex-direction: row;
	flex-wrap: wrap;
	justify-content: center;
	padding-top: 4px;
}
</style>