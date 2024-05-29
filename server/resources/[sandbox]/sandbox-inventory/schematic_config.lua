_schematics = {
	-- AMMO
	pistol_ammo = {
		result = { name = "AMMO_PISTOL", count = 10 },
		items = {
			{ name = "copperwire", count = 100 },
			{ name = "scrapmetal", count = 100 },
		},
	},
	smg_ammo = {
		result = { name = "AMMO_SMG", count = 10 },
		items = {
			{ name = "copperwire", count = 500 },
			{ name = "scrapmetal", count = 500 },
		},
	},
	shotgun_ammo = {
		result = { name = "AMMO_SHOTGUN", count = 10 },
		items = {
			{ name = "copperwire", count = 1000 },
			{ name = "scrapmetal", count = 1000 },
		},
	},
	ar_ammo = {
		result = { name = "AMMO_AR", count = 10 },
		items = {
			{ name = "copperwire", count = 2500 },
			{ name = "scrapmetal", count = 2500 },
		},
	},

	-- TOOLS
	thermite = {
		result = { name = "thermite", count = 1 },
		items = {
			{ name = "ironbar", count = 500 },
			{ name = "electronic_parts", count = 500 },
			{ name = "copperwire", count = 500 },
			{ name = "plastic", count = 500 },
			{ name = "rubber", count = 500 },
		},
	},
	blindfold = {
		result = { name = "blindfold", count = 1 },
		items = {
			{ name = "cloth", count = 100 },
		},
	},
	grapple = {
		result = { name = "WEAPON_BULLPUPSHOTGUN", count = 1 },
		items = {
			{ name = "refined_iron", count = 3 },
			{ name = "refined_rubber", count = 3 },
			{ name = "refined_glue", count = 3 },
			{ name = "refined_plastic", count = 3 },
			{ name = "refined_copper", count = 3 },
		},
	},

	green_laptop = {
		result = { name = "green_laptop", count = 1 },
		items = {
			{ name = "refined_metal", count = 1 },
			{ name = "refined_iron", count = 1 },
			{ name = "refined_electronics", count = 1 },
			{ name = "refined_copper", count = 1 },
			{ name = "refined_glue", count = 1 },
			{ name = "refined_plastic", count = 1 },
		},
		cooldown = 1000 * 60 * 60 * 24,
	},
	blue_laptop = {
		result = { name = "blue_laptop", count = 1 },
		items = {
			{ name = "refined_metal", count = 2 },
			{ name = "refined_iron", count = 2 },
			{ name = "refined_electronics", count = 2 },
			{ name = "refined_copper", count = 2 },
			{ name = "refined_glue", count = 2 },
			{ name = "refined_plastic", count = 2 },
		},
		cooldown = 1000 * 60 * 60 * 24,
	},
	red_laptop = {
		result = { name = "red_laptop", count = 1 },
		items = {
			{ name = "refined_metal", count = 5 },
			{ name = "refined_iron", count = 5 },
			{ name = "refined_electronics", count = 5 },
			{ name = "refined_copper", count = 5 },
			{ name = "refined_glue", count = 5 },
			{ name = "refined_plastic", count = 5 },
		},
		cooldown = 1000 * 60 * 60 * 24,
	},
	purple_laptop = {
		result = { name = "purple_laptop", count = 1 },
		items = {
			{ name = "refined_metal", count = 10 },
			{ name = "refined_iron", count = 10 },
			{ name = "refined_electronics", count = 10 },
			{ name = "refined_copper", count = 10 },
			{ name = "refined_glue", count = 10 },
			{ name = "refined_plastic", count = 10 },
		},
		cooldown = 1000 * 60 * 60 * 24,
	},
	yellow_laptop = {
		result = { name = "yellow_laptop", count = 1 },
		items = {
			{ name = "refined_metal", count = 25 },
			{ name = "refined_iron", count = 25 },
			{ name = "refined_electronics", count = 25 },
			{ name = "refined_copper", count = 25 },
			{ name = "refined_glue", count = 25 },
			{ name = "refined_plastic", count = 25 },
		},
		cooldown = 1000 * 60 * 60 * 24,
	},

	handcuffs = {
		result = { name = "handcuffs", count = 1 },
		items = {
			{ name = "ironbar", count = 1500 },
		},
	},
	adv_electronics_kit = {
		result = { name = "adv_electronics_kit", count = 1 },
		items = {
			{ name = "goldbar", count = 1 },
			{ name = "silverbar", count = 2 },
			{ name = "electronic_parts", count = 30 },
			{ name = "heavy_glue", count = 5 },
			{ name = "plastic", count = 30 },
			{ name = "copperwire", count = 20 },
		},
	},

	radio_extendo = {
		result = { name = "radio_extendo", count = 1 },
		items = {
			{ name = "electronic_parts", count = 100 },
			{ name = "plastic", count = 700 },
			{ name = "copperwire", count = 200 },
			{ name = "heavy_glue", count = 10 },
			{ name = "silverbar", count = 2 },
		},
	},

	-- ATTACHMENTS
	weapon_flashlight = {
		result = { name = "ATTCH_WEAPON_FLASHLIGHT", count = 1 },
		items = {
			{ name = "goldbar", count = 5 },
			{ name = "electronic_parts", count = 250 },
			{ name = "heavy_glue", count = 250 },
			{ name = "plastic", count = 250 },
			{ name = "copperwire", count = 250 },
		},
	},
	pistol_ext_mag = {
		result = { name = "ATTCH_PISTOL_EXT_MAG", count = 1 },
		items = {
			{ name = "refined_metal", count = 1 },
			{ name = "refined_glue", count = 1 },
			{ name = "refined_plastic", count = 1 },
		},
	},
	smg_ext_mag = {
		result = { name = "ATTCH_SMG_EXT_MAG", count = 1 },
		items = {
			{ name = "refined_metal", count = 2 },
			{ name = "refined_glue", count = 2 },
			{ name = "refined_plastic", count = 2 },
		},
	},
	rifle_ext_mag = {
		result = { name = "ATTCH_AR_EXT_MAG", count = 1 },
		items = {
			{ name = "refined_metal", count = 4 },
			{ name = "refined_glue", count = 4 },
			{ name = "refined_plastic", count = 4 },
		},
	},
	drum_mag = {
		result = { name = "ATTCH_DRUM_MAG", count = 1 },
		items = {
			{ name = "refined_metal", count = 10 },
			{ name = "refined_glue", count = 10 },
			{ name = "refined_plastic", count = 10 },
		},
	},
	box_mag = {
		result = { name = "ATTCH_BOX_MAG", count = 1 },
		items = {
			{ name = "refined_metal", count = 10 },
			{ name = "refined_glue", count = 10 },
			{ name = "refined_plastic", count = 10 },
		},
	},

	pistol_suppressor = {
		result = { name = "ATTCH_PISTOL_SILENCER", count = 1 },
		items = {
			{ name = "refined_metal", count = 1 },
			{ name = "refined_electronics", count = 1 },
		},
	},
	adv_pistol_suppressor = {
		result = { name = "ATTCH_ADV_PISTOL_SILENCER", count = 1 },
		items = {
			{ name = "refined_metal", count = 3 },
			{ name = "refined_electronics", count = 3 },
		},
	},
	smg_suppressor = {
		result = { name = "ATTCH_SMG_SILENCER", count = 1 },
		items = {
			{ name = "refined_metal", count = 2 },
			{ name = "refined_electronics", count = 2 },
		},
	},
	adv_smg_suppressor = {
		result = { name = "ATTCH_ADV_SMG_SILENCER", count = 1 },
		items = {
			{ name = "refined_metal", count = 4 },
			{ name = "refined_electronics", count = 4 },
		},
	},
	ar_suppressor = {
		result = { name = "ATTCH_AR_SILENCER", count = 1 },
		items = {
			{ name = "refined_metal", count = 3 },
			{ name = "refined_electronics", count = 3 },
		},
	},
	adv_ar_suppressor = {
		result = { name = "ATTCH_ADV_AR_SILENCER", count = 1 },
		items = {
			{ name = "refined_metal", count = 5 },
			{ name = "refined_electronics", count = 5 },
		},
	},

	scope_holo = {
		result = { name = "ATTCH_HOLO", count = 1 },
		items = {
			{ name = "goldbar", count = 15 },
			{ name = "refined_metal", count = 1 },
			{ name = "refined_electronics", count = 1 },
			{ name = "refined_glue", count = 1 },
			{ name = "refined_copper", count = 1 },
		},
	},
	scope_reddot = {
		result = { name = "ATTCH_REDDOT", count = 1 },
		items = {
			{ name = "goldbar", count = 15 },
			{ name = "refined_metal", count = 1 },
			{ name = "refined_electronics", count = 1 },
			{ name = "refined_glue", count = 1 },
			{ name = "refined_copper", count = 1 },
		},
	},
	scope_small = {
		result = { name = "ATTCH_SMALL_SCOPE", count = 1 },
		items = {
			{ name = "goldbar", count = 15 },
			{ name = "refined_metal", count = 1 },
			{ name = "refined_electronics", count = 1 },
			{ name = "refined_glue", count = 1 },
			{ name = "refined_copper", count = 1 },
		},
	},
	scope_med = {
		result = { name = "ATTCH_MED_SCOPE", count = 1 },
		items = {
			{ name = "goldbar", count = 30 },
			{ name = "refined_metal", count = 2 },
			{ name = "refined_electronics", count = 2 },
			{ name = "refined_glue", count = 2 },
			{ name = "refined_copper", count = 2 },
		},
	},
	scope_lrg = {
		result = { name = "ATTCH_LRG_SCOPE", count = 1 },
		items = {
			{ name = "goldbar", count = 100 },
			{ name = "refined_metal", count = 5 },
			{ name = "refined_electronics", count = 5 },
			{ name = "refined_glue", count = 5 },
			{ name = "refined_copper", count = 5 },
		},
	},

	-- LOW TIER PISTOL START
	pistol = {
		result = { name = "WEAPON_PISTOL", count = 1 },
		items = {
			{ name = "ironbar", count = 350 },
			{ name = "rubber", count = 350 },
			{ name = "heavy_glue", count = 350 },
			{ name = "plastic", count = 350 },
			{ name = "copperwire", count = 350 },
		},
	},
	combatpistol = {
		result = { name = "WEAPON_COMBATPISTOL", count = 1 },
		items = {
			{ name = "ironbar", count = 350 },
			{ name = "rubber", count = 350 },
			{ name = "heavy_glue", count = 350 },
			{ name = "plastic", count = 350 },
			{ name = "copperwire", count = 350 },
		},
	},
	fnx = {
		result = { name = "WEAPON_FNX45", count = 1 },
		items = {
			{ name = "ironbar", count = 350 },
			{ name = "rubber", count = 350 },
			{ name = "heavy_glue", count = 350 },
			{ name = "plastic", count = 350 },
			{ name = "copperwire", count = 350 },
		},
	},
	-- LOW TIER PISTOL END

	-- MID TIER PISTOL START
	fiveseven = {
		result = { name = "WEAPON_FIVESEVEN", count = 1 },
		items = {
			{ name = "ironbar", count = 600 },
			{ name = "rubber", count = 600 },
			{ name = "heavy_glue", count = 600 },
			{ name = "plastic", count = 600 },
			{ name = "copperwire", count = 600 },
		},
	},
	sns = {
		result = { name = "WEAPON_SNSPISTOL", count = 1 },
		items = {
			{ name = "ironbar", count = 600 },
			{ name = "rubber", count = 600 },
			{ name = "heavy_glue", count = 600 },
			{ name = "plastic", count = 600 },
			{ name = "copperwire", count = 600 },
		},
	},
	snsmk2 = {
		result = { name = "WEAPON_SNSPISTOL_MK2", count = 1 },
		items = {
			{ name = "ironbar", count = 600 },
			{ name = "rubber", count = 600 },
			{ name = "heavy_glue", count = 600 },
			{ name = "plastic", count = 600 },
			{ name = "copperwire", count = 600 },
		},
	},
	glock = {
		result = { name = "WEAPON_GLOCK19_CIV", count = 1 },
		items = {
			{ name = "ironbar", count = 600 },
			{ name = "rubber", count = 600 },
			{ name = "heavy_glue", count = 600 },
			{ name = "plastic", count = 600 },
			{ name = "copperwire", count = 600 },
		},
	},
	tact2011 = {
		result = { name = "WEAPON_2011", count = 1 },
		items = {
			{ name = "ironbar", count = 600 },
			{ name = "rubber", count = 600 },
			{ name = "heavy_glue", count = 600 },
			{ name = "plastic", count = 600 },
			{ name = "copperwire", count = 600 },
		},
	},
	m9a3 = {
		result = { name = "WEAPON_FM1_M9A3", count = 1 },
		items = {
			{ name = "ironbar", count = 600 },
			{ name = "rubber", count = 600 },
			{ name = "heavy_glue", count = 600 },
			{ name = "plastic", count = 600 },
			{ name = "copperwire", count = 600 },
		},
	},
	p226 = {
		result = { name = "WEAPON_FM1_P226", count = 1 },
		items = {
			{ name = "ironbar", count = 600 },
			{ name = "rubber", count = 600 },
			{ name = "heavy_glue", count = 600 },
			{ name = "plastic", count = 600 },
			{ name = "copperwire", count = 600 },
		},
	},
	heavypistol = {
		result = { name = "WEAPON_HEAVYPISTOL", count = 1 },
		items = {
			{ name = "ironbar", count = 600 },
			{ name = "rubber", count = 600 },
			{ name = "heavy_glue", count = 600 },
			{ name = "plastic", count = 600 },
			{ name = "copperwire", count = 600 },
		},
	},
	doubleaction = {
		result = { name = "WEAPON_DOUBLEACTION", count = 1 },
		items = {
			{ name = "ironbar", count = 600 },
			{ name = "rubber", count = 600 },
			{ name = "heavy_glue", count = 600 },
			{ name = "plastic", count = 600 },
			{ name = "copperwire", count = 600 },
		},
	},
	snubnose38 = {
		result = { name = "WEAPON_38SNUBNOSE3", count = 1 },
		items = {
			{ name = "ironbar", count = 600 },
			{ name = "rubber", count = 600 },
			{ name = "heavy_glue", count = 600 },
			{ name = "plastic", count = 600 },
			{ name = "copperwire", count = 600 },
		},
	},
	custom38 = {
		result = { name = "WEAPON_38SPECIAL", count = 1 },
		items = {
			{ name = "ironbar", count = 600 },
			{ name = "rubber", count = 600 },
			{ name = "heavy_glue", count = 600 },
			{ name = "plastic", count = 600 },
			{ name = "copperwire", count = 600 },
		},
	},
	-- MID TIER PISTOL END

	-- HIGH TIER PISTOL START
	l5 = {
		result = { name = "WEAPON_L5", count = 1 },
		items = {
			{ name = "ironbar", count = 1350 },
			{ name = "rubber", count = 1350 },
			{ name = "heavy_glue", count = 1350 },
			{ name = "plastic", count = 1350 },
			{ name = "copperwire", count = 1350 },
		},
		--cooldown = 1000 * 60 * 60 * 4,
	},
	deagle = {
		result = { name = "WEAPON_PISTOL50", count = 1 },
		items = {
			{ name = "ironbar", count = 1350 },
			{ name = "rubber", count = 1350 },
			{ name = "heavy_glue", count = 1350 },
			{ name = "plastic", count = 1350 },
			{ name = "copperwire", count = 1350 },
		},
		-- cooldown = 1000 * 60 * 60 * 4,
	},
	revolver = {
		result = { name = "WEAPON_REVOLVER", count = 1 },
		items = {
			{ name = "ironbar", count = 1350 },
			{ name = "rubber", count = 1350 },
			{ name = "heavy_glue", count = 1350 },
			{ name = "plastic", count = 1350 },
			{ name = "copperwire", count = 1350 },
		},
		-- cooldown = 1000 * 60 * 60 * 4,
	},
	magnum = {
		result = { name = "WEAPON_44MAGNUM", count = 1 },
		items = {
			{ name = "ironbar", count = 1350 },
			{ name = "rubber", count = 1350 },
			{ name = "heavy_glue", count = 1350 },
			{ name = "plastic", count = 1350 },
			{ name = "copperwire", count = 1350 },
		},
		-- cooldown = 1000 * 60 * 60 * 4,
	},
	-- HIGH TIER PISTOL END

	-- LOW TIER SMG START
	mp5 = {
		result = { name = "WEAPON_MP5", count = 1 },
		items = {
			{ name = "refined_iron", count = 3 },
			{ name = "refined_rubber", count = 3 },
			{ name = "refined_glue", count = 3 },
			{ name = "refined_plastic", count = 3 },
			{ name = "refined_copper", count = 3 },
		},
		cooldown = 1000 * 60 * 30,
	},
	smg = {
		result = { name = "WEAPON_SMG", count = 1 },
		items = {
			{ name = "refined_iron", count = 3 },
			{ name = "refined_rubber", count = 3 },
			{ name = "refined_glue", count = 3 },
			{ name = "refined_plastic", count = 3 },
			{ name = "refined_copper", count = 3 },
		},
		cooldown = 1000 * 60 * 30,
	},
	microsmg = {
		result = { name = "WEAPON_MICROSMG", count = 1 },
		items = {
			{ name = "refined_iron", count = 3 },
			{ name = "refined_rubber", count = 3 },
			{ name = "refined_glue", count = 3 },
			{ name = "refined_plastic", count = 3 },
			{ name = "refined_copper", count = 3 },
		},
		cooldown = 1000 * 60 * 30,
	},
	tommygun = {
		result = { name = "WEAPON_GUSENBERG", count = 1 },
		items = {
			{ name = "refined_iron", count = 3 },
			{ name = "refined_rubber", count = 3 },
			{ name = "refined_glue", count = 3 },
			{ name = "refined_plastic", count = 3 },
			{ name = "refined_copper", count = 3 },
		},
		cooldown = 1000 * 60 * 30,
	},
	-- LOW TIER SMG END

	-- MID TIER SMG START
	smgmk2 = {
		result = { name = "WEAPON_SMG_MK2", count = 1 },
		items = {
			{ name = "refined_iron", count = 5 },
			{ name = "refined_rubber", count = 5 },
			{ name = "refined_glue", count = 5 },
			{ name = "refined_plastic", count = 5 },
			{ name = "refined_copper", count = 5 },
		},
		cooldown = 1000 * 60 * 30,
	},
	mpx = {
		result = { name = "WEAPON_MPX", count = 1 },
		items = {
			{ name = "refined_iron", count = 5 },
			{ name = "refined_rubber", count = 5 },
			{ name = "refined_glue", count = 5 },
			{ name = "refined_plastic", count = 5 },
			{ name = "refined_copper", count = 5 },
		},
		cooldown = 1000 * 60 * 30,
	},
	pp19 = {
		result = { name = "WEAPON_PP19", count = 1 },
		items = {
			{ name = "refined_iron", count = 5 },
			{ name = "refined_rubber", count = 5 },
			{ name = "refined_glue", count = 5 },
			{ name = "refined_plastic", count = 5 },
			{ name = "refined_copper", count = 5 },
		},
		cooldown = 1000 * 60 * 30,
	},
	ump = {
		result = { name = "WEAPON_HKUMP", count = 1 },
		items = {
			{ name = "refined_iron", count = 5 },
			{ name = "refined_rubber", count = 5 },
			{ name = "refined_glue", count = 5 },
			{ name = "refined_plastic", count = 5 },
			{ name = "refined_copper", count = 5 },
		},
		cooldown = 1000 * 60 * 30,
	},
	p90 = {
		result = { name = "WEAPON_P90FM", count = 1 },
		items = {
			{ name = "refined_iron", count = 5 },
			{ name = "refined_rubber", count = 5 },
			{ name = "refined_glue", count = 5 },
			{ name = "refined_plastic", count = 5 },
			{ name = "refined_copper", count = 5 },
		},
		cooldown = 1000 * 60 * 30,
	},
	-- MID TIER SMG END

	-- HIGH TIER SMG START
	miniuzi = {
		result = { name = "WEAPON_MINIUZI", count = 1 },
		items = {
			{ name = "refined_iron", count = 7 },
			{ name = "refined_rubber", count = 7 },
			{ name = "refined_glue", count = 7 },
			{ name = "refined_plastic", count = 7 },
			{ name = "refined_copper", count = 7 },
		},
		cooldown = 1000 * 60 * 30,
	},
	mp9 = {
		result = { name = "WEAPON_MP9A", count = 1 },
		items = {
			{ name = "refined_iron", count = 7 },
			{ name = "refined_rubber", count = 7 },
			{ name = "refined_glue", count = 7 },
			{ name = "refined_plastic", count = 7 },
			{ name = "refined_copper", count = 7 },
		},
		cooldown = 1000 * 60 * 30,
	},
	vector = {
		result = { name = "WEAPON_VECTOR", count = 1 },
		items = {
			{ name = "refined_iron", count = 7 },
			{ name = "refined_rubber", count = 7 },
			{ name = "refined_glue", count = 7 },
			{ name = "refined_plastic", count = 7 },
			{ name = "refined_copper", count = 7 },
		},
		cooldown = 1000 * 60 * 30,
	},
	appistol = {
		result = { name = "WEAPON_APPISTOL", count = 1 },
		items = {
			{ name = "refined_iron", count = 7 },
			{ name = "refined_rubber", count = 7 },
			{ name = "refined_glue", count = 7 },
			{ name = "refined_plastic", count = 7 },
			{ name = "refined_copper", count = 7 },
		},
		cooldown = 1000 * 60 * 60 * 24,
	},
	tec9 = {
		result = { name = "WEAPON_MACHINEPISTOL", count = 1 },
		items = {
			{ name = "refined_iron", count = 7 },
			{ name = "refined_rubber", count = 7 },
			{ name = "refined_glue", count = 7 },
			{ name = "refined_plastic", count = 7 },
			{ name = "refined_copper", count = 7 },
		},
		cooldown = 1000 * 60 * 60 * 24,
	},
	-- HIGH TIER SMG END

	-- LOW TIER AR START
	draco = {
		result = { name = "WEAPON_COMPACTRIFLE", count = 1 },
		items = {
			{ name = "refined_iron", count = 7 },
			{ name = "refined_rubber", count = 7 },
			{ name = "refined_glue", count = 7 },
			{ name = "refined_plastic", count = 7 },
			{ name = "refined_copper", count = 7 },
		},
		cooldown = 1000 * 60 * 60,
	},
	hk16a = {
		result = { name = "WEAPON_FM1_HK416", count = 1 },
		items = {
			{ name = "refined_iron", count = 7 },
			{ name = "refined_rubber", count = 7 },
			{ name = "refined_glue", count = 7 },
			{ name = "refined_plastic", count = 7 },
			{ name = "refined_copper", count = 7 },
		},
		cooldown = 1000 * 60 * 60,
	},
	hk16b = {
		result = { name = "WEAPON_FM1_HK416", count = 1 },
		items = {
			{ name = "refined_iron", count = 7 },
			{ name = "refined_rubber", count = 7 },
			{ name = "refined_glue", count = 7 },
			{ name = "refined_plastic", count = 7 },
			{ name = "refined_copper", count = 7 },
		},
		cooldown = 1000 * 60 * 60,
	},
	ar = {
		result = { name = "WEAPON_ASSAULTRIFLE", count = 1 },
		items = {
			{ name = "refined_iron", count = 7 },
			{ name = "refined_rubber", count = 7 },
			{ name = "refined_glue", count = 7 },
			{ name = "refined_plastic", count = 7 },
			{ name = "refined_copper", count = 7 },
		},
		cooldown = 1000 * 60 * 60,
	},
	mcxspear = {
		result = { name = "WEAPON_MCXSPEAR", count = 1 },
		items = {
			{ name = "refined_iron", count = 7 },
			{ name = "refined_rubber", count = 7 },
			{ name = "refined_glue", count = 7 },
			{ name = "refined_plastic", count = 7 },
			{ name = "refined_copper", count = 7 },
		},
		cooldown = 1000 * 60 * 60,
	},
	-- LOW TIER AR END

	-- MID TIER AR START
	mcxrattler = {
		result = { name = "WEAPON_MCXRATTLER", count = 1 },
		items = {
			{ name = "refined_iron", count = 10 },
			{ name = "refined_rubber", count = 10 },
			{ name = "refined_glue", count = 10 },
			{ name = "refined_plastic", count = 10 },
			{ name = "refined_copper", count = 10 },
		},
		cooldown = 1000 * 60 * 60,
	},
	advrifle = {
		result = { name = "WEAPON_ADVANCEDRIFLE", count = 1 },
		items = {
			{ name = "refined_iron", count = 10 },
			{ name = "refined_rubber", count = 10 },
			{ name = "refined_glue", count = 10 },
			{ name = "refined_plastic", count = 10 },
			{ name = "refined_copper", count = 10 },
		},
		cooldown = 1000 * 60 * 60,
	},
	asval = {
		result = { name = "WEAPON_ASVAL", count = 1 },
		items = {
			{ name = "refined_iron", count = 10 },
			{ name = "refined_rubber", count = 10 },
			{ name = "refined_glue", count = 10 },
			{ name = "refined_plastic", count = 10 },
			{ name = "refined_copper", count = 10 },
		},
		cooldown = 1000 * 60 * 60,
	},
	nsr9 = {
		result = { name = "WEAPON_NSR9", count = 1 },
		items = {
			{ name = "refined_iron", count = 10 },
			{ name = "refined_rubber", count = 10 },
			{ name = "refined_glue", count = 10 },
			{ name = "refined_plastic", count = 10 },
			{ name = "refined_copper", count = 10 },
		},
		cooldown = 1000 * 60 * 60,
	},
	g36 = {
		result = { name = "WEAPON_G36", count = 1 },
		items = {
			{ name = "refined_iron", count = 10 },
			{ name = "refined_rubber", count = 10 },
			{ name = "refined_glue", count = 10 },
			{ name = "refined_plastic", count = 10 },
			{ name = "refined_copper", count = 10 },
		},
		cooldown = 1000 * 60 * 60,
	},
	-- MID TIER AR END

	-- HIGH TIER AR START
	ak74 = {
		result = { name = "WEAPON_AK74", count = 1 },
		items = {
			{ name = "refined_iron", count = 20 },
			{ name = "refined_rubber", count = 20 },
			{ name = "refined_glue", count = 20 },
			{ name = "refined_plastic", count = 20 },
			{ name = "refined_copper", count = 20 },
		},
		cooldown = 1000 * 60 * 60,
	},
	ar15 = {
		result = { name = "WEAPON_AR15", count = 1 },
		items = {
			{ name = "refined_iron", count = 20 },
			{ name = "refined_rubber", count = 20 },
			{ name = "refined_glue", count = 20 },
			{ name = "refined_plastic", count = 20 },
			{ name = "refined_copper", count = 20 },
		},
		cooldown = 1000 * 60 * 60,
	},
	rpk = {
		result = { name = "WEAPON_RPK16", count = 1 },
		items = {
			{ name = "refined_iron", count = 20 },
			{ name = "refined_rubber", count = 20 },
			{ name = "refined_glue", count = 20 },
			{ name = "refined_plastic", count = 20 },
			{ name = "refined_copper", count = 20 },
		},
		cooldown = 1000 * 60 * 60,
	},
	honeybadger = {
		result = { name = "WEAPON_FM1_HONEYBADGER", count = 1 },
		items = {
			{ name = "refined_iron", count = 20 },
			{ name = "refined_rubber", count = 20 },
			{ name = "refined_glue", count = 20 },
			{ name = "refined_plastic", count = 20 },
			{ name = "refined_copper", count = 20 },
		},
		cooldown = 1000 * 60 * 60,
	},
	hk417 = {
		result = { name = "WEAPON_HK417", count = 1 },
		items = {
			{ name = "refined_iron", count = 20 },
			{ name = "refined_rubber", count = 20 },
			{ name = "refined_glue", count = 20 },
			{ name = "refined_plastic", count = 20 },
			{ name = "refined_copper", count = 20 },
		},
		cooldown = 1000 * 60 * 60,
	},
	mk47mutant = {
		result = { name = "WEAPON_MK47FM", count = 1 },
		items = {
			{ name = "refined_iron", count = 20 },
			{ name = "refined_rubber", count = 20 },
			{ name = "refined_glue", count = 20 },
			{ name = "refined_plastic", count = 20 },
			{ name = "refined_copper", count = 20 },
		},
		cooldown = 1000 * 60 * 60,
	},
	mk47a = {
		result = { name = "WEAPON_MK47BANSHEE2", count = 1 },
		items = {
			{ name = "refined_iron", count = 20 },
			{ name = "refined_rubber", count = 20 },
			{ name = "refined_glue", count = 20 },
			{ name = "refined_plastic", count = 20 },
			{ name = "refined_copper", count = 20 },
		},
		cooldown = 1000 * 60 * 60,
	},
	mk47s = {
		result = { name = "WEAPON_MK47BANSHEE", count = 1 },
		items = {
			{ name = "refined_iron", count = 20 },
			{ name = "refined_rubber", count = 20 },
			{ name = "refined_glue", count = 20 },
			{ name = "refined_plastic", count = 20 },
			{ name = "refined_copper", count = 20 },
		},
		cooldown = 1000 * 60 * 60,
	},
	rfb = {
		result = { name = "WEAPON_RFB", count = 1 },
		items = {
			{ name = "refined_iron", count = 20 },
			{ name = "refined_rubber", count = 20 },
			{ name = "refined_glue", count = 20 },
			{ name = "refined_plastic", count = 20 },
			{ name = "refined_copper", count = 20 },
		},
		cooldown = 1000 * 60 * 60,
	},
	-- HIGH TIER AR END
}
