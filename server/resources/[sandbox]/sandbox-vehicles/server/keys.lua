VEHICLE_KEYS = {}

RegisterServerEvent("Vehicles:Server:StealLocalKeys", function(vehNet)
	local src = source
	local veh = NetworkGetEntityFromNetworkId(vehNet)
	local vehEnt = Entity(veh)
	if vehEnt and vehEnt.state.VIN then
		Vehicles.Keys:Give(src, vehEnt.state.VIN)
	end
end)

_vehKeys = {
	Keys = {
		Has = function(self, source, VIN, groupKeys)
			local char = Fetch:CharacterSource(source)
			if char then
				local id = char:GetData('SID')
				if VEHICLE_KEYS[id] == nil then
					return false
				end
				return (VEHICLE_KEYS[id][VIN] or (groupKeys and (Player(source).state.onDuty == groupKeys or (Player(source).state.sentOffDuty and Player(source).state.sentOffDuty == groupKeys))))
			end
			return false
		end,
		Add = function(self, source, VIN)
			local char = Fetch:CharacterSource(source)
			if char then
				local id = char:GetData('SID')
				if VEHICLE_KEYS[id] == nil then
					VEHICLE_KEYS[id] = {}
				end
				VEHICLE_KEYS[id][VIN] = true
	
				TriggerClientEvent("Vehicles:Client:UpdateKeys", source, VEHICLE_KEYS[id])
			end
		end,
		Remove = function(self, source, VIN)
			local char = Fetch:CharacterSource(source)
			if char then
				local id = char:GetData('SID')
				if VEHICLE_KEYS[id] == nil then
					VEHICLE_KEYS[id] = {}
					return
				end
				if Vehicles.Keys:Has(source, VIN, false) then
					VEHICLE_KEYS[id][VIN] = nil
					TriggerClientEvent("Vehicles:Client:UpdateKeys", source, VEHICLE_KEYS[id])
				end
			end
		end,
		AddBySID = function(self, SID, VIN)
			if VEHICLE_KEYS[SID] == nil then
				VEHICLE_KEYS[SID] = {}
			end

			VEHICLE_KEYS[SID][VIN] = true

			local char = Fetch:SID(SID)
			if char then
				TriggerClientEvent('Vehicles:Client:UpdateKeys', char:GetData('Source'), VEHICLE_KEYS[SID])
			end
		end
	},
}

AddEventHandler("Proxy:Shared:ExtendReady", function(component)
	if component == "Vehicles" then
		exports["sandbox-base"]:ExtendComponent(component, _vehKeys)
	end
end)
