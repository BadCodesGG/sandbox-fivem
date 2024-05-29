AddEventHandler("Hospital:Shared:DependencyUpdate", SAFDComponents)
function SAFDComponents()
	Callbacks = exports["sandbox-base"]:FetchComponent("Callbacks")
	Notification = exports["sandbox-base"]:FetchComponent("Notification")
	Damage = exports["sandbox-base"]:FetchComponent("Damage")
	Notification = exports["sandbox-base"]:FetchComponent("Notification")
	Targeting = exports["sandbox-base"]:FetchComponent("Targeting")
	Hospital = exports["sandbox-base"]:FetchComponent("Hospital")
	Progress = exports["sandbox-base"]:FetchComponent("Progress")
	Blips = exports["sandbox-base"]:FetchComponent("Blips")
	PedInteraction = exports["sandbox-base"]:FetchComponent("PedInteraction")
	Escort = exports["sandbox-base"]:FetchComponent("Escort")
	Action = exports["sandbox-base"]:FetchComponent("Action")
	Polyzone = exports["sandbox-base"]:FetchComponent("Polyzone")
	Animations = exports["sandbox-base"]:FetchComponent("Animations")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["sandbox-base"]:RequestDependencies("Hospital", {
		"Callbacks",
		"Notification",
		"Damage",
		"Targeting",
		"Hospital",
		"Progress",
		"PedInteraction",
		"Escort",
		"Blips",
		"Polyzone",
		"Action",
		"Animations",
	}, function(error)
		if #error > 0 then
			return
		end
		SAFDComponents()
		SAFDInit()
	end)
end)
