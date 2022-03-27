<template>
	<div class="header">
		<span v-if="$parent.name" style="pointer-events: none">{{$parent.name}}</span>
		<div>
			<div v-if="$parent.close" v-on:click="$parent.close"><v-icon name="x"></v-icon></div>
			<div v-if="$parent.minimize && $parent.expanded" v-on:click="$parent.minimize"><v-icon name="chevron-up"></v-icon></div>
			<div v-if="$parent.maximize && !$parent.expanded" v-on:click="$parent.maximize"><v-icon name="chevron-down"></v-icon></div>
			<span v-if="$parent.info && $parent.info.id" style="opacity: 0.5; margin-left: 1vmin">{{$parent.info.id}}</span>
			<slot></slot>
		</div>
	</div>
</template>

<script>
export default {
	name: "Header",
	props: [ "expanded" ],
}
</script>

<style>
.header {
	display: flex;
	justify-content: space-between;
	align-items: center;

	position: relative;
	background: rgba(50, 50, 50, 0.8);
	border-bottom: 1px solid black;

	font-size: 0.8em;
	padding: 0.3vmin;
	padding-left: 0.5vmin;
	padding-right: 0.5vmin;
}

.header > div {
	position: relative;
	display: flex;

	align-items: center;
	flex-direction: row-reverse;
}

.icon {
	width: 2vmin;
	height: 2vmin;
	margin-left: 0.5vmin;
}
</style>