local _intIPL = "gabz_mba_milo_"
local _intCoords = { x = -324.22030000, y = -1968.49300000, z = 20.60336000 }

local _eventNames = {
	basketball = 'Basketball',
	boxing = 'Boxing',
	concert = 'Concert',
	curling = 'Curling',
	derby = 'Derby',
	fameorshame = 'Fame or Shame',
	fashion = 'Fashion',
	football = 'Football',
	icehockey = 'Ice Hockey',
	gokarta = 'Go-Kart A',
	gokartb = 'Go-Kart B',
	trackmaniaa = 'Track Mania A',
	trackmaniab = 'Track Mania B',
	trackmaniac = 'Track Mania C',
	trackmaniad = 'Track Mania D',
	mma = 'MMA',
	none = 'None',
	paintball = 'Paintball',
	rocketleague = 'Rocket League',
	wrestling = 'Wrestling'
}

function SetMBAInterior(entitySet)
    local interior = GetInteriorAtCoords(_intCoords.x, _intCoords.y, _intCoords.z)

    if IsValidInterior(interior) then
		if interior ~= 0 then
			local removeSets, newEntitySet = _EntitySets.Removals.interiors, _EntitySets.Sets[entitySet]
			local removeSigns, newSign = _EntitySets.Removals.signs, _EntitySets.Signs[entitySet]

			for i = 1, #removeSets do
				DeactivateInteriorEntitySet(interior, removeSets[i])
			end

			for i = 1, #removeSigns do
				RemoveIpl(removeSigns[i])
			end

			Wait(100)

			for i = 1, #newEntitySet do
				ActivateInteriorEntitySet(interior, newEntitySet[i])
			end

			if newSign then
				RequestIpl(newSign)
			end

			RefreshInterior(interior)
		end
    end
end

RegisterNetEvent("Characters:Client:Spawn")
AddEventHandler("Characters:Client:Spawn", function()
    while GlobalState["MBA:Interior"] == nil do
        Citizen.Wait(5)
    end
	print('GlobalState["MBA:Interior"]', GlobalState["MBA:Interior"])
    SetMBAInterior(GlobalState["MBA:Interior"])
end)

Citizen.CreateThread(function()
    if LocalPlayer.state.loggedIn then
        SetMBAInterior(GlobalState["MBA:Interior"])
    end
end)

RegisterNetEvent("Businesses:Client:MBA:InteriorUpdate", function(v)
    if LocalPlayer.state.loggedIn then
        SetMBAInterior(v)
    end
end)

AddEventHandler("Businesses:Client:Startup", function()

    Targeting.Zones:AddBox("mba-event-management", "wand-magic-sparkles", vector3(-288.47, -1949.26, 38.05), 5.0, 1.0, {
        heading = 50,
        --debugPoly=true,
        minZ = 37.05,
        maxZ = 39.05
	}, {
        {
            icon = "clipboard-check",
            text = "Clock In",
            event = "Businesses:Client:ClockIn",
			data = { job = "mba" },
			jobPerms = {
				{
					job = "mba",
					reqOffDuty = true,
				}
			},
        },
        {
            icon = "clipboard",
            text = "Clock Out",
            event = "Businesses:Client:ClockOut",
			data = { job = "mba" },
			jobPerms = {
				{
					job = "mba",
					reqDuty = true,
				}
			},
        },
        {
            icon = "wand-magic-sparkles",
            text = "Event Setup",
            event = "Businesses:Client:MBA:StartChangeInterior",
            data = {},
            jobPerms = {
				{
					job = "mba",
					reqDuty = true,
					permissionKey = 'JOB_SET_MBA',
				}
            },
        },
    }, 3.0, true)
end)

AddEventHandler("Businesses:Client:MBA:StartChangeInterior", function()
    local current = GlobalState["MBA:Interior"]

    local options = {}

    for k, v in pairs(_eventNames) do
        if k ~= current then
            table.insert(options, {
                label = v,
                value = k,
            })
        end
    end

    Input:Show(string.format("Change Event Floor - Current: %s", _eventNames[current]), "Match Configuration", {
		{
			id = "interior",
			type = "select",
			select = options,
			options = {},
		},
	}, "Businesses:Client:MBA:ChangeInterior", {})
end)

AddEventHandler("Businesses:Client:MBA:ChangeInterior", function(values)
    if values?.interior then
        Callbacks:ServerCallback("MBA:ChangeInterior", values.interior, function(success)
            if success then
                Notification:Success("Updated")
            else
                Notification:Error("Failed to Change Event Floor")
            end
        end)
    end
end)
