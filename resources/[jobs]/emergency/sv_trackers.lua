GROUP_NAME = "emergency"

Models = {
	[`blazer2`] = "cruiser",
	[`dcrfpiu`] = "cruiser",
	[`dcrspeedo`] = "cruiser",
	[`dcrtahoe`] = "cruiser",
	[`dcrtahoe2`] = "cruiser",
	[`dpscharger`] = "cruiser",
	[`dpscharger2`] = "cruiser",
	[`dpscvpi`] = "cruiser",
	[`dpsf150`] = "cruiser",
	[`dpsfpis`] = "cruiser",
	[`dpsfpiu`] = "cruiser",
	[`dpsfpiu2`] = "cruiser",
	[`dpstahoe`] = "cruiser",
	[`fbi`] = "cruiser",
	[`fbi2`] = "cruiser",
	[`lguard`] = "cruiser",
	[`pbus`] = "cruiser",
	[`pdcaprice`] = "cruiser",
	[`pdcharger`] = "cruiser",
	[`pdcvpi`] = "cruiser",
	[`pdfpis`] = "cruiser",
	[`pdfpiu`] = "cruiser",
	[`pdtahoe`] = "cruiser",
	[`sdf150`] = "cruiser",

	[`dpscamaro`] = "intercept",
	[`dpsdemon`] = "intercept",
	[`pdc8`] = "intercept",
	[`pdcomet`] = "intercept",
	[`pddemon`] = "intercept",
	[`pdhellcat`] = "intercept",
	[`pdrs6`] = "intercept",
	[`pdstang`] = "intercept",

	[`pdbearcat`] = "armored",
	[`riot`] = "armored",
	[`riot2`] = "armored",
	[`swattahoe`] = "armored",

	[`harley`] = "bike",
	[`pdsanchez`] = "bike",

	[`emsexplorer`] = "ambulance",
	[`emsspeedo`] = "ambulance",
	[`emstahoe`] = "ambulance",
	[`firetruk`] = "ambulance",

	[`polmav`] = "heli",
	[`rsheli`] = "heli",

	[`predator`] = "boat",
}

exports.trackers:CreateGroup(GROUP_NAME, {
	delay = 2000,
	states = {
		[1] = { -- Peds.
			["ems"] = {
				Colour = 8,
			},
			["pd"] = {
				Colour = 3,
			},
		},
		[2] = { -- Vehicles.
			["ambulance"] = {
				Colour = 8,
				Sprite = 750,
			},
			["cruiser"] = {
				Colour = 3,
			},
			["intercept"] = {
				Colour = 3,
				Sprite = 595,
			},
			["armored"] = {
				Colour = 3,
				Sprite = 800,
			},
			["bike"] = {
				Colour = 3,
				Sprite = 661,
			},
			["heli"] = {
				Colour = 3,
				Sprite = 64,
			},
			["boat"] = {
				Colour = 3,
				Sprite = 427,
			},
		}
	},
})

AddEventHandler("entityCreated", function(entity)
	if not DoesEntityExist(entity) then return end

	local model = GetEntityModel(entity)
	if not model then return end

	local state = Models[model]
	if state then
		exports.trackers:AddEntity(GROUP_NAME, entity, { state = state })
	end
end)