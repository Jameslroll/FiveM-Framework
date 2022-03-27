<template>
	<div>
		<q-list>
			<!-- General Optiosn -->
			<q-expansion-item
				v-for="(option, key) in filteredOptions"
				:key="key"
				expand-separator
				clickable
				separator
				bordered
				:group="'options'"
				:label="option.name"
				:caption="option.caption"
			>
				<q-input
					v-if="option.type == 'edit'"
					:model-value="$getData('options', option.model)"
					@change="$setData('options', option.model, $event == option.default ? null : $event)"
					class="q-pa-sm"
					filled
					dense
					autofocus
				/>
				<q-option-group
					v-if="option.group"
					:options="option.group"
					:model-value="$getData('options', option.model) ?? option.default"
					@update:model-value="$setData('options', option.model, $event)"
				/>
			</q-expansion-item>
		</q-list>
	</div>
</template>

<script>
import { defineComponent } from "vue";

export default defineComponent({
	name: "Options",
	data() {
		return {
			options: [
				{
					model: "background",
					name: "Background",
					caption: "Your home's background image",
					type: "edit",
					default: "",
				},
				{
					model: "size",
					name: "Size",
					caption: "How large your device is",
					group: [
						{ value: 0, label: "Large" },
						{ value: 1, label: "Medium" },
						{ value: 2, label: "Small" },
					],
					default: 0,
				},
				{
					model: "ringtone",
					name: "Ringtone",
					caption: "Which sound to play when receiving calls",
					devices: [ "phone" ],
					group: [
						{ value: 0, label: "Default" },
						{ value: 1, label: "Silent" },
						{ value: 2, label: "Ring 1" },
						{ value: 3, label: "Ring 2" },
						{ value: 4, label: "Ring 3" },
					],
					default: 0,
				},
				{
					model: "notify",
					name: "Notifications",
					caption: "How you receive incoming notifications",
					devices: [ "phone" ],
					icon: "notifications",
					group: [
						{ value: 0, label: "Vibrate" },
						{ value: 1, label: "Sound" },
						{ value: 2, label: "Vibrate & Sound" },
						{ value: 3, label: "Off" },
					],
					default: 0,
				},
			]
		}
	},
	computed: {
		device() {
			return this.$device?.settings?.name
		},
		filteredOptions() {
			return this.options.filter(option => {
				return !option.devices || option.devices.includes(this.device)
			})
		},
	},
	methods: {
	}
})
</script>

<style scoped>
.inner-content {
	display: flex;
	flex-direction: column;
}
</style>