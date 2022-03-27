Config = {
	Types = {
		["Binoculars"] = {
			Sensitivity = 5.0,
			ZoomSensitivity = 0.1,
			Shake = 0.4,
			Scaleform = "BINOCULARS",
			-- Timecycle = { Name = "", Strength = 1.0 },
			Zoom = {
				Min = 5.0,
				Max = 30.0,
			},
			Horizontal = {
				Min = -45.0,
				Max = 45.0,
			},
			Vertical = {
				Min = -60.0,
				Max = 60.0,
			},
			Anim ={
				Dict = "amb@world_human_binoculars@male@idle_a",
				Name = "idle_c",
				Flag = 49,
				Props = {
					{ Model = "prop_binoc_01", Bone = 28422, Offset = { 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 }},
				},
				DisableMovement = false,
				DisableCarMovement = false,
				DisableCombat = false,
				DisableJumping = false,
			},
		},
		["Camera"] = {
			Sensitivity = 4.0,
			ZoomSensitivity = 0.05,
			Shake = 0.0,
			Forward = 2.3,
			-- Scaleform = "BINOCULARS",
			-- Timecycle = { Name = "", Strength = 1.0 },
			Zoom = {
				Min = 30.0,
				Max = 135.0,
			},
			Horizontal = {
				Min = -60.0,
				Max = 60.0,
			},
			Vertical = {
				Min = -80.0,
				Max = 80.0,
			},
			Anim ={
				Dict = "amb@world_human_paparazzi@male@base",
				Name = "base",
				Flag = 49,
				Props = {
					{ Model = "prop_pap_camera_01", Bone = 28422, Offset = { 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 } },
				},
				DisableMovement = false,
				DisableCarMovement = false,
				DisableCombat = false,
				DisableJumping = false,
			},
		}
	},
}