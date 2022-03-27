<template>
	<div class="footer" v-if="$parent.expanded">
		<slot></slot>
	</div>
</template>

<script>
export default {
	name: "Header",
}
</script>

<style>
.footer {
	display: flex;
	flex-direction: column;

	position: relative;
	background: rgba(50, 50, 50, 0.8);
	border-top: 1px solid black;

	min-height: 1em;
	padding: 0.5vmin;
}

.footer > div:last-child {
	border-bottom-left-radius: var(--border-radius) !important;
	border-bottom-right-radius: var(--border-radius) !important;
}
</style>