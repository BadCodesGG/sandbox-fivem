addDoorsListToConfig({
	{ -- garage door left
		id = "mba_garage_door_left",
		locked = true,
		model = -1098702270,
		coords = vector3(-375.44, -1880.23, 24.11),
		autoRate = 6.0,
		restricted = {
			{ type = "job", job = "mba", gradeLevel = 0, reqDuty = false },
		},
	},
	{ -- garage door right
		id = "mba_garage_door_right",
		locked = true,
		model = -1098702270,
		coords = vector3(-386.16, -1885.45, 24.12),
		autoRate = 6.0,
		restricted = {
			{ type = "job", job = "mba", gradeLevel = 0, reqDuty = false },
		},
	},
})
