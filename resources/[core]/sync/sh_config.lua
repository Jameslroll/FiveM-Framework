Config = {
	TimeScale = 1.0 / 8.0, -- 1.0 = Time passes 1:1.
	TransitionTime = 15.0,
	Winter = {
		Start = 10,
		End = 3,
	},
	Weathers = {
		["EXTRASUNNY"] = {
			Next = {
				["EXTRASUNNY"] = 1.0,
				["CLEARING"] = 0.1,
				["OVERCAST"] = 0.75,
			},
		},
		["CLEAR"] = {
			Next = {
				["EXTRASUNNY"] = 1.0,
				["CLEARING"] = 0.1,
				["OVERCAST"] = 0.75,
			},
		},
		["NEUTRAL"] = {
			Next = {
				["EXTRASUNNY"] = 1.0,
			},
		},
		["SMOG"] = {
			Next = {
				["CLEAR"] = 1.0,
				["OVERCAST"] = 0.75,
			},
		},
		["FOGGY"] = {
			Next = {
				["CLEAR"] = 1.0,
			},
		},
		["OVERCAST"] = {
			Next = {
				["RAIN"] = 0.10,
				["CLOUDS"] = 0.5,
				["CLEAR"] = 1.0,
				["EXTRASUNNY"] = 1.0,
				["SMOG"] = 0.5,
				["FOGGY"] = 0.5,
			},
		},
		["CLOUDS"] = {
			Next = {
				["EXTRASUNNY"] = 1.0,
				["CLEARING"] = 0.5,
				["OVERCAST"] = 0.25,
			},
		},
		["CLEARING"] = {
			Next = {
				["FOGGY"] = 1.0,
				["CLOUDS"] = 0.5,
				["CLEAR"] = 1.0,
				["EXTRASUNNY"] = 1.0,
				["SMOG"] = 0.5,
			},
		},
		["RAIN"] = {
			Next = {
				["CLEARING"] = 1.0,
				["THUNDER"] = 0.05,
			},
		},
		["THUNDER"] = {
			Next = {
				["CLEARING"] = 1.0,
				["RAIN"] = 0.75,
			},
		},
		["SNOW"] = {
			Next = {
				["XMAS"] = 1.0,
			},
		},
		["BLIZZARD"] = {
			Next = {
				["SNOW"] = 1.0,
			},
		},
		["SNOWLIGHT"] = {
			Next = {
				["SNOW"] = 1.0,
			},
		},
		["XMAS"] = {
			Next = {
				["RAIN"] = 1.0,
			},
		},
		["HALLOWEEN"] = {
		},
	}
}