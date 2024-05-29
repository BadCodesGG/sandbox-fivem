AddEventHandler("Robbery:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Logger = exports["sandbox-base"]:FetchComponent("Logger")
	Callbacks = exports["sandbox-base"]:FetchComponent("Callbacks")
	PedInteraction = exports["sandbox-base"]:FetchComponent("PedInteraction")
	Progress = exports["sandbox-base"]:FetchComponent("Progress")
	Phone = exports["sandbox-base"]:FetchComponent("Phone")
	Notification = exports["sandbox-base"]:FetchComponent("Notification")
	Polyzone = exports["sandbox-base"]:FetchComponent("Polyzone")
	Targeting = exports["sandbox-base"]:FetchComponent("Targeting")
	Progress = exports["sandbox-base"]:FetchComponent("Progress")
	Minigame = exports["sandbox-base"]:FetchComponent("Minigame")
	Keybinds = exports["sandbox-base"]:FetchComponent("Keybinds")
	Properties = exports["sandbox-base"]:FetchComponent("Properties")
	Sounds = exports["sandbox-base"]:FetchComponent("Sounds")
	Interaction = exports["sandbox-base"]:FetchComponent("Interaction")
	Inventory = exports["sandbox-base"]:FetchComponent("Inventory")
	Action = exports["sandbox-base"]:FetchComponent("Action")
	Blips = exports["sandbox-base"]:FetchComponent("Blips")
	EmergencyAlerts = exports["sandbox-base"]:FetchComponent("EmergencyAlerts")
	Doors = exports["sandbox-base"]:FetchComponent("Doors")
	ListMenu = exports["sandbox-base"]:FetchComponent("ListMenu")
	Input = exports["sandbox-base"]:FetchComponent("Input")
	Game = exports["sandbox-base"]:FetchComponent("Game")
	NetSync = exports["sandbox-base"]:FetchComponent("NetSync")
	Damage = exports["sandbox-base"]:FetchComponent("Damage")
	Lasers = exports["sandbox-base"]:FetchComponent("Lasers")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["sandbox-base"]:RequestDependencies("Robbery", {
		"Logger",
		"Callbacks",
		"PedInteraction",
		"Progress",
		"Phone",
		"Notification",
		"Polyzone",
		"Targeting",
		"Progress",
		"Minigame",
		"Keybinds",
		"Properties",
		"Sounds",
		"Interaction",
		"Inventory",
		"Action",
		"Blips",
		"EmergencyAlerts",
		"Doors",
		"ListMenu",
		"Input",
		"Game",
		"NetSync",
		"Damage",
		"Lasers",
	}, function(error)
		if #error > 0 then
			return
		end
		RetrieveComponents()
		RegisterGamesCallbacks()
		TriggerEvent("Robbery:Client:Setup")

		Citizen.CreateThread(function()
			PedInteraction:Add(
				"RobToolsPickup",
				GetHashKey("csb_anton"),
				vector3(1129.422, -476.236, 65.485),
				300.00,
				25.0,
				{
					{
						icon = "hand",
						text = "Pickup Items",
						event = "Robbery:Client:PickupItems",
					},
				},
				"box-dollar"
			)
		end)
	end)
end)

AddEventHandler("Robbery:Client:PickupItems", function()
	Callbacks:ServerCallback("Robbery:Pickup", {})
end)

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["sandbox-base"]:RegisterComponent("Robbery", _ROBBERY)
end)

RegisterNetEvent("Robbery:Client:State:Init", function(states)
	_bankStates = states

	for k, v in pairs(states) do
		TriggerEvent(string.format("Robbery:Client:Update:%s", k))
	end
end)

RegisterNetEvent("Robbery:Client:State:Set", function(bank, state)
	_bankStates[bank] = state
	TriggerEvent(string.format("Robbery:Client:Update:%s", bank))
end)

RegisterNetEvent("Robbery:Client:State:Update", function(bank, key, value, tableId)
	print("Heist State Debug: ", bank, key, value, tableId)
	if tableId then
		_bankStates[bank][tableId] = _bankStates[bank][tableId] or {}
		_bankStates[bank][tableId][key] = value
	else
		_bankStates[bank][key] = value
	end
	TriggerEvent(string.format("Robbery:Client:Update:%s", bank))
end)

RegisterNetEvent("Robbery:Client:PrintState", function(heistId)
	if heistId ~= nil and _bankStates[heistId] ~= nil then
		print(json.encode(_bankStates[heistId], { indent = true }))
	else
		print(json.encode(_bankStates, { indent = true }))
	end
end)

AddEventHandler("Robbery:Client:Holdup:Do", function(entity, data)
	Progress:ProgressWithTickEvent({
		name = "holdup",
		duration = 5000,
		label = "Robbing",
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
			animDict = "random@shop_robbery",
			anim = "robbery_action_b",
			flags = 49,
		},
	}, function()
		if
			#(
				GetEntityCoords(LocalPlayer.state.ped)
				- GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(entity.serverId)))
			) <= 3.0
		then
			return
		end
		Progress:Cancel()
	end, function(cancelled)
		if not cancelled then
			Callbacks:ServerCallback("Robbery:Holdup:Do", entity.serverId, function(s)
				Inventory.Dumbfuck:Open(s)

				while not LocalPlayer.state.inventoryOpen do
					Citizen.Wait(1)
				end

				Citizen.CreateThread(function()
					while LocalPlayer.state.inventoryOpen do
						if
							#(
								GetEntityCoords(LocalPlayer.state.ped)
								- GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(entity.serverId)))
							) > 3.0
						then
							Inventory.Close:All()
						end
						Citizen.Wait(2)
					end
				end)
			end)
		end
	end)
end)

_ROBBERY = {}
