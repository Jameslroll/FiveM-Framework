<template>
	<div style="overflow: hidden; overflow-y: scroll">
		<q-list>
			<q-item
				v-for="(item, key) in messages"
				:key="key"
				@click="message(item.number)"
				clickable
			>
				<q-item-section avatar>
					<q-avatar :color="$colors[item.color ?? 0] ?? 'blue'">
						<q-img :src="item.avatar" v-if="item.avatar" style="object-fit: cover;" />
						<q-item-label v-if="!item.avatar" class="text-white">{{$root.formatName(item.name ?? "")}}</q-item-label>
					</q-avatar>
				</q-item-section>
				<q-item-section>
					<q-item-label class="text-bold">{{item.name ?? $root.formatPhoneNumber(item.number)}}</q-item-label>
					<q-item-label>{{item.text.trim() + (item.text.length == 128 ? "..." : "")}}</q-item-label>
					<q-item-label caption v-if="item.time_stamp">
						<span>{{$root.formatDate(item.time_stamp)}}, {{$root.formatTime(item.time_stamp)}}</span>
					</q-item-label>
				</q-item-section>
			</q-item>
		</q-list>
	</div>
</template>

<script>
export default component({
	data: {
		messages: [],
	},
	methods: {
		message(number) {
			this.$emit("setApp", "dm", { number: number })
		},
		add(number, text) {
			var index = this.messages.findIndex(item => item.number == number)
			var message = index == -1 ? null : this.messages[index]
			var now = Date.now()
			
			if (message) {
				this.messages.splice(index, 1)

				message.time_stamp = now
				message.text = text

				this.messages.unshift(message)
			} else {
				var contacts = this.$getData("phone", "contacts")
				var contact = contacts.find(item => item.number == number)
				
				this.messages.unshift({
					number: number,
					text: text,
					time_stamp: now,
					name: contact && contact.name,
					avatar: contact && contact.avatar,
					color: contact && contact.color,
				})
			}
		},
	},
})
</script>