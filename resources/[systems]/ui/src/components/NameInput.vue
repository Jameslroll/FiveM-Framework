<template>
	<q-input
		v-bind="info.binds"
		v-model="model"
		:rules="[ checkName ]"
		type="text"
		lazy-rules
	>
		<template v-slot:prepend v-if="info.icon">
			<q-icon :name="info.icon"></q-icon>
		</template>
	</q-input>
</template>

<script>
export default {
	name: "DateInput",
	props: [ "info" ],
	computed: {
		model: {
			get() {
				return this.$parent.model
			},
			set(value) {
				if (value) {
					value = value.replace(/(^\w)(.+)?/g, (_, start, end) => {
						if (end == undefined) {
							return start.toUpperCase()
						} else {
							return start.toUpperCase() + end.toLowerCase()
						}
					})
				}
				
				this.$parent.model = value
			},
		},
	},
	methods: {
		checkName: function(name) {
			// Check undefined.
			if (!name) {
				return "No name"
			}

			// Check length.
			var length = name.length
			if (length < 3) {
				return "Too short"
			} else if (length > 32) {
				return "Too long"
			}

			// Check characters.
			if (name.match(/[^A-Za-z]+/g)) {
				return "Must only contain letters"
			}
		},
	},
}
</script>