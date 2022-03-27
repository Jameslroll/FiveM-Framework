Templates = {}

Templates.npc = {
	coords = vector4(0, 0, 0, 0),
	model = "mp_m_shopkeep_01",
	interact = "Shop",
	animations = {
		hand = { Dict = "mp_cop_armoury", Name = "package_from_counter", Flag = 0 },
	}
}

Templates.window = {
	title = "Shop",
	class = "compact",
	style = {
		["width"] = "50vmin",
		["height"] = "66vmin",
		["top"] = "50%",
		["right"] = "5vmin",
		["transform"] = "translate(0%, -50%)",
	},
	components = {
		{
			style = {
				["position"] = "relative",
				["top"] = "0%",
				["overflow-y"] = "scroll",
				["flex-grow"] = 1,
			},
			template = [[
				<div
					style="overflow: hidden"
					class="q-ma-sm"
				>
					<q-table
						:rows-per-page-options="[0]"
						:data="$getModel('items')"
						:loading="$getModel('loading')"
						style="overflow: hidden; height: auto"
						row-key="name"
						grid
						flat
						dense
						hide-bottom
					>
						<template v-slot:item="props">
							<q-item
								@click.left.ctrl="$invoke('addToCart', props.row.name, 8)"
								@click.left.exact="$invoke('addToCart', props.row.name, 1)"
								@click.left.shift="$invoke('addToCart', props.row.name, 256)"
								@click.right.ctrl="$invoke('addToCart', props.row.name, -8)"
								@click.right.exact="$invoke('addToCart', props.row.name, -1)"
								@click.right.shift="$invoke('addToCart', props.row.name, -256)"
								clickable
								:style="`
									width: 25%;
									margin: 0%;
									background: ${
										$getModel('cart')[props.row.name] ?
										'rgba(50, 160, 240, 0.4)' :
										'transparent'
									};
								`"
							>
								<q-item-section class="items-center">
									<q-img
										:src="`nui://inventory/icons/${props.row.icon}.png`"
										class="q-ma-xs"
										width="6vmin"
										height="6vmin"
										contain
									/>
									<q-badge
										:color="$getModel('cash') > props.row.price ? 'green' : 'red'"
										style="top: 0.5vmin; right: 0.5vmin"
										floating
									>
										${{props.row.price}}
									</q-badge>
									<q-badge
										v-if="$getModel('cart')[props.row.name]"
										color="blue"
										style="top: 0.5vmin; left: 0.5vmin; right: auto"
										floating
									>
										{{$getModel('cart')[props.row.name]}}
									</q-badge>
									<q-item-label>{{props.row.name}}</q-item-label>
									<q-item-label caption>{{props.row.stock}} in stock</q-item-label>
								</q-item-section>
							</q-item>
						</template>
					</q-table>
				</div>
			]],
		},
		{
			type = "q-toolbar",
			class = "q-pa-none q-ma-none",
			style = {
				["position"] = "sticky",
				["width"] = "100%",
				["bottom"] = "0%",
				["overflow"] = "hidden",
			},
			template = [[
				<q-item style="width: 100%" :class="`q-pa-none q-ma-none ${$getModel('cash') >= $getModel('totalPrice') ? 'bg-green' : 'bg-red'}`">
					<q-item-section class="q-ml-md">
						<q-item-label overline>x{{$getModel('cartAmount') ?? 0}} items</q-item-label>
						<q-item-label caption class="text-bold">${{$getModel('totalPrice') ?? 0.00}}</q-item-label>
					</q-item-section>
					<q-item-section style="max-width: 10vmin" class="q-mr-sm">
						<q-select
							:options="['Cash', 'Credit' ]"
							:value="$getModel('paymentType')"
							@input="$setModel('paymentType', $event)"
							label="Pay with"
							dense
							borderless
						/>
					</q-item-section>
					<q-item-section class="q-ma-none q-mr-md" style="max-width: 5vmin">
						<q-btn
							:disabled="$getModel('cartAmount') == 0 || $getModel('cash') < $getModel('totalPrice')"
							@click="$invoke('purchase')"
							icon="shopping_cart"
							flat
						/>
					</q-item-section>
				</q-item>
			]],
		},
	},
}