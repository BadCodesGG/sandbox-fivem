addDoorsListToConfig({
	{
		id = "vangelico_grapeseed_main_1",
		double = "vangelico_grapeseed_main_2",
		model = 1425919976,
		coords = vector3(1653.66, 4881.57, 42.31),
		locked = true,
		--special = true,
		autoRate = 6.0,
		restricted = {
			{ type = "job", job = "vangelico_grapeseed", reqDuty = false },
		},
	},
	{
		id = "vangelico_grapeseed_main_2",
		double = "vangelico_grapeseed_main_1",
		model = 9467943,
		coords = vector3(1653.29, 4884.15, 42.31),
		locked = true,
		--special = true,
		autoRate = 6.0,
		restricted = {
			{ type = "job", job = "vangelico_grapeseed", reqDuty = false },
		},
	},
	{
		id = "vangelico_grapeseed_office_door",
		model = 1335309163,
		coords = vector3(1648.27, 4877.42, 42.31),
		locked = true,
		-- special = true,
		autoRate = 6.0,
		restricted = {
			{ type = "job", job = "vangelico_grapeseed", reqDuty = true },
		},
	},
})
