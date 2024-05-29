function GetVOIPMumbleAddress()
    local externalAddress = GlobalState.MumbleAddress
    local externalPort = GlobalState.MumblePort
    if externalAddress and externalPort > 0 then
        return externalAddress, externalPort
    else
        local defaultEndpoint = GetCurrentServerEndpoint()
        local defaultAddress, defaultPort
        for match in string.gmatch(defaultEndpoint, "[^:]+") do
            if not defaultAddress then
                defaultAddress = match
            elseif not defaultPort then
                defaultPort = tonumber(match)
            end
        end
        return defaultAddress, defaultPort
    end
end

function LoadAnim(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Citizen.Wait(10)
    end
end