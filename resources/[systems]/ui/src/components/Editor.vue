<template>
	<ace-editor
		@init="init"

		v-model="$parent.model"
		v-bind="info.binds"

		:options="info.options"
		:commands="[
			{
				name: 'save',
				bindKey: { win: 'Ctrl-s', mac: 'Command-s' },
				exec: onExec,
				readOnly: true,
			},
		]"
	></ace-editor>
</template>

<script>
import aceEditor from "vuejs-ace-editor"

export default {
	name: "Editor",
	props: [ "info" ],
	components: {
		aceEditor,
	},
	methods: {
		init: function() {
			require("brace/ext/language_tools")
			require("brace/mode/html")
			require("brace/mode/javascript")
			require("brace/mode/lua")
			require("brace/mode/less")
			require("brace/theme/monokai")
			require("brace/snippets/javascript")
			require("brace/snippets/lua")
		},
		onExec: function() {
			this.$post("saveEditor", {
				id: this.$window?.info?.id,
				code: this.$getModel(this.info?.model),
			}, this.$window?.info?.resource)
		},
	},
}
</script>