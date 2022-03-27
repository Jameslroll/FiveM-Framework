local props = { { Model = "prop_npc_phone_02", Bone = 0x6F06, Offset = { 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 } } }

Config = {
	EnabledControls = { 30, 31, 32, 33, 34, 35, 59, 60, 61, 62, 63, 64, 249 },
	Kvp = "roleplay_device-%s-%s",
	LocalData = {
		["options/background"] = true,
		["options/notify"] = true,
		["options/ringtone"] = true,
	},
	Anims = {
		Call = {
			Dict = "cellphone@str",
			Name = "cellphone_call_listen_c",
			Flag = 49,
			Props = props,
		},
	},
	Devices = {
		["phone"] = {
			name = "Phone",
			item = "Mobile Phone",
			anim = {
				Sequence = {
					{
						Dict = "cellphone@",
						Name = "cellphone_text_in",
						Flag = 50,
						Duration = 700,
					},
					{
						Dict = "cellphone@",
						Name = "cellphone_text_read_base",
						Flag = 49,
						Props = props,
					},
					{
						Dict = "cellphone@",
						Name = "cellphone_text_out",
						Flag = 48,
						Duration = 600,
					},
				},
			},
		},
		["tablet"] = {
			name = "Tablet",
			item = "Tablet",
			anim = {
				Dict = "amb@code_human_in_bus_passenger_idles@female@tablet@base",
				Name = "base",
				Flag = 49,
				Props = { { Model = "prop_cs_tablet", Bone = 60309, Offset = { 0.03, 0.002, 0.0, 10.0, -20.0, 0.0 } } }
			},
		},
	},
}