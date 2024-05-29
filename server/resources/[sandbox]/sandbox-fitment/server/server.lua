AddEventHandler("Fitment:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Callbacks = exports["sandbox-base"]:FetchComponent("Callbacks")
	Database = exports["sandbox-base"]:FetchComponent("Database")
	Utils = exports["sandbox-base"]:FetchComponent("Utils")
	Fetch = exports["sandbox-base"]:FetchComponent("Fetch")
	Logger = exports["sandbox-base"]:FetchComponent("Logger")
	Inventory = exports["sandbox-base"]:FetchComponent("Inventory")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["sandbox-base"]:RequestDependencies("Fitment", {
		"Fetch",
		"Logger",
		"Database",
		"Callbacks",
		"Utils",
		"Inventory",
	}, function(error)
		if #error > 0 then
			return
		end -- Do something to handle if not all dependencies loaded
		RetrieveComponents()

		Inventory.Items:RegisterUse("camber_controller", "Vehicles", function(source, item)
			Callbacks:ClientCallback(source, "Vehicles:UseCamberController", {}, function(veh)
				if not veh then
					return
				end
				veh = NetworkGetEntityFromNetworkId(veh)
				if veh and DoesEntityExist(veh) then
					local vehState = Entity(veh).state
					if not vehState.VIN then
						return
					end

					TriggerClientEvent("Fitment:Client:CamberController:UseItem", source)
				end
			end)
		end)
	end)
end)
