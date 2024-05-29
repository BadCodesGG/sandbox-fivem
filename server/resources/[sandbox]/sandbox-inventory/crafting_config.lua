CraftingTables = {
	{
		label = "Salvage Exchange",
		targetConfig = {
			icon = "briefcase-arrow-right",
			ped = {
				model = "s_m_m_gardener_01",
				task = "WORLD_HUMAN_LEANING",
			},
		},
		location = {
			x = 2350.925,
			y = 3145.093,
			z = 47.209,
			h = 169.500,
		},
		restriction = {
			shared = true,
		},
		recipes = {
			{
				result = { name = "ironbar", count = 10 },
				items = {
					{ name = "salvagedparts", count = 25 },
				},
			},
			{
				result = { name = "scrapmetal", count = 20 },
				items = {
					{ name = "salvagedparts", count = 10 },
				},
			},
			{
				result = { name = "heavy_glue", count = 20 },
				items = {
					{ name = "salvagedparts", count = 10 },
				},
			},
			{
				result = { name = "rubber", count = 16 },
				items = {
					{ name = "salvagedparts", count = 8 },
				},
			},
			{
				result = { name = "plastic", count = 6 },
				items = {
					{ name = "salvagedparts", count = 3 },
				},
			},
			{
				result = { name = "copperwire", count = 4 },
				items = {
					{ name = "salvagedparts", count = 2 },
				},
			},
			{
				result = { name = "glue", count = 4 },
				items = {
					{ name = "salvagedparts", count = 2 },
				},
			},
			{
				result = { name = "electronic_parts", count = 32 },
				items = {
					{ name = "salvagedparts", count = 8 },
				},
			},
		},
	},
	{
		label = "Material Refiner",
		targetConfig = {
			icon = "minimize",
			model = "gr_prop_gr_lathe_01a",
		},
		location = { x = -582.4349975585938, y = -1612.1583251953126, z = 26.01090049743652, h = 86.29170227050781 },
		restriction = {
			shared = true,
		},
		recipes = {
			{
				result = { name = "refined_metal", count = 1 },
				items = {
					{ name = "scrapmetal", count = 1000 },
				},
			},
			{
				result = { name = "refined_iron", count = 1 },
				items = {
					{ name = "ironbar", count = 1000 },
				},
			},
			{
				result = { name = "refined_copper", count = 1 },
				items = {
					{ name = "copperwire", count = 1000 },
				},
			},
			{
				result = { name = "refined_plastic", count = 1 },
				items = {
					{ name = "plastic", count = 1000 },
				},
			},
			{
				result = { name = "refined_glue", count = 1 },
				items = {
					{ name = "heavy_glue", count = 1000 },
				},
			},
			{
				result = { name = "refined_glue", count = 1 },
				items = {
					{ name = "glue", count = 1000 },
				},
			},
			{
				result = { name = "refined_electronics", count = 1 },
				items = {
					{ name = "electronic_parts", count = 1000 },
				},
			},
			{
				result = { name = "refined_rubber", count = 1 },
				items = {
					{ name = "rubber", count = 1000 },
				},
			},
		},
	},
	{
		label = "Sign Exchange",
		targetConfig = {
			icon = "briefcase-arrow-right",
			ped = {
				model = "s_m_m_dockwork_01",
				task = "WORLD_HUMAN_JANITOR",
			},
		},
		location = {
			x = -185.572,
			y = 6270.046,
			z = 30.489,
			h = 56.226,
		},
		restriction = {
			shared = true,
		},
		recipes = {
			{
				result = { name = "ironbar", count = 50 },
				items = {
					{ name = "sign_dontblock", count = 5 },
					{ name = "sign_leftturn", count = 5 },
					{ name = "sign_nopark", count = 5 },
					{ name = "sign_notresspass", count = 5 },
				},
			},
			{
				result = { name = "scrapmetal", count = 75 },
				items = {
					{ name = "sign_rightturn", count = 5 },
					{ name = "sign_stop", count = 5 },
					{ name = "sign_uturn", count = 5 },
					{ name = "sign_walkingman", count = 5 },
					{ name = "sign_yield", count = 5 },
				},
			},
		},
	},
	{
		label = "Sign Exchange",
		targetConfig = {
			icon = "briefcase-arrow-right",
			ped = {
				model = "s_m_y_ammucity_01",
				task = "WORLD_HUMAN_CLIPBOARD",
			},
		},
		location = {
			x = 1746.624,
			y = 3688.159,
			z = 33.334,
			h = 343.688,
		},
		restriction = {
			shared = true,
			rep = {
				id = "SignRobbery",
				level = 16000,
			},
		},
		recipes = {
			_schematics.pistol_ext_mag,
		},
	},
	{
		label = "Recycle Exchange",
		targetConfig = {
			icon = "briefcase-arrow-right",
			ped = {
				model = "s_m_m_dockwork_01",
				task = "WORLD_HUMAN_JANITOR",
			},
		},
		location = {
			x = -334.833,
			y = -1577.247,
			z = 24.222,
			h = 20.715,
		},
		restriction = {
			shared = true,
		},
		recipes = {
			{
				result = { name = "ironbar", count = 10 },
				items = {
					{ name = "recycledgoods", count = 25 },
				},
			},
			{
				result = { name = "scrapmetal", count = 20 },
				items = {
					{ name = "recycledgoods", count = 10 },
				},
			},
			{
				result = { name = "heavy_glue", count = 20 },
				items = {
					{ name = "recycledgoods", count = 10 },
				},
			},
			{
				result = { name = "rubber", count = 16 },
				items = {
					{ name = "recycledgoods", count = 8 },
				},
			},
			{
				result = { name = "plastic", count = 6 },
				items = {
					{ name = "recycledgoods", count = 3 },
				},
			},
			{
				result = { name = "copperwire", count = 4 },
				items = {
					{ name = "recycledgoods", count = 2 },
				},
			},
			{
				result = { name = "glue", count = 4 },
				items = {
					{ name = "recycledgoods", count = 2 },
				},
			},
		},
	},
	{
		label = "Smelter",
		targetConfig = {
			icon = "fireplace",
			model = "gr_prop_gr_bench_02b",
		},
		location = {
			x = 1112.165,
			y = -2030.834,
			z = 29.914,
			h = 235.553,
		},
		restriction = {
			shared = true,
		},
		recipes = {
			{
				result = { name = "goldbar", count = 1 },
				items = {
					{ name = "goldore", count = 1 },
				},
			},
			{
				result = { name = "silverbar", count = 1 },
				items = {
					{ name = "silverore", count = 1 },
				},
			},
			{
				result = { name = "ironbar", count = 3 },
				items = {
					{ name = "ironore", count = 1 },
				},
			},
		},
	},
}

PublicSchematicTables = { -- The ID of each of these NEEDS to be unique
	{
		id = "city-tunnels",
		targetConfig = {
			icon = "toolbox",
			model = "prop_tool_bench02",
		},
		location = {
			x = 42.20, 
			y = -641.86,
			z = 9.77,
			h = 337.98,
		},
	},
	{
		id = "east-train",
		targetConfig = {
			icon = "toolbox",
			model = "prop_tool_bench02",
		},
		location = {
			x = 925.916,
			y = -1488.888,
			z = 29.4938,
			h = 89.19,
		},
	},
	{
		id = "cluck-factory",
		targetConfig = {
			icon = "toolbox",
			model = "prop_tool_bench02",
		},
		location = {
			x = -180.69, 
			y = 6155.62, 
			z = 30.21,
			h = 314.045,
		},
	},
}
