<template>
	<component
		v-model="model"
		v-if="shouldRender"
		v-bind="info.binds"
		v-on="events"

		:is="info.type || 'div'"
		:info="info"

		:class="info.class"
		:style="info.style"
		:name="info.name"
		
		:selected.sync="selected"
		:options="getOptions()"
		:data="data"
		:rules="rules"
		:loading="isLoading"
	>
		<!-- Inner Templates -->
		<template v-if="info.prepend" v-slot:prepend>
			<node :info="info.prepend"></node>
		</template>
		<template v-if="info.append" v-slot:append>
			<node :info="info.append"></node>
		</template>

		<!-- General Text -->
		<span v-if="info.text">{{info.text}}</span>
		<span v-if="info.html" v-html="info.html"></span>

		<!-- Quasar Components -->
		<q-icon v-if="info.icon" :name="info.icon"></q-icon>
		<q-badge v-if="info.badge" v-bind="info.badge"></q-badge>
		
		<!-- Quasar Tabs -->
		<!--<q-tab-panel
			v-for="tab in info.tabs"
			:key="tab.id"
			:name="tab.name"
		>
			<node :info="tab"></node>
		</q-tab-panel>-->

		<!-- Other Components -->
		<v-runtime-template v-if="info.template" :template="info.template"></v-runtime-template>

		<!-- Child Nodes -->
		<node
			v-for="component in nodes"
			:key="component.id"
			:info="component"
		></node>
	</component>
</template>

<script>
import window from "./Window.vue"
import dateInput from "./DateInput.vue"
import editor from "./Editor.vue"
import nameInput from "./NameInput.vue"
import sliderItem from "./SliderItem.vue"
import vRuntimeTemplate from "v-runtime-template"

export default {
	name: "Node",
	props: [ "info" ],
	components: {
		window,
		dateInput,
		editor,
		nameInput,
		sliderItem,
		vRuntimeTemplate,
	},
	computed: {
		window: function() {
			var parent = this.$parent
			while (parent) {
				if (parent.$options.name == "Window") {
					return parent
				}
				parent = parent.$parent
			}
		},
		nodes: function() {
			let components = []
			for (var id in this.info.components) {
				var component = this.info.components[id]
				if (component) {
					components.push(component)
				}
			}

			return components
		},
		shouldRender: function() {
			if (this.info.condition) {
				return eval(this.info.condition)
			}

			return true
		},
		data: function() {
			return this.info?.binds?.data ?? (this.info?.data && this.$getModel(this.info?.data))
		},
		rules: function() {
			if (!this.info?.rules) {
				return
			}

			var rules = []
			for (var rule of this.info?.rules) {
				rules.push(eval(rule))
			}

			return rules
		},
		isLoading: function() {
			var loadingModel = this.info?.loadingModel
			if (!loadingModel) return false

			return this.$getModel(loadingModel)
		},
		events: function() {
			var funcs = {
				click: e => this.onClick(e),
				submit: e => this.onSubmit(e),
			}
			
			if (this.info?.clicks) {
				for (var type in this.info.clicks) {
					var click = this.info.clicks[type]
					funcs[type] = (e, ...args) => {
						if (click.callback) {
							var func = new Function(click.callback)
							func.call(this, ...args)
						}
					}
				}
			}

			return funcs
		},
		model: {
			get() {
				var model = this.info?.model
				if (!model) return

				return this.$getModel(this.info?.model)
			},
			set(value) {
				this.$setModel(this.info?.model, value)
			},
		},
		selected: {
			get() {
				return this.$getModel(this.info?.model)
			},
			set(value) {
				this.$setModel(this.info?.model, value)
			},
		},
	},
	methods: {
		onClick: function(e, override) {
			var click = override ?? this.info?.click
			if (!click) return

			if (click.event) {
				this.$invoke(click.type ?? "click", click.event)
			}

			if (click.callback) {
				eval(click.callback)
			}
		},
		onSubmit: function() {
			this.$invoke("submit")
		},
		getOptions: function() {
			var options = this.info?.binds?.options
			if (typeof options === "string") {
				options = new Function(options)
			}

			return options
		},
	},
	mounted: function() {
		if (this.info?.type == "q-table") {
			this.$on("row-click", e => {
				console.log(e);
			})
		}
	},
}
</script>