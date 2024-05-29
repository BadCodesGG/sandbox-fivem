Callbacks = nil
Game = nil

AddEventHandler("Commands:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Callbacks = exports["sandbox-base"]:FetchComponent("Callbacks")
	Game = exports["sandbox-base"]:FetchComponent("Game")
	Notification = exports["sandbox-base"]:FetchComponent("Notification")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["sandbox-base"]:RequestDependencies("Commands", {
		"Callbacks",
		"Game",
		"Notification",
	}, function(error)
		if #error > 0 then
			return
		end
		RetrieveComponents()

		Callbacks:RegisterClientCallback("Commands:SS", function(d, cb)
			exports["screenshot-basic"]:requestScreenshotUpload(
				string.format("https://discord.com/api/webhooks/%s", d),
				"files[]",
				function(data)
					local image = json.decode(data)
					cb(json.encode({ url = image.attachments[1].proxy_url }))
				end
			)
		end)
	end)
end)

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["sandbox-base"]:RegisterComponent("Commands", CMDS)
end)

CMDS = {}

RegisterNetEvent("Commands:Client:TeleportToMarker", function()
	local WaypointHandle = GetFirstBlipInfoId(8)
	if DoesBlipExist(WaypointHandle) then
		local waypointCoords = GetBlipInfoIdCoord(WaypointHandle)
		for height = 1, 1000 do
			SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)

			local foundGround, zPos = GetGroundZFor_3dCoord(waypointCoords["x"], waypointCoords["y"], height + 0.0)

			if foundGround then
				SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)
				break
			end

			Citizen.Wait(5)
		end
		Notification:Success("Teleported")
	else
		Notification:Error("Please place your waypoint.")
	end
end)
