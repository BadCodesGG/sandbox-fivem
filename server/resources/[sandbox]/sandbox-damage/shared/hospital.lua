Config = Config or {}

Config.ICUBeds = {
	-- -- Mt Zonah ICU
	-- vector4(-484.631, -329.334, 69.523, 352.380),
	-- vector4(-483.648, -341.486, 69.523, 178.489),
	-- vector4(-477.289, -330.050, 69.523, 1.676),
	-- vector4(-476.180, -342.179, 69.523, 179.781),
	-- vector4(-469.840, -331.163, 69.523, 1.152),
	-- vector4(-468.668, -343.538, 69.523, 181.606),
	-- vector4(-462.200, -332.150, 69.521, 4.846),
	-- vector4(-461.303, -344.223, 69.523, 174.951),
	-- vector4(-445.279, -346.800, 69.523, 176.390),
	-- vector4(-435.775, -336.701, 69.523, 274.043),

	-- Pillbox ICU
	-- vector4(359.54, -586.23, 42.84, 250.00),
	-- vector4(361.36, -581.30, 42.83, 250.00),
	-- vector4(354.44, -600.19, 42.85, 250.00),
	-- vector4(363.80, -589.12, 42.85, 250.00),
	-- vector4(364.96, -585.94, 42.85, 250.00),
	-- vector4(366.52, -581.66, 42.85, 250.00),

	-- St. Fiacre

	vector4(1153.138, -1554.661, 39.537, 128.510), -- W2
	vector4(1153.051, -1549.002, 39.537, 114.474), -- W4
	vector4(1153.272, -1543.038, 39.537, 112.909), -- W6
}

Config.BedPolys = {
	{ -- medical room in prison
		center = vector3(1770.22, 2586.29, 45.73),
		length = 2.2,
		width = 0.7,
		options = {
			heading = 1,
			--debugPoly=true,
			minZ = 43.53,
			maxZ = 47.53,
		},
		laydown = vector4(1770.195, 2586.559, 46.803, 181.507),
	},
	{
		center = vector3(-441.25, -303.29, 34.91),
		length = 1.0,
		width = 2.8,
		options = {
			heading = 25,
			--debugPoly=true,
			minZ = 33.91,
			maxZ = 34.91,
		},
		laydown = vector4(-441.079, -303.129, 35.780, 113.386),
	},
	{
		center = vector3(-447.17, -291.22, 35.81),
		length = 1.0,
		width = 2.8,
		options = {
			heading = 25,
			--debugPoly=true,
			minZ = 33.96,
			maxZ = 34.96,
		},
		laydown = vector4(-446.780, -291.055, 35.812, 110.598),
	},
	{
		center = vector3(-464.63, -295.38, 35.68),
		length = 1.0,
		width = 2.8,
		options = {
			heading = 20,
			--debugPoly=true,
			minZ = 33.83,
			maxZ = 34.83,
		},
		laydown = vector4(-464.627, -295.382, 35.676, 108.281),
	},
	{
		center = vector3(-462.23, -301.42, 35.68),
		length = 1.0,
		width = 2.8,
		options = {
			heading = 20,
			--debugPoly=true,
			minZ = 33.83,
			maxZ = 34.83,
		},
		laydown = vector4(-462.232, -301.422, 35.683, 105.833),
	},
	{
		center = vector3(-459.83, -306.67, 35.57),
		length = 1.0,
		width = 2.8,
		options = {
			heading = 20,
			--debugPoly=true,
			minZ = 33.83,
			maxZ = 34.83,
		},
		laydown = vector4(-459.833, -306.669, 35.567, 110.890),
	},
	{
		center = vector3(-456.0, -315.63, 35.68),
		length = 1.0,
		width = 2.8,
		options = {
			heading = 20,
			--debugPoly=true,
			minZ = 33.83,
			maxZ = 34.83,
		},
		laydown = vector4(-455.772, -315.531, 35.684, 111.440),
	},
	{
		center = vector3(-450.43, -323.06, 35.69),
		length = 1.0,
		width = 2.8,
		options = {
			heading = 0,
			--debugPoly=true,
			minZ = 33.84,
			maxZ = 34.84,
		},
		laydown = vector4(-450.418, -322.993, 35.688, 90.981),
	},

	-- PB HOSPITAL
	-- { -- #1
	-- 	center = vector3(307.78, -581.73, 43.28),
	-- 	length = 2.6,
	-- 	width = 1.4,
	-- 	options = {
	-- 		heading = 340.0,
	-- 		--debugPoly=true,
	-- 		minZ = 41.84,
	-- 		maxZ = 45.84,
	-- 	},
	-- 	laydown = vector4(307.680, -581.889, 44.204, 338.434),
	-- },

	-- { -- #2
	-- 	center = vector3(309.35, -577.41, 43.28),
	-- 	length = 2.6,
	-- 	width = 1.4,
	-- 	options = {
	-- 		heading = 340.0,
	-- 		--debugPoly=true,
	-- 		minZ = 41.84,
	-- 		maxZ = 45.84,
	-- 	},
	-- 	laydown = vector4(309.276, -577.288, 44.204, 156.354),
	-- },
	-- { -- #3
	-- 	center = vector3(311.07, -582.95, 43.28),
	-- 	length = 2.6,
	-- 	width = 1.4,
	-- 	options = {
	-- 		heading = 340.0,
	-- 		--debugPoly=true,
	-- 		minZ = 41.84,
	-- 		maxZ = 45.84,
	-- 	},
	-- 	laydown = vector4(311.103, -583.040, 44.204, 343.041),
	-- },
	-- { -- #4
	-- 	center = vector3(313.86, -579.05, 43.28),
	-- 	length = 2.6,
	-- 	width = 1.4,
	-- 	options = {
	-- 		heading = 340.0,
	-- 		--debugPoly=true,
	-- 		minZ = 41.84,
	-- 		maxZ = 45.84,
	-- 	},
	-- 	laydown = vector4(313.868, -579.052, 44.204, 160.074),
	-- },
	-- { -- #5
	-- 	center = vector3(314.54, -584.16, 43.28),
	-- 	length = 2.6,
	-- 	width = 1.4,
	-- 	options = {
	-- 		heading = 340.0,
	-- 		--debugPoly=true,
	-- 		minZ = 41.84,
	-- 		maxZ = 45.84,
	-- 	},
	-- 	laydown = vector4(314.526, -584.377, 44.204, 339.496),
	-- },
	-- { -- #6
	-- 	center = vector3(319.4, -581.02, 43.28),
	-- 	length = 2.6,
	-- 	width = 1.4,
	-- 	options = {
	-- 		heading = 340.0,
	-- 		--debugPoly=true,
	-- 		minZ = 41.84,
	-- 		maxZ = 45.84,
	-- 	},
	-- 	laydown = vector4(319.396, -580.935, 44.204, 151.998),
	-- },
	-- { -- #7
	-- 	center = vector3(317.76, -585.29, 43.28),
	-- 	length = 2.6,
	-- 	width = 1.4,
	-- 	options = {
	-- 		heading = 340.0,
	-- 		--debugPoly=true,
	-- 		minZ = 41.84,
	-- 		maxZ = 45.84,
	-- 	},
	-- 	laydown = vector4(317.636, -585.597, 44.204, 339.229),
	-- },
	-- { -- #8
	-- 	center = vector3(324.21, -582.89, 43.28),
	-- 	length = 2.6,
	-- 	width = 1.4,
	-- 	options = {
	-- 		heading = 340.0,
	-- 		--debugPoly=true,
	-- 		minZ = 41.84,
	-- 		maxZ = 45.84,
	-- 	},
	-- 	laydown = vector4(324.329, -582.686, 44.204, 151.998),
	-- },
	-- { -- #9
	-- 	center = vector3(322.71, -587.11, 43.28),
	-- 	length = 2.6,
	-- 	width = 1.4,
	-- 	options = {
	-- 		heading = 340.0,
	-- 		--debugPoly=true,
	-- 		minZ = 41.84,
	-- 		maxZ = 45.84,
	-- 	},
	-- 	laydown = vector4(322.617, -587.217, 44.204, 335.997),
	-- },

	-- St. Farcre Beds
	{ -- Xray #2
		center = vector3(1137.45, -1546.16, 39.5),
		length = 1.4,
		width = 2.6,
		options = {
			heading = 0.0,
			--debugPoly=true,
			minZ = 36.3,
			maxZ = 40.3,
		},
		laydown = vector4(1137.386, -1545.998, 40.238, 87.460),
	},
	{ -- Xray #1
		center = vector3(1138.47, -1557.61, 39.5),
		length = 1.4,
		width = 2.6,
		options = {
			heading = 0.0,
			--debugPoly=true,
			minZ = 36.3,
			maxZ = 40.3,
		},
		laydown = vector4(1138.484, -1557.521, 40.475, 87.689),
	},
	{ -- Surgery #2
		center = vector3(1126.05, -1576.17, 35.03),
		length = 1.4,
		width = 2.6,
		options = {
			heading = 0.0,
			--debugPoly=true,
			minZ = 31.83,
			maxZ = 35.83,
		},
		laydown = vector4(1125.844, -1576.185, 35.751, 270.227),
	},
	{ -- Surgery #1
		center = vector3(1125.93, -1570.28, 35.03),
		length = 1.4,
		width = 2.6,
		options = {
			heading = 0.0,
			--debugPoly=true,
			minZ = 31.83,
			maxZ = 35.83,
		},
		laydown = vector4(1125.778, -1570.340, 35.760, 266.666),
	},
	{ -- Morgue #1
		center = vector3(1146.23, -1575.69, 35.03),
		length = 1.4,
		width = 2.8,
		options = {
			heading = 270.0,
			--debugPoly=true,
			minZ = 31.83,
			maxZ = 35.83,
		},
		laydown = vector4(1146.236, -1575.540, 36.019, 357.402),
	},
	{ -- Morgue #2
		center = vector3(1149.21, -1575.68, 35.03),
		length = 1.4,
		width = 2.8,
		options = {
			heading = 270.0,
			--debugPoly=true,
			minZ = 31.83,
			maxZ = 35.83,
		},
		laydown = vector4(1149.254, -1575.510, 36.019, 356.960),
	},
}

Config.BedModels = {
	`v_med_bed1`,
	`v_med_bed2`,
	`v_med_emptybed`,
	-- `gabz_pillbox_diagnostics_bed_01`,
	-- `gabz_pillbox_diagnostics_bed_02`,
	-- `gabz_pillbox_diagnostics_bed_03`,
}

Config.Beds = {
	-- St Fiacre
	-- General Ward
	{ x = 1124.827, y = -1554.571, z = 34.948, h = 360.000 },
	{ x = 1121.361, y = -1554.540, z = 34.948, h = 360.000 },
	{ x = 1117.835, y = -1554.577, z = 34.948, h = 360.000 },
	{ x = 1124.759, y = -1563.141, z = 34.949, h = 180.000 },
	{ x = 1121.337, y = -1563.125, z = 34.947, h = 180.000 },
	{ x = 1117.877, y = -1563.128, z = 34.948, h = 180.000 },
	-- Mt Zonah
	-- { x = -448.375, y = -283.771, z = 33.94, h = 203.0 },
	-- { x = -451.535, y = -285.083, z = 33.94, h = 203.0 },
	-- { x = -455.114, y = -278.044, z = 33.94, h = 23.0 },
	-- { x = -454.916, y = -286.475, z = 33.94, h = 203.0 },
	-- { x = -459.004, y = -279.650, z = 33.94, h = 23.0 },
	-- { x = -460.287, y = -288.666, z = 33.94, h = 203.0 },
	-- { x = -462.747, y = -281.232, z = 33.94, h = 23.0 },
	-- { x = -463.686, y = -290.074, z = 33.94, h = 203.0 },
	-- { x = -466.501, y = -282.755, z = 33.94, h = 23.0 },
	-- { x = -466.987, y = -291.403, z = 33.94, h = 203.0 },
	-- { x = -469.906, y = -284.189, z = 33.94, h = 23.0 },
	-- { x = -448.980, y = -303.591, z = 33.94, h = 205.0 },
	-- Pillbox beds, JUST IN FUCKING CASE
	-- { x = 309.35, y = -577.38, z = 42.84, h = 340.00 },
	-- { x = 307.72, y = -581.75, z = 42.84, h = 160.00 },
	-- { x = 313.93, y = -579.04, z = 42.84, h = 340.00 },
	-- { x = 311.06, y = -582.96, z = 42.84, h = 160.00 },
	-- { x = 314.47, y = -584.20, z = 42.84, h = 160.00 },
	-- { x = 319.41, y = -581.04, z = 42.84, h = 340.00 },
	-- { x = 317.67, y = -585.37, z = 42.84, h = 160.00 },
	-- { x = 324.26, y = -582.80, z = 42.84, h = 340.00 },
	-- { x = 322.62, y = -587.17, z = 42.84, h = 160.00 },

	-- { x = 357.55, y = -598.16, z = 42.84, h = 160.00 },
	-- { x = 354.18, y = -593.00, z = 42.84, h = 250.00 },
	-- { x = 346.48, y = -590.33, z = 42.84, h = 70.00 },
	-- { x = 359.54, y = -586.23, z = 42.84, h = 250.00 },
	-- { x = 361.36, y = -581.30, z = 42.83, h = 250.00 },
	-- { x = 354.44, y = -600.19, z = 42.85, h = 250.00 },
	-- { x = 363.80, y = -589.12, z = 42.85, h = 250.00 },
	-- { x = 364.96, y = -585.94, z = 42.85, h = 250.00 },
	-- { x = 366.52, y = -581.66, z = 42.85, h = 250.00 },
	-- { x = 357.55, y = -598.16, z = 42.84, h = 160.00 },
	-- { x = 354.18, y = -593.00, z = 42.84, h = 250.00 },
	-- { x = 346.48, y = -590.33, z = 42.84, h = 70.00 },

	-- { x = 321.9, y = -585.86, z = 43.29, h = 193.55 },
	-- { x = 318.56, y = -580.69, z = 43.29, h = 245.66 },
	-- { x = 316.87, y = -584.93, z = 43.29, h = 247.1 },
	-- { x = 313.56, y = -583.83, z = 43.29, h = 250.0 },
	-- { x = 314.91, y = -579.39, z = 43.29, h = 68.7 },
	-- { x = 312.01, y = -583.34, z = 43.29, h = 66.16 },
}
