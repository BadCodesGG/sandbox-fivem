table.insert(Config.Restaurants, {
	Name = "Bahama Mamas",
	Job = "bahama",
	Benches = {
		bar = {
			label = "Bar",
			targeting = {
				actionString = "Making",
				icon = "martini-glass-citrus",
				poly = {
					coords = vector3(-1399.93, -598.08, 30.32),
					w = 2.0,
					l = 1.0,
					options = {
						heading = 33,
						--debugPoly=true,
						minZ = 26.87,
						maxZ = 31.07,
					},
				},
			},
			recipes = {
				_cocktailRecipies.bahama_mamas,
				_cocktailRecipies.raspberry_mimosa,
				_cocktailRecipies.pina_colada,
				_cocktailRecipies.bloody_mary,
				_cocktailRecipies.vodka_shot,
				_cocktailRecipies.whiskey_glass,
				_cocktailRecipies.jaeger_bomb,
				_genericRecipies.glass_cock,
				_genericRecipies.lemonade,
			},
		},
	},
	Storage = {
		{
			id = "bahama-storage",
			type = "box",
			coords = vector3(-1377.012, -634.215, 30.320),
			width = 2.0,
			length = 1.0,
			options = {
				heading = 215.0,
				--debugPoly=true,
				minZ = 29.320,
				maxZ = 31.320,
			},
			data = {
				business = "bahama",
				inventory = {
					invType = 157,
					owner = "bahama-storage",
				},
			},
		},
	},
	Pickups = {
		{
			id = "bahama-pickup-1",
			coords = vector3(-1398.79, -601.62, 30.32),
			width = 1.0,
			length = 1.0,
			options = {
				heading = 340,
				--debugPoly=true,
				minZ = 29.32,
				maxZ = 31.32,
			},
			data = {
				business = "bahama",
				inventory = {
					invType = 160,
					owner = "bahama-pickup-1",
				},
			},
		},
		{
			id = "bahama-pickup-2",
			coords = vector3(-1400.68, -603.29, 30.32),
			width = 1.0,
			length = 1.0,
			options = {
				heading = 13,
				--debugPoly=true,
				minZ = 29.32,
				maxZ = 31.32,
			},
			data = {
				business = "bahama",
				inventory = {
					invType = 161,
					owner = "bahama-pickup-2",
				},
			},
		},
	},
	Warmers = {
		{
			fridge = true,
			id = "bahama-1",
			coords = vector3(-1404.18, -598.65, 30.32),
			width = 0.8,
			length = 1.2,
			options = {
				heading = 33,
				--debugPoly=true,
				minZ = 26.92,
				maxZ = 30.92,
			},
			restrict = {
				jobs = { "bahama" },
			},
			data = {
				business = "bahama",
				inventory = {
					invType = 158,
					owner = "bahama-1",
				},
			},
		},
		{
			fridge = true,
			id = "bahama-2",
			coords = vector3(-1401.97, -597.04, 30.32),
			width = 1.0,
			length = 1.2,
			options = {
				heading = 33,
				--debugPoly=true,
				minZ = 27.02,
				maxZ = 31.22,
			},
			restrict = {
				jobs = { "bahama" },
			},
			data = {
				business = "bahama",
				inventory = {
					invType = 158,
					owner = "bahama-2",
				},
			},
		},
	},
})
