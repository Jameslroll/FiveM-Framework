Register("Plastic Tote", {
	Placement = "Floor",
	Container = {
		Type = "stash2",
	},
	Stackable = {
		Structure = true,
		Foundation = false,
		Block = false,
	},
	Model = "v_res_smallplasticbox",
})

Register("Antique Box", {
	Placement = "Floor",
	Container = {
		Type = "stash1",
	},
	Stackable = {
		Structure = true,
		Foundation = false,
		Block = false,
	},
	Model = "ba_prop_battle_antique_box",
})

Register("Safe", {
	Placement = "Floor",
	Container = {
		Type = "stash4",
	},
	Stackable = {
		Structure = false,
		Foundation = true,
		Block = false,
	},
	Model = "prop_ld_int_safe_01",
})

Register("Fridge", {
	Placement = "Floor",
	Container = {
		Type = "fridge1",
	},
	Model = "v_res_fridgemodsml",
})