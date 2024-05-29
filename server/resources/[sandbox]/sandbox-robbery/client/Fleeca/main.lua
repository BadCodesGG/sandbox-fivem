local _inPoly = nil
local _polys = {}

AddEventHandler("Characters:Client:Spawn", function()
	FleecaThreads()
end)

AddEventHandler("Robbery:Client:Setup", function()
	_polys = {}

	while GlobalState["FleecaRobberies"] == nil do
		Citizen.Wait(10)
	end

	for k, v in ipairs(GlobalState["FleecaRobberies"]) do
		local bankData = GlobalState[string.format("FleecaRobberies:%s", v)]
		Polyzone.Create:Box(bankData.id, bankData.coords, bankData.width, bankData.length, bankData.options)
		_polys[bankData.id] = true

		SetupFleecaVaults(bankData)
		
		if bankData.reset ~= nil then
			Targeting.Zones:AddBox(
				string.format("fleeca-%s-reset", bankData.id),
				"shield-keyhole",
				bankData.reset.coords,
				bankData.reset.length,
				bankData.reset.width,
				bankData.reset.options,
				{
					{
						icon = "phone",
						text = "Secure Bank",
						event = "Robbery:Client:Fleeca:StartSecuring",
						jobPerms = {
							{
								job = "police",
								reqDuty = true,
							},
						},
						data = bankData.id,
						isEnabled = function(s, s2)
							return (
								(
									GlobalState[string.format("Fleeca:%s:VaultDoor", LocalPlayer.state.fleeca)]
											~= nil
										and GlobalState[string.format("Fleeca:%s:VaultDoor", bankData.id)].state == 2
									or GlobalState[string.format(
												"Fleeca:%s:VaultDoor",
												LocalPlayer.state.fleeca
											)]
											~= nil
										and GlobalState[string.format("Fleeca:%s:VaultDoor", bankData.id)].state == 3
								)
								or (not Doors:IsLocked(string.format("%s_gate", LocalPlayer.state.fleeca)))
							)
						end,
					},
				},
				2.0,
				true
			)
		end
	end

	Callbacks:RegisterClientCallback("Robbery:Fleeca:Keypad:Vault", function(data, cb)
		Minigame.Play:Keypad(data, 5, 10000, false, {
			onSuccess = function(data)
				cb(true, data)
			end,
			onFail = function(data)
				cb(false, data)
			end,
		}, {
			useWhileDead = false,
			vehicle = false,
			controlDisables = {
				disableMovement = true,
				disableCarMovement = true,
				disableMouse = false,
				disableCombat = true,
			},
			animation = {
				animDict = "amb@prop_human_atm@male@idle_a",
				anim = "idle_b",
				flags = 49,
			},
		})
	end)
end)

AddEventHandler("Polyzone:Enter", function(id, testedPoint, insideZones, data)
	if _polys[id] and GlobalState[id] == nil and GlobalState[string.format("FleecaRobberies:%s", id)] ~= nil then
		_inPoly = id
		LocalPlayer.state:set("fleeca", id, true)
	end
end)

AddEventHandler("Polyzone:Exit", function(id, testedPoint, insideZones, data)
	if _polys[id] then
		_inPoly = nil
		if LocalPlayer.state.fleeca ~= nil then
			LocalPlayer.state:set("fleeca", nil, true)
		end
	end
end)

RegisterNetEvent("Robbery:Client:Fleeca:OpenVaultDoor", function(fleecaId)
	if GlobalState[string.format("FleecaRobberies:%s", fleecaId)] ~= nil then
		local myCoords = GetEntityCoords(LocalPlayer.state.ped)
		if #(myCoords - GlobalState[string.format("FleecaRobberies:%s", fleecaId)].coords) <= 100 then
			OpenDoor(
				GlobalState[string.format("FleecaRobberies:%s", fleecaId)].points.vaultPC.coords,
				GlobalState[string.format("FleecaRobberies:%s", fleecaId)].doors.vaultDoor
			)
		end
	end
end)

RegisterNetEvent("Robbery:Client:Fleeca:CloseVaultDoor", function(fleecaId)
	if GlobalState[string.format("FleecaRobberies:%s", fleecaId)] ~= nil then
		local myCoords = GetEntityCoords(LocalPlayer.state.ped)
		if #(myCoords - GlobalState[string.format("FleecaRobberies:%s", fleecaId)].coords) <= 100 then
			CloseDoor(
				GlobalState[string.format("FleecaRobberies:%s", fleecaId)].points.vaultPC.coords,
				GlobalState[string.format("FleecaRobberies:%s", fleecaId)].doors.vaultDoor
			)
		end
	end
end)

AddEventHandler("Robbery:Client:Fleeca:StartSecuring", function(entity, data)
	Progress:Progress({
		name = "secure_fleeca",
		duration = 30000,
		label = "Securing",
		useWhileDead = false,
		canCancel = true,
		ignoreModifier = true,
		controlDisables = {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		},
		animation = {
			anim = "cop3",
		},
	}, function(status)
		if not status then
			Callbacks:ServerCallback("Robbery:Fleeca:SecureBank", {})
		end
	end)
end)

AddEventHandler("Robbery:Client:Fleeca:Drill", function(entity, data)
	Callbacks:ServerCallback("Robbery:Fleeca:Drill", data, function() end)
end)

function OpenDoor(checkOrigin, door)
	local obj =
		GetClosestObjectOfType(checkOrigin[1], checkOrigin[2], checkOrigin[3], 25.0, door.object, false, false, false)

	if obj ~= 0 and tonumber(string.format("%.3f", GetEntityHeading(obj))) == door.originalHeading then
		local count = 0
		repeat
			SetEntityHeading(obj, GetEntityHeading(obj) + door.step)
			count = count + 1
			Citizen.Wait(10)
		until count == 150
	end
end

function CloseDoor(checkOrigin, door)
	local obj =
		GetClosestObjectOfType(checkOrigin[1], checkOrigin[2], checkOrigin[3], 25.0, door.object, false, false, false)

	if obj ~= 0 and tonumber(string.format("%.3f", GetEntityHeading(obj))) ~= door.originalHeading then
		local count = 0
		repeat
			SetEntityHeading(obj, GetEntityHeading(obj) - door.step)
			count = count + 1
			Citizen.Wait(10)
		until count == 150
	end
end

function SetupFleecaVaults(bankData)
	for k, v in ipairs(bankData.loots) do
		Targeting.Zones:AddBox(
			string.format("fleeca-%s", v.options.name),
			"bore-hole",
			v.coords,
			v.width,
			v.length,
			v.options,
			{
				{
					icon = "bore-hole",
					text = "Use Drill",
					item = "drill",
					event = "Robbery:Client:Fleeca:Drill",
					data = {
						bank = bankData.id,
						index = k,
						id = v.options.name,
					},
					isEnabled = function()
						return GlobalState[string.format("Fleeca:%s:VaultDoor", LocalPlayer.state.fleeca)] ~= nil
							and GlobalState[string.format("Fleeca:%s:VaultDoor", LocalPlayer.state.fleeca)].state == 3
							and (GlobalState[string.format(
								"Fleeca:%s:Loot:%s",
								LocalPlayer.state.fleeca,
								v.options.name
							)] == nil or GetCloudTimeAsInt() >= GlobalState[string.format(
								"Fleeca:%s:Loot:%s",
								LocalPlayer.state.fleeca,
								v.options.name
							)])
							and (k <= 2 or not Doors:IsLocked(string.format("%s_gate", LocalPlayer.state.fleeca)))
					end,
				},
			},
			3.0,
			true
		)
	end
end
