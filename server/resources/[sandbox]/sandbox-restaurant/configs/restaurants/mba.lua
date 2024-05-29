table.insert(Config.Restaurants, {
	Name = "Maze Bank Arena",
	Job = "mba",
	Benches = {
		mbaBar = {
			label = "Bar",
			targeting = {
				actionString = "Making",
				icon = "martini-glass-citrus",
				poly = {
					coords = vector3(-296.342, -1935.253, 42.038),
					l = 1.75,
					w = 1.0,
					options = {
						heading = 138.871,
						--debugPoly=true,
						minZ = 40.18,
						maxZ = 44.98,
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
				--_cocktailRecipies.jaeger_bomb,
				_genericRecipies.glass_cock,
				_genericRecipies.lemonade,
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
			},
		},
		mbaPopcorn = {
			label = "Popcorn",
			targeting = {
				actionString = "Cooking",
				icon = "popcorn",
				poly = {
					coords = vector3(-291.348, -1938.110, 30.160),
					w = 1.0,
					l = 1.0,
					options = {
						heading = 144.273,
						--debugPoly=true,
						minZ = 29.07,
						maxZ = 31.17,
					},
				},
			},
			recipes = {
				_genericRecipies.popcorn,
			},
		},
		mbaFood = {
			label = "Food",
			targeting = {
				actionString = "Cooking",
				icon = "burger-fries",
				poly = {
					coords = vector3(-290.873, -1933.139, 30.249),
					w = 1.0,
					l = 2.15,
					options = {
						heading = 322.101,
						--debugPoly=true,
						minZ = 29.07,
						maxZ = 31.17,
					},
				},
			},
			recipes = {
				{
					result = { name = "patty", count = 5 },
					items = {
						{ name = "unk_meat", count = 10 },
					},
					time = 2000,
				},
				{
					result = { name = "pickle", count = 10 },
					items = {
						{ name = "cucumber", count = 15 },
					},
					time = 2000,
				},
				{
					result = { name = "cheeseburger", count = 5 },
					items = {
						{ name = "bun", count = 4 },
						{ name = "patty", count = 4 },
						{ name = "lettuce", count = 3 },
						{ name = "pickle", count = 6 },
						{ name = "tomato", count = 10 },
						{ name = "cheese", count = 5 },
					},
					time = 2000,
				},
				{
					result = { name = "tacos", count = 3 },
					items = {
						{ name = "dough", count = 1 },
						{ name = "lettuce", count = 2 },
						{ name = "tomato", count = 4 },
						{ name = "beef", count = 2 },
					},
					time = 2000,
				},
				{
					result = { name = "hotdog", count = 3 },
					items = {
						{ name = "dough", count = 1 },
						{ name = "hotdog_single", count = 1 },
					},
					time = 2000,
				},
				{
					result = { name = "fries", count = 5 },
					items = {
						{ name = "potato", count = 10 },
					},
					time = 2000,
				},
			},
		},
		mbaFoodBar = {
			label = "Food",
			targeting = {
				actionString = "Cooking",
				icon = "burger-fries",
				poly = {
					coords = vector3(-292.891, -1932.932, 42.081),
					w = 1.0,
					l = 2.15,
					options = {
						heading = 321.108,
						--debugPoly=true,
						minZ = 41.07,
						maxZ = 43.17,
					},
				},
			},
			recipes = {
				_genericRecipies.sandwich,
				_genericRecipies.sandwich_blt,
				_genericRecipies.sandwich_turkey,
				_genericRecipies.sandwich_beef,
				{
					result = { name = "patty", count = 5 },
					items = {
						{ name = "unk_meat", count = 10 },
					},
					time = 2000,
				},
				{
					result = { name = "pickle", count = 10 },
					items = {
						{ name = "cucumber", count = 15 },
					},
					time = 2000,
				},
				{
					result = { name = "cheeseburger", count = 5 },
					items = {
						{ name = "bun", count = 4 },
						{ name = "patty", count = 4 },
						{ name = "lettuce", count = 3 },
						{ name = "pickle", count = 6 },
						{ name = "tomato", count = 10 },
						{ name = "cheese", count = 5 },
					},
					time = 2000,
				},
				{
					result = { name = "tacos", count = 3 },
					items = {
						{ name = "dough", count = 1 },
						{ name = "lettuce", count = 2 },
						{ name = "tomato", count = 4 },
						{ name = "beef", count = 2 },
					},
					time = 2000,
				},
				{
					result = { name = "hotdog", count = 3 },
					items = {
						{ name = "dough", count = 1 },
						{ name = "hotdog_single", count = 1 },
					},
					time = 2000,
				},
				{
					result = { name = "vension_steak", count = 4 },
					items = {
						{ name = "venison", count = 2 },
					},
					time = 2000,
				},
				{
					result = { name = "fries", count = 5 },
					items = {
						{ name = "potato", count = 10 },
					},
					time = 2000,
				},
			},
		},
		mbaColdDrinks = {
			label = "Drinks & Ice Cream",
			targeting = {
				actionString = "Preparing",
				icon = "cup-straw-swoosh",
				poly = {
					coords = vector3(-294.007, -1933.145, 30.572),
					w = 1.0,
					l = 3.0,
					options = {
						heading = 50,
						--debugPoly=true,
						minZ = 28.97,
						maxZ = 31.17,
					},
				},
			},
			recipes = {
				_genericRecipies.soda,
				_genericRecipies.gingerale,
				{
					result = { name = "smoothie_orange", count = 5 },
					items = {
						{ name = "plastic_cup", count = 1 },
						{ name = "water", count = 10 },
						{ name = "orange", count = 10 },
					},
					time = 0,
				},
				{
					result = { name = "orangotang_icecream", count = 10 },
					items = {
						{ name = "milk_can", count = 3 },
						{ name = "sugar", count = 1 },
						{ name = "orange", count = 10 },
					},
					time = 2500,
				},
				{
					result = { name = "meteorite_icecream", count = 10 },
					items = {
						{ name = "milk_can", count = 3 },
						{ name = "sugar", count = 1 },
						{ name = "chocolate_bar", count = 3 },
					},
					time = 2500,
				},
				{
					result = { name = "mocha_shake", count = 5 },
					items = {
						{ name = "plastic_cup", count = 1 },
						{ name = "milk_can", count = 3 },
						{ name = "chocolate_bar", count = 1 },
						{ name = "coffee_beans", count = 3 },
					},
					time = 2500,
				},
			},
		},
	},
	Storage = {
		{
			id = "mba-storage-1",
			type = "box",
			coords = vector3(-289.955, -1936.476, 41.045),
			width = 1.6,
			length = 1.0,
			options = {
				heading = 322.915,
				--debugPoly=true,
				minZ = 39.18,
				maxZ = 43.58,
			},
			data = {
				business = "mba",
				inventory = {
					invType = 145,
					owner = "mba-storage-1",
				},
			},
		},
		{
			id = "mba-storage-2",
			type = "box",
			coords = vector3(-289.337, -1935.401, 30.146),
			width = 1.2,
			length = 1.0,
			options = {
				heading = 291.033,
				--debugPoly=true,
				minZ = 28.18,
				maxZ = 32.58,
			},
			data = {
				business = "mba",
				inventory = {
					invType = 144,
					owner = "mba-storage-2",
				},
			},
		},
	},
	Pickups = {
		{
			id = "mba-pickup-1",
			coords = vector3(-293.921, -1936.200, 42.088),
			width = 1.0,
			length = 1.0,
			options = {
				heading = 147.256,
				--debugPoly=true,
				minZ = 40.78,
				maxZ = 43.18,
			},
			data = {
				business = "mba",
				inventory = {
					invType = 146,
					owner = "mba-pickup-1",
				},
			},
		},
		{
			id = "mba-pickup-2",
			coords = vector3(-292.164, -1932.132, 30.157),
			width = 1.0,
			length = 1.0,
			options = {
				heading = 321,
				--debugPoly=true,
				minZ = 28.78,
				maxZ = 32.18,
			},
			data = {
				business = "mba",
				inventory = {
					invType = 147,
					owner = "mba-pickup-2",
				},
			},
		},
	},
})
