function RunLaborLogoutShit(source)
    for k, v in pairs(_Jobs) do
        for k2, v2 in ipairs(v.OnDuty) do
            if v2.Joiner == source then
                if v2.Group then
                    for k3, v3 in pairs(_Groups) do
                        for k4, v4 in ipairs(v3.Members) do
                            if v3.Creator.ID == source then
                                return Labor.Workgroups:Disband(source, true)
                            end
                        end
                    end
                else
                    Labor.Duty:Off(k, source)
                end
            end
        end
    end

    for k, v in pairs(_Groups) do
        if v.Creator.ID == source then
            return Labor.Workgroups:Disband(source, true)
        else
            for k2, v2 in ipairs(v.Members) do
                if v2.ID == source then
                    return Labor.Workgroups:Leave(v, source)
                end
            end
        end
    end

    _pendingInvites[source] = nil

    for k, v in pairs(_pendingInvites) do
        if v == source then
            Phone.Notification:Add(
                v.Creator.ID,
                "Job Activity",
                "Requested Group Is No Longer Available",
                os.time(),
                6000,
                "labor",
                {}
            )
            _pendingInvites[k] = nil
        end
    end
end


function RegisterMiddleware()
    
end

AddEventHandler("Characters:Server:PlayerLoggedOut", RunLaborLogoutShit)
AddEventHandler("Characters:Server:PlayerDropped", RunLaborLogoutShit)
