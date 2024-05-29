BC_SERVER_START_WAIT = 1000 * 60 * math.random(60, 120)
BC_REQUIRED_POLICE = 4

BC_RESET_TIME = 60 * 60 * 8

_bobcatSchems = {
	"schematic_fnx",
	"schematic_combat_pistol",
	"schematic_57",
	"schematic_snsmk2",
	"schematic_glock",
	"schematic_m9a3",
	"schematic_tact2011",
	"schematic_p226",
	"schematic_deagle",
	"schematic_l5",
	"schematic_revolver",
	"schematic_38_snubnose",
	"schematic_38_custom",
	"schematic_44_magnum",
	"schematic_mp5",
}

_bobcatC2Schems = {
	"schematic_microsmg",
	"schematic_mp9",
	"schematic_miniuzi",
}

_bobcatCombined = {
	"schematic_fnx",
	"schematic_combat_pistol",
	"schematic_57",
	"schematic_snsmk2",
	"schematic_glock",
	"schematic_m9a3",
	"schematic_tact2011",
	"schematic_p226",
	"schematic_deagle",
	"schematic_l5",
	"schematic_revolver",
	"schematic_38_snubnose",
	"schematic_38_custom",
	"schematic_44_magnum",
	"schematic_mp5",
	"schematic_microsmg",
	"schematic_mp9",
	"schematic_miniuzi",
}

_bobcatAttchSchems = {
	"schematic_smg_ammo",
	"schematic_weapon_flashlight",
	"schematic_pistol_ext_mag",
	"schematic_smg_ext_mag",
	"schematic_pistol_suppressor",
	"schematic_smg_suppressor",
}

_bobcatLootTable = {
	["guns"] = {
		{
			10,
			{
				name = "BOBCAT_38SNUBNOSE2",
				min = 1,
				max = 1,
				metadata = { ammo = 100, clip = 0, Company = { name = "Bobcat Security", stolen = true } },
			},
		},
		{
			10,
			{
				name = "BOBCAT_38SNUBNOSE3",
				min = 1,
				max = 1,
				metadata = { ammo = 100, clip = 0, Company = { name = "Bobcat Security", stolen = true } },
			},
		},
		{
			10,
			{
				name = "BOBCAT_57",
				min = 1,
				max = 1,
				metadata = { ammo = 100, clip = 0, Company = { name = "Bobcat Security", stolen = true } },
			},
		},
		{
			10,
			{
				name = "BOBCAT_SNSPISTOL",
				min = 1,
				max = 1,
				metadata = { ammo = 100, clip = 0, Company = { name = "Bobcat Security", stolen = true } },
			},
		},
		{
			10,
			{
				name = "BOBCAT_P226",
				min = 1,
				max = 1,
				metadata = { ammo = 100, clip = 0, Company = { name = "Bobcat Security", stolen = true } },
			},
		},
		{
			10,
			{
				name = "BOBCAT_M9A3",
				min = 1,
				max = 1,
				metadata = { ammo = 100, clip = 0, Company = { name = "Bobcat Security", stolen = true } },
			},
		},
		{
			10,
			{
				name = "BOBCAT_2011",
				min = 1,
				max = 1,
				metadata = { ammo = 100, clip = 0, Company = { name = "Bobcat Security", stolen = true } },
			},
		},
		{
			10,
			{
				name = "BOBCAT_GLOCK19_CIV",
				min = 1,
				max = 1,
				metadata = { ammo = 100, clip = 0, Company = { name = "Bobcat Security", stolen = true } },
			},
		},
		{
			5,
			{
				name = "BOBCAT_DOUBLEACTION",
				min = 1,
				max = 1,
				metadata = { ammo = 100, clip = 0, Company = { name = "Bobcat Security", stolen = true } },
			},
		},
		{
			5,
			{
				name = "WEAPON_L5",
				min = 1,
				max = 1,
				metadata = { ammo = 100, clip = 0, Company = { name = "Bobcat Security", stolen = true } },
			},
		},
		{
			5,
			{
				name = "BOBCAT_PISTOL50",
				min = 1,
				max = 1,
				metadata = { ammo = 100, clip = 0, Company = { name = "Bobcat Security", stolen = true } },
			},
		},
		{
			5,
			{
				name = "BOBCAT_REVOLVER",
				min = 1,
				max = 1,
				metadata = { ammo = 100, clip = 0, Company = { name = "Bobcat Security", stolen = true } },
			},
		},
	},
	["guns-c2"] = {
		{
			22,
			{
				name = "BOBCAT_38SNUBNOSE2",
				min = 1,
				max = 1,
				metadata = { ammo = 100, clip = 0, Company = { name = "Bobcat Security", stolen = true } },
			},
		},
		{
			22,
			{
				name = "BOBCAT_38SNUBNOSE3",
				min = 1,
				max = 1,
				metadata = { ammo = 100, clip = 0, Company = { name = "Bobcat Security", stolen = true } },
			},
		},
		{
			10,
			{
				name = "BOBCAT_38CUSTOM",
				min = 1,
				max = 1,
				metadata = { ammo = 100, clip = 0, Company = { name = "Bobcat Security", stolen = true } },
			},
		},
		{
			10,
			{
				name = "BOBCAT_44MAGNUM",
				min = 1,
				max = 1,
				metadata = { ammo = 100, clip = 0, Company = { name = "Bobcat Security", stolen = true } },
			},
		},
		{
			6,
			{
				name = "BOBCAT_REVOLVER",
				min = 1,
				max = 1,
				metadata = { ammo = 100, clip = 0, Company = { name = "Bobcat Security", stolen = true } },
			},
		},
		{
			6,
			{
				name = "BOBCAT_PISTOL50",
				min = 1,
				max = 1,
				metadata = { ammo = 100, clip = 0, Company = { name = "Bobcat Security", stolen = true } },
			},
		},
		{
			6,
			{
				name = "BOBCAT_L5",
				min = 1,
				max = 1,
				metadata = { ammo = 100, clip = 0, Company = { name = "Bobcat Security", stolen = true } },
			},
		},
		{
			7,
			{
				name = "BOBCAT_PP19",
				min = 1,
				max = 1,
				metadata = { ammo = 100, clip = 0, Company = { name = "Bobcat Security", stolen = true } },
			},
		},
		{
			7,
			{
				name = "BOBCAT_MPX",
				min = 1,
				max = 1,
				metadata = { ammo = 100, clip = 0, Company = { name = "Bobcat Security", stolen = true } },
			},
		},
		{
			2,
			{
				name = "BOBCAT_MP9",
				min = 1,
				max = 1,
				metadata = { ammo = 100, clip = 0, Company = { name = "Bobcat Security", stolen = true } },
			},
		},
		{
			2,
			{
				name = "BOBCAT_MINIUZI",
				min = 1,
				max = 1,
				metadata = { ammo = 100, clip = 0, Company = { name = "Bobcat Security", stolen = true } },
			},
		},
	},
	["components"] = {
		{
			15,
			{
				name = "ATTCH_WEAPON_FLASHLIGHT",
				min = 1,
				max = 1,
			},
		},
		{
			15,
			{
				name = "scuba_gear",
				min = 1,
				max = 1,
			},
		},
		{
			15,
			{
				name = "AMMO_SMG",
				min = 3,
				max = 10,
			},
		},
		{
			15,
			{
				name = "AMMO_SHOTGUN",
				min = 3,
				max = 10,
			},
		},
		{
			10,
			{
				name = "ATTCH_PISTOL_EXT_MAG",
				min = 1,
				max = 1,
			},
		},
		{
			10,
			{
				name = "ATTCH_PISTOL_SILENCER",
				min = 1,
				max = 1,
			},
		},
		{
			10,
			{
				name = "ATTCH_SMG_EXT_MAG",
				min = 1,
				max = 1,
			},
		},
		{
			10,
			{
				name = "ATTCH_SMG_SILENCER",
				min = 1,
				max = 1,
			},
		},
	},
}

_bobcatLocations = {
	extrDoor = {
		coords = vector3(882.174, -2258.287, 30.541),
		heading = 178.102,
	},
	startDoor = {
		coords = vector3(880.3293, -2264.466, 30.59444),
		heading = 178.102,
	},
	securedDoor = {
		coords = vector3(882.976, -2268.013, 30.468),
	},
	vaultDoor = {
		coords = vector3(890.41, -2285.601, 30.467),
		heading = 93.374,
	},
}

_bobcatPedLocs = {
	vector4(883.967, -2276.069, 30.468, 46.108),
	vector4(887.204, -2275.289, 30.468, 78.713),
	vector4(887.706, -2276.708, 30.468, 70.493),
	vector4(890.998, -2276.155, 30.468, 76.662),
	vector4(891.644, -2278.115, 30.468, 61.522),
	vector4(893.985, -2275.837, 30.468, 72.070),
	vector4(894.188, -2278.598, 30.468, 67.238),
	vector4(896.048, -2282.575, 30.468, 39.264),
	vector4(892.170, -2286.094, 30.468, 352.334),
	vector4(893.804, -2284.555, 30.468, 10.603),
	vector4(894.432, -2288.290, 30.468, 1.191),
	vector4(892.147, -2289.318, 30.468, 353.226),
	vector4(893.299, -2292.591, 30.468, 353.592),
	vector4(891.166, -2293.612, 30.468, 343.993),
	vector4(887.185, -2294.485, 30.468, 290.266),
	vector4(884.734, -2291.749, 30.468, 276.584),
	vector4(880.892, -2293.349, 30.468, 272.596),
	vector4(878.148, -2295.895, 30.468, 312.062),
	vector4(876.398, -2290.847, 30.468, 256.690),
	vector4(879.946, -2291.485, 30.468, 265.639),
	vector4(874.683, -2296.097, 30.468, 300.001),
	vector4(877.389, -2295.764, 30.468, 323.910),
	vector4(872.100, -2291.334, 30.468, 259.871),
	vector4(869.719, -2288.677, 30.468, 249.077),
	vector4(868.316, -2288.768, 30.468, 245.280),
	vector4(869.559, -2293.151, 30.468, 282.122),
	vector4(872.193, -2297.360, 30.468, 297.501),
	vector4(874.321, -2294.222, 30.468, 277.020),
	vector4(895.646, -2287.415, 30.468, 13.802),
	vector4(894.001, -2277.819, 30.468, 59.191),
}

_bobcatLootLocs = {
	{
		coords = vector3(881.8, -2282.79, 30.47),
		width = 2.0,
		length = 1.4,
		options = {
			heading = 333,
			-- debugPoly = true,
			minZ = 29.47,
			maxZ = 31.67,
		},
		data = {
			id = 1,
			type = "guns-c2",
			amount = 2,
			bonus = 8,
		},
	},
	{
		coords = vector3(882.55, -2285.82, 30.47),
		width = 1.15,
		length = 1.8,
		options = {
			heading = 341,
			-- debugPoly = true,
			minZ = 29.47,
			maxZ = 31.27,
		},
		data = {
			id = 2,
			type = "guns-c2",
			amount = 2,
			bonus = 8,
		},
	},
	{
		coords = vector3(886.63, -2286.84, 30.59),
		width = 1.4,
		length = 2.0,
		options = {
			heading = 0,
			-- debugPoly = true,
			minZ = 29.59,
			maxZ = 30.99,
		},
		data = {
			id = 3,
			type = "guns",
			amount = 3,
			bonus = 15,
		},
	},
	{
		coords = vector3(887.01, -2282.06, 30.47),
		width = 1.2,
		length = 2.2,
		options = {
			heading = 354,
			-- debugPoly = true,
			minZ = 29.47,
			maxZ = 31.27,
		},
		data = {
			id = 4,
			type = "components",
			amount = 4,
			bonus = 10,
		},
	},
}
