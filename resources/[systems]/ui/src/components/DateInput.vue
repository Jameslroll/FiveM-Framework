<template>
	<q-input
		v-bind="info.binds"
		v-model="$parent.model"
		:rules="rules"
		hint="YYYY/MM/DD"
		mask="date"
		fill-mask
	>
		<template v-slot:prepend>
			<q-icon name="event">
				<q-popup-proxy>
					<q-date
						v-model="$parent.model"
						:options="options"
					>
					</q-date>
				</q-popup-proxy>
			</q-icon>
		</template>
	</q-input>
</template>

<script>
export default {
	name: "DateInput",
	props: [ "info" ],
	computed: {
		rules: function() {
			return [ "date", date => ((!this.info.min || date >= this.info.min) && (!this.info.max || date <= this.info.max)) || "Out of range" ]
		},
	},
	methods: {
		options: function(date) {
			if (this.info.min && date < this.info.min) {
				return false
			} else if (this.info.max && date > this.info.max) {
				return false
			}

			return true
		},
	},
}
</script>