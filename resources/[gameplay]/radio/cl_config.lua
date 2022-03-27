local props = {
	{ Model = "prop_cs_hand_radio", Bone = 28422, Offset = { 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 }},
}

Config = {
	DisabledControls = { 0, 1, 2, 24, 25, 38, 68, 69, 70, 92, 114, 121, 140, 141, 142, 199, 200, 257, 263, 264, 331 },
	Clicks = {
		Key = "roleplay_radioClick",
		Variations = 3,
	},
	Controls = {
		Modifier = 21, -- Sprint (Shift).
	},
	Anims = {
		Open = {
			Dict = "cellphone@",
			Name = "cellphone_text_in",
			Flag = 50,
			Blend = 16.0,
			Props = props,
		},
		Close = {
			Dict = "cellphone@",
			Name = "cellphone_text_out",
			Flag = 48,
			Blend = 16.0,
			Props = props,
		},
		Talking = {
			Radio = true,
			Dict = "random@arrests",
			Name = "generic_radio_chatter",
			BlendSpeed = 6.0,
			DisableCombat = true,
			Flag = 49,
		},
	}
}