addDoorsListToConfig({
	{
		id = "cloud9_main_office",
		model = -684382235,
		coords = vector3(-63.31, -2519.13, 7.55),
		locked = true,
		autoRate = 6.0,
		restricted = {
			{ type = "job", job = "cloud9", gradeLevel = 0, reqDuty = false },
		},
	},
	{
		id = "cloud9_front_gate_enter",
		model = 1286392437,
		coords = vector3(19.41, -2529.7, 5.05),
		locked = true,
		special = true,
		--autoRate = 6.0,
		restricted = {
			{ type = "job", job = "cloud9", gradeLevel = 0, reqDuty = false },
		},
		holdOpen = true,
	},
	{
		id = "cloud9_front_gate_exit_out",
		model = 1286392437,
		coords = vector3(10.64, -2542.21, 5.05),
		locked = true,
		special = true,
		--autoRate = 6.0,
		restricted = {
			{ type = "job", job = "cloud9", gradeLevel = 0, reqDuty = false },
		},
		holdOpen = true,
	},
	{
		id = "cloud9_rear_gate_enter",
		model = 1286392437,
		coords = vector3(-193.55, -2515.57, 5.28),
		locked = true,
		special = true,
		--autoRate = 6.0,
		restricted = {
			{ type = "job", job = "cloud9", gradeLevel = 0, reqDuty = false },
		},
		holdOpen = true,
	},
	{
		id = "cloud9_rear_gate_exit_out",
		model = 1286392437,
		coords = vector3(-202.62, -2515.31, 5.05),
		locked = true,
		special = true,
		--autoRate = 6.0,
		restricted = {
			{ type = "job", job = "cloud9", gradeLevel = 0, reqDuty = false },
		},
		holdOpen = true,
	},
})
