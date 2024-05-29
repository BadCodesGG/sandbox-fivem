local noTopSpeed = {
    [13] = true,
    [14] = true,
    [15] = true,
    [16] = true,
}

AddEventHandler('Vehicles:Client:StartUp', function()
    AddTaskToVehicleThread('top_speed', 5, true, function(veh, class)
        if not noTopSpeed[class] then
            if IsEntityInAir(veh) and GetEntityHeightAboveGround(veh) >= 5.0 then
                SetEntityMaxSpeed(VEHICLE_INSIDE, 1000.0)
            else
                if not VEHICLE_CRUISE then
                    SetEntityMaxSpeed(VEHICLE_INSIDE, VEHICLE_TOP_SPEED)
                end
            end
        end
    end, false)
end)

AddEventHandler('Vehicles:Client:EnterVehicle', function(v, seat)
    SetEntityMaxSpeed(VEHICLE_INSIDE, VEHICLE_TOP_SPEED)
end)

AddEventHandler('Vehicles:Client:ExitVehicle', function()
    SetEntityMaxSpeed(VEHICLE_INSIDE, 1000.0)
end)