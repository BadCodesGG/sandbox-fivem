_prisonCrafting = {
	recipes = {
		["low"] = {
			["coffee"] = {
				result = { name = "coffee", count = 3 },
				items = {
					{ name = "coffee_beans", count = 5 },
				},
				time = 5000,
			},
		},
		["high"] = {
			["WEAPON_SHIV"] = {
				result = { name = "WEAPON_SHIV", count = 1 },
				items = {
					{ name = "plastic", count = 25 },
					{ name = "glue", count = 25 },
					{ name = "scrapmetal", count = 50 },
				},
				time = 5000,
			},
			["phone"] = {
				result = { name = "phone", count = 1 },
				items = {
					{ name = "electronic_parts", count = 25 },
					{ name = "glue", count = 25 },
					{ name = "scrapmetal", count = 25 },
					{ name = "plastic", count = 25 },
				},
				time = 5000,
			},
			["radio_shitty"] = {
				result = { name = "radio_shitty", count = 1 },
				items = {
					{ name = "electronic_parts", count = 50 },
					{ name = "glue", count = 50 },
					{ name = "scrapmetal", count = 50 },
					{ name = "plastic", count = 50 },
				},
				time = 5000,
			},
		},
	},
	peds = {
		prison_crafting_1 = {
			target = "Wanna Talk?",
			coords = vector4(1625.526, 2578.829, 44.565, 51.167),
			model = "s_m_y_prisoner_01",
			anim = "WORLD_HUMAN_SMOKING",
			icon = "toolbox",
			level = 0,
			recipeType = "low",
		},
		prison_crafting_2 = {
			target = "Lets Chat",
			coords = vector4(1699.579, 2472.416, 44.565, 87.913),
			model = "s_m_y_prisoner_01",
			anim = "WORLD_HUMAN_SMOKING",
			icon = "toolbox",
			level = 3,
			recipeType = "high",
		},
	},
}
