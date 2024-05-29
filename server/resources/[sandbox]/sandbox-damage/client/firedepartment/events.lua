local safdCheckin = {
	{
		coords = vector3(1188.29, -1468.48, 34.86),
		length = 1.2,
		width = 1.2,
		options = {
			heading = 128.0,
			debugPoly = false,
			minZ = 33.23,
			maxZ = 35.23,
		},
	},
	{
		coords = vector3(199.38, -1639.41, 29.80),
		length = 1.2,
		width = 1.2,
		options = {
			heading = 85.0,
			debugPoly = false,
			minZ = 28.23,
			maxZ = 30.23,
		},
	},
}

function SAFDInit()
	-- PedInteraction:Add(
	-- 	"hospital-check-in",
	-- 	`u_f_m_miranda_02`,
	-- 	vector3(-437.484, -323.269, 33.911),
	-- 	162.630,
	-- 	25.0,
	-- 	hospitalCheckin,
	-- 	"notes-medical",
	-- 	"WORLD_HUMAN_CLIPBOARD"
	-- )

	for k, v in ipairs(safdCheckin) do
		Targeting.Zones:AddBox("safd-checkin-" .. k, "chess-clock", v.coords, v.length, v.width, v.options, {
			{
				icon = "clipboard-check",
				text = "Go On Duty",
				event = "EMS:Client:OnDuty",
				jobPerms = {
					{
						job = "ems",
						reqOffDuty = true,
					},
				},
			},
			{
				icon = "clipboard",
				text = "Go Off Duty",
				event = "EMS:Client:OffDuty",
				jobPerms = {
					{
						job = "ems",
						reqDuty = true,
					},
				},
			},
		}, 3.0, true)
	end
end

RegisterNetEvent("Characters:Client:Spawn", function()
	for k, v in ipairs(safdCheckin) do
		Blips:Add("safd-office-" .. k, "Fire & Medical", v.coords, 648, 1, 0.8)
	end
end)
