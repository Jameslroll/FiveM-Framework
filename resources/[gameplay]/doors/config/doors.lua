Config.Doors = {
	[`prison_prop_door1`] = { Electronic = true },
	[`prison_prop_door1a`] = { Electronic = true },
	[`prison_prop_door2`] = { Electronic = true },
	[`prison_prop_jaildoor`] = { Electronic = true },
	[`xm_cellgate`] = { Sliding = true, Locked = false, Electronic = true },
	[`prop_gate_prison_01`] = { Sliding = true, Distance = 10.0, Electronic = true },
	[`hei_prop_station_gate`] = { Sliding = true, Distance = 6.0, Electronic = true, Fob = true },
	[`v_ilev_gtdoor`] = { Electronic = true },
	[`v_ilev_gtdoor02`] = { Electronic = true },
	[`prop_fnclink_03gate5`] = { Electronic = true },
	[`prop_strip_door_01`] = {},
	[`v_ilev_door_orangesolid`] = {},
	[`v_ilev_roc_door2`] = {},
	[`prop_magenta_door`] = {},
	[`v_ilev_arm_secdoor`] = { Electronic = true },
	[`v_ilev_fa_dinedoor`] = {},
	[`v_ilev_ph_gendoor`] = {},
	[`v_ilev_ph_gendoor002`] = {},
	[`v_ilev_ph_gendoor004`] = {},
	[`v_ilev_ph_gendoor005`] = {},
	[`v_ilev_ph_gendoor006`] = {},
	[`v_ilev_ph_cellgate`] = {},
	[`v_ilev_ph_cellgate02`] = {},
	[395979613] = {},
	[-361000789] = { Sliding = true },
	[4787313] = { Sliding = true },
	[-543497392] = {},
	[452874391] = {},
	[-739665083] = {},
	[1240350830] = {},
	[1286535678] = { Sliding = true, Distance = 10.0 },
	[282722808] = {},
	[964838196] = { Locked = true, Item = "Lockpick" }, -- PSB & City Hall.

	--[[ Bank Doors ]]--
	[`hei_v_ilev_bk_gate_pris`] = {
		Item = "Thermite",
		SpecialState = {
			Lifetime = 15.0,
			Offsets = { 0.2, 0.0, 0.0, -0.1, 0.0, 90.0 },
			PtfxDict = "scr_ornate_heist",
			PtfxName = "scr_heist_ornate_thermal_burn",
			SwapModel = "hei_v_ilev_bk_gate_molten",
		}
	},

	[`hei_v_ilev_bk_gate2_pris`] = {
		Item = "Thermite",
		SpecialState = {
			Lifetime = 15.0,
			Offsets = { 0.2, 0.0, 0.0, -0.1, 0.0, 90.0 },
			PtfxDict = "scr_ornate_heist",
			PtfxName = "scr_heist_ornate_thermal_burn",
			SwapModel = "hei_v_ilev_bk_gate2_molten",
		}
	},

	[`hei_v_ilev_bk_safegate_pris`] = {
		Item = "Thermite",
		SpecialState = {
			Lifetime = 15.0,
			Offsets = { -0.2, 0.0, -0.1, 0.0, 0.0, -90.0 },
			PtfxDict = "scr_ornate_heist",
			PtfxName = "scr_heist_ornate_thermal_burn",
			SwapModel = "hei_v_ilev_bk_safegate_molten",
		}
	},

	[`v_ilev_gb_vaubar`] = {
		Item = "Thermite",
		SpecialState = {
			Lifetime = 15.0,
			Offsets = { 0.35, 0.0, 0.0, 0.0, 0.0, 90.0 },
			PtfxDict = "scr_ornate_heist",
			PtfxName = "scr_heist_ornate_thermal_burn",
		}
	},
	
	[`hei_v_ilev_bk_gate_molten`] = { Ignore = true },
	[`hei_v_ilev_bk_gate2_molten`] = { Ignore = true },
	[`hei_v_ilev_bk_safegate_molten`] = { Ignore = true },
	
	[`hei_prop_hei_bankdoor_new`] = { Locked = false },
	[`v_ilev_bk_door`] = { Item = "Lockpick" },
	[`v_ilev_fingate`] = {}, -- Thermite door? Unsure where it's used.
	[`v_ilev_gb_teldr`] = { Item = "Lockpick" },

	--[[ Jewelry ]]--
	[1425919976] = { Item = "Lockpick", Locked = true },
	[9467943] = { Item = "Lockpick", Locked = true },
	[1335309163] = { Item = "Lockpick", Locked = true },

	--[[ Vaults ]]--
	[`v_ilev_bk_vaultdoor`] = { Vault = -160.0 },
	[`v_ilev_gb_vauldr`] = { Vault = -90.0, Distance = 1.0 },
	[`v_ilev_fin_vaultdoor`] = { Vault = 170.0, Distance = 4.0 },
	[`v_ilev_cbankvauldoor01`] = { Default = -105.0, Vault = 105.0 },
	[`hei_prop_heist_sec_door`] = { Vault = -90.0 },

	[`ch_prop_arcade_fortune_door_01a`] = { Locked = true, Vault = 90.0 },

	--[[ Humane Labs ]]--
	[-1081024910] = { Sliding = true, Locked = true, Speed = 10.0, Force = 1.0 }, -- Front bay.
	[161378502] = { Sliding = true, Locked = true, Speed = 10.0, Force = 1.0 }, -- Sliding glass (R).
	[-1572101598] = { Sliding = true, Locked = true, Speed = 10.0, Force = -1.0 }, -- Sliding glass (L).
	[-421709054] = { Locked = true },
	[1282049587] = { Locked = true },
	[19193616] = { Locked = true },

	--[[ Gabz Hospital ]]--
	[-1421582160] = {},
	[-1700911976] = { Locked = true },
	[-1927754726] = {},
	[-434783486] = { Locked = true },
	[-820650556] = { Locked = true, Distance = 10.0 },
	[1248599813] = {},
	[854291622] = { Locked = true },

	--[[ Gabz MRPD ]]--
	[-692649124] = {},
	[1830360419] = {},
	[-1406685646] = {},
	[-96679321] = {},
	[149284793] = {},
	[-288803980] = {},
	[-1547307588] = {},
	[2130672747] = { Sliding = true, Distance = 3.0, Speed = 0.2, Fob = true },
	[-53345114] = {},
	[-1258679973] = {},
	[-1635161509] = { Sliding = true, Fob = true },
	[-1868050792] = { Sliding = true, Fob = true },

	--[[ Gabz Vanilla Unicorn ]]--
	[390840000] = {},
	[1695461688] = {},

	--[[ La Mesa PD ]]--
	[1734343003] = {},
	[864572485] = {},
	[-553047264] = {},
	[-703073730] = {},
	[-551608542] = {},
	[-502195954] = {},
	[-1920147247] = {},
	[836255965] = { Sliding = true, Distance = 10.0 },
	[-321609811] = { Sliding = true, NoDouble = true },
	[-471294496] = { Locked = false },

	--[[ Sandy PD ]]--
	[1993173653] = {},
	[-1425448544] = {},
	[1196497453] = {},
	[2083270719] = {},
	[-1486622150] = {},
	[-461148726] = {},
	[-702496327] = {},

	--[[ Sandy Medical ]]--
	[1336564066] = { Sliding = true, Locked = false },
	[1415151278] = {},
	[580361003] = {},
	[-1143010057] = { Locked = false },

	--[[ New Prison ]]--
	[1373390714] = { Electronic = true },
	[539686410] = {},
	[-684929024] = {},
	[2074175368] = {},
	[-1624297821] = {},
	[-1392981450] = {},
	[2024969025] = {},
	[241550507] = { Electronic = true },
	[913760512] = { Locked = false, Electronic = true },

	--[[ Tequi-la-la ]]--
	[993120320] = {},
	[757543979] = {},

	--[[ Bean Machine & PDM ]]--
	[736699661] = {},
	[1417577297] = {},
	[2059227086] = {},
	[-883710603] = {},

	--[[ Arcade ]]--
	[-1977830166] = {},
	[1044811355] = {},
	[-637233066] = {},
	[1044811355] = {},
	[-2051651622] = {},
	[-2045695986] = {},
	[-114880996] = {},
	[1122723068] = { Sliding = true },
	[-603547852] = { Sliding = true },

	--[[ Weed | High Times ]]--
	[230454090] = {},
	[-538477509] = {},
	[-311575617] = {},

	--[[ Offices ]]--
	[220394186] = {},
	[1939954886] = {},
	[-923302700] = {},
	[1901651314] = {},
	[9006550] = {},
	[-1625169788] = {},

	--[[ Sewer ]] --
	[-267021114] = {},
	[`v_ilev_rc_door2`] = {},

	--[[ Victrix ]]--
	[1388116908] = {},
	[933053701] = {},
	[1286392437] = { Sliding = true },

	--[[ Cayo Perico ]]--
	[1215477734] = { NoDouble = false },
	[-1574151574] = { NoDouble = false },
	[-607013269] = {},
	[-1360938964] = {},
	[-2058786200] = {},
	[-630812075] = {},
	[1526539404] = {},
	[1413187371] = {},
	[227019171] = {},
	[141297241] = { Sliding = true, Distance = 5.0 },
	[-1052729812] = { NoDouble = false },
	[1866987242] = { NoDouble = false },
	[-1635579193] = {},
	[-23367131] = {},
	[-1747016523] = {},

	--[[ Paleto Medical ]]--
	[-770740285] = {},
	[613848716] = {},

	--[[ Hen House ]]--
	[1286502769] = {},
	[633547679] = {},
	[1743859485] = {},
	[-1671830748] = {},
	[1901183774] = {},
	[1167251902] = {},

	--[[ Yellowjack ]]--
	[-287662406] = {},
	[479144380] = {},

	--[[ Luchettis ]]--
	[-950166942] = {},
	[1289778077] = {},
	[757543979] = {},
	[2035930085] = {},

	--[[ Axel's Auto at Elgin & Spanish ]]--
	[141631573] = {},
	[-1458889440] = {},
	[-1218332211] = {},
	[-1309543596] = {},
	[1497823487] = {},
	[-733661186] = {},

	--[[ Luxury Auto's ]]--
	[1718041838] = {},
	[2008932251] = {},
	[1409837716] = { Sliding = true, Distance = 10.0 },

	--[[ Paleto Pd ]]--
	[-952356348] = {},
	[-519068795] = {},
	[245182344] = {},
	[-681066206] = {},
	[-1501157055] = { Locked = false },

	--[[ Bail Bonds ]]--
	[-2112350883] = {},
	[-816468097] = {},
	[1242124150] = {},

	--[[ Burger Shot ]]--
	[1517256706] = {},
	[-1475798232] = {},
	[-1253427798] = {},
	
	--[[ Hayes Auto Body Shop ]]--
	[-634936098] = {},

	--[[ Beeker's Garage \ Paleto ]]--
	[1335311341] = {},

	--[[ Taco Shop ]]--
	[-1215222675] = {},

	--[[ Bahama Mama's ]]--
	[-2037125726] = {},
}