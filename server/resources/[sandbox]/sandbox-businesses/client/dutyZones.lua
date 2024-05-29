AddEventHandler("Businesses:Client:Startup", function()
	Polyzone.Create:Box("unicorn_offdutyzone", vector3(119.96, -1302.6, 29.12), 61.4, 67.4, {
		heading = 7,
		--debugPoly=true,
		minZ = 25.32,
		maxZ = 46.32,
	}, {
		goOffDuty = "unicorn",
		goOffDutyTimer = 15, -- Minutes
	})

	Polyzone.Create:Poly("autoexotics_offdutyzone", {
		vector2(525.57733154297, -147.49894714355),
		vector2(524.30938720703, -159.20474243164),
		vector2(524.62188720703, -171.75160217285),
		vector2(531.15222167969, -193.53562927246),
		vector2(538.61694335938, -220.47174072266),
		vector2(520.58044433594, -281.94580078125),
		vector2(543.20123291016, -291.62701416016),
		vector2(569.04608154297, -238.08901977539),
		vector2(579.29455566406, -244.13694763184),
		vector2(608.89074707031, -183.92904663086),
		vector2(561.16107177734, -164.25286865234),
		vector2(556.12274169922, -147.75842285156),
		vector2(544.82659912109, -147.91070556641),
	}, {
		--debugPoly=true,
		minZ = 29.526962280273,
		maxZ = 74.530416488647,
	}, {
		goOffDuty = "autoexotics",
		goOffDutyTimer = 20, -- Minutes
	})

	Polyzone.Create:Box("bahama_offdutyzone", vector3(-1387.98, -612.01, 30.22), 53.2, 39.8, {
		heading = 33,
		--debugPoly=true,
		minZ = 25.32,
		maxZ = 46.32,
	}, {
		goOffDuty = "bahama",
		goOffDutyTimer = 15, -- Minutes
	})

	Polyzone.Create:Box("dreamworks_offdutyzone", vector3(-744.94, -1476.06, 5.0), 102.8, 118.4, {
		heading = 50,
		--debugPoly=true,
		minZ = 2.0,
		maxZ = 15.4,
	}, {
		goOffDuty = "dreamworks",
		goOffDutyTimer = 20, -- Minutes
	})

	Polyzone.Create:Box("rockford_records_offdutyzone", vector3(-990.76, -279.63, 39.05), 56.0, 72.6, {
		heading = 298,
		--debugPoly=true,
		minZ = 33.05,
		maxZ = 57.25,
	}, {
		goOffDuty = "rockford_records",
		goOffDutyTimer = 15, -- Minutes
	})

	Polyzone.Create:Box("triad_offdutyzone", vector3(-827.49, -712.77, 27.89), 57.6, 45.8, {
		heading = 0,
		--debugPoly=true,
		minZ = 5.89,
		maxZ = 124.49,
	}, {
		goOffDuty = "triad",
		goOffDutyTimer = 15, -- Minutes
	})

	Polyzone.Create:Box("lsfc_offdutyzone", vector3(1636.4, 4855.55, 33.14), 69.0, 50, {
		heading = 7,
		--debugPoly=true,
		minZ = 18.54,
		maxZ = 50.54,
	}, {
		goOffDuty = "lsfc",
		goOffDutyTimer = 10, -- Minutes
	})

	Polyzone.Create:Box("lasttrain_offdutyzone", vector3(-374.12, 279.15, 84.99), 57.4, 42.0, {
		heading = 0,
		--debugPoly=true,
		minZ = 81.39,
		maxZ = 90.39,
	}, {
		goOffDuty = "lasttrain",
		goOffDutyTimer = 15, -- Minutes
	})

	Polyzone.Create:Box("tequila_offdutyzone", vector3(-556.95, 286.15, 99.17), 42.2, 39.4, {
		heading = 0,
		--debugPoly=true,
		minZ = 75.57,
		maxZ = 97.17,
	}, {
		goOffDuty = "tequila",
		goOffDutyTimer = 15, -- Minutes
	})

	Polyzone.Create:Box("woods_saloon_offdutyzone", vector3(-305.68, 6269.82, 31.36), 26.8, 24.2, {
		heading = 44,
		--debugPoly=true,
		minZ = 29.36,
		maxZ = 36.36,
	}, {
		goOffDuty = "woods_saloon",
		goOffDutyTimer = 20, -- Minutes
	})

	-- Polyzone.Create:Box("pepega_pawn_offdutyzone", vector3(170.78, -1316.72, 29.36), 28.6, 46.6, {
	-- 	heading = 330,
	-- 	--debugPoly=true,
	-- 	minZ = 28.36,
	-- 	maxZ = 38.16,
	-- }, {
	-- 	goOffDuty = "pepega_pawn",
	-- 	goOffDutyTimer = 10, -- Minutes
	-- })

	Polyzone.Create:Box("pepega_pawn_hawick_offdutyzone", vector3(-321.67, -95.88, 47.05), 17.4, 59.2, {
		heading = 340,
		--debugPoly=true,
		minZ = 44.25,
		maxZ = 55.45,
	}, {
		goOffDuty = "pepega_pawn",
		goOffDutyTimer = 10, -- Minutes
	})

	Polyzone.Create:Box("garcon_pawn_offdutyzone", vector3(-224.68, 6230.24, 31.49), 27.8, 24.2, {
		heading = 45,
		--debugPoly=true,
		minZ = 29.89,
		maxZ = 39.29,
	}, {
		goOffDuty = "garcon_pawn",
		goOffDutyTimer = 10, -- Minutes
	})

	Polyzone.Create:Box("uwu_offdutyzone", vector3(-590.48, -1084.29, 22.33), 85.4, 69.6, {
		heading = 1,
		--debugPoly=true,
		minZ = 18.33,
		maxZ = 33.33,
	}, {
		goOffDuty = "uwu",
		goOffDutyTimer = 15, -- Minutes
	})

	Polyzone.Create:Box("pizza_this_offdutyzone", vector3(805.32, -750.21, 42.06), 50.8, 36.0, {
		heading = 0,
		--debugPoly=true,
		minZ = 17.86,
		maxZ = 43.86,
	}, {
		goOffDuty = "pizza_this",
		goOffDutyTimer = 15, -- Minutes
	})

	Polyzone.Create:Box("prego_offdutyzone", vector3(-1120.35, -1453.0, 17.12), 24.5, 32.5, {
		heading = 305,
		--debugPoly=true,
		minZ = -7.08,
		maxZ = 18.92,
	}, {
		goOffDuty = "prego",
		goOffDutyTimer = 15, -- Minutes
	})

	Polyzone.Create:Box("noodle_offdutyzone", vector3(-1188.02, -1159.9, 18.06), 23.5, 32.5, {
		heading = 195,
		--debugPoly=true,
		minZ = -6.14,
		maxZ = 19.86,
	}, {
		goOffDuty = "noodle",
		goOffDutyTimer = 15, -- Minutes
	})

	Polyzone.Create:Box("pdm_offdutyzone", vector3(-34.61, -1096.26, 25.89), 70.0, 55.0, {
		heading = 340,
		--debugPoly=true,
		minZ = 24.89,
		maxZ = 33.33,
	}, {
		goOffDuty = "pdm",
		goOffDutyTimer = 10, -- Minutes
	})

	Polyzone.Create:Box("casino_offdutyzone", vector3(950.83, 45.03, 115.47), 120.0, 90.0, {
		heading = 328,
		--debugPoly=true,
	}, {
		goOffDuty = "casino",
		goOffDutyTimer = 10, -- Minutes
	})

	Polyzone.Create:Box("bakery_offdutyzone", vector3(-1262.7, -290.64, 47.95), 30, 30, {
		heading = 27,
		--debugPoly=true,
		minZ = 35.15,
		maxZ = 45.35,
	}, {
		goOffDuty = "bakery",
		goOffDutyTimer = 15, -- Minutes
	})

	Polyzone.Create:Box("jewel_offdutyzone", vector3(-708.2, -893.29, 27.58), 30, 30, {
		heading = 0,
		--debugPoly=true,
		minZ = 15.58,
		maxZ = 32.78,
	}, {
		goOffDuty = "jewel",
		goOffDutyTimer = 10, -- Minutes
	})

	Polyzone.Create:Box("vangelico_offdutyzone", vector3(-384.17, 6047.39, 31.5), 26.1, 40.75, {
		heading = 317,
		--debugPoly=true,
		minZ = 30.3,
		maxZ = 36.1,
	}, {
		goOffDuty = "vangelico",
		goOffDutyTimer = 15, -- Minutes
	})

	Polyzone.Create:Box("vangelico_grapeseed_offdutyzone", vector3(1646.25, 4883.42, 42.08), 20.6, 24.2, {
		heading = 8,
		--debugPoly=true,
		minZ = 40.08,
		maxZ = 49.08,
	}, {
		goOffDuty = "vangelico_grapeseed",
		goOffDutyTimer = 15, -- Minutes
	})

	Polyzone.Create:Box("beanmachine_offdutyzone", vector3(118.04, -1038.19, 29.36), 28.6, 19.6, {
		heading = 340,
		--debugPoly=true,
		minZ = 28.36,
		maxZ = 35.56,
	}, {
		goOffDuty = "beanmachine",
		goOffDutyTimer = 15, -- Minutes
	})

	Polyzone.Create:Box("burgershot_offdutyzone", vector3(-1185.72, -893.32, 14.03), 45.8, 30.6, {
		heading = 300,
		--debugPoly=true,
		minZ = 11.83,
		maxZ = 22.83,
	}, {
		goOffDuty = "burgershot",
		goOffDutyTimer = 15, -- Minutes
	})

	Polyzone.Create:Box("rustybrowns_offdutyzone", vector3(154.81, 240.54, 106.92), 27.6, 21.4, {
		heading = 340,
		--debugPoly=true,
		minZ = 105.32,
		maxZ = 117.72,
	}, {
		goOffDuty = "rustybrowns",
		goOffDutyTimer = 15, -- Minutes
	})

	Polyzone.Create:Box("mba_offdutyzone", vector3(-322.88, -1969.15, 83.02), 206.0, 260.0, {
		heading = 0,
	}, {
		goOffDuty = "mba",
		goOffDutyTimer = 10, -- Minutes
	})

	Polyzone.Create:Box("tuna_offdutyzone", vector3(141.624, -3024.490, 7.041), 70.0, 70.0, {
		heading = 180,
		--debugPoly=true,
		minZ = 3.89,
		maxZ = 14.33,
	}, {
		goOffDuty = "tuna",
		goOffDutyTimer = 20, -- Minutes
	})

	Polyzone.Create:Box("bennys_offdutyzone", vector3(-215.27, -1325.25, 49.27), 47.8, 68.8, {
		heading = 0,
		--debugPoly=true,
		minZ = 26.67,
		maxZ = 48.87,
	}, {
		goOffDuty = "bennys",
		goOffDutyTimer = 20, -- Minutes
	})

	Polyzone.Create:Box("ottos_offdutyzone", vector3(933.22, -963.35, 39.8), 58.4, 61.8, {
		heading = 0,
		--debugPoly=true,
		minZ = 34.07,
		maxZ = 48.67,
	}, {
		goOffDuty = "ottos",
		goOffDutyTimer = 20, -- Minutes
	})

	Polyzone.Create:Box("hayes_offdutyzone", vector3(-1416.83, -449.99, 41.01), 36.4, 47.7, {
		heading = 32,
		--debugPoly=true,
		minZ = 17.41,
		maxZ = 42.81,
	}, {
		goOffDuty = "hayes",
		goOffDutyTimer = 20, -- Minutes
	})

	Polyzone.Create:Box("harmony_offdutyzone", vector3(1183.8, 2650.36, 37.93), 50.0, 52.6, {
		heading = 358,
		--debugPoly=true,
		minZ = 14.33,
		maxZ = 43.13,
	}, {
		goOffDuty = "harmony",
		goOffDutyTimer = 20, -- Minutes
	})

	Polyzone.Create:Box("paleto_tuners_offdutyzone", vector3(157.02, 6401.64, 41.06), 112.2, 101.6, {
		heading = 30,
		--debugPoly=true,
		minZ = 28.06,
		maxZ = 43.06,
	}, {
		goOffDuty = "paleto_tuners",
		goOffDutyTimer = 20, -- Minutes
	})

	-- Polyzone.Create:Box("securoserv_offdutyzone", vector3(24.56, -112.35, 55.94), 31.0, 21.4, {
	-- 	heading = 340,
	-- 	--debugPoly=true,
	-- 	minZ = 52.34,
	-- 	maxZ = 67.54,
	-- }, {
	-- 	goOffDuty = "securoserv",
	-- 	goOffDutyTimer = 15, -- Minutes
	-- })
end)

local pendingOffDuty = nil
local pendingTimeout = nil

AddEventHandler("Polyzone:Exit", function(id, testedPoint, insideZones, data)
	if data.goOffDuty and LocalPlayer.state.onDuty == data.goOffDuty then
		LocalPlayer.state:set("inDutyZone", false, true)
		if data.goOffDutyTimer and data.goOffDutyTimer > 0 then
			pendingOffDuty = data.goOffDuty

			Notification:Info(
				string.format(
					"Leaving Business Area - You Will be Automatically Clocked Off in %s Minutes.",
					data.goOffDutyTimer
				)
			)

			local time = GetGameTimer()
			pendingTimeout = time
			Citizen.SetTimeout(60000 * data.goOffDutyTimer, function()
				if pendingOffDuty and LocalPlayer.state.onDuty == pendingOffDuty and pendingTimeout == time then
					Jobs.Duty:Off(pendingOffDuty)
					LocalPlayer.state:set("sentOffDuty", pendingOffDuty, true)
				end
			end)
		else
			Jobs.Duty:Off(data.goOffDuty)
			LocalPlayer.state:set("sentOffDuty", data.goOffDuty, true)
		end
	end
end)

AddEventHandler("Polyzone:Enter", function(id, testedPoint, insideZones, data)
	if data.goOffDuty and pendingOffDuty == data.goOffDuty then
		pendingOffDuty = nil
		pendingTimeout = nil
		LocalPlayer.state:set("inDutyZone", true, true)
	end
end)

RegisterNetEvent("Job:Client:DutyChanged", function(state)
	if state then
		LocalPlayer.state:set("sentOffDuty", false, true)
		LocalPlayer.state:set("inDutyZone", true, true)
	else
		LocalPlayer.state:set("inDutyZone", false, true)
	end
end)
