addDoorsListToConfig({
	{
		id = "deathrow_gate",
		model = -1603817716,
		coords = vector3(-1555.06, -295.69, 47.25),
		locked = true,
		-- special = true,
		--autoRate = 6.0,
		restricted = {
			{ type = "job", job = "deathrow", gradeLevel = 0, reqDuty = false },
		},
	},

	{
		id = "deathrow_northgate_1",
		double = "deathrow_northgate_2",
		model = -1156020871,
		coords = vector3(-1592.03, -251.5, 54.48),
		locked = true,
		autoRate = 6.0,
		restricted = {
			{ type = "job", job = "deathrow", gradeLevel = 0, reqDuty = false },
		},
	},
	{
		id = "deathrow_northgate_2",
		double = "deathrow_northgate_1",
		model = -1156020871,
		coords = vector3(-1591.16, -248.17, 54.48),
		locked = true,
		autoRate = 6.0,
		restricted = {
			{ type = "job", job = "deathrow", gradeLevel = 0, reqDuty = false },
		},
	},

	{
		id = "deathrow_eastgate_1",
		double = "deathrow_eastgate_2",
		model = -1156020871,
		coords = vector3(-1538.7, -232.2, 53.33),
		locked = true,
		autoRate = 6.0,
		restricted = {
			{ type = "job", job = "deathrow", gradeLevel = 0, reqDuty = false },
		},
	},
	{
		id = "deathrow_eastgate_2",
		double = "deathrow_eastgate_1",
		model = -1156020871,
		coords = vector3(-1536.42, -234.78, 53.32),
		locked = true,
		autoRate = 6.0,
		restricted = {
			{ type = "job", job = "deathrow", gradeLevel = 0, reqDuty = false },
		},
	},
})
