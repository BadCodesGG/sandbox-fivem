PER_PAGE = 10

local fuckingCharProjection = {
    SID = 1,
    First = 1,
    Last = 1,
    DOB = 1,
    BankAccount = 1,
    Jobs = 1,
    Cash = 1,
    LastPlayed = 1,
    Phone = 1,
    Deleted = 1,
    User = 1,
}

function GetSpawnLocations()
    local p = promise.new()

    Database.Game:find({
        collection = 'locations',
        query = {
            Type = 'spawn'
        }
    }, function(success, results)
        if success and #results > 0 then
            p:resolve(results)
        else
            p:resolve(false)
        end
    end)

    local res = Citizen.Await(p)
    return res
end

function RegisterCallbacks()
    Callbacks:RegisterServerCallback('Admin:GetPlayerList', function(source, data, cb)
        Citizen.CreateThread(function()
            local player = Fetch:Source(source)
            if player and player.Permissions:IsStaff() then
                local data = {}
                local activePlayers = Fetch:All()
    
                for k, v in pairs(activePlayers) do
                    if v ~= nil and v:GetData('AccountID') then
                        table.insert(data, {
                            Source = v:GetData('Source'),
                            Name = v:GetData('Name'),
                            AccountID = v:GetData('AccountID'),
                            Character = v:GetData('Character'),
                        })
                    end
                end
                cb(data)
            else
                cb(false)
            end
        end)
    end)

    Callbacks:RegisterServerCallback('Admin:GetDisconnectedPlayerList', function(source, data, cb)
        local player = Fetch:Source(source)
        if player and player.Permissions:IsStaff() then
            local rDs = exports['sandbox-base']:FetchComponent('RecentDisconnects')
            cb(rDs)
        else
            cb(false)
        end
    end)

    Callbacks:RegisterServerCallback('Admin:GetPlayer', function(source, data, cb)
        local player = Fetch:Source(source)
        if player and player.Permissions:IsStaff() then
            local target = Fetch:Source(data)

            if target then
                local staffGroupName = false
                if target.Permissions:IsStaff() then
                    local highestLevel = 0
                    for k, v in ipairs(target:GetData('Groups')) do
                        if C.Groups[tostring(v)] ~= nil and (type(C.Groups[tostring(v)].Permission) == 'table') then
                            if C.Groups[tostring(v)].Permission.Level > highestLevel then
                                highestLevel = C.Groups[tostring(v)].Permission.Level
                                staffGroupName = C.Groups[tostring(v)].Name
                            end
                        end
                    end
                end

                local pPed = GetPlayerPed(target:GetData('Source'))
                local coords = GetEntityCoords(pPed)
                local inVehicle = GetVehiclePedIsIn(pPed, false)
                if inVehicle and inVehicle > 0 then
                    local ent = Entity(inVehicle)

                    local isDriver = GetPedInVehicleSeat(inVehicle, -1) == pPed

                    inVehicle = {
                        Entity = inVehicle,
                        VIN = ent.state.VIN,
                        Plate = GetVehicleNumberPlateText(inVehicle),
                        Make = ent.state.Make,
                        Model = ent.state.Model,
                        Driver = isDriver,
                    }
                end

                local char = Fetch:CharacterSource(data)

                local p = promise.new()
                Database.Game:find({
                    collection = "characters",
                    query = char and {
                        User = target:GetData('AccountID'),
                        SID = {
                            ["$ne"] = char:GetData("SID")
                        }
                    } or {
                        User = target:GetData('AccountID'),
                    },
                    options = {
                        projection = fuckingCharProjection,
                    }
                }, function(success, results)
                    if success and results and #results > 0 then
                        p:resolve(results)
                    else
                        p:resolve({})
                    end
                end)

                local chars = Citizen.Await(p)

                local tData = {
                    Source = target:GetData('Source'),
                    Name = target:GetData('Name'),
                    GameName = target:GetData('GameName'),
                    AccountID = target:GetData('AccountID'),
                    Identifier = target:GetData('Identifier'),
                    Discord = target:GetData("Discord"),
                    Mention = target:GetData("Mention"),
                    Avatar = target:GetData("Avatar"),
                    Level = target.Permissions:GetLevel(),
                    Groups = target:GetData('Groups'),
                    StaffGroup = staffGroupName,
                    Character = char and {
                        First = char:GetData('First'),
                        Last = char:GetData('Last'),
                        SID = char:GetData('SID'),
                        DOB = char:GetData('DOB'),
                        Phone = char:GetData('Phone'),
                        Jobs = char:GetData('Jobs'),
                        Coords = {
                            x = coords.x,
                            y = coords.y,
                            z = coords.z
                        }
                    } or false,
                    Characters = chars,
                    Vehicle = inVehicle,
                }

                cb(tData)
            else
                local rDs = exports['sandbox-base']:FetchComponent('RecentDisconnects')
                for k, v in ipairs(rDs) do
                    if v.Source == data then
                        local tData = v

                        if tData.IsStaff then
                            local highestLevel = 0
                            for k, v in ipairs(tData.Groups) do
                                if C.Groups[tostring(v)] ~= nil and (type(C.Groups[tostring(v)].Permission) == 'table') then
                                    if C.Groups[tostring(v)].Permission.Level > highestLevel then
                                        highestLevel = C.Groups[tostring(v)].Permission.Level
                                        tData.StaffGroup = C.Groups[tostring(v)].Name
                                    end
                                end
                            end
                        end

                        tData.Disconnected = true
                        tData.Reconnected = false

                        for k, v in pairs(Fetch:All()) do
                            if v:GetData('AccountID') == tData.AccountID then
                                tData.Reconnected = k
                            end
                        end

                        cb(tData)
                        return
                    end
                end

                cb(false)
            end
        else
            cb(false)
        end
    end)

    Callbacks:RegisterServerCallback('Admin:GetAllPlayersByCharacter', function(source, data, cb)
        local player = Fetch:Source(source)
        if player and player.Permissions:IsStaff() then
            local matchQuery = {
                User = { ["$exists"] = 1 },
            }

            if #data.term > 0 then
                matchQuery = {
                    ["$and"] = {
                        {
                            ["$or"] = {
                                {
                                    ["$expr"] = {
                                        ["$eq"] = {
                                            { ["$toString"] = "$SID" },
                                            data.term
                                        }
                                    },
                                },
                                {
									["$expr"] = {
										["$regexMatch"] = {
											input = {
												["$concat"] = { "$First", " ", "$Last" },
											},
											regex = data.term,
											options = "i",
										},
									},
								},
                            }
                        },
                    }
                }
            end

            Database.Game:aggregate({
                collection = 'characters',
                aggregate = {
                    {
                        ["$match"] = matchQuery,
                    },
                    {
                        ["$project"] = fuckingCharProjection,
                    },
                    {
                        ["$sort"] = {
                            SID = -1
                        }
                    },
                    {
                        ['$facet'] = {
                            data = {
                                { ["$skip"] = (data.page - 1) * PER_PAGE },
                                { ["$limit"] = PER_PAGE }
                            },
                            pagination = {
                                { ["$count"] = "total" }
                            }
                        },
                    }
                }
            }, function(success, results)
                if success and results[1]?.data and results[1]?.pagination then
                    local totalPages = results[1]?.pagination[1]?.total or 1
                    local foundPlayers = results[1]?.data or {}
                    local data = {}

                    for k, v in ipairs(foundPlayers) do
                        local isOnline = Fetch:PlayerData("AccountID", v.User)

                        if isOnline then
                            v.Online = isOnline:GetData("Source")
                        end

                        table.insert(data, v)
                    end

                    cb({
                        players = data,
                        pages = totalPages,
                    })
                else
                    cb(false)
                end
            end)
        else
            cb(false)
        end
    end)

    Callbacks:RegisterServerCallback('Admin:BanPlayer', function(source, data, cb)
        local player = Fetch:Source(source)
        if player and data.targetSource and type(data.length) == "number" and type(data.reason) == "string" and data.length >= -1 and data.length <= 90 then
            if player.Permissions:IsAdmin() or (player.Permissions:IsStaff() and data.length > 0 and data.length <= 7) then
                cb(Punishment.Ban:Source(data.targetSource, data.length, data.reason, source))
            else
                cb(false)
            end
        else
            cb(false)
        end
    end)

    Callbacks:RegisterServerCallback('Admin:KickPlayer', function(source, data, cb)
        local player = Fetch:Source(source)
        if player and data.targetSource and type(data.reason) == "string" and player.Permissions:IsStaff() then
            cb(Punishment:Kick(data.targetSource, data.reason, source))
        else
            cb(false)
        end
    end)

    Callbacks:RegisterServerCallback('Admin:ActionPlayer', function(source, data, cb)
        local player = Fetch:Source(source)
        if player and data.action and data.targetSource and player.Permissions:IsStaff() then
            local target = Fetch:Source(data.targetSource)
            if target then
                local canFuckWith = player.Permissions:GetLevel() > target.Permissions:GetLevel()
                local notMe = player:GetData('Source') ~= target:GetData('Source')
                local wasSuccessful = false

                local targetChar = Fetch:CharacterSource(data.targetSource)
                if targetChar then
                    local playerPed = GetPlayerPed(player:GetData('Source'))
                    local targetPed = GetPlayerPed(target:GetData('Source'))
                    if data.action == 'bring' and canFuckWith and notMe then
                        local playerCoords = GetEntityCoords(playerPed)
                        Pwnzor.Players:TempPosIgnore(target:GetData("Source"))
                        SetEntityCoords(targetPed, playerCoords.x, playerCoords.y, playerCoords.z + 1.0)

                        cb({
                            success = true,
                            message = 'Brought Successfully'
                        })

                        wasSuccessful = true
                    elseif data.action == 'goto' then
                        local targetCoords = GetEntityCoords(targetPed)
                        TriggerEvent("PAC:IgnoreNextNoclipFlag")
                        SetEntityCoords(playerPed, targetCoords.x, targetCoords.y, targetCoords.z + 1.0)

                        cb({
                            success = true,
                            message = 'Teleported To Successfully'
                        })

                        wasSuccessful = true
                    elseif data.action == 'heal' then
                        if (notMe or player.Permissions:IsAdmin()) then
                            Callbacks:ClientCallback(targetChar:GetData("Source"), "Damage:Heal", true)
                            
                            cb({
                                success = true,
                                message = 'Healed Successfully'
                            })

                            wasSuccessful = true
                        else
                            cb({
                                success = false,
                                message = 'Can\'t Heal Yourself'
                            })
                        end
                    elseif data.action == 'attach' and (canFuckWith or player.Permissions:GetLevel() == 100) and notMe then
                        TriggerClientEvent('Admin:Client:Attach', source, target:GetData('Source'), GetEntityCoords(targetPed), {
                            First = targetChar:GetData("First"),
                            Last = targetChar:GetData("Last"),
                            SID = targetChar:GetData("SID"),
                            Account = target:GetData("AccountID"),
                        })

                        cb({
                            success = true,
                            message = 'Attached Successfully'
                        })

                        wasSuccessful = true
                    elseif data.action == 'marker' and (canFuckWith or player.Permissions:GetLevel() == 100) then
                        local targetCoords = GetEntityCoords(targetPed)
                        TriggerClientEvent('Admin:Client:Marker', source, targetCoords.x, targetCoords.y)
					else
						cb({
                            success = false,
                            message = 'An error has occured due to similar permissions.'
                        })
					end

                    if wasSuccessful then
                        Logger:Warn(
                            "Admin",
                            string.format(
                                "%s [%s] Used Staff Action %s On %s [%s] - Character %s %s (%s)", 
                                player:GetData("Name"),
                                player:GetData("AccountID"),
                                string.upper(data.action),
                                target:GetData("Name"),
                                target:GetData("AccountID"),
                                targetChar:GetData('First'),
                                targetChar:GetData('Last'),
                                targetChar:GetData('SID')
                            ),
                            {
                                console = true,
                                file = false,
                                database = true,
                                discord = {
                                    embed = true,
                                    type = "error",
                                    webhook = GetConvar("discord_admin_webhook", ''),
                                },
                            }
                        )
                    end
                    return
                end
            end
        end

        cb(false)
    end)

    Callbacks:RegisterServerCallback('Admin:GetVehicleList', function(source, data, cb)
        local player = Fetch:Source(source)
        if player and player.Permissions:IsStaff() then
            local tData = {}
            local allVehicles = Vehicles.Owned.GetAllActive()
            for k, v in pairs(allVehicles) do
                local entityId = v:GetData("EntityId")
                local ent = Entity(entityId)
                if ent then
                    table.insert(tData, {
                        Entity = entityId,
                        VIN = ent.state.VIN,
                        Plate = GetVehicleNumberPlateText(entityId),
                        Make = ent.state.Make,
                        Model = ent.state.Model,
                        OwnerId = ent.state.Owner?.Id
                    })
                end
            end
            cb(tData)
        else
            cb(false)
        end
    end)

    Callbacks:RegisterServerCallback('Admin:GetVehicle', function(source, data, cb)
        local player = Fetch:Source(source)
        if player and player.Permissions:IsStaff() and data and DoesEntityExist(data) then
            local ent = Entity(data)

            local vehicleCoords = GetEntityCoords(data)
            local vehicleHeading = GetEntityHeading(data)

            local vData = {
                Make = ent.state.Make,
                Model = ent.state.Model,
                VIN = ent.state.VIN,
                Owned = ent.state.Owned,
                Owner = ent.state.Owner,
                Plate = ent.state.Plate,
                Value = ent.state.Value,
                Entity = data,
                EntityModel = GetEntityModel(data),
                Coords = {
                    x = vehicleCoords.x,
                    y = vehicleCoords.y,
                    z = vehicleCoords.z,
                },
                Heading = vehicleHeading,
                Fuel = ent.state.Fuel,
                Damage = ent.state.Damage,
                DamagedParts = ent.state.DamagedParts,
            }

            cb(vData)
        else
            cb(false)
        end
    end)

    Callbacks:RegisterServerCallback('Admin:VehicleAction', function(source, data, cb)
        local player = Fetch:Source(source)
        if player and data.action and player.Permissions:IsAdmin() and data.target and DoesEntityExist(data.target) then
            local veh = Entity(data.target)
            local netOwner = NetworkGetEntityOwner(data.target)

            if data.action == "fuel" then
                veh.state.Fuel = 100
            elseif data.action == "delete" then
                Vehicles:Delete(data.target, function() end)
            elseif data.action == "locks" then
                veh.state.Locked = not veh.state.Locked

                SetVehicleDoorsLocked(data.target, veh.state.Locked and 2 or 1)

                cb({
                    success = true,
                    message = veh.state.Locked and "Vehicle Locked" or "Vehicle Unlocked",
                })

                return
            elseif data.action == "sitinside" then
                local pPed = GetPlayerPed(source)
                local currentVehicle = GetVehiclePedIsIn(pPed, false)
                if currentVehicle == data.target then
                    cb({
                        success = false,
                        message = "Already In Vehicle!",
                    })

                    return
                end

                for i = -1, (data.numSeats - 2) do
                    if GetPedInVehicleSeat(data.target, i) <= 0 then
                        local vehCoords = GetEntityCoords(data.target)

                        SetEntityCoords(pPed, vehCoords.x, vehCoords.y, vehCoords.z - 25.0, true, false, false, false)
                        Citizen.Wait(300)
                        SetPedIntoVehicle(pPed, data.target, i)

                        break
                    end
                end
            else
                if netOwner > 0 then
                    if data.action == "explode" then
                        TriggerClientEvent("NetSync:Client:Execute", netOwner, "NetworkExplodeVehicle", NetworkGetNetworkIdFromEntity(data.target), 1, 0)
                    elseif data.action == "repair" then
                        TriggerClientEvent("Vehicles:Client:Repair:Normal", netOwner, NetworkGetNetworkIdFromEntity(data.target))
                    elseif data.action == "repair_full" then
                        TriggerClientEvent("Vehicles:Client:Repair:Full", netOwner, NetworkGetNetworkIdFromEntity(data.target))
                    elseif data.action == "repair_engine" then
                        TriggerClientEvent("Vehicles:Client:Repair:Engine", netOwner, NetworkGetNetworkIdFromEntity(data.target))
                    elseif data.action == "stall" then
                        TriggerClientEvent("Admin:Client:Stall", netOwner, NetworkGetNetworkIdFromEntity(data.target))
                    else
                        cb({
                            success = false,
                            message = "Unknown Action"
                        })

                        return
                    end
                else
                    cb({
                        success = false,
                        message = "Cannot Execute RPC Action on This Vehicle At This Time!"
                    })

                    return
                end
            end

            Logger:Warn(
                "Admin",
                string.format(
                    "%s [%s] Used Vehicle Action %s on %s",
                    player:GetData("Name"),
                    player:GetData("AccountID"),
                    string.upper(data.action),
                    veh.state.VIN or "Unknown"
                ),
                {
                    console = true,
                    file = false,
                    database = true,
                    discord = {
                        embed = true,
                        type = "error",
                        webhook = GetConvar("discord_admin_webhook", ''),
                    },
                }
            )
            cb({
                success = true,
                message = "Success"
            })
        else
            cb(false)
        end
    end)

    Callbacks:RegisterServerCallback('Admin:CurrentVehicleAction', function(source, data, cb)
        local player = Fetch:Source(source)
        if player and data.action and player.Permissions:IsAdmin() and player.Permissions:GetLevel() >= 90 then
            Logger:Warn(
                "Admin",
                string.format(
                    "%s [%s] Used Vehicle Action %s",
                    player:GetData("Name"),
                    player:GetData("AccountID"),
                    string.upper(data.action)
                ),
                {
                    console = (player.Permissions:GetLevel() < 100),
                    file = false,
                    database = true,
                    discord = (player.Permissions:GetLevel() < 100) and {
                        embed = true,
                        type = "error",
                        webhook = GetConvar("discord_admin_webhook", ''),
                    } or false,
                }
            )
            cb(true)
        else
            cb(false)
        end
    end)

    Callbacks:RegisterServerCallback('Admin:NoClip', function(source, data, cb)
        local player = Fetch:Source(source)
        if player and player.Permissions:IsStaff() then
            Logger:Warn(
                "Admin",
                string.format(
                    "%s [%s] Used NoClip (State: %s)",
                    player:GetData("Name"),
                    player:GetData("AccountID"),
                    data?.active and 'On' or 'Off'
                ),
                {
                    console = true,
                    file = false,
                    database = true,
                    discord = {
                        embed = true,
                        type = "error",
                        webhook = GetConvar("discord_admin_webhook", ''),
                    },
                }
            )
            cb(true)
        else
            cb(false)
        end
    end)

    Callbacks:RegisterServerCallback('Admin:UpdatePhonePerms', function(source, data, cb)
        local player = Fetch:Source(source)
        if player.Permissions:IsAdmin() then
            local char = Fetch:CharacterSource(data.target)
            if char ~= nil then
                local cPerms = char:GetData("PhonePermissions")
                cPerms[data.app][data.perm] = data.state
                char:SetData("PhonePermissions", cPerms)
                cb(true)
            else
                cb(false)
            end
        else
            cb(false)
        end
    end)

    Callbacks:RegisterServerCallback('Admin:ToggleInvisible', function(source, data, cb)
        local player = Fetch:Source(source)
        if player and player.Permissions:IsAdmin() then
            Logger:Warn(
                "Admin",
                string.format(
                    "%s [%s] Used Invisibility",
                    player:GetData("Name"),
                    player:GetData("AccountID")
                ),
                {
                    console = true,
                    file = false,
                    database = true,
                    discord = {
                        embed = true,
                        type = "error",
                        webhook = GetConvar("discord_admin_webhook", ''),
                    },
                }
            )

            TriggerClientEvent('Admin:Client:Invisible', source)
            cb(true)
        else
            cb(false)
        end
    end)
end