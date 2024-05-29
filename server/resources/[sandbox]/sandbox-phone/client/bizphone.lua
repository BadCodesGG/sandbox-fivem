local phoneModel = `vw_prop_casino_phone_01a`
local _createdPhones = {}

function CreateBizPhoneObject(coords, rotation)
	RequestModel(phoneModel)
	while not HasModelLoaded(phoneModel) do
		Citizen.Wait(1)
	end

    local obj = CreateObject(phoneModel, coords.x, coords.y, coords.z, false, true, false)
    SetEntityRotation(obj, rotation.x, rotation.y, rotation.z)
    FreezeEntityPosition(obj, true)
    SetEntityCoords(obj, coords.x, coords.y, coords.z)

    while not DoesEntityExist(obj) do
        Citizen.Wait(1)
    end

    return obj
end

function CreateBizPhones()
    while GlobalState.BizPhones == nil do
        Citizen.Wait(100)
    end

    for k, v in pairs(GlobalState.BizPhones) do
        local object = CreateBizPhoneObject(v.coords, v.rotation)

        Targeting:AddEntity(object, "phone-office", {
            {
                icon = "phone-volume",
                text = "Phone",
                event = "",
                isEnabled = function(data, entity)
                    if data then
                        local pData = GlobalState[string.format("BizPhone:%s", data.id)]
                        if pData and pData.state > 1 then
                            return true
                        end
                    end
                end,
                textFunc = function(data, entity)
                    if data then
                        local pData = GlobalState[string.format("BizPhone:%s", data.id)]
                        if pData then
                            if pData.state == 2 then
                                return string.format("On Call (%s)", pData.callingStr)
                            else
                                return string.format("Dialing (%s)", pData.number)
                            end
                        end
                    end

                    return ""
                end,
                data = {
                    id = v.id,
                },
                jobPerms = {
                    {
                        job = v.job
                    }
                }
            },
            {
                icon = "phone-arrow-up-right",
                text = "Make Call",
                event = "Phone:Client:MakeBizCall",
                isEnabled = function(data, entity)
                    if data then
                        local pData = GlobalState[string.format("BizPhone:%s", data.id)]
                        if not pData then
                            return true
                        end
                    end
                end,
                data = {
                    id = v.id,
                },
                jobPerms = {
                    {
                        job = v.job
                    }
                }
            },
            {
                icon = "phone",
                text = "Answer Phone",
                event = "Phone:Client:AcceptBizCall",
                isEnabled = function(data, entity)
                    if data then
                        local pData = GlobalState[string.format("BizPhone:%s", data.id)]
                        if pData and pData.state == 1 then
                            return true
                        end
                    end
                end,
                textFunc = function(data, entity)
                    if data then
                        local pData = GlobalState[string.format("BizPhone:%s", data.id)]
                        if pData and pData.state == 1 then
                            return string.format("Answer Call From %s", pData.callingStr)
                        end
                    end

                    return ""
                end,
                data = {
                    id = v.id,
                },
                jobPerms = {
                    {
                        job = v.job
                    }
                }
            },
            {
                icon = "phone-hangup",
                text = "Hang Up",
                event = "Phone:Client:DeclineBizCall",
                isEnabled = function(data, entity)
                    if data then
                        local pData = GlobalState[string.format("BizPhone:%s", data.id)]
                        if pData then
                            return true
                        end
                    end
                end,
                data = {
                    id = v.id,
                },
                jobPerms = {
                    {
                        job = v.job
                    }
                }
            },
            {
                icon = "phone-slash",
                text = "Mute Phone",
                event = "Phone:Client:MuteBiz",
                textFunc = function(data, entity)
                    if data then
                        local pData = GlobalState[string.format("BizPhone:%s:Muted", data.id)]
                        if pData then
                            return "Unmute Phone"
                        end
                    end

                    return "Mute Phone"
                end,
                data = {
                    id = v.id,
                },
                jobPerms = {
                    {
                        job = v.job
                    }
                }
            },
        })

        table.insert(_createdPhones, object)
    end
end

function CleanupBizPhones()
    for k, v in ipairs(_createdPhones) do
        if DoesEntityExist(v) then
            DeleteEntity(v)
        end
    end

    _createdPhones = {}
end

AddEventHandler("Phone:Client:MakeBizCall", function(entityData, data)
    Input:Show("Phone Number", "Number to Call", {
		{
			id = "number",
			type = "text",
			options = {
                helperText = "E.g 555-555-5555",
				inputProps = {
                    pattern = "[0-9-]+",
                    minlength = 12,
                    maxlength = 12,
                },
			},
		},
	}, "Phone:Client:MakeBizCallConfirm", data)
end)

AddEventHandler("Phone:Client:MuteBiz", function(entityData, data)
    Callbacks:ServerCallback("Phone:MuteBiz", data.id, function(success, state)
        if success then
            if state then
                Notification:Error("Muted Phone")
            else
                Notification:Success("Unmuted Phone")
            end
        else
            Notification:Error("Error")
        end
    end)
end)

AddEventHandler("Phone:Client:MakeBizCallConfirm", function(values, data)
    if values.number and data.id and GlobalState.BizPhones[data.id] then
        Callbacks:ServerCallback("Phone:MakeBizCall", { id = data.id, number = values.number }, function(success)
            LocalPlayer.state.bizCall = data.id
            local startCoords = GlobalState.BizPhones[data.id].coords

            if success then
                Citizen.CreateThread(function()
                    Animations.Emotes:Play("phonecall2", true)
                    Sounds.Loop:One("ringing.ogg", 0.1)
                    InfoOverlay:Show("Dialing", string.format("Dailing Number: %s", values.number))

                    while LocalPlayer.state.loggedIn and LocalPlayer.state.bizCall do
                        if #(GetEntityCoords(LocalPlayer.state.ped) - startCoords) >= 10.0 then
                            TriggerServerEvent("Phone:Server:ForceEndBizCall")
                        end
                        Citizen.Wait(500)
                    end

                    Animations.Emotes:ForceCancel()
                    Sounds.Stop:One("ringing.ogg")
                    InfoOverlay:Close()
                end)
            else
                Notification:Error("Failed to Make Call")
            end
        end)
    end
end)

RegisterNetEvent("Phone:Client:Phone:AcceptBizCall", function(number)
    if LocalPlayer.state.bizCall then
        InfoOverlay:Show("On Call", string.format("To Number: %s", number))
        Sounds.Stop:One("ringing.ogg")
    end
end)

RegisterNetEvent("Phone:Client:Biz:Recieve", function(id, coords, radius)
    if LocalPlayer.state.loggedIn and not GlobalState[string.format("BizPhone:%s:Muted", id)] then
        local myCoords = GetEntityCoords(LocalPlayer.state.ped)
        if #(myCoords - coords) <= 150.0 then
            Sounds.Do.Loop:Location(string.format("bizphones-%s", id), coords, radius, "bizphone.ogg", 0.1)
            Citizen.SetTimeout(30000, function()
                Sounds.Do.Stop:Distance(string.format("bizphones-%s", id), "bizphone.ogg")
            end)
        end
    end
end)

AddEventHandler("Phone:Client:DeclineBizCall", function(entityData, data)
    Callbacks:ServerCallback("Phone:DeclineBizCall", data.id, function(success)
        if not success then
            Notification:Error("Failed to Decline Call")
        end
    end)
end)

AddEventHandler("Phone:Client:AcceptBizCall", function(entityData, data)
    if data.id and GlobalState.BizPhones[data.id] then
        Callbacks:ServerCallback("Phone:AcceptBizCall", data.id, function(success, callStr)
            local startCoords = GlobalState.BizPhones[data.id].coords
            LocalPlayer.state.bizCall = data.id
    
            if success then
                Citizen.CreateThread(function()
                    Animations.Emotes:Play("phonecall2", true)
                    InfoOverlay:Show("On Call", string.format("From Number: %s", callStr))
                    while LocalPlayer.state.loggedIn and LocalPlayer.state.bizCall do
                        if #(GetEntityCoords(LocalPlayer.state.ped) - startCoords) >= 10.0 then
                            TriggerServerEvent("Phone:Server:ForceEndBizCall")
                        end
                        Citizen.Wait(500)
                    end
    
                    Animations.Emotes:ForceCancel()
                    InfoOverlay:Close()
                end)
            else
                Notification:Error("Failed to Accept Call")
            end
        end)
    end
end)

RegisterNetEvent("Phone:Client:Biz:Answered", function(id)
    Sounds.Do.Stop:Distance(string.format("bizphones-%s", id), "bizphone.ogg")
end)

RegisterNetEvent("Phone:Client:Biz:End", function(id)
    Sounds.Do.Stop:Distance(string.format("bizphones-%s", id), "bizphone.ogg")

    if LocalPlayer.state.bizCall and LocalPlayer.state.bizCall == id then
        LocalPlayer.state.bizCall = nil
        Sounds.Play:One("ended.ogg", 0.15)
    end
end)