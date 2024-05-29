VEHICLE_CRUISE = false
local noCruise = {
    [13] = true,
    [14] = true,
    [15] = true,
    [16] = true,
}

function DisableCruiseControl(skip)
    VEHICLE_CRUISE = false
    SetEntityMaxSpeed(VEHICLE_INSIDE, 1000.0)

    if not noCruise[GetVehicleClass(VEHICLE_INSIDE)] and VEHICLE_TOP_SPEED then
        SetEntityMaxSpeed(VEHICLE_INSIDE, VEHICLE_TOP_SPEED)
    end

    if not skip then
        TriggerEvent('Vehicles:Client:Cruise', false)
    end
end

AddEventHandler('Vehicles:Client:StartUp', function()
    Keybinds:Add('vehicle_cruise', '', 'keyboard', 'Vehicle - Toggle Cruise', function()
        if VEHICLE_INSIDE and not noCruise[VEHICLE_CLASS] then
            if VEHICLE_CRUISE then
                DisableCruiseControl(true)
            else
                local speed = GetEntitySpeed(VEHICLE_INSIDE)
                if speed >= 6.7 then
                    VEHICLE_CRUISE = true
                    SetEntityMaxSpeed(VEHICLE_INSIDE, speed)
                else
                    Notification:Info('Cruise Can Only Be Enabled Above 15MPH')
                end
            end

            TriggerEvent('Vehicles:Client:Cruise', VEHICLE_CRUISE)
        end
    end)

    AddTaskToVehicleThread('cruise', 5, true, function(veh, class)
        if VEHICLE_CRUISE and IsEntityInAir(veh) and GetEntityHeightAboveGround(veh) >= 5.0 then
            DisableCruiseControl()
        end
    end, false)
end)

AddEventHandler('Vehicles:Client:EnterVehicle', function(v, seat)
    DisableCruiseControl()
end)

AddEventHandler('Vehicles:Client:ExitVehicle', function()
    DisableCruiseControl()
end)