table.insert(Config.Businesses, {
	Job = "cloud9",
	Name = "Cloud9 Drift",
	Storage = {
		{
			id = "cloud9-storage",
			type = "box",
			coords = vector3(-61.9327, -2516.3125, 7.4032),
			width = 1.4,
			length = 1.0,
			options = {
				heading = 325.0,
				debugPoly = false,
				minZ = 5.4,
				maxZ = 9.4,
			},
			data = {
				business = "cloud9",
				inventory = {
					invType = 190,
					owner = "cloud9-storage",
				},
			},
		},
	},
})
