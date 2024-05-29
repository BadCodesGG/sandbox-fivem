table.insert(Config.Businesses, {
	Job = "garcon_pawn",
	Name = "Garcon Pawn",
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
			id = "garcon-pawn-storage",
			type = "box",
			coords = vector3(-217.28, 6230.52, 31.79),
			length = 1.4,
			width = 1.8,
			options = {
				heading = 315,
				--debugPoly=true,
				minZ = 29.59,
				maxZ = 33.59,
			},
			data = {
				business = "garcon_pawn",
				inventory = {
					invType = 222,
					owner = "garcon_pawn-storage",
				},
			},
		},
	},
	Pickups = {
		{
			id = "garcon-pawn-pickup-1",
			coords = vector3(-225.87, 6235.17, 31.79),
			width = 4.2,
			length = 0.6,
			options = {
				heading = 315,
				--debugPoly=true,
				minZ = 28.39,
				maxZ = 32.39,
			},
			data = {
				business = "garcon_pawn",
				inventory = {
					invType = 224,
					owner = "garcon_pawn-pickup-1",
				},
			},
		},
		{
			id = "garcon-pawn-pickup-2",
			coords = vector3(-228.98, 6228.6, 31.79),
			width = 4.6,
			length = 1.0,
			options = {
				heading = 225,
				--debugPoly=true,
				minZ = 28.39,
				maxZ = 32.39,
			},
			data = {
				business = "garcon_pawn",
				inventory = {
					invType = 225,
					owner = "garcon_pawn-pickup-2",
				},
			},
		},
		{
			id = "garcon-pawn-pickup-3",
			coords = vector3(-217.25, 6223.11, 31.79),
			width = 5.6,
			length = 0.8,
			options = {
				heading = 225,
				--debugPoly=true,
				minZ = 28.39,
				maxZ = 32.39,
			},
			data = {
				business = "garcon_pawn",
				inventory = {
					invType = 226,
					owner = "garcon_pawn-pickup-3",
				},
			},
		},

		{
			id = "garcon-pawn-pickup-4",
			coords = vector3(-222.07, 6227.88, 31.79),
			width = 5.6,
			length = 0.8,
			options = {
				heading = 225,
				--debugPoly=true,
				minZ = 28.39,
				maxZ = 32.39,
			},
			data = {
				business = "garcon_pawn",
				inventory = {
					invType = 227,
					owner = "garcon_pawn-pickup-4",
				},
			},
		},
	},
})
