PedProps = {
	{ index = 0, name = "Head", focus = "head" },
	{ index = 1, name = "Eyes", focus = "head" },
	{ index = 2, name = "Ear", focus = "head", onchange = function() SetPedComponentVariation(Ped, 2, 0) end },
	{ index = 6, name = "Left Wrist", focus = "lhand" },
	{ index = 7, name = "Right Wrist", focus = "rhand" },
}