_weedDealer = Locations[tostring(os.date("%w"))]

function RegisterMiddleware()
	Middleware:Add("Characters:Spawning", function(source)
		TriggerClientEvent("Weed:Client:Login", source, _weedDealer)

		TriggerLatentClientEvent("Weed:Client:Objects:Init", source, 10000, _plants)
	end)
end

AddEventHandler("Characters:Server:PlayerLoggedOut", function(source)
	Player(source).state.WeedZone = nil
end)