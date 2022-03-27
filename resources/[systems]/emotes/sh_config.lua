--[[
	ANIM_FLAG_NORMAL = 0,
	ANIM_FLAG_REPEAT = 1,
	ANIM_FLAG_STOP_LAST_FRAME = 2,
	ANIM_FLAG_UPPERBODY = 16,
	ANIM_FLAG_ENABLE_PLAYER_CONTROL = 32,
	ANIM_FLAG_CANCELABLE = 120,

	Odd: loop infinitely
	Even: Freeze at last frame
	Multiple of 4: Freeze at last frame but controllable

	01 to 15 > Full body
	10 to 31 > Upper body
	32 to 47 > Full body > Controllable
	48 to 63 > Upper body > Controllable

	001 to 255 > Normal
	256 to 511 > Garbled
]]

Config = {}

Config.Walkstyles = {
	["reset"] = {},
	["alien"] = { Name = "move_m@alien" },
	["armored"] = { Name = "anim_group_move_ballistic" },
	["arrogant"] = { Name = "move_f@arrogant@a" },
	["brave"] = { Name = "move_m@brave" },
	["casual"] = { Name = "move_m@casual@a" },
	["casual2"] = { Name = "move_m@casual@b" },
	["casual3"] = { Name = "move_m@casual@c" },
	["casual4"] = { Name = "move_m@casual@d" },
	["casual5"] = { Name = "move_m@casual@e" },
	["casual6"] = { Name = "move_m@casual@f" },
	["chichi"] = { Name = "move_f@chichi" },
	["confident"] = { Name = "move_m@confident" },
	["cop"] = { Name = "move_m@business@a" },
	["cop2"] = { Name = "move_m@business@b" },
	["cop3"] = { Name = "move_m@business@c" },
	["depressed"] = { Name = "move_m@depressed@a" },
	["drunk"] = { Name = "move_m@drunk@slightlydrunk" },
	["drunk2"] = { Name = "move_m@drunk@moderatedrunk" },
	["drunk3"] = { Name = "move_m@drunk@verydrunk" },
	["fat"] = { Name = "move_m@fat@a" },
	["female"] = { Name = "move_f@multiplayer" },
	["femme"] = { Name = "move_f@femme@" },
	["fire"] = { Name = "move_characters@franklin@fire" },
	["fire2"] = { Name = "move_characters@michael@fire" },
	["fire3"] = { Name = "move_m@fire" },
	["flee"] = { Name = "move_f@flee@a" },
	["franklin"] = { Name = "move_p_m_one" },
	["gangster"] = { Name = "move_m@gangster@generic" },
	["gangster2"] = { Name = "move_m@gangster@ng" },
	["gangster3"] = { Name = "move_m@gangster@var_e" },
	["gangster4"] = { Name = "move_m@gangster@var_f" },
	["gangster5"] = { Name = "move_m@gangster@var_i" },
	["golfer"] = { Name = "move_m@golfer@ " },
	["grooving"] = { Name = "anim@move_m@grooving@" },
	["guard"] = { Name = "move_m@prison_gaurd" },
	["handcuffs"] = { Name = "move_m@prisoner_cuffed" },
	["heels"] = { Name = "move_f@heels@c" },
	["heels2"] = { Name = "move_f@heels@d" },
	["hiking"] = { Name = "move_m@hiking" },
	["hipster"] = { Name = "move_m@hipster@a" },
	["hobo"] = { Name = "move_m@hobo@a" },
	["hurry"] = { Name = "move_f@hurry@a" },
	["injured"] = { Name = "move_m@injured" },
	["janitor"] = { Name = "move_p_m_zero_janitor" },
	["janitor2"] = { Name = "move_p_m_zero_slow" },
	["jog"] = { Name = "move_m@jog@" },
	["lemar"] = { Name = "anim_group_move_lemar_alley" },
	["lester"] = { Name = "move_heist_lester" },
	["lester2"] = { Name = "move_lester_caneup" },
	["male"] = { Name = "move_m@multiplayer" },
	["maneater"] = { Name = "move_f@maneater" },
	["michael"] = { Name = "move_ped_bucket" },
	["money"] = { Name = "move_m@money" },
	["muscle"] = { Name = "move_m@muscle@a" },
	["posh"] = { Name = "move_m@posh@" },
	["posh2"] = { Name = "move_f@posh@" },
	["quick"] = { Name = "move_m@quick" },
	["runner"] = { Name = "female_fast_runner" },
	["sad"] = { Name = "move_m@sad@a" },
	["sassy"] = { Name = "move_m@sassy" },
	["sassy2"] = { Name = "move_f@sassy" },
	["scared"] = { Name = "move_f@scared" },
	["sexy"] = { Name = "move_f@sexy@a" },
	["shady"] = { Name = "move_m@shadyped@a" },
	["slow"] = { Name = "move_characters@jimmy@slow@" },
	["swagger"] = { Name = "move_m@swagger" },
	["tough"] = { Name = "move_m@tough_guy@" },
	["tough2"] = { Name = "move_f@tough_guy@" },
	["trash"] = { Name = "clipset@move@trash_fast_turn" },
	["trash2"] = { Name = "missfbi4prepp1_garbageman" },
	["trevor"] = { Name = "move_p_m_two" },
	["wide"] = { Name = "move_m@bag" },
	["crouch"] = { Name = "move_ped_crouched", Strafe = "move_ped_crouched_strafing" },
}

Config.Expressions = {
	{
		Name = "Normal",
		Icon = "sentiment_neutral",
		Anim = { Dict = "facials@gen_male@base", Name = "mood_normal_1", Facial = true },
	},
	{
		Name = "Smug",
		Icon = "sentiment_neutral",
		Anim = { Dict = "facials@gen_male@base", Name = "mood_smug_1", Facial = true },
	},
	{
		Name = "Happy",
		Icon = "insert_emoticon",
		Anim = { Dict = "facials@gen_male@base", Name = "mood_happy_1", Facial = true },
	},
	{
		Name = "Excited",
		Icon = "insert_emoticon",
		Anim = { Dict = "facials@gen_male@base", Name = "mood_excited_1", Facial = true },
	},
	{
		Name = "Shocked",
		Icon = "insert_emoticon",
		Anim = { Dict = "facials@gen_female@base", Name = "shocked_1", Facial = true },
	},
	{
		Name = "Injured",
		Icon = "sentiment_dissatisfied",
		Anim = { Dict = "facials@gen_male@base", Name = "mood_injured_1", Facial = true },
	},
	{
		Name = "Stressed",
		Icon = "sentiment_dissatisfied",
		Anim = { Dict = "facials@gen_male@base", Name = "mood_stressed_1", Facial = true },
	},
	{
		Name = "Sulk",
		Icon = "sentiment_dissatisfied",
		Anim = { Dict = "facials@gen_male@base", Name = "mood_sulk_1", Facial = true },
	},
	{
		Name = "Sleeping",
		Icon = "bed",
		Anim = { Dict = "facials@gen_male@base", Name = "mood_sleeping_1", Facial = true },
	},
	{
		Name = "Dead",
		Icon = "sentiment_very_dissatisfied",
		Anim = { Dict = "facials@gen_male@base", Name = "dead_1", Facial = true },
	},
	{
		Name = "Electrocuted",
		Icon = "bolt",
		Anim = { Dict = "facials@gen_male@base", Name = "electrocuted_1", Facial = true },
	},
	{
		Name = "Focus",
		Icon = "priority_high",
		Anim = { Dict = "facials@gen_male@base", Name = "effort_1", Facial = true },
	},
}