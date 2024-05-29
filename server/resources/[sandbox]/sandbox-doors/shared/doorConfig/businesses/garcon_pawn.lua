addDoorsListToConfig({
	{
		id = "garcon_pawn_front_door",
		model = 1534738093,
		coords = vector3(-230.81, 6233.4, 31.92),
		locked = true,
		-- special = true,
		autoRate = 6.0,
		restricted = {
			{ type = "job", job = "garcon_pawn", reqDuty = false },
		},
	},
	{
		id = "garcon_pawn_office_door",
		model = 616583517,
		coords = vector3(-218.64, 6230.66, 31.94),
		locked = true,
		-- special = true,
		autoRate = 6.0,
		restricted = {
			{ type = "job", job = "garcon_pawn", reqDuty = false },
		},
	},
})
