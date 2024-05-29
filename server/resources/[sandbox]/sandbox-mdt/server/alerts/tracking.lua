local memberCoords = {}

function StartAETrackingThreads()
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(3000)
            for k, v in pairs(emergencyAlertsData) do
                if v ~= nil and v.Source and GetPlayerEndpoint(v.Source) then
                    if not v.TrackerDisabled then
                        local tpCoords = Player(v.Source)?.state?.tpLocation
                        if tpCoords then
                            memberCoords[k] = vector3(tpCoords.x, tpCoords.y, tpCoords.z)
                        else
                            memberCoords[k] = GetEntityCoords(GetPlayerPed(k))
                        end
                    end
                else
                    memberCoords[k] = nil
                end
            end

            EmergencyAlerts:SendOnDutyEvent("EmergencyAlerts:Client:UpdateTrackers", memberCoords)
        end
    end)
end