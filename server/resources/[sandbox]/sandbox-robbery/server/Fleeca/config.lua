SERVER_START_WAIT = 1000 * 60 * math.random(60, 90)
REQUIRED_POLICE = 4

RESET_TIME = 60 * 60 * 6

MAX_GATEPC_SEQ_ATTEMPTS = 100

FLEECA_LOCATIONS = {
	fleeca_hawick_east = {
		id = "fleeca_hawick_east",
		label = "East Hawick Ave",
		coords = vector3(311.5, -282.35, 54.16),
		width = 13.2,
		length = 11.6,
		options = {
			name = "fleeca_hawick_east",
			heading = 340,
			minZ = 53.16,
			maxZ = 58.16,
			--debugPoly = true,
		},
		reset = {
			coords = vector3(309.15, -281.37, 54.16),
			length = 0.4,
			width = 0.4,
			options = {
				heading = 340,
				--debugPoly=true,
				minZ = 53.56,
				maxZ = 55.76,
			},
		},
		points = {
			vaultPC = {
				coords = vector3(311.202, -284.257, 54.165),
				heading = 161.541,
			},
			vaultGate = {
				coords = vector3(313.2626, -285.3768, 54.50795),
				heading = 166.280,
			},
		},
		loots = {
			{
				coords = vector3(314.22, -282.97, 54.16),
				width = 0.2,
				length = 2.8,
				options = {
					name = "hawick_east_1",
					heading = 340,
					--debugPoly=true,
					minZ = 53.16,
					maxZ = 55.56,
				},
			},
			{
				coords = vector3(315.77, -285.06, 54.16),
				width = 2.0,
				length = 0.2,
				options = {
					name = "hawick_east_2",
					heading = 339,
					--debugPoly=true,
					minZ = 53.16,
					maxZ = 55.56,
				},
			},
			{
				coords = vector3(315.22, -288.37, 54.16),
				width = 2.95,
				length = 0.2,
				options = {
					name = "hawick_east_3",
					heading = 340,
					--debugPoly=true,
					minZ = 53.16,
					maxZ = 55.56,
				},
			},
			{
				coords = vector3(312.36, -289.4, 54.16),
				width = 0.2,
				length = 3.8,
				options = {
					name = "hawick_east_4",
					heading = 340,
					--debugPoly=true,
					minZ = 53.16,
					maxZ = 55.56,
				},
			},
			{
				coords = vector3(310.86, -286.81, 54.16),
				width = 2.95,
				length = 0.2,
				options = {
					name = "hawick_east_5",
					heading = 339,
					--debugPoly=true,
					minZ = 53.16,
					maxZ = 55.56,
				},
			},
		},
		doors = {
			vaultDoor = {
				object = 2121050683,
				step = -0.60,
				originalHeading = 249.866,
			},
		},
	},
	fleeca_hawick_west = {
		id = "fleeca_hawick_west",
		label = "West Hawick Ave",
		coords = vector3(-353.26, -53.09, 49.04),
		width = 12.4,
		length = 14.0,
		options = {
			name = "fleeca_hawick_west",
			heading = 340,
			minZ = 48.04,
			maxZ = 52.04,
			--debugPoly = true,
		},
		reset = {
			coords = vector3(-356.0, -52.24, 49.04),
			length = 0.4,
			width = 0.4,
			options = {
				heading = 340,
				--debugPoly=true,
				minZ = 48.64,
				maxZ = 50.24,
			},
		},
		points = {
			vaultPC = {
				coords = vector3(-353.713, -54.698, 49.037),
				heading = 160.637,
			},
			vaultGate = {
				coords = vector3(-351.7869, -56.2472, 49.36483),
				heading = 163.485,
			},
		},
		loots = {
			{
				coords = vector3(-350.84, -53.73, 49.04),
				width = 0.45,
				length = 2.95,
				options = {
					name = "hawick_west_1",
					heading = 340,
					--debugPoly=true,
					minZ = 48.04,
					maxZ = 50.44,
				},
			},
			{
				coords = vector3(-349.23, -55.87, 49.04),
				width = 2.0,
				length = 0.2,
				options = {
					name = "hawick_west_2",
					heading = 340,
					--debugPoly=true,
					minZ = 48.04,
					maxZ = 50.44,
				},
			},
			{
				coords = vector3(-349.77, -59.17, 49.04),
				width = 2.95,
				length = 0.2,
				options = {
					name = "hawick_west_3",
					heading = 341,
					--debugPoly=true,
					minZ = 48.04,
					maxZ = 50.44,
				},
			},
			{
				coords = vector3(-352.62, -60.26, 49.04),
				width = 0.2,
				length = 3.8,
				options = {
					name = "hawick_west_4",
					heading = 340,
					--debugPoly=true,
					minZ = 48.04,
					maxZ = 50.44,
				},
			},
			{
				coords = vector3(-354.13, -57.68, 49.04),
				width = 2.95,
				length = 0.2,
				options = {
					name = "hawick_west_5",
					heading = 341,
					--debugPoly=true,
					minZ = 48.04,
					maxZ = 50.44,
				},
			},
		},
		doors = {
			vaultDoor = {
				object = 2121050683,
				step = -0.60,
				originalHeading = 250.860,
			},
		},
	},
	fleeca_delperro = {
		id = "fleeca_delperro",
		label = "Boulevard Del Perro",
		coords = vector3(-1212.59, -335.36, 37.78),
		width = 12.4,
		length = 14.0,
		options = {
			name = "fleeca_delperro",
			heading = 207,
			minZ = 36.78,
			maxZ = 40.78,
			--debugPoly = true,
		},
		reset = {
			coords = vector3(-1214.56, -336.0, 37.78),
			length = 0.4,
			width = 0.4,
			options = {
				heading = 25,
				--debugPoly=true,
				minZ = 37.38,
				maxZ = 39.18,
			},
		},
		points = {
			vaultPC = {
				coords = vector3(-1210.908, -336.374, 37.781),
				heading = 207.123,
			},
			vaultGate = {
				coords = vector3(-1208.644, -335.7033, 38.10191),
				heading = 209.101,
			},
		},
		loots = {
			{
				coords = vector3(-1209.8, -333.39, 37.78),
				width = 0.2,
				length = 2.95,
				options = {
					name = "delperro_1",
					heading = 26,
					--debugPoly=true,
					minZ = 36.78,
					maxZ = 39.18,
				},
			},
			{
				coords = vector3(-1207.2, -333.65, 37.78),
				width = 2.0,
				length = 0.2,
				options = {
					name = "delperro_2",
					heading = 27,
					--debugPoly=true,
					minZ = 36.78,
					maxZ = 39.18,
				},
			},
			{
				coords = vector3(-1205.2, -336.32, 37.78),
				width = 2.95,
				length = 0.2,
				options = {
					name = "delperro_3",
					heading = 27,
					--debugPoly=true,
					minZ = 36.78,
					maxZ = 39.18,
				},
			},
			{
				coords = vector3(-1206.37, -339.1, 37.78),
				width = 0.2,
				length = 3.8,
				options = {
					name = "delperro_4",
					heading = 27,
					--debugPoly=true,
					minZ = 36.78,
					maxZ = 39.18,
				},
			},
			{
				coords = vector3(-1209.31, -338.44, 37.78),
				width = 2.95,
				length = 0.2,
				options = {
					name = "delperro_5",
					heading = 26,
					--debugPoly=true,
					minZ = 36.78,
					maxZ = 39.18,
				},
			},
		},
		doors = {
			vaultDoor = {
				object = 2121050683,
				step = -0.60,
				originalHeading = 296.864,
			},
		},
	},
	fleeca_great_ocean = {
		id = "fleeca_great_ocean",
		label = "Great Ocean Highway",
		coords = vector3(-2959.0, 479.93, 15.7),
		width = 13.2,
		length = 14.0,
		options = {
			name = "fleeca_great_ocean",
			heading = 177,
			minZ = 14.7,
			maxZ = 18.7,
			--debugPoly = true,
		},
		reset = {
			coords = vector3(-2958.92, 478.64, 15.7),
			length = 0.4,
			width = 0.4,
			options = {
				heading = 0,
				--debugPoly=true,
				minZ = 15.1,
				maxZ = 16.9,
			},
		},
		points = {
			vaultPC = {
				coords = vector3(-2957.010, 481.691, 15.697),
				heading = 270.583,
			},
			vaultGate = {
				coords = vector3(-2956.255, 483.9868, 16.0309),
				heading = 269.528,
			},
		},
		loots = {
			{
				coords = vector3(-2958.89, 484.14, 15.7),
				width = 0.2,
				length = 2.95,
				options = {
					name = "great_ocean_1",
					heading = 88,
					--debugPoly=true,
					minZ = 14.7,
					maxZ = 17.1,
				},
			},
			{
				coords = vector3(-2957.34, 486.26, 15.7),
				width = 2.0,
				length = 0.2,
				options = {
					name = "great_ocean_2",
					heading = 88,
					--debugPoly=true,
					minZ = 14.7,
					maxZ = 17.1,
				},
			},
			{
				coords = vector3(-2954.02, 486.68, 15.7),
				width = 2.95,
				length = 0.2,
				options = {
					name = "great_ocean_3",
					heading = 88,
					--debugPoly=true,
					minZ = 14.7,
					maxZ = 17.1,
				},
			},
			{
				coords = vector3(-2952.18, 484.3, 15.7),
				width = 0.2,
				length = 3.8,
				options = {
					name = "great_ocean_4",
					heading = 88,
					--debugPoly=true,
					minZ = 14.7,
					maxZ = 17.1,
				},
			},
			{
				coords = vector3(-2954.21, 482.1, 15.7),
				width = 2.95,
				length = 0.2,
				options = {
					name = "great_ocean_5",
					heading = 88,
					--debugPoly=true,
					minZ = 14.7,
					maxZ = 17.1,
				},
			},
		},
		doors = {
			vaultDoor = {
				object = 2121050683,
				step = -0.60,
				originalHeading = 357.542,
			},
		},
	},
	fleeca_route68 = {
		id = "fleeca_route68",
		label = "Route 68",
		coords = vector3(1177.01, 2710.92, 38.09),
		width = 12.4,
		length = 14.0,
		options = {
			name = "fleeca_route68",
			heading = 359,
			minZ = 37.09,
			maxZ = 41.09,
			--debugPoly = true,
		},
		reset = {
			coords = vector3(1179.12, 2710.69, 38.09),
			length = 0.4,
			width = 0.4,
			options = {
				heading = 0,
				--debugPoly=true,
				minZ = 37.49,
				maxZ = 39.29,
			},
		},
		points = {
			vaultPC = {
				coords = vector3(1176.091, 2712.595, 38.088),
				heading = 4.828,
			},
			vaultGate = {
				coords = vector3(1173.74, 2713.073, 38.41225),
				heading = 3.455,
			},
		},
		loots = {
			{
				coords = vector3(1173.72, 2710.48, 38.09),
				width = 0.2,
				length = 2.95,
				options = {
					name = "route68_1",
					heading = 0,
					--debugPoly=true,
					minZ = 37.09,
					maxZ = 39.49,
				},
			},
			{
				coords = vector3(1171.51, 2711.88, 38.09),
				width = 2.0,
				length = 0.2,
				options = {
					name = "route68_2",
					heading = 359,
					--debugPoly=true,
					minZ = 37.09,
					maxZ = 39.49,
				},
			},
			{
				coords = vector3(1170.94, 2715.19, 38.09),
				width = 2.95,
				length = 0.2,
				options = {
					name = "route68_3",
					heading = 0,
					--debugPoly=true,
					minZ = 37.09,
					maxZ = 39.49,
				},
			},
			{
				coords = vector3(1173.24, 2717.08, 38.09),
				width = 0.2,
				length = 3.8,
				options = {
					name = "route68_4",
					heading = 0,
					--debugPoly=true,
					minZ = 37.09,
					maxZ = 39.49,
				},
			},
			{
				coords = vector3(1175.57, 2715.2, 38.09),
				width = 2.95,
				length = 0.2,
				options = {
					name = "route68_5",
					heading = 0,
					--debugPoly=true,
					minZ = 37.09,
					maxZ = 39.49,
				},
			},
		},
		doors = {
			vaultDoor = {
				object = 2121050683,
				step = -0.60,
				originalHeading = 90.0,
			},
		},
	},
	fleeca_vespucci = {
		id = "fleeca_vespucci",
		label = "Vespucci Blvd",
		coords = vector3(146.18, -1043.61, 29.37),
		width = 13.4,
		length = 12.8,
		options = {
			name = "fleeca_vespucci",
			heading = 340,
			minZ = 28.37,
			maxZ = 32.37,
			--debugPoly = true,
		},
		reset = {
			coords = vector3(144.66, -1042.92, 29.37),
			length = 0.4,
			width = 0.4,
			options = {
				heading = 340,
				--debugPoly=true,
				minZ = 28.57,
				maxZ = 30.77,
			},
		},
		points = {
			vaultPC = {
				coords = vector3(147.043, -1045.367, 29.368),
				heading = 165.714,
			},
			vaultGate = {
				coords = vector3(148.9605, -1047.058, 29.70366),
				heading = 165.708,
			},
		},
		loots = {
			{
				coords = vector3(149.93, -1044.61, 29.37),
				width = 0.2,
				length = 2.95,
				options = {
					name = "vespucci_1",
					heading = 340,
					--debugPoly=true,
					minZ = 28.37,
					maxZ = 30.77,
				},
			},
			{
				coords = vector3(151.48, -1046.72, 29.37),
				width = 2.0,
				length = 0.2,
				options = {
					name = "vespucci_2",
					heading = 340,
					--debugPoly=true,
					minZ = 28.37,
					maxZ = 30.77,
				},
			},
			{
				coords = vector3(150.64, -1049.96, 29.37),
				width = 2.95,
				length = 0.4,
				options = {
					name = "vespucci_3",
					heading = 340,
					--debugPoly=true,
					minZ = 28.37,
					maxZ = 30.77,
				},
			},
			{
				coords = vector3(148.07, -1051.01, 29.37),
				width = 0.2,
				length = 3.8,
				options = {
					name = "vespucci_4",
					heading = 339,
					--debugPoly=true,
					minZ = 28.37,
					maxZ = 30.77,
				},
			},
			{
				coords = vector3(146.48, -1048.4, 29.37),
				width = 2.95,
				length = 0.2,
				options = {
					name = "vespucci_5",
					heading = 340,
					--debugPoly=true,
					minZ = 28.37,
					maxZ = 30.77,
				},
			},
		},
		doors = {
			vaultDoor = {
				object = 2121050683,
				step = -0.60,
				originalHeading = 249.846,
			},
		},
	},
}
