AddEventHandler("Phone:Server:RegisterMiddleware", function()
	Middleware:Add("Phone:Spawning", function(source, char)
		return {
			{
				type = "garages",
				data = Vehicles.Garages:GetAll(),
			},
		}
	end)
end)

AddEventHandler("Phone:Server:RegisterCallbacks", function()
	Callbacks:RegisterServerCallback("Phone:Garage:GetCars", function(source, data, cb)
		local src = source
		local char = Fetch:CharacterSource(src)
		Vehicles.Owned:GetAll(nil, 0, char:GetData("SID"), cb)
	end)

	Callbacks:RegisterServerCallback("Phone:Garage:TrackVehicle", function(source, data, cb)
		cb(Vehicles.Owned:Track(data))
	end)
end)
