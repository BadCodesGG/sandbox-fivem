_blipCount = 1
_alertBlips = {}

_specialBlips = {}

RegisterNetEvent("EmergencyAlerts:Client:Clear", function(eventRoutine)
    for i = 1, _blipCount do
        local id = string.format("emrg-%s", i)
        Blips:Remove(id)
    end

    for k, v in ipairs(_alertBlips) do
        RemoveBlip(v.blip)
    end

    _blipCount = 1
    _alertBlips = {}

    Notification:Success("Blips Cleared & Reset")
end)

RegisterNetEvent("Job:Client:DutyChanged", function(state)
    if state then
        Citizen.CreateThread(function()
            local mySID = LocalPlayer.state.Character:GetData('SID')
            while LocalPlayer.state.loggedIn and LocalPlayer.state.onDuty and _trackedJobs[LocalPlayer.state.onDuty] do
                if #_alertBlips > 0 then
                    for k, v in ipairs(_alertBlips) do
                        if v.time <= GetCloudTimeAsInt() then
                            SetBlipFlashes(v.blip, false)
                            Blips:Remove(v.id)
                            RemoveBlip(v.blip)
                            table.remove(_alertBlips, k)
                        end
                    end
                    Citizen.Wait(30000)
                else
                    Citizen.Wait(1000)
                end
            end

            for k, v in ipairs(_alertBlips) do
                SetBlipFlashes(v.blip, false)
                Blips:Remove(v.id)
                RemoveBlip(v.blip)
                table.remove(_alertBlips, k)
            end

            for k, v in pairs(_specialBlips) do
                Blips:Remove(string.format("etb-%s", k))
            end

            _specialBlips = {}
        end)
    end
end)

RegisterNetEvent("EmergencyAlerts:Client:TrackerBlip", function(job, uId, title, coords, icon, color, size, flashing, alpha)
    if LocalPlayer.state.onDuty == job then
        if title then
            if _specialBlips[uId] and DoesBlipExist(_specialBlips[uId]) then
                SetBlipCoords(_specialBlips[uId], coords)
            else
                local blip = Blips:Add(
                    string.format("etb-%s", uId),
                    title,
                    coords,
                    icon,
                    color,
                    size,
                    2,
                    false,
                    flashing
                )
    
                if alpha then
                    SetBlipAlpha(blip, alpha)
                end
        
                _specialBlips[uId] = blip
            end
        elseif _specialBlips[uId] then
            Blips:Remove(string.format("etb-%s", uId))
            _specialBlips[uId] = nil
        end
    end
end)