_inuse = {}

Citizen.CreateThread(function()
	while true do
		for k, v in pairs(_activeTowers) do
			if not v.onTask and v.next < os.time() then
				v.onTask = true

				local cId = math.random(#_spawns)
				while _inuse[cId] do
					cId = math.random(#_spawns)
					Citizen.Wait(1)
				end

				_inuse[cId] = k

				Vehicles:SpawnTemp(
					-1,
					Vehicles.RandomModel:DClass(),
					'automobile',
					vector3(_spawns[cId][1], _spawns[cId][2], _spawns[cId][3]),
					_spawns[cId][4],
					function(veh, VIN, plate)
						SetVehicleDoorsLocked(veh, 2)
		
						v.location = cId
						v.veh = veh
		
						local ent = Entity(veh).state
						ent.towObjective = true
						TriggerClientEvent("Tow:Client:MarkPickup", k, _spawns[cId], veh)
		
						Phone.Notification:AddWithId(
							k,
							"TOW_OBJ",
							"Yard Manager",
							"Got a pickup for you, check your GPS (flashing gray car)",
							os.time() * 1000,
							-1,
							{
								color = "#247919",
								label = "Los Santos Tow",
								icon = "truck-tow",
							},
							{},
							nil
						)
					end
				)
			end
		end
		Citizen.Wait(5000)
	end
end)