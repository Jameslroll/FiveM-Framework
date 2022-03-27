
local resources = {
	{
		name = "Cloth",
		weight = 0.08,
	},
	{
		name = "Coal",
		weight = 0.7,
	},
	{
		name = "Compact Coal",
		weight = 1.4,
	},
	{
		name = "Copper Ingot",
		weight = 0.45,
	},
	{
		name = "Copper Ore",
		weight = 0.68,
	},
	{
		name = "Flint",
		weight = 0.3,
	},
	{
		name = "Glass",
		weight = 0.2,
		model = "prop_cs_glass_scrap",
	},
	{
		name = "Gold Ingot",
		weight = 1.0,
	},
	{
		name = "Gold Nugget",
		weight = 0.04,
	},
	{
		name = "Gold Ore",
		weight = 0.72,
	},
	{
		name = "Gun Powder",
		weight = 0.5,
	},
	{
		name = "Iron Ingot",
		weight = 0.45,
	},
	{
		name = "Iron Ore",
		weight = 0.72,
	},
	{
		name = "Lead",
		weight = 0.45,
	},
	{
		name = "PCB",
		weight = 0.05,
	},
	{
		name = "Platinum Ingot",
		weight = 1.42,
	},
	{
		name = "Platinum Ore",
		weight = 0.84,
	},
	{
		name = "Polymer Plastic",
		weight = 0.45,
	},
	{
		name = "Raw Quartz",
		weight = 0.21,
	},
	{
		name = "Raw Rose Quartz",
		weight = 0.22,
	},
	{
		name = "Salt",
		weight = 1.56,
	},
	{
		name = "Screws",
		weight = 2.12,
	},
	{
		name = "Silver Ingot",
		weight = 2.83,
	},
	{
		name = "Silver Ore",
		weight = 0.77,
	},
	{
		name = "Steel Ingot",
		weight = 1.2,
	},
	{
		name = "Sulfur",
		weight = 0.45,
	},
	{
		name = "Sulfur Ore",
		weight = 0.04,
		description = "Brittle solid that is pale yellow in colour used in batteries, detergents, manufacture of fertilizers, gun power, matches and fireworks",
	},
	{
		name = "Twigs",
		weight = 0.04,
	},
	{
		name = "Wood",
		weight = 0.8,
		description = "Porous and fibrous structural tissue found in the stems and roots of trees and other woody plants",
	},
}

for k, resource in ipairs(resources) do
	resource.category = "Resource"
	resource.stack = resource.stack or 1024
	
	RegisterItem(resource)
end


local chemicals = {
	{
		name = "Calcium Powder",
		weight = 0.54,
	},
	{
		name = "Caustic Soda",
		weight = 1.42,
	},
	{
		name = "Phosphorus",
		weight = 0.08,
	},
	{
		name = "Sulphuric Acid",
		weight = 1.0,
		description = "Oily, dense, corrosive liquid used for chemical synthesis",
	},
	{
		name = "Rat Poison",
		weight = 0.82,
	},
	{
		name = "Hydrochloride",
		weight = 0.63,
	},
	{
		name = "Epoxy",
		weight = 0.98,
	},
	{
		name = "Hydroxy",
		weight = 0.32,
		description = "Bottle containing hydroxy. The label says, 'Not for food or drug use, for laboratory R&D use only'"
	},
	{
		name = "Methoxy",
		weight = 0.32,
		description = "Bottle containing methoxy. The label says, 'Not for food or drug use, for laboratory R&D use only'"
	},
	{
		name = "Ketamine",
		weight = 0.11,
	},
	{
		name = "Acetic Anhydride",
		weight = 0.4,
		description = "Small bottle, says 'Reagent Grade' on the side",
	},
	{
		name = "Calcium Oxide",
		weight = 0.76,
	},
	{
		name = "Hydrochloric Acid",
		weight = 0.79,
	},
	{
		name = "Sodium Carbonate",
		weight = 0.75,
		description = "Used in a wide range of industries, such as in cleaning and personal care products and as a fungicide, microbicide, herbicide, and pH adjuster",
	},
	{
		name = "Ammonium Chloride",
		weight = 0.5,
	},
	{
		name = "Iodine",
		weight = 0.15,
	},
	{
		name = "Ferric Ammonium Citrate",
		weight = 0.46,
	},
	{
		name = "Hydrogen Peroxide",
		weight = 0.46,
	},
	{
		name = "Codeine",
		weight = 0.52,
	},
}

for k, resource in ipairs(chemicals) do
	resource.category = "Chemical"
	resource.stack = resource.stack or 256
	
	RegisterItem(resource)
end