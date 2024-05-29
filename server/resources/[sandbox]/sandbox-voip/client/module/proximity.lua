function DoProximityCheck(myCoords, player, proximity)
    local tgtPed = GetPlayerPed(player)
    local voiceRange = GetConvar('voice_useNativeAudio', 'false') == 'true' and proximity * 3 or proximity
    local distance = #(myCoords - GetEntityCoords(tgtPed))
    return distance < voiceRange, distance
end

function StartVOIPGridThreads()
    Citizen.CreateThread(function()
        while _characterLoaded do
            local coords = GetEntityCoords(LocalPlayer.state.ped)
            local proximity = MumbleGetTalkerProximity()

            MumbleClearVoiceTargetChannels(1)

            MumbleAddVoiceChannelListen(LocalPlayer.state.voiceChannel)
            MumbleAddVoiceTargetChannel(1, LocalPlayer.state.voiceChannel)

            for k, v in pairs(CALL_DATA) do
                if k ~= PLAYER_SERVER_ID then
                    MumbleAddVoiceTargetChannel(1, MumbleGetVoiceChannelFromServerId(k))
                end
            end

            local players = GetActivePlayers()
            local added = {}
            for _, player in ipairs(players) do
                local serverId = GetPlayerServerId(player)
                local shouldAdd, dist = DoProximityCheck(coords, player, proximity)
                if shouldAdd then
                    MumbleAddVoiceTargetChannel(1, MumbleGetVoiceChannelFromServerId(serverId))
                    table.insert(added, {serverId, MumbleGetVoiceChannelFromServerId(serverId)})
                end
            end

            if _inDebug then
                print(#added, json.encode(added), proximity, json.encode(CALL_DATA), LocalPlayer.state.voiceChannel)
            end

            local isSpectating = NetworkIsInSpectatorMode()
            if isSpectating then
                SetSpectatorVoiceMode(true)
            else
                SetSpectatorVoiceMode(false)
            end

            Citizen.Wait(200)
        end
    end)
end

local isSpecVoiceEnabled = true
function SetSpectatorVoiceMode(enabled)
    if enabled then
        isSpecVoiceEnabled = true

        for _, player in ipairs(GetActivePlayers()) do
            local serverId = GetPlayerServerId(player)
            if serverId ~= PLAYER_SERVER_ID then
                MumbleAddVoiceChannelListen(MumbleGetVoiceChannelFromServerId(serverId))
            end
        end
    else
        if isSpecVoiceEnabled then
            for _, player in ipairs(GetActivePlayers()) do
                local serverId = GetPlayerServerId(player)
                if serverId ~= PLAYER_SERVER_ID then 
                    MumbleRemoveVoiceChannelListen(MumbleGetVoiceChannelFromServerId(serverId))
                end
            end
        end

        isSpecVoiceEnabled = false
    end
end

RegisterNetEvent('onPlayerJoining', function(serverId)
    if isSpecVoiceEnabled then
        MumbleAddVoiceChannelListen(MumbleGetVoiceChannelFromServerId(serverId))
    end
end)

RegisterNetEvent('onPlayerDropped', function(serverId)
    if isSpecVoiceEnabled then
        MumbleRemoveVoiceChannelListen(MumbleGetVoiceChannelFromServerId(serverId))
    end
end)