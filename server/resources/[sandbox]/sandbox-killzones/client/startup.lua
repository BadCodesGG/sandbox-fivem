AddEventHandler("Killzones:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Polyzone = exports["sandbox-base"]:FetchComponent("Polyzone")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["sandbox-base"]:RequestDependencies("Killzones", {
		"Polyzone",
	}, function(error)
		if #error > 0 then
			return
		end
		RetrieveComponents()

		TriggerEvent("Killzones:Client:Setup")
	end)
end)
