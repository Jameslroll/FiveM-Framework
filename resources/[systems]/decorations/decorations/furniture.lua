Register("Debug Prop", {
	-- Placement = "Floor",
	Stackable = {
		Structure = true,
		Foundation = true,
		Block = true,
	},
	Snap = "CUBE",
	Model = {
		"h4_dfloor_strobe_lightproxy",
	},
})

Register("Table", {
	Placement = "Floor",
	Stackable = {
		Structure = false,
		Foundation = true,
		Block = false,
	},
	Model = {
		"apa_mp_h_din_table_01",
		"apa_mp_h_din_table_04",
		"apa_mp_h_din_table_05",
		"apa_mp_h_din_table_06",
		"apa_mp_h_din_table_11",
		"apa_mp_h_yacht_coffee_table_01",
		"apa_mp_h_yacht_coffee_table_02",
		"apa_mp_h_yacht_side_table_01",
		"apa_mp_h_yacht_side_table_02",
		"ba_prop_int_edgy_table_01",
		"ba_prop_int_trad_table",
		"bkr_prop_fakeid_table",
		"bkr_prop_weed_table_01b",
		"ex_mp_h_din_table_01",
		"ex_mp_h_din_table_04",
		"ex_mp_h_din_table_05",
		"ex_mp_h_din_table_06",
		"ex_mp_h_din_table_11",
		"ex_mp_h_yacht_coffee_table_01",
		"ex_mp_h_yacht_coffee_table_02",
		"ex_prop_ex_console_table_01",
		"gr_dlc_gr_yacht_props_table_01",
		"gr_dlc_gr_yacht_props_table_02",
		"gr_dlc_gr_yacht_props_table_03",
		"hei_heist_din_table_01",
		"hei_heist_din_table_04",
		"hei_heist_din_table_06",
		"hei_heist_din_table_07",
		"hei_prop_yah_table_01",
		"hei_prop_yah_table_02",
		"hei_prop_yah_table_03",
		"prop_chateau_table_01",
		"prop_fbi3_coffee_table",
		"prop_patio_lounger1_table",
		"prop_picnictable_01",
		"prop_rub_table_01",
		"prop_rub_table_02",
		"prop_t_coffe_table",
		"prop_table_02",
		"prop_table_03",
		"prop_table_03b_cs",
		"prop_table_03b",
		"prop_table_04",
		"prop_table_05",
		"prop_table_06",
		"prop_table_07",
		"prop_table_08_chr",
		"prop_table_08",
		"prop_table_tennis",
		"prop_tablesmall_01",
		"prop_ven_market_table1",
		"v_ilev_liconftable_sml",
		"v_res_m_dinetble",
		"v_res_fh_coftbldisp",
		"v_res_tre_bedsidetableb",
		"v_res_tre_bedsidetable",
		"v_res_m_sidetable",
	},
})

Register("Drawer", {
	Placement = "Floor",
	Stackable = {
		Structure = false,
		Foundation = true,
		Block = false,
	},
	Model = {
		"hei_heist_bed_chestdrawer_04",
		"apa_mp_h_bed_chestdrawer_02",
	},
})

Register("Television", {
	Placement = "Floor",
	Stackable = {
		Structure = true,
		Foundation = false,
		Block = false,
	},
	Model = {
		"prop_tv_test",
	},
})

Register("Ceiling Light", {
	Rotation = vector3(180, 0, 0),
	Placement = "Ceiling",
	Model = {
		"apa_mp_h_lampbulb_multiple_a",
		{
			Name = "v_serv_ct_striplight",
			Offset = vector3(0, 0, -0.2),
		},
	},
})

Register("Lamp", {
	Placement = "Floor",
	Stackable = {
		Structure = false,
		Foundation = false,
		Block = true,
	},
	Model = {
		"apa_mp_h_floor_lamp_int_08",
		"apa_mp_h_floorlamp_a",
		"apa_mp_h_floorlamp_b",
		"apa_mp_h_floorlamp_c",
		"apa_mp_h_lit_floorlamp_01",
		"apa_mp_h_lit_floorlamp_03",
		"apa_mp_h_lit_floorlamp_05",
		"apa_mp_h_lit_floorlamp_06",
		"apa_mp_h_lit_floorlamp_10",
		"apa_mp_h_lit_floorlamp_13",
		"apa_mp_h_lit_floorlamp_17",
		"apa_mp_h_lit_floorlampnight_05",
		"apa_mp_h_lit_floorlampnight_07",
		"apa_mp_h_lit_floorlampnight_14",
		"apa_mp_h_lit_lamptable_005",
		"apa_mp_h_lit_lamptable_02",
		"apa_mp_h_lit_lamptable_04",
		"apa_mp_h_lit_lamptable_09",
		"apa_mp_h_lit_lamptable_14",
		"apa_mp_h_lit_lamptable_17",
		"apa_mp_h_lit_lamptable_21",
		"apa_mp_h_lit_lamptablenight_16",
		"apa_mp_h_lit_lamptablenight_24",
		"apa_mp_h_table_lamp_int_08",
		"apa_mp_h_yacht_floor_lamp_01",
		"apa_mp_h_yacht_table_lamp_01",
		"apa_mp_h_yacht_table_lamp_02",
		"apa_mp_h_yacht_table_lamp_03",
		"bkr_prop_fakeid_desklamp_01a",
		"xm_base_cia_lamp_floor_01a",
		"xm_base_cia_lamp_floor_01b",
	},
})

Register("Painting", {
	Rotation = vector3(0, -90, -90),
	Placement = "Wall",
	Model = {
		"ch_prop_vault_painting_01a",
		"ch_prop_vault_painting_01b",
		"ch_prop_vault_painting_01c",
		"ch_prop_vault_painting_01d",
		"ch_prop_vault_painting_01e",
		"ch_prop_vault_painting_01f",
		"ch_prop_vault_painting_01g",
		"ch_prop_vault_painting_01h",
		"ch_prop_vault_painting_01i",
		"ch_prop_vault_painting_01j",
	},
})

Register("Couch", {
	Placement = "Floor",
	Stackable = {
		Structure = false,
		Foundation = true,
		Block = false,
	},
	Model = {
		"prop_couch_01",
		"prop_couch_03",
		"prop_couch_04",
		"prop_couch_lg_02",
		"prop_couch_lg_05",
		"prop_couch_lg_06",
		"prop_couch_lg_07",
		"prop_couch_lg_08",
		"prop_couch_sm_02",
		"prop_couch_sm_05",
		"prop_couch_sm_06",
		"prop_couch_sm_07",
		"prop_couch_sm1_07",
		"prop_couch_sm2_07",
	},
})

Register("Bed", {
	Placement = "Floor",
	Stackable = {
		Structure = false,
		Foundation = true,
		Block = false,
	},
	Model = {
		"apa_mp_h_bed_double_08",
		"apa_mp_h_bed_double_09",
		"apa_mp_h_bed_wide_05",
		"apa_mp_h_bed_with_table_02",
		"apa_mp_h_yacht_bed_01",
		"apa_mp_h_yacht_bed_02",
		"ex_prop_exec_bed_01",
		"gr_prop_bunker_bed_01",
		"gr_prop_gr_campbed_01",
		"imp_prop_impexp_sofabed_01a",
		"p_lestersbed_s",
		"p_mbbed_s",
		"p_v_res_tt_bed_s",
		"v_res_msonbed_s",
	},
})

Register("Clutter", {
	Placement = "Floor",
	Stackable = {
		Structure = true,
		Foundation = false,
		Block = false,
	},
	Model = {
		"prop_ashtray_01",
		"prop_cs_beer_box",
		"prop_cs_ironing_board",
		"prop_cs_lester_crate",
		"prop_cs_magazine",
		"prop_pool_rack_01",
		"prop_sh_bong_01",
		"prop_t_telescope_01b",
		"v_res_fa_magtidy",
		"v_res_fh_aftershavebox",
	},
})

Register("Book", {
	Placement = "Floor",
	Stackable = {
		Structure = false,
		Foundation = false,
		Block = true,
	},
	Model = {
		"v_res_fa_book01",
		"v_res_fa_book02",
		"v_res_fa_book03",
		"v_res_fa_book04",
		"v_ret_ta_book1",
		"v_ret_ta_book2",
		"v_ret_ta_book3",
		"v_ret_ta_book4",
		"prop_cs_stock_book",
		"vw_prop_book_stack_01a",
		"vw_prop_book_stack_01b",
		"vw_prop_book_stack_01c",
		"vw_prop_book_stack_02a",
		"vw_prop_book_stack_02b",
		"vw_prop_book_stack_02c",
		"vw_prop_book_stack_03a",
		"vw_prop_book_stack_03b",
		"vw_prop_book_stack_03c",
		"v_ilev_mp_bedsidebook",
	},
})

Register("Tools", {
	Stackable = {
		Structure = false,
		Foundation = false,
		Block = true,
	},
	Model = "sum_prop_ac_qub3d_cube_01",
})

Register("Generator", {
	Stackable = {
		Structure = false,
		Foundation = false,
		Block = true,
	},
	Model = {
		{
			Name = "prop_generator_01a",
		},
	},
})
