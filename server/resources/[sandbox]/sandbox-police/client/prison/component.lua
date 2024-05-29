AddEventHandler("Corrections:Shared:DependencyUpdate", CorrectionsComponents)
function CorrectionsComponents()
	Callbacks = exports["sandbox-base"]:FetchComponent("Callbacks")
	Inventory = exports["sandbox-base"]:FetchComponent("Inventory")
	Notification = exports["sandbox-base"]:FetchComponent("Notification")
	Input = exports["sandbox-base"]:FetchComponent("Input")
	Keybinds = exports["sandbox-base"]:FetchComponent("Keybinds")
	Handcuffs = exports["sandbox-base"]:FetchComponent("Handcuffs")
	Interaction = exports["sandbox-base"]:FetchComponent("Interaction")
	Blips = exports["sandbox-base"]:FetchComponent("Blips")
	Targeting = exports["sandbox-base"]:FetchComponent("Targeting")
	Jobs = exports["sandbox-base"]:FetchComponent("Jobs")
	Sounds = exports["sandbox-base"]:FetchComponent("Sounds")
	Properties = exports["sandbox-base"]:FetchComponent("Properties")
	Apartment = exports["sandbox-base"]:FetchComponent("Apartment")
	EmergencyAlerts = exports["sandbox-base"]:FetchComponent("EmergencyAlerts")
	Wardrobe = exports["sandbox-base"]:FetchComponent("Wardrobe")
	Status = exports["sandbox-base"]:FetchComponent("Status")
	Game = exports["sandbox-base"]:FetchComponent("Game")
	Sync = exports["sandbox-base"]:FetchComponent("Sync")
	Polyzone = exports["sandbox-base"]:FetchComponent("Polyzone")
	Vehicles = exports["sandbox-base"]:FetchComponent("Vehicles")
	Utils = exports["sandbox-base"]:FetchComponent("Utils")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["sandbox-base"]:RequestDependencies("Corrections", {
		"Callbacks",
		"Inventory",
		"Notification",
		"Input",
		"Keybinds",
		"Handcuffs",
		"Interaction",
		"Blips",
		"Targeting",
		"Jobs",
		"Sounds",
		"Properties",
		"Apartment",
		"EmergencyAlerts",
		"Wardrobe",
		"Status",
		"Game",
		"Sync",
		"Polyzone",
		"Vehicles",
		"Utils",
	}, function(error)
		if #error > 0 then
			return
		end
		CorrectionsComponents()

		Interaction:RegisterMenu("prison", false, "siren-on", function(data)
			Interaction:ShowMenu({
				{
					icon = "siren-on",
					label = "13-A",
					action = function()
						Interaction:Hide()
						TriggerServerEvent("Police:Server:Panic", true)
					end,
					shouldShow = function()
						return LocalPlayer.state.isDead
					end,
				},
				{
					icon = "siren",
					label = "13-B",
					action = function()
						Interaction:Hide()
						TriggerServerEvent("Police:Server:Panic", false)
					end,
					shouldShow = function()
						return LocalPlayer.state.isDead
					end,
				},
			})
		end, function()
			return LocalPlayer.state.onDuty == "prison" and LocalPlayer.state.isDead
		end)

		Targeting.Zones:AddBox("prison-lockdown-1", "door-closed", vector3(1771.76, 2491.75, 49.67), 4.8, 0.8, {
			name = "prison-lockdown-target-1",
			heading = 30,
			--debugPoly=true,
			minZ = 49.07,
			maxZ = 50.07,
		}, {
			{
				icon = "lock",
				text = "Enable Lockdown",
				event = "Prison:Client:SetLockdown",
				data = { state = true },
				isEnabled = function()
					return not GlobalState["PrisonLockdown"]
						and (LocalPlayer.state.onDuty == "police" or LocalPlayer.state.onDuty == "prison")
				end,
			},
			{
				icon = "lock-open",
				text = "Disable Lockdown",
				event = "Prison:Client:SetLockdown",
				data = { state = false },
				isEnabled = function()
					return GlobalState["PrisonLockdown"]
						and (LocalPlayer.state.onDuty == "police" or LocalPlayer.state.onDuty == "prison")
				end,
			},
		}, 3.0, true)

		Targeting.Zones:AddBox("prison-lockdown-2", "door-closed", vector3(1773.06, 2571.9, 45.73), 0.6, 0.4, {
			name = "prison-lockdown-target-2",
			heading = 0,
			--debugPoly=true,
			minZ = 45.93,
			maxZ = 46.93,
		}, {
			{
				icon = "lock",
				text = "Enable Lockdown",
				event = "Prison:Client:SetLockdown",
				data = { state = true },
				isEnabled = function()
					return not GlobalState["PrisonLockdown"]
						and (LocalPlayer.state.onDuty == "police" or LocalPlayer.state.onDuty == "prison")
				end,
			},
			{
				icon = "lock-open",
				text = "Disable Lockdown",
				event = "Prison:Client:SetLockdown",
				data = { state = false },
				isEnabled = function()
					return GlobalState["PrisonLockdown"]
						and (LocalPlayer.state.onDuty == "police" or LocalPlayer.state.onDuty == "prison")
				end,
			},
		}, 3.0, true)

		Targeting.Zones:AddBox("prison-doors-lockup", "door-closed", vector3(1774.88, 2492.29, 49.67), 2.2, 0.4, {
			name = "prison-doors-lockup-cells",
			heading = 30,
			--debugPoly=true,
			minZ = 49.77,
			maxZ = 50.97,
		}, {
			{
				icon = "lock",
				text = "Lock Cell Doors",
				event = "Prison:Client:SetCellState",
				data = { state = true },
				isEnabled = function()
					return not GlobalState["PrisonCellsLocked"]
						and not GlobalState["PrisonLockdown"]
						and (LocalPlayer.state.onDuty == "police" or LocalPlayer.state.onDuty == "prison")
				end,
			},
			{
				icon = "lock-open",
				text = "Unlock Cell Doors",
				event = "Prison:Client:SetCellState",
				data = { state = false },
				isEnabled = function()
					return GlobalState["PrisonCellsLocked"]
						and (LocalPlayer.state.onDuty == "police" or LocalPlayer.state.onDuty == "prison")
				end,
			},
		}, 3.0, true)

		Interaction:RegisterMenu("prison-utils", "Corrections Utilities", "tablet-rugged", function(data)
			Interaction:ShowMenu({
				{
					icon = "lock-keyhole-open",
					label = "Slimjim Vehicle",
					action = function()
						Interaction:Hide()
						TriggerServerEvent("Police:Server:Slimjim")
					end,
					shouldShow = function()
						local target = Targeting:GetEntityPlayerIsLookingAt()
						return target
							and target.entity
							and DoesEntityExist(target.entity)
							and IsEntityAVehicle(target.entity)
							and #(GetEntityCoords(target.entity) - GetEntityCoords(LocalPlayer.state.ped)) <= 2.0
					end,
				},
				{
					icon = "tablet-screen-button",
					label = "MDT",
					action = function()
						Interaction:Hide()
						TriggerEvent("MDT:Client:Toggle")
					end,
					shouldShow = function()
						return LocalPlayer.state.onDuty == "prison"
					end,
				},
				{
					icon = "camera-security",
					label = "Toggle Body Cam",
					action = function()
						Interaction:Hide()
						TriggerEvent("MDT:Client:ToggleBodyCam")
					end,
					shouldShow = function()
						return LocalPlayer.state.onDuty == "prison"
					end,
				},
			})
		end, function()
			return LocalPlayer.state.onDuty == "prison"
		end)

		Targeting.Zones:AddBox("prison-clockinoff-1", "clipboard", vector3(1838.94, 2578.14, 46.01), 2.0, 0.8, {
			heading = 305,
			--debugPoly=true,
			minZ = 45.81,
			maxZ = 46.61,
		}, {
			{
				icon = "clipboard-check",
				text = "Go On Duty",
				event = "Corrections:Client:OnDuty",
				jobPerms = {
					{
						job = "prison",
						reqOffDuty = true,
					},
				},
			},
			{
				icon = "clipboard",
				text = "Go Off Duty",
				event = "Corrections:Client:OffDuty",
				jobPerms = {
					{
						job = "prison",
						reqDuty = true,
					},
				},
			},
			{
				icon = "clipboard-check",
				text = "Go On Duty (Medical)",
				event = "EMS:Client:OnDuty",
				jobPerms = {
					{
						job = "ems",
						workplace = "prison",
						reqOffDuty = true,
					},
				},
			},
			{
				icon = "clipboard",
				text = "Go Off Duty (Medical)",
				event = "EMS:Client:OffDuty",
				jobPerms = {
					{
						job = "ems",
						workplace = "prison",
						reqDuty = true,
					},
				},
			},
		}, 2.0, true)

		Targeting.Zones:AddBox("prison-clockinoff-2", "clipboard", vector3(1773.99, 2493.69, 49.67), 0.6, 0.4, {
			heading = 30,
			--debugPoly=true,
			minZ = 50.02,
			maxZ = 50.62,
		}, {
			{
				icon = "clipboard-check",
				text = "Go On Duty",
				event = "Corrections:Client:OnDuty",
				jobPerms = {
					{
						job = "prison",
						reqOffDuty = true,
					},
				},
			},
			{
				icon = "clipboard",
				text = "Go Off Duty",
				event = "Corrections:Client:OffDuty",
				jobPerms = {
					{
						job = "prison",
						reqDuty = true,
					},
				},
			},
			{
				icon = "clipboard-check",
				text = "Go On Duty (Medical)",
				event = "EMS:Client:OnDuty",
				jobPerms = {
					{
						job = "ems",
						workplace = "prison",
						reqOffDuty = true,
					},
				},
			},
			{
				icon = "clipboard",
				text = "Go Off Duty (Medical)",
				event = "EMS:Client:OffDuty",
				jobPerms = {
					{
						job = "ems",
						workplace = "prison",
						reqDuty = true,
					},
				},
			},
		}, 2.0, true)

		Targeting.Zones:AddBox("prison-clockinoff-3", "clipboard", vector3(1768.84, 2573.73, 45.73), 1.4, 0.6, {
			heading = 0,
			--debugPoly=true,
			minZ = 45.13,
			maxZ = 46.13,
		}, {
			{
				icon = "clipboard-check",
				text = "Go On Duty",
				event = "Corrections:Client:OnDuty",
				jobPerms = {
					{
						job = "prison",
						reqOffDuty = true,
					},
				},
			},
			{
				icon = "clipboard",
				text = "Go Off Duty",
				event = "Corrections:Client:OffDuty",
				jobPerms = {
					{
						job = "prison",
						reqDuty = true,
					},
				},
			},
			{
				icon = "clipboard-check",
				text = "Go On Duty (Medical)",
				event = "EMS:Client:OnDuty",
				jobPerms = {
					{
						job = "ems",
						workplace = "prison",
						reqOffDuty = true,
					},
				},
			},
			{
				icon = "clipboard",
				text = "Go Off Duty (Medical)",
				event = "EMS:Client:OffDuty",
				jobPerms = {
					{
						job = "ems",
						workplace = "prison",
						reqDuty = true,
					},
				},
			},
		}, 2.0, true)

		local locker = {
			{
				icon = "user-lock",
				text = "Open Personal Locker",
				event = "Police:Client:OpenLocker",
				jobPerms = {
					{
						job = "prison",
						reqDuty = false,
					},
					{
						job = "ems",
						workplace = "prison",
						reqDuty = true,
					},
				},
			},
		}

		Targeting.Zones:AddBox("prison-shitty-locker", "siren-on", vector3(1833.2, 2574.06, 46.01), 5.4, 0.4, {
			heading = 0,
			--debugPoly=true,
			minZ = 45.01,
			maxZ = 47.01,
		}, locker, 3.0, true)
	end)
end)

_PROGRESS_LOCKDOWN = false

AddEventHandler("Prison:Client:SetLockdown", function(entity, data)
	if not _PROGRESS_LOCKDOWN then
		_PROGRESS_LOCKDOWN = true
		Callbacks:ServerCallback("Prison:SetLockdown", data.state, function(success, state)
			if success then
				if state then
					Notification:Success("Lockdown Initiated")
					TriggerServerEvent("Prison:Server:Lockdown:AlertPolice", state)
				else
					Notification:Success("Lockdown Disabled")
					TriggerServerEvent("Prison:Server:Lockdown:AlertPolice", state)
				end

				Citizen.SetTimeout(5000, function()
					_PROGRESS_LOCKDOWN = false
				end)
			else
				Notification:Success("Unauthorized!")
			end
		end)
	end
end)

_PROGRESS_DOORS = false

AddEventHandler("Prison:Client:SetCellState", function(entity, data)
	if not _PROGRESS_DOORS then
		_PROGRESS_DOORS = true
		Callbacks:ServerCallback("Prison:SetCellState", data.state, function(success, state)
			if success then
				if state then
					Notification:Success("Cell Doors Locked")
				else
					Notification:Success("Cell Doors Unlocked")
				end

				-- TriggerEvent("Prison:Client:JailAlarm", data.state)
				Citizen.SetTimeout(5000, function()
					_PROGRESS_DOORS = false
				end)
			else
				Notification:Success("Unauthorized!")
			end
		end)
	end
end)

RegisterNetEvent("Prison:Client:JailAlarm")
AddEventHandler("Prison:Client:JailAlarm", function(toggle)
	if toggle then
		local alarmIpl = GetInteriorAtCoordsWithType(1787.004, 2593.1984, 45.7978, "int_prison_main")

		RefreshInterior(alarmIpl)
		EnableInteriorProp(alarmIpl, "prison_alarm")

		Citizen.CreateThread(function()
			while not PrepareAlarm("PRISON_ALARMS") do
				Citizen.Wait(100)
			end
			StartAlarm("PRISON_ALARMS", true)
		end)
	else
		local alarmIpl = GetInteriorAtCoordsWithType(1787.004, 2593.1984, 45.7978, "int_prison_main")

		RefreshInterior(alarmIpl)
		DisableInteriorProp(alarmIpl, "prison_alarm")

		Citizen.CreateThread(function()
			while not PrepareAlarm("PRISON_ALARMS") do
				Citizen.Wait(100)
			end
			StopAllAlarms(true)
		end)
	end
end)
