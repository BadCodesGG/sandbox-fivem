AddEventHandler("Businesses:Client:Startup", function()
	Polyzone.Create:Poly("cloud9-drift-area", {
		vector2(210.07374572754, -2536.0458984375),
		vector2(146.61747741699, -2573.9255371094),
		vector2(14.569815635681, -2559.7707519531),
		vector2(-69.121536254883, -2571.5832519531),
		vector2(-114.825050354, -2560.146484375),
		vector2(-176.95079040527, -2517.75),
		vector2(-179.06674194336, -2607.1774902344),
		vector2(-212.45495605469, -2610.2861328125),
		vector2(-210.50201416016, -2453.4765625),
		vector2(-249.2979888916, -2417.8229980469),
		vector2(-281.83419799805, -2425.3129882813),
		vector2(-302.69195556641, -2401.9189453125),
		vector2(-283.2268371582, -2382.2077636719),
		vector2(-37.403812408447, -2380.8742675781),
		vector2(116.00241851807, -2477.1823730469),
		vector2(97.418601989746, -2527.5705566406),
	}, {
		--debugPoly=true,
		minZ = 2.260225296021,
		maxZ = 8.55025100708,
	})
	Targeting.Zones:AddBox("cloud9-clockinoff-1", "chess-clock", vector3(-59.4912, -2517.1326, 7.40), 1.5, 2.7, {
		heading = 325.0,
		debugPoly = false,
		minZ = 5.40,
		maxZ = 9.40,
	}, {
		{
			icon = "clipboard-check",
			text = "Clock In",
			event = "Restaurant:Client:ClockIn",
			data = { job = "cloud9" },
			jobPerms = {
				{
					job = "cloud9",
					reqOffDuty = true,
				},
			},
		},
		{
			icon = "clipboard",
			text = "Clock Out",
			event = "Restaurant:Client:ClockOut",
			data = { job = "cloud9" },
			jobPerms = {
				{
					job = "cloud9",
					reqDuty = true,
				},
			},
		},
	}, 3.0, true)
end)

AddEventHandler("Polyzone:Enter", function(id, testedPoint, insideZones, data)
	if id == "cloud9-drift-area" then
		DoDriftStuff()
	end
end)

AddEventHandler("Polyzone:Exit", function(id, testedPoint, insideZones, data)
	if id == "cloud9-drift-area" then
		DoDriftStuff()
	end
end)

function DoDriftStuff()
	DeleteDriftStuff()
	ClearAreaOfPeds(10.28622, -2531.553, 5.147942, 50.0, 1)
	ClearAreaOfPeds(-194.1378, -2509.718, 5.137756, 50.0, 1)
	setScenarioState(false)
end

function DeleteDriftStuff()
	setScenarioState(true)
end

AddStateBagChangeHandler("cloud9_drift", nil, function(bagName, key, value, _unused, replicated)
	if Polyzone:IsCoordsInZone(GetEntityCoords(LocalPlayer.state.ped), "cloud9-drift-area") then
		if value then
			DoDriftStuff()
		else
			DeleteDriftStuff()
		end
	end
end)

AddEventHandler("onResourceStop", function(resource)
	if resource == GetCurrentResourceName() then
		DeleteDriftStuff()
	end
end)

local scenarios = {
	"WORLD_VEHICLE_DRIVE_SOLO",
	"WORLD_GULL_STANDING",
	"WORLD_HUMAN_CLIPBOARD",
	"WORLD_HUMAN_SEAT_LEDGE",
	"WORLD_HUMAN_SEAT_LEDGE_EATING",
	"WORLD_HUMAN_STAND_MOBILE",
	"WORLD_HUMAN_HANG_OUT_STREET",
	"WORLD_HUMAN_SMOKING",
	"WORLD_HUMAN_DRINKING",
	"WORLD_GULL_FEEDING",
	"WORLD_HUMAN_GUARD_STAND",
	"WORLD_HUMAN_SEAT_STEPS",
	"WORLD_HUMAN_STAND_IMPATIENT",
	"WORLD_HUMAN_SEAT_WALL_EATING",
	"WORLD_HUMAN_WELDING",
}

function setScenarioState(pToggle)
	for i = 1, #scenarios do
		SetScenarioTypeEnabled(scenarios[i], pToggle)
	end
end
