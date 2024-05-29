local _threading = false
AddEventHandler("Drugs:Server:StartCookThreads", function()
    if _threading then
        return
    end
    _threading = true

    Citizen.CreateThread(function()
        while _threading do
            for k, v in pairs(_inProgBrews) do
                if os.time() > v.end_time then
                    _placedStills[k].pickupReady = true
                    Logger:Info("Drugs:Moonshine", string.format("Brew for Still %s Is Ready For Pickup", k))
                    TriggerClientEvent("Drugs:Client:Moonshine:UpdateStillData", -1, k, _placedStills[k])
                    _inProgBrews[k] = nil
                end
            end

            Citizen.Wait(60000)
        end
    end)

    Citizen.CreateThread(function()
        while _threading do
            for k, v in pairs(_inProgAges) do
                if os.time() > v then
                    _placedBarrels[k].pickupReady = true
                    Logger:Info("Drugs:Moonshine", string.format("Brew for Barrel %s Is Ready For Pickup", k))
                    TriggerClientEvent("Drugs:Client:Moonshine:UpdateBarrelData", -1, k, _placedBarrels[k])
                    _inProgAges[k] = nil
                end
            end

            Citizen.Wait(60000)
        end
    end)
end)