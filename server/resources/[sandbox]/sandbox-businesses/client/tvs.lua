local insideTV = false
local createdDUIs = {}
local url = 'nui://sandbox-businesses/dui/tvs/index.html'
local scale = 0.08

AddEventHandler('Businesses:Client:Startup', function()
    for k, v in pairs(_tvData) do
        if v.viewZone then
            Polyzone.Create:Box(
                'tv_zone_'.. k,
                v.viewZone.center,
                v.viewZone.length,
                v.viewZone.width,
                v.viewZone.options,
                {
                    tv_zone = true,
                    tv_zone_id = k,
                }
            )
        end

        if v.interactZone then
            Targeting.Zones:AddBox(
                string.format("tv-interact-%s", k),
                "tv",
                v.interactZone.center,
                v.interactZone.length,
                v.interactZone.width,
                v.interactZone.options,
                {
                    {
                        icon = "tv",
                        text = "Set TV Link",
                        event = "TVs:Client:SetLink",
                        data = k,
                        jobPerms = {
                            v.jobPerm,
                        },
                    },
                },
                3.0,
                true
            )
        end
    end
end)

AddEventHandler('Polyzone:Enter', function(id, testedPoint, insideZones, data)
    if data?.tv_zone then
        insideTV = data?.tv_zone_id
        EnterTVZone(insideTV)
    end
end)

AddEventHandler('Polyzone:Exit', function(id, testedPoint, insideZones, data)
    if data?.tv_zone and data?.tv_zone_id == insideTV then
        insideTV = false
        ExitTVZone()
    end
end)

function EnterTVZone(id)
    local zoneData = _tvData[id]
    if not zoneData then return; end

    for k, v in ipairs(zoneData.tvs) do
        createdDUIs[k] = createTVScaleform(k)
        Citizen.Wait(500)
    
        PushScaleformMovieFunction(createdDUIs[k].sf, 'SET_TEXTURE')
    
        PushScaleformMovieMethodParameterString('texture_arp_tvs_' .. k)
        PushScaleformMovieMethodParameterString('texture_arp_tvs_other_' .. k)
    
        PushScaleformMovieFunctionParameterInt(0)
        PushScaleformMovieFunctionParameterInt(0)
        PushScaleformMovieFunctionParameterInt(1280)
        PushScaleformMovieFunctionParameterInt(720)
    
        PopScaleformMovieFunctionVoid()
    end


    Citizen.CreateThread(function()
        while insideTV do
            for k, v in ipairs(zoneData.tvs) do
                DrawScaleformMovie_3dSolid(
                    createdDUIs[k].sf,
                    v.coords.x,
                    v.coords.y,
                    v.coords.z,
                    v.rotation.x,
                    v.rotation.y,
                    v.rotation.z,
                    2.0, 2.0, 2.0,
                    v.scale * 1, v.scale * (9 / 16), 1,
                    2
                )
            end
            Citizen.Wait(0)
        end
    end)

    Citizen.Wait(1500)

    if createdDUIs and #createdDUIs > 0 then
        for k, v in pairs(createdDUIs) do
            SendDUIMessage(v.dui, {
                event = 'updateLink',
                data = GlobalState[string.format('TVsLink:%s', id)],
            })
        end
    end
end

function ExitTVZone()
    if createdDUIs and #createdDUIs > 0 then
        for k, v in pairs(createdDUIs) do
            DestroyDui(v.dui)
            SetScaleformMovieAsNoLongerNeeded(v.sf)
        end
        createdDUIs = {}
    end
end

AddEventHandler('onResourceStop', function(res)
    ExitTVZone()
end)

RegisterNetEvent('TVs:Client:Update', function(id)
    if insideTV == id then
        Citizen.Wait(1500)
        if createdDUIs and #createdDUIs > 0 then
            for k, v in pairs(createdDUIs) do
                SendDUIMessage(v.dui, {
                    event = 'updateLink',
                    data = GlobalState[string.format('TVsLink:%s', insideTV)],
                })
            end
        end
    end
end)

function createTVScaleform(id)
    local sfHandle = LoadScaleform('arp_tv_texture_renderer_' .. id)
    local txd = CreateRuntimeTxd('texture_arp_tvs_' .. id)
    local duiObj = CreateDui(url, 1280, 720)
    local dui = GetDuiHandle(duiObj)
    local tx = CreateRuntimeTextureFromDuiHandle(txd, 'texture_arp_tvs_other_' .. id, dui)

    return {
        sf = sfHandle,
        dui = duiObj,
    }
end

local linkPromise
function GetNewTVLink()
    linkPromise = promise.new()
    Input:Show('TVs', 'URL', {
		{
			id = 'name',
			type = 'text',
			options = {
				inputProps = {},
			},
		},
	}, 'TVs:Client:RecieveTVLinkInput', {})

    return Citizen.Await(linkPromise)
end

AddEventHandler('TVs:Client:RecieveTVLinkInput', function(values)
    if linkPromise then
        linkPromise:resolve(values?.name)
        linkPromise = nil
    end
end)

AddEventHandler('TVs:Client:SetLink', function(e, data)
    local tvLink = GetNewTVLink()
    Callbacks:ServerCallback('TVs:UpdateTVLink', {
        tv = data,
        link = tvLink
    }, function(success)
        if success then
            Notification:Success('Updated Link!', 5000, 'tv')
        else
            Notification:Error('Error', 5000, 'tv')
        end
    end)
end)