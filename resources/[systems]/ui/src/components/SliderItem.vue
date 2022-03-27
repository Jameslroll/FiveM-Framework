<template>
	<q-item-section>
		<q-item>
			<q-item-label header>
				{{info.name}}
			</q-item-label>
		</q-item>
		<q-item>
			<q-input
				v-if="info.input"
				v-model="model"
				:rules="[ 'number', val => val > info.slider.min - 0.001 && val < info.slider.max + 0.001 ]"
				class="dense"
				square filled
			/>
			<q-item-section v-if="info.minIcon" side>
				<q-icon
					:name="info.minIcon"
					@click="stepValue(-1)"
				/>
			</q-item-section>
			<q-item-section>
				<q-slider
					v-model="model"
					v-bind="info.slider"
				/>
			</q-item-section>
			<q-item-section v-if="info.maxIcon" side>
				<q-icon
					:name="info.maxIcon"
					@click="stepValue(1)"
				/>
			</q-item-section>
			<q-item-section v-if="info.secondary" style="padding-left: 20px; max-width: 20%">
				<q-slider
					v-model="secondaryModel"
					v-bind="info.secondary"
				/>
			</q-item-section>
		</q-item>
	</q-item-section>
</template>

<script>
export default {
	name: "SliderItem",
	props: [ "info" ],
	computed: {
		window: function() {
			return this.$parent?.window
		},
		value: function() {
			return this.$parent?.value
		},
		model: {
			get() {
				return this.$getModel(this.info?.slider?.model) ?? this.info?.slider?.default
			},
			set(value) {
				this.$setModel(this.info?.slider?.model, value)
			},
		},
		secondaryModel: {
			get() {
				return this.$getModel(this.info?.secondary?.model) ?? this.info?.secondary?.default
			},
			set(value) {
				this.$setModel(this.info?.secondary?.model, value)
			},
		},
	},
	methods: {
		onInput: function(value, e) {
			value = parseFloat(value)
			if (!value) {
				return
			}

			var step = this.info?.slider?.step
			if (step) {
				value = Math.round(value / step) * step
			}

			this.$parent?.onInput(value)
		},
		stepValue: function(value) {
			this.model = Math.max(Math.min(this.model + value * (this.info?.step ?? 1), this.info.slider?.max ?? 0), this.info.slider?.min ?? 1)
		}
	},
}
</script>

<style scoped>
.q-item {
	overflow: visible;
	align-items: center;
	padding: 0px;
	height: 50px;
}

.q-field {
	padding-bottom: 0px;
}

.q-input {
	padding-right: 2vmin;
	width: 20%;
	min-width: 10vmin;
}

.q-item {
	height: auto;
	min-height: 0px;
}

.q-item__label {
	padding: 0px !important;
	padding-top: 6px !important;
	padding-bottom: 2px !important;
	margin: 0px !important;
}

.q-item__section {
	margin: 0px !important;
}
</style>