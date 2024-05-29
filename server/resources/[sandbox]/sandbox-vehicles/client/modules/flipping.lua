function FlipVehicle(vehicle, pedPitch, vehRoll, vehYaw)
    if vehicle and DoesEntityExist(vehicle) then
        SetEntityRotation(vehicle, pedPitch, vehRoll, vehYaw)
        Citizen.Wait(30)
        SetVehicleOnGroundProperly(vehicle)
    end
end

AddEventHandler('Vehicles:Client:FlipVehicle', function(entityData)
    if not entityData then return end
    TaskTurnPedToFaceEntity(LocalPlayer.state.ped, entityData.entity, 1)
    Citizen.Wait(250)
    Progress:ProgressWithTickEvent({
		name = "flipping_vehicle",
		duration = math.random(13, 20) * 1000,
		label = "Flipping Vehicle",
		canCancel = true,
		tickrate = 500,
		controlDisables = {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		},
		animation = {
			animDict = "missfinale_c2ig_11",
			anim = "pushcar_offcliff_f",
			flags = 15,
		},
	}, function()
		if not DoesEntityExist(entityData.entity) or (#(GetEntityCoords(entityData.entity) - LocalPlayer.state.myPos) > 5.0) then
            Progress:Cancel()
			return
        end
	end, function(wasCancelled)
		if not wasCancelled then
            local pedPitch, pedRoll, pedYaw = GetEntityRotation(LocalPlayer.state.ped)
            local vehPitch, vehRoll, vehYaw = GetEntityRotation(entityData.entity)

            if not NetworkGetEntityIsNetworked(entityData.entity) or NetworkHasControlOfEntity(entityData.entity) then
                FlipVehicle(entityData.entity, pedPitch, vehRoll, vehYaw)
            else
                local netId = VehToNet(entityData.entity)
                TriggerServerEvent('Vehicles:Server:FlipVehicle', netId, pedPitch, vehRoll, vehYaw)
            end
        end
	end)
end)

RegisterNetEvent('Vehicles:Client:FlipVehicleRequest', function(netVeh, pedPitch, vehRoll, vehYaw)
    Logger:Info('Vehicles', string.format('Flipping Vehicle %s By Server Request', netVeh))
    if NetworkDoesEntityExistWithNetworkId(netVeh) then
        local vehicle = NetToVeh(netVeh)
        FlipVehicle(vehicle, pedPitch, vehRoll, vehYaw)
    end
end)