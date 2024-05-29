AddEventHandler("Drugs:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Callbacks = exports["sandbox-base"]:FetchComponent("Callbacks")
	Inventory = exports["sandbox-base"]:FetchComponent("Inventory")
	Targeting = exports["sandbox-base"]:FetchComponent("Targeting")
	Progress = exports["sandbox-base"]:FetchComponent("Progress")
	Hud = exports["sandbox-base"]:FetchComponent("Hud")
	Notification = exports["sandbox-base"]:FetchComponent("Notification")
	ObjectPlacer = exports["sandbox-base"]:FetchComponent("ObjectPlacer")
	Minigame = exports["sandbox-base"]:FetchComponent("Minigame")
	ListMenu = exports["sandbox-base"]:FetchComponent("ListMenu")
	PedInteraction = exports["sandbox-base"]:FetchComponent("PedInteraction")
	Polyzone = exports["sandbox-base"]:FetchComponent("Polyzone")
	Buffs = exports["sandbox-base"]:FetchComponent("Buffs")
	Minigame = exports["sandbox-base"]:FetchComponent("Minigame")
	Status = exports["sandbox-base"]:FetchComponent("Status")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["sandbox-base"]:RequestDependencies("Drugs", {
		"Callbacks",
		"Inventory",
		"Targeting",
		"Progress",
		"Hud",
		"Notification",
		"ObjectPlacer",
		"Minigame",
		"ListMenu",
		"PedInteraction",
		"Polyzone",
		"Buffs",
		"Minigame",
		"Status",
	}, function(error)
		if #error > 0 then
			exports["sandbox-base"]:FetchComponent("Logger"):Critical("Drugs", "Failed To Load All Dependencies")
			return
		end
		RetrieveComponents()

		TriggerEvent("Drugs:Client:Startup")
	end)
end)
