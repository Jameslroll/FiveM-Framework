local items = {
	{
		name = "One Dollar",
		weight = 0.00001,
		stack = 100,
		model = "bkr_prop_money_unsorted_01",
	},
	{
		name = "Five Dollars",
		weight = 0.00001,
		stack = 100,
		model = "bkr_prop_money_unsorted_01",
	},
	{
		name = "Ten Dollars",
		weight = 0.00001,
		stack = 100,
		model = "bkr_prop_money_unsorted_01",
	},
	{
		name = "Twenty Dollars",
		weight = 0.00001,
		stack = 100,
		model = "bkr_prop_money_unsorted_01",
	},
	{
		name = "Fifty Dollars",
		weight = 0.00001,
		stack = 100,
		model = "bkr_prop_money_unsorted_01",
	},
	{
		name = "One Hundred Dollars",
		weight = 0.00001,
		stack = 100,
		model = "bkr_prop_money_unsorted_01",
	},
	{
		name = "Penny",
		weight = 0.0025,
		stack = 100,
		model = "vw_prop_vw_coin_01a",
	},
	{
		name = "Nickel",
		weight = 0.005,
		stack = 100,
		model = "vw_prop_vw_coin_01a",
	},
	{
		name = "Dime",
		weight = 0.00268,
		stack = 100,
		model = "vw_prop_vw_coin_01a",
	},
	{
		name = "Quarter",
		weight = 0.00567,
		stack = 100,
		model = "vw_prop_vw_coin_01a",
	},
	{
		name = "Debit Card",
		weight = 0.01,
		stack = 100,
		stack = 1,
	},
}

for _, item in ipairs(items) do
	item.category = "Money"

	RegisterItem(item)
end

RegisterItem({
	name = "Wallet",
	wallet = true,
	weight = 0.1,
	stack = 1,
	model = "prop_ld_wallet_01",
	nested = "wallet",
	fields = {
		[1] = {
			default = 0,
			hidden = true,
		},
	},
})