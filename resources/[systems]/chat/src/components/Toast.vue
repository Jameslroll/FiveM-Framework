<template>
	<div :class="['toast', toast.class ? toast.class : '']">
		<span>{{toast.text}}</span>
		<div class="progress" ref="progress"></div>
	</div>
</template>

<script>
export default {
	name: "App",
	props: [ "toast" ],
	mounted: function() {
		var progressBar = this.$refs["progress"]
		progressBar.style.animationDuration = `${this.toast?.duration ?? 7000}ms`
	},
}
</script>

<style scoped>
.toast {
	position: relative;

	color: white;
	background: rgba(0, 0, 0, 0.8);

	border-radius: var(--border-radius);
	overflow: hidden;

	margin-right: 0.5vmin;
	margin-bottom: 0.5vmin;

	padding: 0.5vmin;
	padding-left: 1.0vmin;
	padding-right: 1.0vmin;
}

.progress {
	position: absolute;
	display: block;

	background: rgb(50, 200, 255);

	height: 2px;
	bottom: 0px;
	left: 0px;
	right: 0px;
	width: auto;

	animation-name: progress-bar;
	animation-timing-function: linear;
}

.success {
	color: white;
	background: #3498db;
}

.error {
	color: white;
	background: #e74c3c;
}

.inform {
	color: white;
	background: #e67e22;
}

@keyframes progress-bar {
	0% {
		right: 100%;
	}
	100% {
		right: 0%;
	}
}
</style>
