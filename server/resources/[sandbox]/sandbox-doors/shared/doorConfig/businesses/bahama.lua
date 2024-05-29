local bahamaMamasDoorPerms = {
	{
		type = "job",
		job = "bahama",
		gradeLevel = 0,
		jobPermission = "JOB_DOORS",
		reqDuty = false,
	},
}

addDoorsListToConfig({
	{
		id = "bh_front_left",
		model = -224738884,
		coords = vector3(-1387.036, -586.6933, 30.44564),
		double = "bh_front_right",
		locked = true,
		autoRate = 6.0,
		restricted = bahamaMamasDoorPerms,
	},
	{
		id = "bh_front_right",
		model = 666905606,
		coords = vector3(-1389.137, -588.0577, 30.44564),
		double = "bh_front_left",
		locked = true,
		autoRate = 6.0,
		restricted = bahamaMamasDoorPerms,
	},
	{
		id = "bh_reception_left",
		model = 134859901,
		coords = vector3(-1390.449, -594.8032, 30.44565),
		double = "bh_reception_right",
		locked = true,
		autoRate = 6.0,
		restricted = bahamaMamasDoorPerms,
	},
	{
		id = "bh_reception_right",
		model = 134859901,
		coords = vector3(-1391.869, -592.616, 30.44565),
		double = "bh_reception_left",
		locked = true,
		autoRate = 6.0,
		restricted = bahamaMamasDoorPerms,
	},
	{
		id = "bh_office_door",
		model = -2102541881,
		coords = vector3(-1378.59, -621.32, 30.45),
		locked = true,
		autoRate = 6.0,
		restricted = {
			{
				type = "job",
				job = "bahama",
				gradeLevel = 99,
				jobPermission = "JOB_DOORS",
				reqDuty = false,
			},
		},
	},
	{
		id = "bh_dressing_door",
		model = -2102541881,
		coords = vector3(-1377.678, -624.8817, 30.44565),
		locked = true,
		autoRate = 6.0,
		restricted = bahamaMamasDoorPerms,
	},
	{
		id = "bh_dressing_office",
		model = 134859901,
		coords = vector3(-1373.76, -628.75, 30.45),
		locked = true,
		autoRate = 6.0,
		restricted = {
			{
				type = "job",
				job = "bahama",
				gradeLevel = 99,
				jobPermission = "JOB_DOORS",
				reqDuty = false,
			},
		},
	},
})
