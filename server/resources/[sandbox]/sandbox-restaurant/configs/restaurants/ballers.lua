table.insert(Config.Restaurants, {
	Name = "Ballers Clubhouse Bar",
	Job = "ballers",
	IgnoreDuty = true,
	Benches = {
		bar = {
			label = "Bar",
			targeting = {
				actionString = "Making",
				icon = "martini-glass-citrus",
				poly = {
					coords = vector3(-1.38, -1825.94, 29.15),
					w = 0.6,
					l = 1.6,
					options = {
						heading = 320,
						--debugPoly=true,
						minZ = 29.95,
						maxZ = 30.95,
					},
				},
			},
			recipes = {
				_cocktailRecipies.raspberry_mimosa,
				_cocktailRecipies.pina_colada,
				_cocktailRecipies.bloody_mary,
				_cocktailRecipies.vodka_shot,
				_cocktailRecipies.whiskey_glass,
				--_cocktailRecipies.jaeger_bomb,
				-- _genericRecipies.glass_cock,
				-- _genericRecipies.lemonade,
			},
		},
	},
	Storage = {
		{
			id = "ballers-clubhouse-storage",
			type = "box",
			coords = vector3(-1.96, -1827.12, 29.15),
			length = 1.0,
			width = 1.2,
			options = {
				heading = 320,
				--debugPoly=true,
				minZ = 26.35,
				maxZ = 30.35,
			},
			data = {
				business = "ballers",
				inventory = {
					invType = 229,
					owner = "ballers_storage",
				},
			},
		},
	},
	Pickups = {
		{
			id = "ballers-clubhouse-pickup-1",
			coords = vector3(-3.31, -1827.16, 29.15),
			width = 1.6,
			length = 1.0,
			options = {
				heading = 320,
				--debugPoly=true,
				minZ = 25.95,
				maxZ = 29.95,
			},
			data = {
				business = "ballers",
				inventory = {
					invType = 228,
					owner = "ballers_pickup-1",
				},
			},
		},
	},
	Warmers = false,
})
