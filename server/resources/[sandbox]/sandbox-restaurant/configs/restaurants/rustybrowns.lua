table.insert(Config.Restaurants, {
	Name = "Rusty Browns",
	Job = "rustybrowns",
	Benches = {
		drinks = {
			label = "Drinks",
			targeting = {
				actionString = "Preparing",
				icon = "cup-straw-swoosh",
				poly = {
					coords = vector3(155.32, 244.1, 107.05),
					w = 1.0,
					l = 0.6,
					options = {
						heading = 340,
						--debugPoly=true,
						minZ = 104.25,
						maxZ = 108.25,
					},
				},
			},
			recipes = {
				_genericRecipies.lemonade,
				_genericRecipies.soda,
				_genericRecipies.gingerale,
				_genericRecipies.shmilk,
			},
		},
		coffee = {
			label = "Coffee",
			targeting = {
				actionString = "Preparing",
				icon = "coffee",
				poly = {
					coords = vector3(154.26, 250.32, 107.05),
					w = 0.8,
					l = 0.6,
					options = {
						heading = 340,
						--debugPoly=true,
						minZ = 106.65,
						maxZ = 107.85,
					},
				},
			},
			recipes = {
				_genericRecipies.chai_latte,
				_genericRecipies.tommy_tea,
				_genericRecipies.coffee,
			},
		},
		food = {
			label = "Food",
			targeting = {
				actionString = "Cooking",
				icon = "donut",
				poly = {
					coords = vector3(160.5, 246.07, 107.05),
					w = 2.2,
					l = 1.0,
					options = {
						heading = 340,
						--debugPoly=true,
						minZ = 105.65,
						maxZ = 108.05,
					},
				},
			},
			recipes = {
				_donutRecipies.rusty_strawsprinkle,
				_donutRecipies.rusty_ring,
				_donutRecipies.rusty_lemon,
				_donutRecipies.rusty_custard,
				_donutRecipies.rusty_cookiecream,
				_donutRecipies.rusty_chocstuff,
				_donutRecipies.rusty_chocsprinkle,
				_donutRecipies.rusty_blueice,
				_donutRecipies.rusty_strawsprinkbox,
				_donutRecipies.rusty_ringbox,
				_donutRecipies.rusty_ringmixbox,
				_donutRecipies.rusty_pd,
			},
		},
	},
	Storage = {
		{
			id = "rustybrowns-storage",
			type = "box",
			coords = vector3(158.21, 247.93, 107.05),
			width = 2,
			length = 1.4,
			options = {
				heading = 340,
				--debugPoly=true,
				minZ = 104.65,
				maxZ = 108.65,
			},
			data = {
				business = "rustybrowns",
				inventory = {
					invType = 206,
					owner = "rustybrowns-storage",
				},
			},
		},
	},
	Pickups = {
		{
			id = "rustybrowns-pickup-1",
			coords = vector3(153.85, 249.28, 107.05),
			width = 1.4,
			length = 1.2,
			options = {
				heading = 340,
				--debugPoly=true,
				minZ = 105.85,
				maxZ = 107.85,
			},
			data = {
				business = "rustybrowns",
				inventory = {
					invType = 204,
					owner = "rustybrowns-pickup-1",
				},
			},
		},
		{
			id = "rustybrowns-pickup-2",
			coords = vector3(153.15, 247.51, 107.05),
			width = 1.8,
			length = 1.2,
			options = {
				heading = 340,
				--debugPoly=true,
				minZ = 105.85,
				maxZ = 107.85,
			},
			data = {
				business = "rustybrowns",
				inventory = {
					invType = 205,
					owner = "rustybrowns-pickup-2",
				},
			},
		},
	},
	Warmers = {
		{
			id = "rustybrowns-warmer-1",
			coords = vector3(157.38, 249.11, 107.05),
			length = 0.6,
			width = 1.6,
			options = {
				heading = 340,
				--debugPoly=true,
				minZ = 104.65,
				maxZ = 108.65,
			},
			restrict = {
				jobs = { "rustybrowns" },
			},
			data = {
				business = "rustybrowns",
				inventory = {
					invType = 202,
					owner = "rustybrowns-warmer-1",
				},
			},
		},
		{
			id = "rustybrowns-warmer-2",
			coords = vector3(156.79, 247.61, 107.05),
			width = 1.6,
			length = 0.6,
			options = {
				heading = 340,
				--debugPoly=true,
				minZ = 104.65,
				maxZ = 108.65,
			},
			restrict = {
				jobs = { "rustybrowns" },
			},
			data = {
				business = "rustybrowns",
				inventory = {
					invType = 203,
					owner = "rustybrowns-warmer-2",
				},
			},
		},
	},
})
