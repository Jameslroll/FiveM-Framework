<template>
	<div class="contents" v-if="$parent.expanded != false">
		<slot></slot>
	</div>
</template>

<script>
export default {
	name: "Content",
}
</script>

<style scoped>
.contents {
	display: flex;
	position: relative;
	background: rgba(50, 50, 50, 0.9);

	flex-direction: column;
	flex-wrap: nowrap;
	align-content: flex-start;

	overflow-x: hidden;
	overflow-y: auto;
}

.contents > button {
	padding: 4px;
	margin: 2px;
}

.row {
	display: flex;
	flex-direction: row;
	flex-wrap: nowrap;
	padding: 0px;
	margin: 0px;
}

.col {
	display: flex;
	flex-direction: column;
	flex-wrap: nowrap;
	padding: 0px;
	margin: 0px;
}
</style>