<template>
<div class="chat">
	<div class="messages">
		<transition-group name="fade" ref="messages">
			<message
				v-for="message in filteredMessages"
				:key="message.key"
				:message="message"
			></message>
		</transition-group>
	</div>
	<div class="input" v-if="isEnabled">
		<span
			role="textbox"
			class="textbox"
			ref="input"
			contenteditable
			@keypress="onKeyPress"
			@input="onInput"
			@paste="paste"
			tabindex="-1"
		></span>
		<span
			@click="submit"
			class="caret"
		>
			<v-icon name="chevron-right"></v-icon>
		</span>
		<div v-if="suggestions && suggestions.length > 0" class="suggestions">
			<div
				v-for="(suggestion, index) in suggestions"
				:key="suggestion.name"
			>
				<span class="name">{{suggestion.name}}</span>
				<span class="description">{{suggestion.description}}</span>
				<div v-if="index == 0 && suggestion.parameters" class="parameters">
					<div
						v-for="(parameter, _key) in suggestion.parameters"
						:key="_key"
					>
						<div class="name">└{{parameter.name}}</div>
						<div class="description">{{parameter.description}}</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
</template>

<script>
import message from "@/components/Message.vue"

export default {
	name: "App",
	components: {
		message
	},
	data: function() {
		return {
			suggestions: undefined,
			lastSuggestion: undefined,
			historyIndex: 0,
		}
	},
	computed: {
		messages: function() {
			return this.$store.state.messages
		},
		isEnabled: function() {
			return this.$store.state.isEnabled
		},
		filteredMessages: function() {
			var messages = this.messages
			var newMessages = []

			for (var index in messages) {
				var message = messages[index]
				if (this.isEnabled || message.isPreview) {
					newMessages.push(message)
				}
			}

			return newMessages
		},
	},
	methods: {
		submit: function(e) {
			e.preventDefault()

			// Get input.
			var input = this.$refs["input"]
			if (input == undefined) return

			// Get comment.
			var command = input.textContent.replace(/\s+/g, " ")

			// Commit to history.
			this.$store.state.history.push(command)
			this.historyIndex = 0

			// Post message.
			this.$post("submit", { text: command })

			// Reset content.
			input.textContent = ""
		},
		onKeyDown: function(e) {
			if (e.key == "Tab") { // Auto complete.
				// Prevent the input.
				e.preventDefault()

				// Check suggestions.
				if (this.suggestions == undefined) return

				// Get input.
				var input = this.$refs["input"]
				if (input?.style == undefined) return

				// Get first suggestion.
				var suggestion = this.suggestions[0]
				if (suggestion == undefined) return

				// Set input.
				input.textContent = suggestion.name
				input.focus()

				// Move cursor.
				document.execCommand("selectAll", false, null);
				document.getSelection().collapseToEnd();
			} else if (e.key == "ArrowUp") { // History.
				this.restoreHistory(1)
			} else if (e.key == "ArrowDown") { // History.
				this.restoreHistory(-1)
			}
		},
		onKeyPress: function(e) {
			if (e.key == "Enter") {
				this.suggestions = undefined
				this.lastSuggestion = undefined

				this.submit(e)
			}
		},
		onInput: function(e) {
			this.updateSuggestions()
		},
		paste: function(e) {
			e.preventDefault()

			var text = (e.originalEvent || e).clipboardData.getData("text/plain")
			document.execCommand("insertHTML", false, text)
		},
		restoreHistory: function(direction) {
			// Get input.
			var input = this.$refs["input"]
			if (input?.style == undefined) return

			// Get history.
			var history = this.$store.state.history
			var index = Math.min(Math.max((this.historyIndex ?? 0) + direction, 0), history.length)

			// Update history.
			this.historyIndex = index

			// Set input.
			input.textContent = index <= 0 ? "" : history[history.length - index]

			// Move cursor to end.
			this.moveCursorToEnd(input)
		},
		updateSuggestions: function() {
			// Get input.
			var input = this.$refs["input"]
			if (input?.style == undefined) {
				this.suggestions = undefined
				this.lastSuggestion = undefined
				return
			}

			// Get search text.
			var search = (input?.textContent ?? "").toLowerCase().split(/[\s+]/)[0] ?? ""
			var firstChar = search.charAt(0)

			if (!(/[a-zA-Z]/).test(firstChar)) {
				search = search.substring(1)
			}

			if (search == "") {
				this.suggestions = undefined
				this.lastSuggestion = undefined
				return
			}

			// Check last search.
			if (this.lastSuggestion == search) return
			this.lastSuggestion = search

			// Return filtered commands.
			var commands = this.$store.state.commands
			var keys = Object.keys(commands)

			keys = keys.filter((name) => {
				return name.toLowerCase().indexOf(search) != -1
			}).sort((a, b) => {
				return a < b ? -1 : 1
			})

			this.suggestions = Array.from(keys, (name) => commands[name])
		},
		onTab: function() {
			console.log("TAB")
		},
		moveCursorToEnd(el) {
			el.focus()

			setTimeout(() => {
				document.execCommand("selectAll", false, null)
				document.getSelection().collapseToEnd()
			}, 0)
		}
	},
	watch: {
		isEnabled: function(value) {
			if (value) {
				this.$nextTick().then(() => {
					this.$refs["input"]?.focus()
				})
			}
		}
	},
	mounted: function() {
		window.addEventListener("keydown", this.onKeyDown)

		setInterval(() => {
			if (this.$el?.style == undefined) return

			var input = this.$refs["input"]
			if (input?.style == undefined) return

			if (document.activeElement != input) {
				this.moveCursorToEnd(input)
			}
		}, 200)
	},
	updated: function() {
		var el = this.$el
		if (el?.style == undefined) return

		// Update message scroll.
		var messages = this.$refs["messages"]?.$el
		messages.scrollTop = messages.scrollHeight
	},
}
</script>

<style scoped>
.chat {
	position: relative;
	display: block;
}

.messages > span {
	position: relative;
	display: flex;
	flex-direction: column;
	align-items: stretch;

	max-height: 30vmin;

	user-select: none;
	overflow-y: scroll;
	scrollbar-width: none;
}

.input {
	position: relative;
	display: flex;

	justify-content: center;
	align-content: center;
	align-items: center;

	color: white;
	background: rgba(40, 40, 40, 0.8);
	border-radius: var(--border-radius);

	height: auto;
	width: 100%;
	padding: 0px;
	margin: 0px;
	margin-top: 0.5vmin;
}

.caret {
	display: flex;
	justify-content: center;
	align-items: center;
	
	color: rgb(255, 255, 255);
	
	width: 2.5vmin;
	margin: 0.4vmin;
}

.caret .icon {
	width: 100%;
}

.textbox {
	position: relative;

	width: 100%;
	height: auto;
	max-height: 40vh;
	margin: 0px;
	padding: 0.4em;

	border: none;
	outline: none;

	resize: none;
	text-align: left;
	overflow-y: auto;
	scrollbar-width: none;
}

.suggestions {
	display: flex;
	position: absolute;

	flex-direction: column;
	align-items: flex-start;

	width: auto;
	left: var(--border-radius);
	right: var(--border-radius);
	top: 100%;
	max-height: 30vmin;
	
	background: rgba(30, 30, 30, 0.8);
	border-top: 1px solid rgba(80, 80, 80, 0.8);
	border-bottom-left-radius: var(--border-radius);
	border-bottom-right-radius: var(--border-radius);
	
	overflow-y: scroll;
	scrollbar-width: none;
}

.suggestions > div {
	display: block;

	margin-top: 0vmin;
	padding-top: 0.4vmin;
	padding-bottom: 0.4vmin;
	padding-left: 1vmin;
	padding-right: 1vmin;

	user-select: none;
}

.suggestions .name {
	color: rgb(241, 196, 15);
	font-weight: 700;
	margin-right: 1vmin;
}

.suggestions .description {
	font-size: 0.9em;
	margin-right: 0.5vmin;
}

.parameters {
	position: relative;
	display: flex;
	flex-direction: column;
	margin-left: 1vmin;
	margin-top: 0.5vmin;
	font-size: 0.8em;
	opacity: 0.8;
}

.parameters > div {
	position: relative;
	display: flex;
	flex-direction: row;
}

.parameters .name {
	position: relative;
	min-width: 10vmin;
	max-width: 10vmin;
	word-wrap: normal;
	overflow-x: hidden;
}

.parameters .description {
	position: relative;
}

.rainbow {
	background: linear-gradient(90deg, #ff2400, #e81d1d, #e8b71d, #e3e81d, #1de840, #1ddde8, #2b1de8, #dd00f3);
	background-size: 1500% 1500%;
	animation: rainbow 8s alternate ease infinite;
}

@keyframes rainbow {
	0% {
		background-position: 0% 0%;
	}
	100% {
		background-position: 100% 0%;
	}
}
</style>
