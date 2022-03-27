<template>
	<div style="display: flex; flex-direction: column" v-if="loaded">
		<q-header class="flex flex-center q-pa-sm bg-grey-3 text-black contact-info">
			{{title}}
		</q-header>
		<div class="q-pa-md" id="chat-box" style="max-height: 100%; overflow: auto" v-if="number">
			<q-infinite-scroll
				id="infinite-scroll"
				@load="load"
				scroll-target="#chat-box"
				debounce=1000
				offset=100
				reverse
			>
				<q-chat-message
					v-for="(message, key) in messages"
					:key="key"
					:sent="message.sent"
					:stamp="$root.formatTime(message.time_stamp)"
					:text="[ message.text ]"
					:bg-color="message.error && 'red-2' || !message.sent && 'green-2'"
					size="8"
				>
					<template v-slot:stamp v-if="message.error">
						<div>
							Failed to send
						</div>
					</template>
					<template v-slot:label v-if="displayDate(key)">
						{{$root.formatDate(message.time_stamp)}}
					</template>
				</q-chat-message>
			</q-infinite-scroll>
		</div>
		<div style="flex-grow: 1" />
		<q-separator />
		<q-input
			@change="input"
			@keydown.enter.exact.prevent="send"
			:counter="(text && text.length > 512) || false"
			:model-value="text"
			ref="input"
			class="q-pa-sm"
			label="Message"
			maxlength=1024
			borderless
			dense
			autogrow
			hide-bottom-space
			autofocus
		/>
	</div>
</template>

<script>
export default component({
	data: {
		number: "",
		messages: [],
		text: "",
	},
	computed: {
		contact() {
			var contacts = this.$getData("phone", "contacts")
			if (contacts) {
				return contacts.find(item => item.number == this.number)
			}
		},
		title() {
			return this.contact?.name || this.$root.formatPhoneNumber(this.number)
		},
	},
	watch: {
		
	},
	methods: {
		input(value) {
			this.text = value
		},
		load(index, done) {
			let offset = this.messages.filter(item => !item.error).length

			this.$device.post(
				"LoadMessages",
				this.number,
				offset
			).then(response => {
				let isObj = typeof response == "object"

				if (isObj) {
					if (offset == 0) {
						setTimeout(() => {
							let chatBox = document.querySelector("#chat-box")
							chatBox.scrollTop = chatBox.scrollHeight
						}, 20)
					}

					response.forEach(item => {
						item.sent = item.sent == 1
						this.add(item, true)
					})
				}

				done(isObj && response.length == 0 || response.length < 30)
			})
		},
		add(message, atStart) {
			if (this.messages.find(item => item.id && item.id == message.id)) {
				return
			}

			if (!message.time_stamp) {
				message.time_stamp = Date.now()
			}

			if (atStart) {
				this.messages.unshift(message)
			} else {
				let chatBox = document.querySelector("#chat-box")
				let isScrolled = chatBox.scrollTop + chatBox.clientHeight >= chatBox.scrollHeight - 40
				
				this.messages.push(message)

				this.$nextTick(() => {
					if (isScrolled) {
						chatBox.scrollTop = chatBox.scrollHeight
					}
				})
			}

			return message
		},
		send(e) {
			var text = e?.target?.value
			if (!text) return

			text = text.replace(/[^\S\r\n]+/g, " ").trim()
			if (text == "" || text == " ") return

			this.text = ""
			e.target.value = ""

			this.$device.post("Message", this.number, text).then(response => {
				this.add({
					sent: true,
					text: text,
					time_stamp: Date.now(),
					error: !response
				})
			})
		},
		displayDate(index) {
			var message = this.messages[index]
			if (!message) return false

			var lastMessage = this.messages[index - 1]
			if (!lastMessage) return true

			return this.$root.formatDate(message.time_stamp) != this.$root.formatDate(lastMessage.time_stamp)
		},
	},
})
</script>

<style>
.contact-info {
	user-select: all;
}

.q-message-text-content div:first-child {
	user-select: text;
}
</style>