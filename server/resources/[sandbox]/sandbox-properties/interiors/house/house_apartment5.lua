PropertyInteriors = PropertyInteriors or {}

PropertyInteriors["house_apartment5"] = {
	type = "house",
	price = 280000,
	info = {
		name = "Small Luxury",
		description = "1 Bedroom Super Lux",
	},
	locations = {
		front = {
			coords = vector3(301.413, 115.035, 102.630),
			heading = 343.860,
			polyzone = {
				center = vector3(301.19, 114.42, 102.63),
				length = 0.6,
				width = 2.0,
				options = {
					heading = 340,
					--debugPoly=true,
					minZ = 101.63,
					maxZ = 104.23
				},
			},
		},
	},
	zone = {
		center = vector3(305.53, 121.46, 102.63),
		length = 20.0,
		width = 20.0,
		options = {
			heading = 340,
			--debugPoly=true,
			minZ = 100.0,
			maxZ = 110.0,
		},
	},
	defaultFurniture = {
		{
			id = 1,
			name = "Default Storage",
			model = "v_res_tre_storagebox",
			coords = {
				x = 299.544,
				y = 116.251,
				z = 101.630
			},
			heading = 160.055,
			data = {},
		},
	},
	cameras = {
		{
			name = "Large Living Area",
			coords = vec3(295.262177, 116.951546, 104.586761),
			rotation = vec3(-11.350663, 0.000000, 309.762421),
		},
		{
			name = "Bedroom #1",
			coords = vec3(315.053436, 120.435852, 104.125885),
			rotation = vec3(-13.082957, 0.000000, 37.045776),
		},
		{
			name = "Closet",
			coords = vec3(313.731049, 117.232155, 104.452583),
			rotation = vec3(-15.996346, 0.000000, 68.305557),
		},
		{
			name = "Bathroom",
			coords = vec3(310.928223, 111.265846, 104.2841),
			rotation = vec3(-17.059328, 0.000000, 45.667690),
		},
	},
}
