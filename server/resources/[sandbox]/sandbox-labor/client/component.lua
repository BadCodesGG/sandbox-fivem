AddEventHandler("Labor:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Logger = exports["sandbox-base"]:FetchComponent("Logger")
	Callbacks = exports["sandbox-base"]:FetchComponent("Callbacks")
	Game = exports["sandbox-base"]:FetchComponent("Game")
	Phone = exports["sandbox-base"]:FetchComponent("Phone")
	PedInteraction = exports["sandbox-base"]:FetchComponent("PedInteraction")
	Interaction = exports["sandbox-base"]:FetchComponent("Interaction")
	Progress = exports["sandbox-base"]:FetchComponent("Progress")
	Minigame = exports["sandbox-base"]:FetchComponent("Minigame")
	Notification = exports["sandbox-base"]:FetchComponent("Notification")
	ListMenu = exports["sandbox-base"]:FetchComponent("ListMenu")
	Blips = exports["sandbox-base"]:FetchComponent("Blips")
	Polyzone = exports["sandbox-base"]:FetchComponent("Polyzone")
	Targeting = exports["sandbox-base"]:FetchComponent("Targeting")
	Hud = exports["sandbox-base"]:FetchComponent("Hud")
	Inventory = exports["sandbox-base"]:FetchComponent("Inventory")
	EmergencyAlerts = exports["sandbox-base"]:FetchComponent("EmergencyAlerts")
	Status = exports["sandbox-base"]:FetchComponent("Status")
	Labor = exports["sandbox-base"]:FetchComponent("Labor")
	Sounds = exports["sandbox-base"]:FetchComponent("Sounds")
	Properties = exports["sandbox-base"]:FetchComponent("Properties")
	Action = exports["sandbox-base"]:FetchComponent("Action")
	Sync = exports["sandbox-base"]:FetchComponent("Sync")
	Confirm = exports["sandbox-base"]:FetchComponent("Confirm")
	Utils = exports["sandbox-base"]:FetchComponent("Utils")
	Keybinds = exports["sandbox-base"]:FetchComponent("Keybinds")
	Reputation = exports["sandbox-base"]:FetchComponent("Reputation")
	NetSync = exports["sandbox-base"]:FetchComponent("NetSync")
	Vehicles = exports["sandbox-base"]:FetchComponent("Vehicles")
	Animations = exports["sandbox-base"]:FetchComponent("Animations")
	Weapons = exports["sandbox-base"]:FetchComponent("Weapons")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["sandbox-base"]:RequestDependencies("Labor", {
		"Logger",
		"Callbacks",
		"Game",
		"Phone",
		"PedInteraction",
		"Interaction",
		"Progress",
		"Minigame",
		"Notification",
		"ListMenu",
		"Blips",
		"Polyzone",
		"Targeting",
		"Hud",
		"Inventory",
		"EmergencyAlerts",
		"Status",
		"Labor",
		"Sounds",
		"Properties",
		"Action",
		"Sync",
		"Confirm",
		"Utils",
		"Keybinds",
		"Reputation",
		"NetSync",
		"Vehicles",
		"Animations",
		"Weapons",
	}, function(error)
		if #error > 0 then
			return
		end
		RetrieveComponents()
		TriggerEvent("Labor:Client:Setup")
	end)
end)

function Draw3DText(x, y, z, text)
	local onScreen, _x, _y = World3dToScreen2d(x, y, z)
	local px, py, pz = table.unpack(GetGameplayCamCoords())

	SetTextScale(0.25, 0.25)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextColour(255, 255, 255, 245)
	SetTextOutline(true)
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x, _y)
end

function PedFaceCoord(pPed, pCoords)
	TaskTurnPedToFaceCoord(pPed, pCoords.x, pCoords.y, pCoords.z)

	Citizen.Wait(100)

	while GetScriptTaskStatus(pPed, 0x574bb8f5) == 1 do
		Citizen.Wait(0)
	end
end

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["sandbox-base"]:RegisterComponent("Labor", LABOR)
end)

AddEventHandler("Labor:Client:AcceptRequest", function(data)
	Callbacks:ServerCallback("Labor:AcceptRequest", data)
end)

AddEventHandler("Labor:Client:DeclineRequest", function(data)
	Callbacks:ServerCallback("Labor:DeclineRequest", data)
end)

LABOR = {
	Get = {
		Jobs = function(self)
			local p = promise.new()
			Callbacks:ServerCallback("Labor:GetJobs", {}, function(jobs)
				p:resolve(jobs)
			end)
			return Citizen.Await(p)
		end,
		Groups = function(self)
			local p = promise.new()
			Callbacks:ServerCallback("Labor:GetGroups", {}, function(groups)
				p:resolve(groups)
			end)
			return Citizen.Await(p)
		end,
		Reputations = function(self)
			local p = promise.new()
			Callbacks:ServerCallback("Labor:GetReputations", {}, function(jobs)
				p:resolve(jobs)
			end)
			return Citizen.Await(p)
		end,
	},
}
