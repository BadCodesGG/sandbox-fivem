local _tableCam = nil
local _gemObj = 0

local _appraisalTables = {
	{
		coords = vector3(1650.01, 4876.99, 42.16),
		length = 1.0,
		width = 2.4,
		options = {
			heading = 9,
			--debugPoly=true,
			minZ = 39.76,
			maxZ = 43.76,
		},
	},
	{
		coords = vector3(1647.59, 4882.01, 42.16),
		length = 1.4,
		width = 1.4,
		options = {
			heading = 278,
			--debugPoly=true,
			minZ = 38.96,
			maxZ = 42.96,
		},
	},
}

local _tableConfig = {
	{
		createCoords = vector4(1650.01, 4876.99, 42.16, 9.0),
	},
	{
		createCoords = vector4(1647.59, 4882.01, 42.16, 278.0),
	},
}

local _sellers = {
	{
		coords = vector3(-1096.968, -1257.046, 4.367),
		heading = 28.522,
		model = `a_m_y_smartcaspat_01`,
	},
}

AddEventHandler("Businesses:Client:Startup", function()
	for k, v in ipairs(_sellers) do
		PedInteraction:Add(string.format("VANGELICOGRAPESEEDSeller%s", k), v.model, v.coords, v.heading, 25.0, {
			{
				icon = "ring",
				text = "Sell Gems",
				event = "VANGELICOGRAPESEED:Client:Sell",
				jobPerms = {
					{
						job = "vangelico_grapeseed",
						jobPerms = "JOB_SELL_GEMS",
					},
				},
			},
		}, "sack-dollar")
	end

	for k, v in ipairs(_appraisalTables) do
		Targeting.Zones:AddBox(
			"vangelico-grapeseed-table-" .. k,
			"table-picnic",
			v.coords,
			v.length,
			v.width,
			v.options,
			{
				{
					icon = "gem",
					text = "View Gem Table",
					event = "Businesses:Client:VANGELICOGRAPESEED:OpenTable",
					data = { id = k },
					jobPerms = {
						{
							job = "vangelico_grapeseed",
							reqDuty = true,
							jobPerms = "JOB_USE_GEM_TABLE",
						},
					},
				},
				{
					icon = "gem",
					text = "Create Jewelry",
					event = "Businesses:Client:VANGELICOGRAPESEED:OpenJewelryCrafting",
					data = { id = k },
					jobPerms = {
						{
							job = "vangelico_grapeseed",
							reqDuty = true,
							jobPerms = "JOB_USE_JEWELRY_CRAFTING",
						},
					},
				},
			},
			3.0,
			true
		)
	end
end)

RegisterNetEvent("UI:Client:Reset", function()
	CleanupTable()
end)

AddEventHandler("VANGELICOGRAPESEED:Client:Sell", function()
	Callbacks:ServerCallback("Businesses:VANGELICOGRAPESEED:Sell", {})
end)

AddEventHandler("Businesses:Client:VANGELICOGRAPESEED:OpenTable", function(e, data)
	Inventory.Dumbfuck:Open({
		invType = 221,
		owner = data.id,
	})
end)

AddEventHandler("Businesses:Client:VANGELICOGRAPESEED:OpenJewelryCrafting", function(e, data)
	Crafting.Benches:Open("vangelico_grapeseed-jewelry")
end)

RegisterNetEvent("Businesses:Client:VANGELICOGRAPESEED:ViewGem", function(tableId, gemProps, quality, item)
	LocalPlayer.state:set("inGemViewVangelicoGrapeseed", true, true)
	-- HUD.GemTable:Open(quality)
	Inventory.StaticTooltip:Open(item)
	local str = string.format("Gem Quality: %s%%", quality)
	Notification:Standard(str, 5000, "gem")
	--ActivateTable(tableId, gemProps.color, quality, item)
end)

AddEventHandler("Keybinds:Client:KeyUp:cancel_action", function()
	if LocalPlayer.state.inGemView then
		HUD.GemTable:Close()
		Inventory.StaticTooltip:Close()
		LocalPlayer.state:set("inGemViewVangelicoGrapeseed", false, true)
	end
end)

local _threading = false
function RunTableThread()
	if _threading then
		return
	end
	_threading = true
	Citizen.CreateThread(function()
		while _threading do
			if IsControlJustReleased(0, 202) then
				listening = false
				FreezeEntityPosition(LocalPlayer.state.ped, false)
				DoScreenFadeOut(1000)
				Wait(1000)
				CleanupTable()
				DoScreenFadeIn(1000)
				return
			end
			local curHeading = GetEntityHeading(_gemObj)
			if curHeading >= 360 then
				curHeading = 0.0
			end
			SetEntityHeading(_gemObj, curHeading + 0.1)
			DisablePlayerFiring(LocalPlayer.state.ped, true)
			Wait(0)
		end
	end)
end

function ActivateTable(tableId, color, quality, item)
	local prop = `h4_prop_h4_diamond_01a`
	Stream.RequestModel(prop)

	LocalPlayer.state:set("inGemTableVangelicoGrapeseed", true, true)

	if _gemObj ~= 0 then
		DeleteEntity(_gemObj)
	end

	local obj = -1
	local loopcount = 0
	while loopcount < 5 do
		obj = GetClosestObjectOfType(GetEntityCoords(LocalPlayer.state.ped), 5.0, prop, 0)
		loopcount = loopcount + 1
		DeleteEntity(obj)
	end
	DoScreenFadeOut(1000)
	FreezeEntityPosition(LocalPlayer.state.ped, true)
	Wait(1000)
	local dirtLevel = (15 - math.floor(quality / 6.66)) + 0.0

	HUD.GemTable:Open(quality)
	Inventory.StaticTooltip:Open(item)

	_gemObj = CreateObject(prop, _tableConfig[tableId].createCoords, 0, 0)
	FreezeEntityPosition(_gemObj, true)
	SetEntityCollision(_gemObj, false, false)
	SetVehicleDirtLevel(_gemObj, dirtLevel)
	SetVehicleColours(_gemObj, color, 0)
	SetVehicleExtraColours(_gemObj, 0, false)
	_tableCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
	SetCamCoord(_tableCam, GetOffsetFromEntityInWorldCoords(_gemObj, -0.55, 0.10, 0.45))

	SetCamRot(_tableCam, -20.0, 0.0, _tableConfig[tableId].createCoords[4] + 90.0, 2)
	SetCamFov(_tableCam, 50.0)
	RenderScriptCams(true, false, 0, 1, 0)
	Wait(200)
	DoScreenFadeIn(1000)
	RunTableThread()
end

function CleanupTable()
	RenderScriptCams(false, false, 0, 1, 0)
	DeleteEntity(_gemObj)
	HUD.GemTable:Close()
	Inventory.StaticTooltip:Close()
	if LocalPlayer.state.inGemTableVangelico then
		LocalPlayer.state:set("inGemTableVangelicoGrapeseed", false, true)
	end

	_tableCam = false
	_gemObj = 0
	_threading = false
end
