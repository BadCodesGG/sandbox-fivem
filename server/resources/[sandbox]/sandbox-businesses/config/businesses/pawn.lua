table.insert(Config.Businesses, {
	Job = "pepega_pawn",
	Name = "Pepega Pawn",
	Benches = {
		-- regular = {
		--     label = "Make Electronics",
		--     targeting = {
		--         actionString = "Making",
		--         icon = "microchip",
		--         poly = {
		--             coords = vector3(377.86, -820.56, 29.3),
		--             w = 2.8,
		--             l = 1.4,
		--             options = {
		--                 heading = 0,
		--                 --debugPoly=true,
		--                 minZ = 28.3,
		--                 maxZ = 29.5
		--             },
		--         },
		--     },
		--     recipes = {
		--         {
		--             result = { name = "radio_shitty", count = 1 },
		--             items = {
		--                 { name = "electronic_parts", count = 2 },
		--                 { name = "plastic", count = 5 },
		--                 { name = "copperwire", count = 1 },
		--                 { name = "glue", count = 2 },
		--             },
		--             time = 6500,
		--         },
		--         {
		--             result = { name = "phone", count = 1 },
		--             items = {
		--                 { name = "electronic_parts", count = 1 },
		--                 { name = "plastic", count = 2 },
		--                 { name = "glue", count = 1 },
		--             },
		--             time = 2000,
		--         },
		--     },
		-- },
	},
	Storage = {
		{
			id = "pawn-storage",
			type = "box",
			coords = vector3(-330.93, -89.35, 47.05),
			length = 1.4,
			width = 2.6,
			options = {
				heading = 340,
				--debugPoly=true,
				minZ = 45.05,
				maxZ = 49.05,
			},
			data = {
				business = "pepega_pawn",
				inventory = {
					invType = 117,
					owner = "pepega_pawn-storage",
				},
			},
		},
	},
	Pickups = {
		{
			id = "pawn-pickup-1",
			coords = vector3(-303.64, -101.79, 47.05),
			width = 0.8,
			length = 6.6,
			options = {
				heading = 341,
				--debugPoly=true,
				minZ = 44.05,
				maxZ = 48.05,
			},
			data = {
				business = "pepega_pawn",
				inventory = {
					invType = 136,
					owner = "pepega_pawn-pickup-1",
				},
			},
		},
		{
			id = "pawn-pickup-2",
			coords = vector3(-306.04, -105.18, 47.05),
			width = 0.8,
			length = 6.6,
			options = {
				heading = 341,
				--debugPoly=true,
				minZ = 44.05,
				maxZ = 48.05,
			},
			data = {
				business = "pepega_pawn",
				inventory = {
					invType = 197,
					owner = "pepega_pawn-pickup-2",
				},
			},
		},
		{
			id = "pawn-pickup-3",
			coords = vector3(-317.4, -97.14, 47.05),
			width = 0.8,
			length = 6.6,
			options = {
				heading = 341,
				--debugPoly=true,
				minZ = 44.05,
				maxZ = 48.05,
			},
			data = {
				business = "pepega_pawn",
				inventory = {
					invType = 198,
					owner = "pepega_pawn-pickup-3",
				},
			},
		},

		{
			id = "pawn-pickup-4",
			coords = vector3(-319.82, -100.62, 47.05),
			width = 6.6,
			length = 0.8,
			options = {
				heading = 252,
				--debugPoly=true,
				minZ = 44.05,
				maxZ = 48.05,
			},
			data = {
				business = "pepega_pawn",
				inventory = {
					invType = 199,
					owner = "pepega_pawn-pickup-4",
				},
			},
		},
	},
})
