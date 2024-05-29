function RegisterCallbacks()
	Callbacks:RegisterServerCallback("Mechanic:InstallMultipleRepairParts", function(source, data, cb)
		local char = Fetch:CharacterSource(source)
		if char and data?.part and data?.quantity and _mechanicItemsToParts[data.part] then
			if Inventory.Items:Has(char:GetData("SID"), 1, data.part, data.quantity) then
				Callbacks:ClientCallback(source, "Mechanic:StartInstall", data, function(success)
					if success then
					Inventory.Items:Remove(char:GetData("SID"), 1, data.part, data.quantity)
					end
				end)

				cb(true)
				return
			end
		end

		cb(false)
	end)
	Callbacks:RegisterServerCallback("Mechanic:RemovePerformanceUpgrade", function(source, data, cb)
		local partData = data
		Callbacks:ClientCallback(source, 'Mechanic:StartUpgradeRemoval', partData, function(success, veh)
			if success and veh then
				local veh = NetworkGetEntityFromNetworkId(veh)
				local vehState = Entity(veh)
				if DoesEntityExist(veh) and vehState and vehState.state.VIN then
					local vehicleData = Vehicles.Owned:GetActive(vehState.state.VIN)
					if vehicleData and vehicleData:GetData('Properties') then
						local currentProperties = vehicleData:GetData('Properties')

						if currentProperties.mods then
							currentProperties.mods[partData.partName:lower()] = -1
						end

						vehicleData:SetData('Properties', currentProperties)
						Vehicles.Owned:ForceSave(vehicleData:GetData('VIN'))
					end
				end

				TriggerClientEvent('Mechanic:Client:ForcePerformanceProperty', -1, NetworkGetNetworkIdFromEntity(veh), partData.modType, partData.toggleMod or partData.modIndex)
			end
		end)
		cb(true)
	end)
end
