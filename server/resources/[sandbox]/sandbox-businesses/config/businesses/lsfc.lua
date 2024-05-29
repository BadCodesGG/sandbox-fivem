table.insert(Config.Businesses, {
	Job = "lsfc",
	Name = "Los Santos Fight Club",
	Storage = {
		{
			id = "lsfc-storage",
			type = "box",
			coords = vector3(1616.95, 4829.26, 33.14),
			width = 1.4,
			length = 2.2,
			options = {
				heading = 10.0,
				debugPoly = false,
				minZ = 32.09,
				maxZ = 34.29,
			},
			data = {
				business = "lsfc",
				inventory = {
					invType = 192,
					owner = "lsfc-storage",
				},
			},
		},
	},
})
