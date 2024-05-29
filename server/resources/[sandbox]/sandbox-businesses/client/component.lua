AddEventHandler("Businesses:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Logger = exports["sandbox-base"]:FetchComponent("Logger")
	Fetch = exports["sandbox-base"]:FetchComponent("Fetch")
	Callbacks = exports["sandbox-base"]:FetchComponent("Callbacks")
	Game = exports["sandbox-base"]:FetchComponent("Game")
	Utils = exports["sandbox-base"]:FetchComponent("Utils")
	Animations = exports["sandbox-base"]:FetchComponent("Animations")
	Notification = exports["sandbox-base"]:FetchComponent("Notification")
	Targeting = exports["sandbox-base"]:FetchComponent("Targeting")
	Polyzone = exports["sandbox-base"]:FetchComponent("Polyzone")
	Jobs = exports["sandbox-base"]:FetchComponent("Jobs")
	Weapons = exports["sandbox-base"]:FetchComponent("Weapons")
	Progress = exports["sandbox-base"]:FetchComponent("Progress")
	Vehicles = exports["sandbox-base"]:FetchComponent("Vehicles")
	ListMenu = exports["sandbox-base"]:FetchComponent("ListMenu")
	Action = exports["sandbox-base"]:FetchComponent("Action")
	Sounds = exports["sandbox-base"]:FetchComponent("Sounds")
	PedInteraction = exports["sandbox-base"]:FetchComponent("PedInteraction")
	Blips = exports["sandbox-base"]:FetchComponent("Blips")
	Keybinds = exports["sandbox-base"]:FetchComponent("Keybinds")
	Minigame = exports["sandbox-base"]:FetchComponent("Minigame")
	Input = exports["sandbox-base"]:FetchComponent("Input")
	Interaction = exports["sandbox-base"]:FetchComponent("Interaction")
	Inventory = exports["sandbox-base"]:FetchComponent("Inventory")
	StorageUnits = exports["sandbox-base"]:FetchComponent("StorageUnits")
	HUD = exports["sandbox-base"]:FetchComponent("Hud")
	Crafting = exports["sandbox-base"]:FetchComponent("Crafting")
	Stream = exports["sandbox-base"]:FetchComponent("Stream")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["sandbox-base"]:RequestDependencies("Businesses", {
		"Logger",
		"Fetch",
		"Callbacks",
		"Game",
		"Menu",
		"Notification",
		"Utils",
		"Animations",
		"Targeting",
		"Polyzone",
		"Jobs",
		"Weapons",
		"Progress",
		"Vehicles",
		"ListMenu",
		"Action",
		"Sounds",
		"PedInteraction",
		"Blips",
		"Keybinds",
		"Minigame",
		"Input",
		"Interaction",
		"Inventory",
		"StorageUnits",
		"Hud",
		"Crafting",
		"Stream",
	}, function(error)
		if #error > 0 then
			return
		end
		RetrieveComponents()

		TriggerEvent("Businesses:Client:Startup")
	end)
end)

RegisterNetEvent("Characters:Client:Spawn")
AddEventHandler("Characters:Client:Spawn", function()
	--  self, id, name, coords, sprite, colour, scale, display, category, flashes
	-- Blips:Add("shopping-mall", "Shopping Mall", vector3(-555.491, -597.852, 34.682), 59, 50, 0.6)
	Blips:Add(
		"black_woods_saloon",
		"Black Woods Saloon",
		vector3(-305.136078, 6264.041016, 31.526928),
		93,
		31,
		0.6,
		2,
		11
	)

	-- Blips:Add(
	-- 	"redline-performance",
	-- 	"Mechanic: Redline Performance",
	-- 	vector3(-600.028, -929.695, 23.866),
	-- 	483,
	-- 	59,
	-- 	0.6,
	-- 	2,
	-- 	11
	-- )
	Blips:Add("pizza_this", "Pizza This", vector3(793.905, -758.289, 26.779), 267, 52, 0.5, 2, 11)
	Blips:Add("uwu_cafe", "UwU Cafe", vector3(-581.098, -1070.048, 22.330), 621, 34, 0.6, 2, 11)
	--Blips:Add("arcade", "Business: Arcade", vector3(-1651.675, -1082.294, 13.156), 484, 58, 0.8, 2, 11)
	Blips:Add("cloud9_drift", "Business: Cloud9 Drift", vector3(-27.3694, -2544.8574, 6.0120), 315, 77, 0.5, 2, 11)

	Blips:Add("tuna", "Business: Tuner Shop", vector3(161.992, -3036.946, 6.683), 611, 83, 0.6, 2, 11)
	Blips:Add("triad", "Triad Records", vector3(-832.578, -698.627, 27.280), 614, 76, 0.5, 2, 11)

	Blips:Add("mba", "Maze Bank Arena", vector3(-284.307, -1920.541, 29.946), 675, 50, 0.6, 2, 11)

	Blips:Add("bballs", "Bobs Balls", vector3(756.944, -768.288, 26.337), 536, 23, 0.4, 2, 11)

	--Blips:Add("cabco", "Business: Downtown Cab Co.", vector3(908.036, -160.553, 74.142), 198, 5, 0.4, 2, 11)

	--Blips:Add("tirenutz", "Mechanic: Tire Nutz", vector3(-73.708, -1338.770, 29.257), 488, 62, 0.7, 2, 11)
	--Blips:Add("atomic", "Mechanic: Atomic Mechanics", vector3(482.176, -1889.637, 26.095), 544, 33, 1.0, 2, 11)
	Blips:Add("hayes", "Hayes Autos", vector3(-1418.532, -445.162, 35.910), 544, 63, 1.0, 2, 11)
	Blips:Add("autoexotics", "Auto Exotics", vector3(539.754, -182.979, 54.487), 488, 68, 0.7, 2, 11)
	Blips:Add("harmony", "Harmony Repairs", vector3(1176.567, 2657.295, 37.972), 542, 7, 0.5, 2, 11)

	Blips:Add("bakery", "Bakery", vector3(-1255.273, -293.090, 37.383), 106, 31, 0.5, 2, 11)
	-- Blips:Add("noodle", "Noodle Exchange", vector3(-1194.746, -1161.401, 7.692), 414, 6, 0.5, 2, 11)
	Blips:Add("burgershot", "Burger Shot", vector3(-1183.511, -884.722, 13.800), 106, 6, 0.5, 2, 11)

	Blips:Add("rustybrowns", "Rusty Browns", vector3(148.068, 238.705, 106.983), 270, 8, 0.65, 2, 11)

	-- Blips:Add("lasttrain", "Last Train Diner", vector3(-361.137, 275.310, 86.422), 208, 6, 0.5, 2, 11)
	Blips:Add("beanmachine", "Business: Bean Machine", vector3(116.985, -1039.424, 29.278), 536, 52, 0.5, 2, 11)

	Blips:Add("tequila", "Tequi-la-la", vector3(-564.575, 276.170, 83.119), 93, 81, 0.6, 2, 11)

	Blips:Add("dyn8", "Dynasty 8 Real Estate", vector3(-708.271, 268.543, 83.147), 374, 52, 0.65, 2)

	Blips:Add("unicorn", "Vanilla Unicorn", vector3(110.380, -1313.496, 29.210), 121, 48, 0.7, 2, 11)

	Blips:Add("bahama", "Bahama Mamas", vector3(-1388.605, -586.612, 30.219), 93, 61, 0.7, 2, 11)

	Blips:Add("smokeonwater", "Smoke on the Water", vector3(-1169.751, -1571.643, 4.667), 140, 52, 0.6, 2, 11)

	Blips:Add("digitalden", "Digital Den", vector3(1137.494, -470.840, 66.659), 355, 58, 0.6, 2, 11)

	-- Blips:Add("rockford_records", "Rockford Records", vector3(-1007.658, -267.795, 39.040), 614, 63, 0.5, 2, 11)

	-- Blips:Add("gruppe6", "Gruppe 6 Security", vector3(22.813, -123.661, 55.978), 487, 24, 0.8, 2, 11)

	Blips:Add("pepega_pawn", "Pepega Pawn", vector3(-296.300, -106.232, 47.051), 605, 1, 0.6, 2, 11)

	Blips:Add("garcon_pawn", "Garcon Pawn", vector3(-231.868, 6235.155, 31.496), 605, 1, 0.6, 2, 11)

	-- Blips:Add("ottos_autos", "Ottos Autos", vector3(946.128, -988.302, 39.178), 483, 25, 0.8, 2, 11)

	-- Blips:Add("fightclub", "The Fightclub", vector3(1059.197, -2409.773, 29.928), 311, 8, 0.6, 2, 11)

	-- Blips:Add("jewel", "The Jeweled Dragon", vector3(-708.910, -886.714, 23.804), 674, 5, 0.6, 2, 11)

	Blips:Add("vangelico", "Vangelico Paleto", vector3(-384.467, 6041.473, 31.500), 617, 53, 0.6, 2, 11)

	Blips:Add("vangelico_grapeseed", "Vangelico Grapeseed", vector3(1655.029, 4883.049, 41.969), 617, 53, 0.6, 2, 11)

	-- Blips:Add("sagma", "San Andreas Gallery of Modern Art", vector3(-424.835, 21.379, 46.269), 674, 5, 0.6, 2, 11)

	Blips:Add("bennys", "Benny's Mechanics", vector3(-211.4965, -1326.7563, 31.3005), 544, 63, 1.0, 2, 11)

	Blips:Add("taco", "Taco Shop", vector3(8.572, -1609.225, 29.296), 52, 43, 0.6, 2, 11)

	-- Blips:Add("prego", "Cafe Prego", vector3(-1114.819, -1452.965, 5.147), 267, 6, 0.7, 2, 11)

	-- Blips:Add("white_law", "White & Associates", vector3(-1370.389, -502.949, 33.158), 457, 10, 0.7, 2, 11)

	Blips:Add("paleto_tuners", "Paleto Tuners", vector3(160.253, 6386.286, 31.343), 544, 43, 1.0, 2, 11)

	Blips:Add("dreamworks", "Dreamworks Mechanics", vector3(-739.396, -1514.290, 5.055), 524, 6, 0.7, 2, 11)
end)

RegisterNetEvent("Businesses:Client:CreatePoly", function(pickups, onSpawn)
	for k, v in ipairs(pickups) do
		local data = GlobalState[string.format("Businesses:Pickup:%s", v)]
		if data ~= nil then
			Targeting.Zones:AddBox(data.id, "box-open", data.coords, data.width, data.length, data.options, {
				{
					icon = "box-open",
					text = string.format("Pickup Order (#%s)", data.num),
					event = "Businesses:Client:Pickup",
					data = data.data,
				},
				{
					icon = "money-check-dollar-pen",
					text = "Set Contactless Payment",
					event = "Businesses:Client:CreateContactlessPayment",
					isEnabled = function(data)
						return not GlobalState[string.format("PendingContactless:%s", data.id)]
					end,
					data = data,
					jobPerms = {
						{
							job = data.job,
							reqDuty = true,
						},
					},
				},
				{
					icon = "money-check-dollar-pen",
					text = "Clear Contactless Payment",
					event = "Businesses:Client:ClearContactlessPayment",
					isEnabled = function(data)
						return GlobalState[string.format("PendingContactless:%s", data.id)]
					end,
					data = data,
					jobPerms = {
						{
							job = data.job,
							reqDuty = true,
						},
					},
				},
				{
					icon = "money-check-dollar",
					isEnabled = function(data)
						return GlobalState[string.format("PendingContactless:%s", data.id)]
							and GlobalState[string.format("PendingContactless:%s", data.id)] > 0
					end,
					textFunc = function(data)
						if
							GlobalState[string.format("PendingContactless:%s", data.id)]
							and GlobalState[string.format("PendingContactless:%s", data.id)] > 0
						then
							return string.format(
								"Pay Contactless ($%s)",
								GlobalState[string.format("PendingContactless:%s", data.id)]
							)
						end
					end,
					event = "Businesses:Client:PayContactlessPayment",
					data = data,
					item = "phone",
				},
			}, 2.0, true)
		end
	end
end)

AddEventHandler("Businesses:Client:Pickup", function(entity, data)
	Inventory.Dumbfuck:Open(data.inventory)
end)

function GetBusinessClockInMenu(businessName)
	return {
		{
			icon = "clipboard-check",
			text = "Clock In",
			event = "Businesses:Client:ClockIn",
			data = { job = businessName },
			jobPerms = {
				{
					job = businessName,
					reqOffDuty = true,
				},
			},
		},
		{
			icon = "clipboard",
			text = "Clock Out",
			event = "Businesses:Client:ClockOut",
			data = { job = businessName },
			jobPerms = {
				{
					job = businessName,
					reqDuty = true,
				},
			},
		},
	}
end

AddEventHandler("Businesses:Client:Startup", function()
	Targeting.Zones:AddBox("digitalden-clockinoff", "chess-clock", vector3(384.17, -830.31, 29.3), 1.2, 0.8, {
		heading = 0,
		--debugPoly=true,
		minZ = 28.7,
		maxZ = 30.3,
	}, GetBusinessClockInMenu("digitalden"), 3.0, true)

	Targeting.Zones:AddBox("securoserv-clockinoff", "chess-clock", vector3(19.99, -119.98, 56.22), 2, 1.0, {
		heading = 340,
		--debugPoly=true,
		minZ = 55.22,
		maxZ = 57.42,
	}, GetBusinessClockInMenu("securoserv"), 3.0, true)

	Targeting.Zones:AddBox("pepega_pawn-clockinoff", "chess-clock", vector3(-328.13, -90.89, 47.05), 2.6, 0.6, {
		heading = 340,
		--debugPoly=true,
		minZ = 45.65,
		maxZ = 47.85,
	}, {
		{
			icon = "clipboard-check",
			text = "Clock In",
			event = "Businesses:Client:ClockIn",
			data = { job = "pepega_pawn" },
			jobPerms = {
				{
					job = "pepega_pawn",
					reqOffDuty = true,
				},
			},
		},
		{
			icon = "clipboard",
			text = "Clock Out",
			event = "Businesses:Client:ClockOut",
			data = { job = "pepega_pawn" },
			jobPerms = {
				{
					job = "pepega_pawn",
					reqDuty = true,
				},
			},
		},
		-- {
		-- 	icon = "tv",
		-- 	text = "Set TV Link",
		-- 	event = "Billboards:Client:SetLink",
		-- 	data = { id = "business_pepega" },
		-- 	jobPerms = {
		-- 		{
		-- 			job = "pepega_pawn",
		-- 			reqDuty = true,
		-- 		},
		-- 	},
		-- },
	}, 3.0, true)

	Targeting.Zones:AddBox("garcon_pawn-clockinoff", "chess-clock", vector3(-216.49, 6231.88, 31.79), 1.8, 1.0, {
		heading = 315,
		--debugPoly=true,
		minZ = 28.39,
		maxZ = 32.39,
	}, {
		{
			icon = "clipboard-check",
			text = "Clock In",
			event = "Businesses:Client:ClockIn",
			data = { job = "garcon_pawn" },
			jobPerms = {
				{
					job = "garcon_pawn",
					reqOffDuty = true,
				},
			},
		},
		{
			icon = "clipboard",
			text = "Clock Out",
			event = "Businesses:Client:ClockOut",
			data = { job = "garcon_pawn" },
			jobPerms = {
				{
					job = "garcon_pawn",
					reqDuty = true,
				},
			},
		},
	}, 3.0, true)

	Targeting.Zones:AddBox("sagma-clockinoff", "chess-clock", vector3(-422.48, 31.83, 46.23), 1, 1, {
		heading = 8,
		--debugPoly=true,
		minZ = 46.03,
		maxZ = 47.23,
	}, GetBusinessClockInMenu("sagma"), 3.0, true)

	Targeting.Zones:AddBox("sagma-clockinoff2", "chess-clock", vector3(-491.26, 31.8, 46.3), 1, 1, {
		heading = 355,
		--debugPoly=true,
		minZ = 46.1,
		maxZ = 47.1,
	}, GetBusinessClockInMenu("sagma"), 3.0, true)

	Targeting.Zones:AddBox("jewel-clockinoff", "chess-clock", vector3(-708.553, -900.005, 23.819), 0.5, 0.5, {
		heading = 356,
		--debugPoly=true,
		minZ = 23.219,
		maxZ = 24.219,
	}, GetBusinessClockInMenu("jewel"), 3.0, true)

	Targeting.Zones:AddBox("vangelico-clockinoff", "chess-clock", vector3(-382.69, 6046.2, 31.51), 0.6, 0.4, {
		heading = 45,
		--debugPoly=true,
		minZ = 31.16,
		maxZ = 31.91,
	}, GetBusinessClockInMenu("vangelico"), 3.0, true)

	Targeting.Zones:AddBox(
		"vangelico_grapeseed-clockinoff",
		"chess-clock",
		vector3(1651.47, 4880.55, 42.16),
		0.6,
		0.4,
		{
			heading = 8,
			--debugPoly=true,
			minZ = 38.56,
			maxZ = 42.56,
		},
		GetBusinessClockInMenu("vangelico_grapeseed"),
		3.0,
		true
	)

	Targeting.Zones:AddBox("tuner-tvs", "tv", vector3(125.35, -3014.88, 7.04), 0.8, 2.0, {
		heading = 0,
		--debugPoly=true,
		minZ = 6.64,
		maxZ = 7.64,
	}, {
		{
			icon = "tv",
			text = "Set TV Link",
			event = "Billboards:Client:SetLink",
			data = { id = "business_tuner" },
			jobPerms = {
				{
					job = "tuna",
					reqDuty = true,
				},
			},
		},
	}, 3.0, true)

	Targeting.Zones:AddBox("paleto_tuners-clockinoff", "chess-clock", vector3(178.55, 6382.73, 31.27), 2.0, 1.4, {
		heading = 28,
		--debugPoly=true,
		minZ = 30.27,
		maxZ = 32.07,
	}, {
		{
			icon = "clipboard-check",
			text = "Clock In",
			event = "Businesses:Client:ClockIn",
			data = { job = "paleto_tuners" },
			jobPerms = {
				{
					job = "paleto_tuners",
					reqOffDuty = true,
				},
			},
		},
		{
			icon = "clipboard",
			text = "Clock Out",
			event = "Businesses:Client:ClockOut",
			data = { job = "paleto_tuners" },
			jobPerms = {
				{
					job = "paleto_tuners",
					reqDuty = true,
				},
			},
		},
		{
			icon = "tv",
			text = "Set TV Link",
			event = "Billboards:Client:SetLink",
			data = { id = "business_paleto_tuners" },
			jobPerms = {
				{
					job = "paleto_tuners",
					reqDuty = true,
				},
			},
		},
	}, 3.0, true)

	Targeting.Zones:AddBox("paleto_tuners-clockinoff2", "chess-clock", vector3(149.34, 6378.17, 31.27), 1.4, 1.8, {
		heading = 26,
		--debugPoly=true,
		minZ = 30.27,
		maxZ = 31.87,
	}, {
		{
			icon = "clipboard-check",
			text = "Clock In",
			event = "Businesses:Client:ClockIn",
			data = { job = "paleto_tuners" },
			jobPerms = {
				{
					job = "paleto_tuners",
					reqOffDuty = true,
				},
			},
		},
		{
			icon = "clipboard",
			text = "Clock Out",
			event = "Businesses:Client:ClockOut",
			data = { job = "paleto_tuners" },
			jobPerms = {
				{
					job = "paleto_tuners",
					reqDuty = true,
				},
			},
		},
		{
			icon = "tv",
			text = "Set TV Link",
			event = "Billboards:Client:SetLink",
			data = { id = "business_paleto_tuners" },
			jobPerms = {
				{
					job = "paleto_tuners",
					reqDuty = true,
				},
			},
		},
	}, 3.0, true)

	Targeting.Zones:AddBox("blackline-clockinoff", "circle-dot", vector3(946.64, -1744.41, 21.03), 2.2, 2.2, {
		heading = 0,
		--debugPoly=true,
		minZ = 20.03,
		maxZ = 22.43,
	}, {
		{
			icon = "clipboard-check",
			text = "Clock In",
			event = "Businesses:Client:ClockIn",
			data = { job = "blackline" },
			jobPerms = {
				{
					job = "blackline",
					reqOffDuty = true,
				},
			},
		},
		{
			icon = "clipboard",
			text = "Clock Out",
			event = "Businesses:Client:ClockOut",
			data = { job = "blackline" },
			jobPerms = {
				{
					job = "blackline",
					reqDuty = true,
				},
			},
		},
	}, 3.0, true)
end)

AddEventHandler("Businesses:Client:ClockIn", function(_, data)
	if data and data.job then
		Jobs.Duty:On(data.job)
	end
end)

AddEventHandler("Businesses:Client:ClockOut", function(_, data)
	if data and data.job then
		Jobs.Duty:Off(data.job)
	end
end)
