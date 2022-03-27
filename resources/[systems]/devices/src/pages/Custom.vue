<template>
	<div>
		<v-runtime-template class="template" :template="template"></v-runtime-template>
	</div>
</template>

<script>
import { defineComponent } from "vue"
import vRuntimeTemplate from "vue3-runtime-template"
import { Quasar, QAvatar, QBadge, QBtn, QBtnDropdown, QBtnGroup, QBtnToggle, QCard, QCardActions, QCardSection, QCarousel, QCarouselControl, QCarouselSlide, QChatMessage, QCheckbox, QChip, QCircularProgress, QColor, QDate, QDialog, QEditor, QExpansionItem, QFab, QFabAction, QField, QForm, QIcon, QImg, QInfiniteScroll, QInnerLoading, QInput, QItem, QItemLabel, QItemSection, QKnob, QLinearProgress, QList, QMarkupTable, QMenu, QOptionGroup, QPagination, QPopupEdit, QPopupProxy, QRadio, QRange, QScrollArea, QSelect, QSeparator, QSlider, QSlideTransition, QSpace, QSpinner, QStep, QStepper, QStepperNavigation, QTab, QTable, QTabPanel, QTabPanels, QTabs, QTd, QTh, QTime, QTimeline, QTimelineEntry, QToggle, QToolbar, QToolbarTitle, QTooltip, QTr, QTree, QVideo } from "quasar"

export default defineComponent({
	name: "Custom",
	props: [
		"device",
		"app",
	],
	components: {
		vRuntimeTemplate,
		Quasar,
		QAvatar,
		QBadge,
		QBtn,
		QBtnDropdown,
		QBtnGroup,
		QBtnToggle,
		QCard,
		QCardActions,
		QCardSection,
		QCarousel,
		QCarouselControl,
		QCarouselSlide,
		QChatMessage,
		QCheckbox,
		QChip,
		QCircularProgress,
		QColor,
		QDate,
		QDialog,
		QEditor,
		QExpansionItem,
		QFab,
		QFabAction,
		QField,
		QForm,
		QIcon,
		QImg,
		QInfiniteScroll,
		QInnerLoading,
		QInput,
		QItem,
		QItemLabel,
		QItemSection,
		QKnob,
		QLinearProgress,
		QList,
		QMarkupTable,
		QMenu,
		QOptionGroup,
		QPagination,
		QPopupEdit,
		QPopupProxy,
		QRadio,
		QRange,
		QScrollArea,
		QSelect,
		QSeparator,
		QSlider,
		QSlideTransition,
		QSpace,
		QSpinner,
		QStep,
		QStepper,
		QStepperNavigation,
		QTab,
		QTable,
		QTabPanel,
		QTabPanels,
		QTabs,
		QTd,
		QTh,
		QTime,
		QTimeline,
		QTimelineEntry,
		QToggle,
		QToolbar,
		QToolbarTitle,
		QTooltip,
		QTr,
		QTree,
		QVideo
	},
	beforeUnmount() {
		var func = this.app?.beforeUnmount
		if (func) {
			func.bind(this)()
		}
	},
	beforeUpdate() {
		var func = this.app?.beforeUpdate
		if (func) {
			func.bind(this)()
		}
	},
	unmounted() {
		var func = this.app?.unmounted
		if (func) {
			func.bind(this)()
		}
	},
	mounted() {
		var func = this.app?.mounted
		if (func) {
			func.bind(this)()
		}
	},
	updated() {
		var func = this.app?.updated
		if (func) {
			func.bind(this)()
		}
	},
	beforeCreate() {
		var app = this.app
		if (!app) return

		var func = this.app?.beforeCreate
		if (func) {
			func.bind(this)()
		}

		var computed = app.computed
		if (computed) {
			for (var key in computed) {
				var func = computed[key]
				var prop = func.bind(this)
	
				this.$options.computed[key] = prop
			}
		}

		var methods = app.methods
		if (methods) {
			for (var key in methods) {
				var func = methods[key].bind(this)

				this[key] = func
				this.$options.methods[key] = func
			}
		}
	},
	created() {
		var func = this.app?.created
		if (func) {
			func.bind(this)()
		}
	},
	data() {
		return {}
	},
	methods: {},
	computed: {
		template() {
			return this.app?.template
		},
	},
})
</script>

<style scoped>
.template {
	position: absolute;
	top: 0%;
	bottom: 0%;
	left: 0%;
	right: 0%;
	width: 100%;
	height: 100%;
}
</style>