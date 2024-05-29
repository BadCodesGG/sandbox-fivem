local _lsfcDoorPerms = {
	{
		type = "job",
		job = "lsfc",
		gradeLevel = 0,
		-- jobPermission = "JOB_DOORS",
		reqDuty = false,
	},
}

addDoorsListToConfig({
	{
		model = 1219405180, -- enter
		coords = vector3(1647.04, 4843.48, 42.15),
		locked = true,
		autoRate = 6.0,
		restricted = _lsfcDoorPerms,
	},
	{
		model = 757543979, -- enter steps
		coords = vector3(1643.08, 4846.29, 27.15),
		locked = true,
		autoRate = 6.0,
		restricted = _lsfcDoorPerms,
	},
	{
		model = 464151082, -- enter main
		coords = vector3(1633.5, 4848.33, 27.15),
		locked = true,
		autoRate = 6.0,
		restricted = _lsfcDoorPerms,
	},

	{
		model = -1023447729, -- torture outer
		coords = vector3(1617.11, 4856.07, 27.15),
		locked = true,
		autoRate = 6.0,
		restricted = _lsfcDoorPerms,
	},
	{
		model = -1023447729, -- torture inner
		coords = vector3(1617.56, 4861.54, 27.15),
		locked = true,
		autoRate = 6.0,
		restricted = _lsfcDoorPerms,
	},
	{
		model = -1156020871, -- ring enter
		coords = vector3(1625.41, 4840.0, 24.39),
		locked = true,
		autoRate = 6.0,
		restricted = {
			{
				type = "job",
				job = "lsfc",
				gradeLevel = 99,
				jobPermission = "JOB_DOORS",
				reqDuty = false,
			},
		},
	},
	{
		model = -1116041313, -- office
		coords = vector3(1624.7, 4834.2, 33.29),
		locked = true,
		autoRate = 6.0,
		restricted = {
			{
				type = "job",
				job = "lsfc",
				gradeLevel = 99,
				jobPermission = "JOB_DOORS",
				reqDuty = false,
			},
		},
	},
})
