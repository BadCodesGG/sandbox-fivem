addDoorsListToConfig({
	{
		id = "doors_parsons_gate",
		double = "parsons_gate_right",
		model = -349730013,
		coords = vector3(-1478.26, 882.24, 183.07),
		locked = true,
		autoRate = 6.0,
		restricted = {
			{ type = "job", job = "blackdragons", gradeLevel = 0, reqDuty = false },
		},
	},
	{
		id = "parsons_gate_right",
		double = "doors_parsons_gate",
		model = -1918480350,
		coords = vector3(-1477.23, 887.65, 183.07),
		locked = true,
		autoRate = 6.0,
		restricted = {
			{ type = "job", job = "blackdragons", gradeLevel = 0, reqDuty = false },
		},
	},
})
