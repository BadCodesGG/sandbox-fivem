local publicDoorPermissions = { -- Public Doors, Police can lock when on duty, Medical Staff Whenever
	{ type = "job", job = "police", workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = true },
	{ type = "job", job = "ems", workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = false },
}

local staffOnlyDoorPermissions = { -- Medical Staff Only (Allows Offduty)
	{ type = "job", job = "ems", workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = false },
}

local staffOnlyStrictDoorPermissions = { -- On Duty Medical Staff Only
	{ type = "job", job = "ems", workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = true },
}

addDoorsListToConfig({
	--[[
		EASTSIDE SAFD
	]]
	--
	-- Main Door
	{
		id = "safd_eastside_main_door",
		model = -585526495,
		coords = vector3(1185.0, -1464.69, 34.08),
		locked = true,
		autoRate = 6.0,
		restricted = staffOnlyDoorPermissions,
	},
	{
		id = "safd_eastside_garage_1",
		model = 1934132135,
		coords = vector3(1204.82, -1463.52, 35.87),
		locked = true,
		autoRate = 6.0,
		restricted = staffOnlyStrictDoorPermissions,
	},
	{
		id = "safd_eastside_garage_2",
		model = 1934132135,
		coords = vector3(1200.75, -1463.52, 35.87),
		locked = true,
		autoRate = 6.0,
		restricted = staffOnlyStrictDoorPermissions,
	},
	{
		id = "safd_eastside_garage_3",
		model = 1934132135,
		coords = vector3(1196.67, -1463.52, 35.87),
		locked = true,
		autoRate = 6.0,
		restricted = staffOnlyStrictDoorPermissions,
	},
	--[[
		SOUTHSIDE SAFD
	]]
	--
	-- Main Door
	{
		id = "safd_southside_main_door",
		model = -585526495,
		coords = vector3(199.29, -1634.49, 29.02),
		locked = true,
		autoRate = 6.0,
		restricted = staffOnlyDoorPermissions,
	},
	{
		id = "safd_southside_garage_1",
		model = 1934132135,
		coords = vector3(215.23, -1646.33, 30.82),
		locked = true,
		autoRate = 6.0,
		restricted = staffOnlyStrictDoorPermissions,
	},
	{
		id = "safd_southside_garage_2",
		model = 1934132135,
		coords = vector3(212.1, -1643.71, 30.82),
		locked = true,
		autoRate = 6.0,
		restricted = staffOnlyStrictDoorPermissions,
	},
	{
		id = "safd_southside_garage_3",
		model = 1934132135,
		coords = vector3(208.98, -1641.09, 30.82),
		locked = true,
		autoRate = 6.0,
		restricted = staffOnlyStrictDoorPermissions,
	},
})
