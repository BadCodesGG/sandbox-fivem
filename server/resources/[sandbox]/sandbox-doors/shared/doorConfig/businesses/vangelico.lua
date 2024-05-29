addDoorsListToConfig({
	{
		id = "vangelico_main_1",
		double = "vangelico_main_2",
		model = 1425919976,
		coords = vector3(-383.84, 6044.06, 31.66),
		locked = true,
		--special = true,
		autoRate = 6.0,
		restricted = {
			{ type = "job", job = "vangelico", reqDuty = false },
		},
	},
	{
		id = "vangelico_main_2",
		double = "vangelico_main_1",
		model = 9467943,
		coords = vector3(-382.0, 6042.22, 31.66),
		locked = true,
		--special = true,
		autoRate = 6.0,
		restricted = {
			{ type = "job", job = "vangelico", reqDuty = false },
		},
	},
	{
		id = "vangelico_office_door",
		model = 1335309163,
		coords = vector3(-382.01, 6050.6, 31.66),
		locked = true,
		-- special = true,
		autoRate = 6.0,
		restricted = {
			{ type = "job", job = "vangelico", reqDuty = true },
		},
	},
})
