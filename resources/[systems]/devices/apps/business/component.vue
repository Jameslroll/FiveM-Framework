<template>
	<div>
		<q-item
			v-for="job in jobs"
			:key="job.id"
			:class="job.duty ? 'bg-green-3' : ''"
			clickable
			@click="selectJob(job.id)"
		>
			<q-item-section avatar v-if="job.duty">
				<q-icon name="sensors" />
			</q-item-section>
			<q-item-section>
				<q-item-label>{{job.title}}</q-item-label>
				<q-item-label caption v-if="job.name">{{job.name}}</q-item-label>
			</q-item-section>
			<q-item-section side>
				<q-badge v-if="job.rank" :label="job.rank" />
			</q-item-section>
		</q-item>
	</div>
</template>

<script>
export default component({
	data: {
		"jobs": [],
	},
	methods: {
		selectJob(id) {
			this.$emit("setApp", "job", { job: id })
		},
	},
})
</script>

<style>

</style>