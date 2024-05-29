table.insert(Config.Restaurants, {
	Name = "Burger Shot",
	Job = "burgershot",
	Benches = {
		drinks = {
			label = "Drinks & Ice Cream",
			targeting = {
				actionString = "Preparing",
				icon = "cup-straw-swoosh",
				poly = {
					coords = vector3(-1191.52, -897.64, 13.8),
					w = 2.6,
					l = 0.6,
					options = {
						heading = 35,
						--debugPoly=true,
						minZ = 11.65,
						maxZ = 14.85,
					},
				},
			},
			recipes = {
				{
					result = { name = "burgershot_drink", count = 1 },
					items = {
						{ name = "burgershot_cup", count = 1 },
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
		drinksDrivethru = {
			label = "Drinks & Ice Cream",
			targeting = {
				actionString = "Preparing",
				icon = "cup-straw-swoosh",
				poly = {
					coords = vector3(-1191.12, -905.38, 13.8),
					w = 1.4,
					l = 1.0,
					options = {
						heading = 305,
						--debugPoly=true,
						minZ = 13.85,
						maxZ = 15.25,
					},
				},
			},
			recipes = {
				{
					result = { name = "burgershot_drink", count = 1 },
					items = {
						{ name = "burgershot_cup", count = 1 },
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
		food = {
			label = "Food",
			targeting = {
				actionString = "Cooking",
				icon = "burger-fries",
				poly = {
					coords = vector3(-1187.16, -900.2, 13.8),
					w = 1.8,
					l = 3.4,
					options = {
						heading = 34,
						--debugPoly=true,
						minZ = 12.8,
						maxZ = 14.6,
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
					result = { name = "burger", count = 5 },
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
					result = { name = "double_shot_burger", count = 5 },
					items = {
						{ name = "bun", count = 6 },
						{ name = "patty", count = 6 },
						{ name = "lettuce", count = 6 },
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
					result = { name = "heartstopper", count = 1 },
					items = {
						{ name = "bun", count = 2 },
						{ name = "patty", count = 3 },
						{ name = "lettuce", count = 2 },
						{ name = "pickle", count = 3 },
						{ name = "tomato", count = 4 },
						{ name = "cheese", count = 5 },
					},
					time = 2000,
				},
				{
					result = { name = "the_simply_burger", count = 5 },
					items = {
						{ name = "bun", count = 5 },
						{ name = "patty", count = 5 },
						{ name = "lettuce", count = 12 },
					},
					time = 2000,
				},
				{
					result = { name = "prickly_burger", count = 5 },
					items = {
						{ name = "bun", count = 3 },
						{ name = "patty", count = 3 },
						{ name = "lettuce", count = 9 },
						{ name = "chicken", count = 9 },
						{ name = "cheese", count = 3 },
					},
					time = 2000,
				},
				{
					result = { name = "chicken_wrap", count = 3 },
					items = {
						{ name = "dough", count = 1 },
						{ name = "lettuce", count = 1 },
						{ name = "cucumber", count = 3 },
						{ name = "tomato", count = 5 },
						{ name = "cheese", count = 1 },
						{ name = "chicken", count = 1 },
					},
					time = 2000,
				},
				{
					result = { name = "goat_cheese_wrap", count = 3 },
					items = {
						{ name = "dough", count = 1 },
						{ name = "lettuce", count = 1 },
						{ name = "cucumber", count = 2 },
						{ name = "tomato", count = 3 },
						{ name = "cheese", count = 5 },
					},
					time = 2000,
				},
				{
					result = { name = "burgershot_fries", count = 5 },
					items = {
						{ name = "potato", count = 10 },
					},
					time = 2000,
				},
			},
		},
	},
	Storage = {
		{
			id = "burgershot-freezer",
			type = "box",
			coords = vector3(-1192.9, -898.69, 13.8),
			width = 2.4,
			length = 2.2,
			options = {
				heading = 35,
				--debugPoly=true,
				minZ = 12.6,
				maxZ = 15.2,
			},
			data = {
				business = "burgershot",
				inventory = {
					invType = 23,
					owner = "burgershot-freezer",
				},
			},
		},
	},
	Pickups = {
		{ -- Burger Shot
			id = "burgershot-pickup-1",
			coords = vector3(-1191.38, -896.1, 13.8),
			width = 0.6,
			length = 1,
			options = {
				heading = 34,
				--debugPoly=true,
				minZ = 12.8,
				maxZ = 14.2,
			},
			data = {
				business = "burgershot",
				inventory = {
					invType = 25,
					owner = "burgershot-pickup-2",
				},
			},
		},
		{ -- Burger Shot
			id = "burgershot-pickup-2",
			coords = vector3(-1189.83, -895.03, 13.8),
			width = 0.6,
			length = 1,
			options = {
				heading = 34,
				--debugPoly=true,
				minZ = 12.8,
				maxZ = 14.2,
			},
			data = {
				business = "burgershot",
				inventory = {
					invType = 171,
					owner = "burgershot-pickup-2",
				},
			},
		},
		{ -- Burger Shot
			id = "burgershot-pickup-3",
			coords = vector3(-1188.25, -893.98, 13.8),
			width = 0.6,
			length = 1.2,
			options = {
				heading = 34,
				--debugPoly=true,
				minZ = 12.8,
				maxZ = 14.2,
			},
			data = {
				business = "burgershot",
				inventory = {
					invType = 172,
					owner = "burgershot-pickup-3",
				},
			},
		},
		{ -- Burger Shot
			id = "burgershot-pickup-4",
			driveThru = true,
			coords = vector3(-1194.52, -905.37, 13.8),
			width = 1.2,
			length = 2.2,
			options = {
				heading = 349,
				--debugPoly=true,
				minZ = 13.6,
				maxZ = 15.6,
			},
			data = {
				business = "burgershot",
				inventory = {
					invType = 173,
					owner = "burgershot-pickup-4",
				},
			},
		},
	},
	Warmers = {
		{ -- Burger Shot
			id = "burgershot-warmer-1",
			coords = vector3(-1187.61, -896.94, 13.79),
			length = 0.8,
			width = 1.6,
			options = {
				heading = 306,
				--debugPoly=true,
				minZ = 13.79,
				maxZ = 15.19,
			},
			restrict = {
				jobs = { "burgershot" },
			},
			data = {
				business = "burgershot",
				inventory = {
					invType = 24,
					owner = "burgershot-warmer-1",
				},
			},
		},
		{ -- Burger Shot
			id = "burgershot-warmer-2",
			coords = vector3(-1191.11, -903.78, 13.8),
			length = 1.6,
			width = 1,
			options = {
				heading = 305,
				--debugPoly=true,
				minZ = 13.95,
				maxZ = 15.15,
			},
			restrict = {
				jobs = { "burgershot" },
			},
			data = {
				business = "burgershot",
				inventory = {
					invType = 24,
					owner = "burgershot-warmer-2",
				},
			},
		},
		{
			fridge = true,
			id = "burgershot-fridge-1",
			coords = vector3(-1183.35, -900.94, 13.8),
			width = 2.6,
			length = 0.8,
			options = {
				heading = 304,
				--debugPoly=true,
				minZ = 12.8,
				maxZ = 15.2,
			},
			restrict = {
				jobs = { "burgershot" },
			},
			data = {
				business = "burgershot",
				inventory = {
					invType = 174,
					owner = "burgershot-fridge-1",
				},
			},
		},
	},
})
