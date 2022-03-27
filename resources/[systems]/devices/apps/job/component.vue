<template>
	<div v-if="info" class="q-pa-sm scroll">
		<div class="text-h6">{{info.Name}}</div>
		<div class="text-bold">{{info.Title}}</div>
		<div class="text-subtitle" v-if="info.Description">{{info.Description}}</div>
		<!-- Selection -->
		<q-card v-if="selection" class="q-mt-sm">
			<q-card-section>
				<q-inner-section>
					<q-badge :class="getStatusClass(selection.status) + ' q-mb-sm'" :label="selection.status" />
					<q-item-label class="text-bold">{{selection.name}}</q-item-label>
					<q-item-label>
						<span>{{selection.rank}}</span>
					</q-item-label>
					
					<q-item-label style="user-select: all">
						{{$root.formatPhoneNumber(selection.phoneNumber)}}
					</q-item-label>

					<q-expansion-item
						v-if="flags && flags.length > 0"
						header-class="bg-green-2"
						expand-separator
						label="Flags"
						class="q-mt-md"
						dense
					>
						<q-table
							:rows="flags"
							:columns="flagColumns"
							:rows-per-page-options="[ -1 ]"
							v-model:selected="flagSelection"
							row-key="name"
							selection="multiple"
							dense flat
							hide-footer
							hide-header
							hide-selected-banner
							hide-no-data
							hide-pagination
						/>
					</q-expansion-item>

					<q-expansion-item
						v-if="selection.times && selection.times.length > 0"
						header-class="bg-green-2"
						expand-separator
						label="Times"
						dense
					>
						<q-table
							:rows="selection.times"
							:columns="timeColumns"
							:rows-per-page-options="[ -1 ]"
							row-key="rank"
							dense flat
							hide-footer
							hide-no-data
							hide-pagination
						/>
					</q-expansion-item>

					<q-expansion-item
						v-if="$isTablet() && selection.history && selection.history.length > 0"
						header-class="bg-green-2"
						expand-separator
						label="History"
						dense
					>
						<q-table
							:rows="selection.history"
							:columns="historyColumns"
							:rows-per-page-options="[ -1 ]"
							row-key="start_time"
							dense flat
							hide-footer
							hide-no-data
							hide-pagination
						>
							<template v-slot:body="props">
								<q-tr
									:props="props"
									:class="props.row.was_cached && 'bg-grey-3'"
								>
									<q-td>
										{{$root.formatDate(props.row.start_time)}} {{$root.formatTime(props.row.start_time)}}
									</q-td>
									<q-td>
										<span v-if="props.row.end_time">
											{{$root.formatDate(props.row.end_time)}} {{$root.formatTime(props.row.end_time)}}
										</span>
										<span v-else>
											N/A
										</span>
									</q-td>
									<q-td>
										{{formatDuration(props.row.end_time - props.row.start_time)}}
									</q-td>
								</q-tr>
							</template>
						</q-table>
					</q-expansion-item>
				</q-inner-section>
			</q-card-section>
			<q-separator v-if="hasActions" />
			<q-card-actions v-if="hasActions">
				<q-btn-dropdown
					v-if="permissions.CAN_SET_USER_STATUS"
					color="primary"
					label="Status"
					menu-self="top left"
					menu-anchor="top left"
					dense flat
					auto-close
				>
					<q-list dense separator>
						<q-item
							v-for="(status, key) in statuses"
							:key="key"
							@click="updateUser('Status', status)"
							clickable
						>
							<q-item-section>
								<q-item-label>{{status}}</q-item-label>
							</q-item-section>
						</q-item>
					</q-list>
				</q-btn-dropdown>
				<q-btn-dropdown
					v-if="permissions.CAN_SET_USER_STATUS"
					color="primary"
					label="Rank"
					menu-self="top left"
					menu-anchor="top left"
					dense flat
					auto-close
					:disable="isSelf"
				>
					<q-list dense separator>
						<q-item
							v-for="(rank, key) in ranks"
							:key="key"
							@click="updateUser('Rank', rank)"
							clickable
						>
							<q-item-section>
								<q-item-label>{{rank}}</q-item-label>
							</q-item-section>
						</q-item>
					</q-list>
				</q-btn-dropdown>
			</q-card-actions>
		</q-card>
		<!-- Roster -->
		<q-table
			class="q-mt-sm"
			row-key="id"
			:rows="rosterData"
			:columns="rosterColumns"
			:loading="rosterData.length == 0"
			:rows-per-page-options="[ -1 ]"
			:filter="rosterFilter"
			:filter-method="rosterFilterMethod"
			separator="cell"
			dense
			hide-footer
		>
			<template v-slot:top>
				<q-input
					:model-value="rosterFilter"
					@change="searchRoster"
					style="width: 100%"
					placeholder="Search"
					borderless
					dense
				>
					<template v-slot:append>
						<q-icon name="search" />
					</template>
				</q-input>
			</template>
			<template v-slot:body="props">
				<q-tr :props="props">
					<q-td
						v-for="(column, key) in rosterColumns"
						:key="key"
						:class="
							(column.field == 'status' && getStatusClass(props.row.status)) ||
							(props.row.id == selfId && 'bg-yellow-3') ||
							(props.row.id == selection?.id && 'bg-grey-3')
						"
						@click="selectUser(props.row)"
					>
						<div>
							<q-badge v-if="column.field == 'name' && props.row.fields?.callsign" class="q-mr-sm">
								{{props.row.fields.callsign}}
							</q-badge>
							<span v-if="column.format">
								{{column.format(props.row[column.field], props.row)}}
							</span>
							<span v-else>
								{{props.row[column.field]}}
							</span>
						</div>
					</q-td>
				</q-tr>
			</template>
		</q-table>
	</div>
</template>

<script>
export default component({
	data: {
		selection: null,
		selfId: null,
		job: null,
		info: null,

		rosterFilter: "",
		rosterData: [],

		rank: {},
		permissions: {},
		statuses: [ "Active", "Semi-active", "Inactive", "LOA", "ICU" ],

		flags: [],
		flagSelection: [],
		flagColumns: [
			{
				name: "name",
				align: "left",
				label: "Name",
				field: "name",
			},
		],

		historyColumns: [
			{
				name: "startTime",
				align: "left",
				label: "Start",
				field: "start_time",
			},
			{
				name: "endTime",
				align: "left",
				label: "End",
				field: "end_time",
			},
			{
				name: "duration",
				align: "left",
				label: "Duration",
				field: "duration",
			},
		],

		timeColumns: [
			{
				name: "rank",
				align: "left",
				label: "Rank",
				field: "rank",
				classes: (row) => row.class,
			},
			{
				name: "time",
				align: "right",
				label: "Hours",
				field: "time",
				format: (val, row) => `${(val / 36e5).toFixed(2)} hours`,
				classes: (row) => row.class,
			}
		],
	},
	computed: {
		rosterColumns() {
			var columns = [
				{
					name: "status",
					label: "Status",
					field: "status",
					align: "left",
					sortable: true,
					headerStyle: "width: 50px",
					style: "width: 50px",
				},
				{
					name: "name",
					label: "Name",
					field: "name",
					align: "left",
					sortable: true,
					headerStyle: "width: 50px",
					style: "width: 50px",
				},
				{
					name: "rank",
					label: "Rank",
					field: "rank",
					align: "left",
					sortable: true,
				},
			]

			if (this.$isTablet()) {
				let formatTime = (val, row) => {
					var date = new Date(val)
					var str = date.toISOString()

					return `${str.substring(0, 10)} ${str.substring(11, 16)}`
				}

				columns.push({
					name: "hired",
					label: "Hired",
					field: "join_time",
					align: "left",
					sortable: true,
					format: formatTime,
				})

				columns.push({
					name: "timeInService",
					label: "Time In Service",
					field: "join_time",
					align: "left",
					sortable: true,
					format: (val, row) => {
						return `${((Date.now() - row.join_time) / 864e5).toFixed(0)} days`
					},
				})

				columns.push({
					name: "promoted",
					label: "Promoted",
					field: "update_time",
					align: "left",
					sortable: true,
					format: formatTime,
				})

				columns.push({
					name: "timeInRank",
					label: "Time In Rank",
					field: "update_time",
					align: "left",
					sortable: true,
					format: (val, row) => {
						return `${((Date.now() - row.update_time) / 864e5).toFixed(0)} days`
					},
				})
			}

			return columns
		},
		isSelf() {
			return this.selection?.id == this.selfId
		},
		hasActions() {
			return this.permissions.CAN_SET_USER_STATUS
		},
		ranks() {
			var ranks = []

			for (var rank of this.info.Ranks) {
				if (rank.Name == this.rank.Name) {
					break
				}

				ranks.push(rank.Name)
			}

			return ranks
		},
	},
	methods: {
		getStatusClass(status) {
			switch (status) {
				case "Active":
					return `bg-green text-white`
				case "Semi-active":
					return `bg-orange text-white`
				case "Inactive":
					return `bg-red text-white`
				case "LOA":
					return `bg-yellow text-black`
				case "ICU":
					return `bg-blue text-white`
				default:
					return ""
			}
		},
		formatDuration(time) {
			if (!time || isNaN(time)) {
				return "N/A"
			}

			if (time >= 36e5) {
				return `${(time / 36e5).toFixed(0)} hours`
			} else {
				return `${(time / 6e4).toFixed(0)} minutes`
			}
		},
		rosterFilterMethod(rows, terms, cols, getCellValue) {
			terms = terms.toLowerCase()
			var isNumber = !isNaN(parseInt(terms))

			return rows.filter(row => {
				if (isNumber && row.fields?.callsign != null) {
					return row.fields.callsign == terms
				} else if (row.status?.toLowerCase() == terms) {
					return true
				} else if (row.rank?.toLowerCase() == terms) {
					return true
				} else if (row.name?.toLowerCase().includes(terms)) {
					return true
				}

				return false
			})
		},
		selectUser(row) {
			if (this.selection?.id == row.id) {
				this.selection = null
				return
			}

			this.$device.post("GetJobInfo", row.id).then(response => {
				for (var key in response) {
					row[key] = response[key]
				}

				this.flagSelection.push(this.flags[0])

				this.selection = row
			}).catch(() => {
				this.selection = null
			})
		},
		updateUser(key) {
			var args = Array.from(arguments)
			args.shift()

			this.$device.post("UpdateJobUser", this.selection?.id, key, ...args)
		},
		update(characterId, key, value) {
			if (this.selection.id == characterId) {
				this.selection[key] = value
			}

			var index = this.rosterData.findIndex(user => user.id == characterId)
			if (index != -1) {
				this.rosterData[index][key] = value
			}
		},
		searchRoster(value) {
			this.rosterFilter = value
		},
	},
})
</script>

<style>

</style>