<template>
	<div>
		<!-- <div class="spacer" /> -->
		<!-- Tabs -->
		<q-card square class="tab-content">
			<q-tab-panels
				v-model="tab"
				animated
				style="height: 100%"
			>
				<!-- Keypad -->
				<q-tab-panel name="keypad" align="center" class="keypad-container q-pa-none q-pt-sm q-pb-sm">
					<q-separator spaced />
					<q-item class="input">
						<q-item-section side>
							<q-btn
								size="1.2vmin"
								class="q-ma-none"
								round
								flat
								icon="add_circle"
								@click="addContact('keypad')"
							/>
						</q-item-section>
						<q-item-section>{{formattedNumber}}</q-item-section>
						<q-item-section side>
							<q-btn
								size="1.2vmin"
								class="q-ma-none"
								round
								flat
								icon="backspace"
								@click="backspace"
							/>
						</q-item-section>
					</q-item>
					<q-separator spaced />
					<div class="keypad q-ma-sm">
						<q-btn
							v-for="key in keypad"
							:key="key"
							@click="enterKeypad(key)"
							@mousedown="startBeep(key)"
							@mouseup="stopBeep"
							@mouseleave="stopBeep"
							flat
							class="text-primary"
						>{{key}}</q-btn>
					</div>
					<div class="q-ma-sm">
						<q-btn
							@click="call"
							class="text-white bg-green"
							icon="call"
							flat
							round
						/>
					</div>
					<q-inner-loading
						:showing="isCalling"
					/>
				</q-tab-panel>
				<!-- Contacts -->
				<q-tab-panel name="contacts" class="q-pa-none">
					<q-item
						style="flex-grow: 1"
						@click="addContact"
						clickable
						v-ripple
						dense
					>
						<q-item-section avatar>
							<q-icon name="person" />
						</q-item-section>
						<q-item-section>
							<q-item-label class="text-bold">New Contact</q-item-label>
						</q-item-section>
					</q-item>
					<q-item
						style="flex-grow: 1"
						clickable
						v-ripple
						v-if="number"
						@click="$copyToClipboard(number)"
					>
						<q-item-section avatar>
							<q-icon name="copy_all" />
						</q-item-section>
						<q-item-section>
							<q-item-label>My Number</q-item-label>
							<q-item-label caption>{{$root.formatPhoneNumber(number)}}</q-item-label>
						</q-item-section>
					</q-item>
					<q-list
						v-for="(group, key) in contactGroups"
						:key="key"
					>
						<q-item>
							<q-item-section side caption>
								{{group.letter}}
							</q-item-section>
						</q-item>
						<q-expansion-item
							v-for="(contact, _key) in group.contacts"
							:key="contact.number"
							@click.right.ctrl.prevent="call(contact.number)"
							@click.right.alt.prevent="message(contact.number)"
							@click.right.exact.prevent="addContact(contact)"
							group="contacts"
							expand-separator
						>
							<template v-slot:header>
								<q-item-section avatar>
									<q-avatar :color="$colors[contact.color ?? 0] ?? 'blue'">
										<q-img :src="contact.avatar" v-if="contact.avatar" style="object-fit: cover;" />
										<q-item-label v-if="!contact.avatar" class="text-white">{{$root.formatName(contact.name)}}</q-item-label>
										<q-badge v-if="contact.unread" rounded floating color="red">{{contact.unread}}</q-badge>
									</q-avatar>
								</q-item-section>
								<q-item-section>
									<q-item-label>{{contact.name}}</q-item-label>
									<q-item-label caption>{{$root.formatPhoneNumber(contact.number)}}</q-item-label>
								</q-item-section>
							</template>
							<div class="row justify-between text-grey-8 q-pa-sm">
								<q-btn
									flat dense
									label="Call" icon="call"
									@click="call(contact.number)"
								/>
								<q-btn
									flat dense
									label="Message" icon="message"
									@click="message(contact.number)"
								/>
								<q-btn
									flat dense
									label="Edit" icon="edit"
									@click="addContact(contact)"
								/>
								<q-btn
									flat dense
									label="Favorite" icon="star"
									:color="contact.favorite ? 'orange' : 'grey'"
									@click="favorite(contact)"
								/>
							</div>
						</q-expansion-item>
					</q-list>
					<q-inner-loading
						:showing="$getData(this.app.id, 'isLoading')"
					/>
				</q-tab-panel>
				<!-- Recents -->
				<q-tab-panel name="recents" class="q-pa-none">
					<q-infinite-scroll
						ref="scrollRecents"
						@load="loadRecents"
						debounce=1000
					>
						<q-item
							v-for="(item, index) in recents"
							:key="index"
						>
							<q-item-section avatar>
								<q-avatar :color="$colors[item.color ?? 0] ?? 'blue'">
									<q-img :src="item.avatar" v-if="item.avatar" style="object-fit: cover;" />
									<q-item-label v-if="!item.avatar" class="text-white">{{$root.formatName(item.name)}}</q-item-label>
								</q-avatar>
							</q-item-section>
							<q-item-section clickable>
								<q-item-label v-if="item.name">{{item.name}}</q-item-label>
								<q-item-label caption v-if="item.time_stamp">
									<q-icon :color="item.duration ? 'blue' : 'red'" :name="
										(!item.duration && (item.direction && 'call_missed_outgoing' || 'call_missed')) ||
										(item.direction && 'call_made' || 'call_received')
									" />
									<span style="margin-left: 4px">{{$root.formatDate(item.time_stamp)}}, {{$root.formatTime(item.time_stamp)}}</span>
								</q-item-label>
								<q-item-label caption v-if="item.duration">
									Lasted {{item.duration}} seconds
								</q-item-label>
								<q-item-label style="user-select: all" caption>{{$root.formatPhoneNumber(item.number)}}</q-item-label>
							</q-item-section>
							<q-item-section side>
								<div class="text-grey-8 q-gutter-xs">
									<q-btn flat dense round icon="add" @click="addContact(item)" />
									<q-btn flat dense round icon="call" @click="call(item.number)" />
									<q-btn flat dense round icon="message" @click="message(item.number)" />
								</div>
							</q-item-section>
						</q-item>
						<template v-slot:loading>
							<div class="row justify-center q-my-md">
								<q-spinner-dots color="primary" size="32px" />
							</div>
						</template>
					</q-infinite-scroll>
				</q-tab-panel>
			</q-tab-panels>
		</q-card>
		<!-- Navigation -->
		<q-card square>
			<q-tabs
				@update:model-value="updateTab"
				v-model="tab"
				align="justify"
				active-color="primary"
				indicator-color="transparent"
				dense
			>
				<q-tab name="keypad" label="Keypad" />
				<q-tab name="contacts" label="Contacts" />
				<q-tab name="recents" label="Recents" />
			</q-tabs>
		</q-card>
	</div>
</template>

<script>
import { defineComponent } from "vue"

export default defineComponent({
	name: "Phone",
	props: [
		"app",
	],
	data() {
		return {
			context: null,
			tab: "keypad",
			keypad: [ "1", "2", "3", "4", "5", "6", "7", "8", "9", "*", "0", "#" ],
			dial: "",
			number: "",
			isCalling: false,
			recents: [],
			tones: {
					"*": [ 941, 1209 ],
					"#": [ 925, 1111 ],
					"0": [ 941, 1336 ],
					"1": [ 697, 1209 ],
					"2": [ 697, 1336 ],
					"3": [ 697, 1477 ],
					"4": [ 770, 1209 ],
					"5": [ 770, 1336 ],
					"6": [ 770, 1477 ],
					"7": [ 852, 1209 ],
					"8": [ 852, 1336 ],
					"9": [ 852, 1477 ],
			},
		}
	},
	mounted() {
		document.addEventListener("keydown", this.keyPress)

		this.context = new (window.AudioContext || window.webkitAudioContext || window.mozAudioContext)()
		this.resetRecents()
	},
	beforeUnmount() {
		document.removeEventListener("keydown", this.keyPress)
	},
	computed: {
		now() {
			return Date.now()
		},
		formattedNumber() {
			return this.$root.formatPhoneNumber(this.dial)
		},
		contactGroups() {
			let contacts = this.$getData(this.app.id, "contacts")
			if (!contacts) return

			let groups = []
			let indexes = {}

			contacts.forEach(contact => {
				let letter = contact.favorite ? "Favorites" : contact.name.substring(0, 1)
				let index = indexes[letter]
				let group = index !== undefined && groups[index]

				if (!group) {
					group = {
						contacts: [],
						letter: letter,
					}

					indexes[letter] = groups.length
					groups.push(group)
				}

				group.contacts.push(contact)
			})

			for (let group of groups) {
				group.contacts.sort((a, b) => (a.name ?? "") > (b.name ?? "") ? 1 : -1)
			}

			groups.sort((a, b) => (a.letter == "Favorites" ? "*" : a.letter ?? "") > (b.letter == "Favorites" ? "*" : b.letter ?? "") ? 1 : -1)

			return groups
		},
	},
	methods: {
		updateTab(value) {
			this.resetRecents()
		},
		call(number) {
			if (this.isCalling) return
			
			this.isCalling = true
			this.$device.post("Call", typeof number == "string" ? number : this.dial).then(response => this.isCalling = false)
		},
		message(number) {
			this.$emit("setApp", "dm", { number: typeof number == "string" ? number : this.dial })
		},
		enterKeypad(key, shouldBeep) {
			if (isNaN(parseInt(key)) && key != "#" && key != "*") return

			let number = this.dial

			if (key == -1) {
				number = number.substring(0, number.length - 1)
			} else {
				number += key
			}

			if (number.length > 10) {
				number = number.substring(1, 11)
			}

			this.dial = number

			if (shouldBeep) {
				if (this.beepTimeout) {
					clearInterval(this.beepTimeout)

					this.beepTimeout = null
					this.stopBeep()
				}

				this.startBeep(key)

				this.beepTimeout = setTimeout(() => {
					this.beepTimeout = null
					this.stopBeep()
				}, 200 + Math.random() * 50.0);
			}
		},
		backspace() {
			this.dial = this.dial.substring(0, this.dial.length - 1)
		},
		keyPress(e) {
			if (e.key == "Backspace") {
				this.enterKeypad(-1)
				return
			}

			const number = parseInt(e.key)
			if (isNaN(number)) return

			this.enterKeypad(number, true)
		},
		startBeep(key) {
			if (key == undefined || !this.context) return

			let [freq1, freq2] = this.tones[key]
			let volume = 0.02

			this.oscillator1 = this.context.createOscillator()
			this.oscillator1.frequency.value = freq1

			this.gainNode = this.context.createGain ? this.context.createGain() : this.context.createGainNode()
			this.oscillator1.connect(this.gainNode, 0, 0)

			this.gainNode.connect(this.context.destination)
			this.gainNode.gain.value = volume
			
			this.oscillator2 = this.context.createOscillator()
			this.oscillator2.frequency.value = freq2

			this.gainNode = this.context.createGain ? this.context.createGain() : this.context.createGainNode()
			this.oscillator2.connect(this.gainNode)

			this.gainNode.connect(this.context.destination)
			this.gainNode.gain.value = volume

			this.oscillator1.start ? this.oscillator1.start(0) : this.oscillator1.noteOn(0)
			this.oscillator2.start ? this.oscillator2.start(0) : this.oscillator2.noteOn(0)
		},
		stopBeep() {
			if (this.oscillator1) {
				this.oscillator1.disconnect()
			}

			if (this.oscillator2) {
				this.oscillator2.disconnect()
			}
		},
		favorite(contact) {
			var value = !contact.favorite

			this.$device.post("FavoriteContact", contact.number, value).then(response => contact.favorite = value)
		},
		addContact(contact) {
			if (contact == "keypad") {
				var number = this.dial
				var contacts = this.$getData(this.app.id, "contacts")
				
				contact = contacts && contacts.find(_contact => _contact.number == number) || { number: number }
			}

			this.$emit("setApp", {
				id: "contact",
				name: "Add Contact",
				theme: "blue",
				component: "Contact",
			}, {
				avatar: contact?.avatar,
				color: contact?.color,
				name: contact?.name,
				notes: contact?.notes,
				number: contact?.number,
			})
		},
		loadRecents(index, done) {
			index = this.recents.length + 1

			if (this.$isDebug) {
				var contact = this.$getData('phone', 'contacts')[index - 1]
				if (contact) {
					contact.direction = Math.random() > 0.5
					contact.duration = Math.random() > 0.5 ? 0 : Math.ceil(Math.random() * 300)
					contact.time_stamp = 1642187036*1000 - Math.ceil(Math.random() * 864000)*1000

					this.recents.push(contact)
				}
				done(!contact)
			}

			console.log("load recents", index)

			this.$device.post("LoadRecentCalls", index).then(response => {
				var isObj = typeof response == "object"
				
				if (isObj) {
					response.forEach(item => {
						this.recents.push(item)
					})
				}
				
				done(isObj && response.length == 0)
			})
		},
		resetRecents() {
			var scrollRecents = this.$refs["scrollRecents"]
			if (scrollRecents) {
				scrollRecents.reset()
			}

			this.recents = []
		},
	},
})
</script>

<style scoped>
.inner-content {
	position: relative;
	display: flex;
	flex-direction: column;
}

.tab-content {
	flex-grow: 1;
	overflow-y: auto;
}

.spacer {
	flex-grow: 1;
}

.input {
	font-size: 1.6em;
}

.keypad-container {
	display: flex;
	flex-direction: column;
	justify-content: flex-end;
}

.keypad {
	display: flex;
	flex-direction: row;
	flex-wrap: wrap;
	font-size: 1.8em;
}

.keypad .q-btn {
	width: 33%;
}

.keypad .q-btn:nth-child(10), .q-btn:nth-child(12) {
	color: rgb(120, 120, 120) !important;
}
</style>