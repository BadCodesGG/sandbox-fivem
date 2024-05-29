AddEventHandler("Businesses:Client:Startup", function()
	Targeting.Zones:AddBox("lsfc-clockinoff-1", "chess-clock", vector3(1617.97, 4832.24, 33.14), 1.6, 0.8, {
		heading = 10.0,
		debugPoly = false,
		minZ = 32.14,
		maxZ = 33.34,
	}, {
		{
			icon = "clipboard-check",
			text = "Clock In",
			event = "Restaurant:Client:ClockIn",
			data = { job = "lsfc" },
			jobPerms = {
				{
					job = "lsfc",
					reqOffDuty = true,
				},
			},
		},
		{
			icon = "clipboard",
			text = "Clock Out",
			event = "Restaurant:Client:ClockOut",
			data = { job = "lsfc" },
			jobPerms = {
				{
					job = "lsfc",
					reqDuty = true,
				},
			},
		},
	}, 3.0, true)
end)
