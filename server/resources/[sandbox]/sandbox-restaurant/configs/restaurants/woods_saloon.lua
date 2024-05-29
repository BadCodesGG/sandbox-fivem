table.insert(Config.Restaurants, {
	Name = "Black Woods Saloon",
	Job = "woods_saloon",
	Benches = {
		bar = {
			label = "Bar",
			targeting = {
				actionString = "Making",
				icon = "martini-glass-citrus",
				poly = {
					coords = vector3(-303.37, 6269.09, 31.53),
					l = 0.8,
					w = 0.8,
					options = {
						heading = 225,
						--debugPoly=true,
						minZ = 30.28,
						maxZ = 32.48,
					},
				},
			},
			recipes = {
				_cocktailRecipies.raspberry_mimosa,
				_cocktailRecipies.pina_colada,
				_cocktailRecipies.bloody_mary,
				_cocktailRecipies.vodka_shot,
				_cocktailRecipies.whiskey_glass,
				_cocktailRecipies.beer,
				_cocktailRecipies.jaeger_bomb,
				{
					result = { name = "tequila_shot", count = 5 },
					items = {
						{ name = "tequila", count = 1 },
					},
					time = 2000,
				},
				{
					result = { name = "tequila_sunrise", count = 6 },
					items = {
						{ name = "tequila", count = 1 },
						{ name = "orange", count = 5 },
						{ name = "raspberry", count = 1 },
						{ name = "raspberry_liqueur", count = 1 },
					},
					time = 2000,
				},
				_genericRecipies.glass_cock,
				_genericRecipies.green_tea,
				_genericRecipies.lemonade,
				_genericRecipies.gingerale,
				_genericRecipies.sandwich,
				_genericRecipies.sandwich_turkey,
				_genericRecipies.sandwich_beef,
				_genericRecipies.fishandchips,
				_genericRecipies.sandwich_blt,
				_genericRecipies.salad,
			},
		},
		bar2 = {
			label = "Bar",
			targeting = {
				actionString = "Making",
				icon = "martini-glass-citrus",
				poly = {
					coords = vector3(-305.2, 6267.41, 31.53),
					l = 0.8,
					w = 0.8,
					options = {
						heading = 225,
						--debugPoly=true,
						minZ = 30.28,
						maxZ = 32.48,
					},
				},
			},
			recipes = {
				_cocktailRecipies.raspberry_mimosa,
				_cocktailRecipies.pina_colada,
				_cocktailRecipies.bloody_mary,
				_cocktailRecipies.vodka_shot,
				_cocktailRecipies.whiskey_glass,
				_cocktailRecipies.beer,
				_cocktailRecipies.jaeger_bomb,
				{
					result = { name = "tequila_shot", count = 5 },
					items = {
						{ name = "tequila", count = 1 },
					},
					time = 2000,
				},
				{
					result = { name = "tequila_sunrise", count = 6 },
					items = {
						{ name = "tequila", count = 1 },
						{ name = "orange", count = 5 },
						{ name = "raspberry", count = 1 },
						{ name = "raspberry_liqueur", count = 1 },
					},
					time = 2000,
				},
				_genericRecipies.glass_cock,
				_genericRecipies.green_tea,
				_genericRecipies.lemonade,
				_genericRecipies.gingerale,
				_genericRecipies.sandwich,
				_genericRecipies.sandwich_turkey,
				_genericRecipies.sandwich_beef,
				_genericRecipies.fishandchips,
				_genericRecipies.sandwich_blt,
				_genericRecipies.salad,
			},
		},
	},
	Storage = {
		{
			id = "woods-saloon-storage",
			type = "box",
			coords = vector3(-305.63, 6271.79, 31.53),
			width = 5.6,
			length = 1.4,
			options = {
				heading = 225,
				--debugPoly=true,
				minZ = 30.28,
				maxZ = 32.48,
			},
			data = {
				business = "woods_saloon",
				inventory = {
					invType = 162,
					owner = "woods-saloon-storage",
				},
			},
		},
	},
	Pickups = {
		{
			id = "woods-saloon-pickup-1",
			coords = vector3(-302.18, 6270.04, 31.53),
			width = 1.2,
			length = 1.0,
			options = {
				heading = 225,
				--debugPoly=true,
				minZ = 30.28,
				maxZ = 32.48,
			},
			data = {
				business = "woods_saloon",
				inventory = {
					invType = 165,
					owner = "woods-saloon-pickup-1",
				},
			},
		},
		{
			id = "woods-saloon-pickup-2",
			coords = vector3(-304.37, 6268.08, 31.53),
			width = 1.2,
			length = 1.0,
			options = {
				heading = 225,
				--debugPoly=true,
				minZ = 30.28,
				maxZ = 32.48,
			},
			data = {
				business = "woods_saloon",
				inventory = {
					invType = 166,
					owner = "woods-saloon-pickup-2",
				},
			},
		},
		{
			id = "woods-saloon-pickup-3",
			coords = vector3(-305.99, 6266.54, 31.53),
			width = 1.2,
			length = 1.0,
			options = {
				heading = 225,
				--debugPoly=true,
				minZ = 30.28,
				maxZ = 32.48,
			},
			data = {
				business = "woods_saloon",
				inventory = {
					invType = 167,
					owner = "woods-saloon-pickup-3",
				},
			},
		},
	},
	Warmers = {
		{
			fridge = true,
			id = "woods-saloon-fridge-1",
			coords = vector3(-305.84, 6269.73, 31.53),
			width = 0.8,
			length = 2.2,
			options = {
				heading = 43,
				--debugPoly=true,
				minZ = 29.93,
				maxZ = 32.33,
			},
			restrict = {
				jobs = { "woods_saloon" },
			},
			data = {
				business = "woods_saloon",
				inventory = {
					invType = 163,
					owner = "woods-saloon-fridge-1",
				},
			},
		},
	},
})
