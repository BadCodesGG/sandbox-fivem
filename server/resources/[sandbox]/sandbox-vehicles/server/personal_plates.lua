local tempTakenPlates = {}

function IsPersonalPlateValid(plate)
    plate = string.upper(plate)

    local res = string.match(plate, "[A-HJ-NPR-Z0-9 ]+", 1)
    local trimmedLength = #plate:gsub(" ", "")

    local addedSpacing = math.floor((8 - trimmedLength) / 2)

    if res and res == plate and trimmedLength >= 4 then
        if trimmedLength < 8 then
            return string.rep(" ", addedSpacing) .. plate .. string.rep(" ", (8 - trimmedLength) - addedSpacing)
        else
            return plate
        end
    end

    return false
end

function IsPersonalPlateTaken(plate)
    if GENERATED_TEMP_PLATES[plate] then
        return true
    end

    if tempTakenPlates[plate] then
        return true
    end

    local test = IsPlateOwned(plate)
    return test
end

function PrivatePlateStuff(char, source, itemData)
    Callbacks:ClientCallback(source, "Vehicles:GetPersonalPlate", {}, function(veh, plate)
        if not veh or not plate then
            return
        end
        veh = NetworkGetEntityFromNetworkId(veh)
        if veh and DoesEntityExist(veh) then
            local vehState = Entity(veh).state
            if not vehState.VIN then
                Execute:Client(source, "Notification", "Error", "Error")
                return
            end

            local vehicle = Vehicles.Owned:GetActive(vehState.VIN)
            if not vehicle then
                Execute:Client(source, "Notification", "Error", "Can't Do It on This Vehicle")
                return
            end

            if vehicle:GetData("FakePlate") then
                Execute:Client(source, "Notification", "Error", "Can't Do It on This Vehicle")
                return
            end

            local originalPlate = vehicle:GetData("RegisteredPlate")
            local newPlate = IsPersonalPlateValid(plate)

            if not newPlate then
                Execute:Client(source, "Notification", "Error", "Invalid Plate Formatting")
                return
            end

            if IsPersonalPlateTaken(newPlate) then
                Execute:Client(source, "Notification", "Error", "That Plate is Taken")
                return
            end

            tempTakenPlates[vehicle:GetData("RegisteredPlate")] = true
            tempTakenPlates[newPlate] = true

            local previousPlateChanges = vehicle:GetData("PreviousPlates") or {}

            table.insert(previousPlateChanges, {
                time = os.time(),
                oldPlate = vehicle:GetData("RegisteredPlate"),
                newPlate = newPlate,
                doneBy = char:GetData("SID")
            })

            vehicle:SetData("PreviousPlates", previousPlateChanges)
            vehicle:SetData("RegisteredPlate", newPlate)
            SetVehicleNumberPlateText(veh, newPlate)
            vehState.Plate = newPlate
            vehState.RegisteredPlate = newPlate

            Vehicles.Owned:ForceSave(vehState.VIN)
            Inventory.Items:RemoveSlot(itemData.Owner, itemData.Name, 1, itemData.Slot, itemData.invType)

            Execute:Client(source, "Notification", "Success", "Personal Plate Setup")
            Logger:Info('Vehicles', string.format("Personal Plate Change For Vehicle: %s. %s -> %s", vehState.VIN, originalPlate, newPlate))
        else
            Execute:Client(source, "Notification", "Error", "Error")
        end
    end)
end

function RegisterPersonalPlateCallbacks()
    Inventory.Items:RegisterUse("personal_plates", "Vehicles", function(source, itemData)
        local char = Fetch:CharacterSource(source)
        if not char or (Player(source).state.onDuty ~= "government" and Player(source).state.onDuty ~= "dgang") then
            Execute:Client(source, "Notification", "Error", "Error")
            return
        end

        PrivatePlateStuff(char, source, itemData)
	end)

    Inventory.Items:RegisterUse("personal_plates_donator", "Vehicles", function(source, itemData)
        local char = Fetch:CharacterSource(source)
        if not char then
            Execute:Client(source, "Notification", "Error", "Error")
            return
        end

        PrivatePlateStuff(char, source, itemData)
	end)

    Chat:RegisterAdminCommand("adddonatorplates", function(source, args, rawCommand)
        local license = table.unpack(args)
    
        if license then
            local success = Vehicles.DonatorPlates:Add(license)
            if success then
                Chat.Send.System:Single(source, "Successfully Added")
            else
                Chat.Send.System:Single(source, "Failed")
            end
        end
      end, {
        help = "[Admin] Add donator plates",
        params = {
            {
                name = "Player Identifier",
                help = "Player License",
            },
        },
    }, 1)

    Chat:RegisterAdminCommand("getdonatorplates", function(source, args, rawCommand)
        local license = table.unpack(args)
    
        if license then
            local success = Vehicles.DonatorPlates:Check(license)
            if success and success.pending then
                Chat.Send.System:Single(source, string.format("Player Identifier: %s<br>Pending Plates: %s<br>Redeemed Plates: %s", license, success.pending, success.redeemed or 0))
            else
                Chat.Send.System:Single(source, "Failed")
            end
        end
      end, {
        help = "[Admin] Check donator plates",
        params = {
            {
                name = "Player Identifier",
                help = "Player License",
            },
        },
    }, 1)

    Chat:RegisterAdminCommand("removedonatorplates", function(source, args, rawCommand)
        local license = table.unpack(args)
    
        if license then
            local success = Vehicles.DonatorPlates:Remove(license, 1)
            if success then
                Chat.Send.System:Single(source, "Successfully Removed")
            else
                Chat.Send.System:Single(source, "Failed")
            end
        end
      end, {
        help = "[Admin] Remove donator plates",
        params = {
            {
                name = "Player Identifier",
                help = "Player License",
            },
        },
    }, 1)

    Callbacks:RegisterServerCallback("Vehicles:CheckDonatorPersonalPlates", function(source, data, cb)
        local plyr = Fetch:Source(source)
        if plyr then
            local res = Vehicles.DonatorPlates:Check(plyr:GetData("Identifier"))

            cb(res?.pending or 0)
        else
            cb(false)
        end
    end)

    Callbacks:RegisterServerCallback("Vehicles:ClaimDonatorPersonalPlates", function(source, data, cb)
        local plyr = Fetch:Source(source)
        if plyr then
            local char = Fetch:CharacterSource(source)
            local res = Vehicles.DonatorPlates:Check(plyr:GetData("Identifier"))

            if char and res?.pending >= data then
                local isRemoved = Vehicles.DonatorPlates:Remove(plyr:GetData("Identifier"), data)

                if isRemoved then
                    Inventory:AddItem(char:GetData("SID"), "personal_plates_donator", data, {}, 1)
                    cb(true)

                    Logger:Warn(
                      "Donator",
                      string.format(
                        "%s [%s] Redeemed %s Donator Plates - Character %s %s (%s)", 
                        plyr:GetData("Name"),
                        plyr:GetData("AccountID"),
                        data,
                        char:GetData('First'),
                        char:GetData('Last'),
                        char:GetData('SID')
                      ),
                      {
                        console = true,
                        file = false,
                        database = true,
                        discord = {
                          embed = true,
                          type = "error",
                          webhook = GetConvar("discord_donation_webhook", ''),
                        }
                      }
                    )
                    return
                end
            end
        else
            cb(false)
        end
    end)
end

-- Citizen.SetTimeout(2500, function()
--     print(IsPersonalPlateValid('FFFF'))
--     print(IsPersonalPlateValid('FFFFF'))
--     print(IsPersonalPlateValid('FFFFFF'))
--     print(IsPersonalPlateValid('FFFFFFF'))
--     print(IsPersonalPlateValid('FFFFFFFF'))
-- end)

_vehDonatorPlates = {
	DonatorPlates = {
		Add = function(self, playerIdentifier)
            local p = promise.new()
            Database.Game:updateOne({
                collection = "donator_plates",
                query = {
                    player = playerIdentifier,
                },
                update = {
                    ["$inc"] = {
                        pending = 1
                    }
                },
                options = {
                    upsert = true,
                }
            }, function(success)
                p:resolve(success)
            end)

            return Citizen.Await(p)
        end,
        Check = function(self, playerIdentifier)
            local p = promise.new()
            Database.Game:findOne({
                collection = "donator_plates",
                query = {
                    player = playerIdentifier,
                },
            }, function(success, results)
                if success then
                    p:resolve(results)
                else
                    p:resolve(false)
                end
            end)

            local res = Citizen.Await(p)

            if res and res[1]?.player then
                return res[1]
            end
            return false
        end,
        Remove = function(self, playerIdentifier, amount)
            local p = promise.new()
            Database.Game:updateOne({
                collection = "donator_plates",
                query = {
                    player = playerIdentifier,
                    pending = {
                        ["$gte"] = amount
                    }
                },
                update = {
                    ["$inc"] = {
                        pending = -amount,
                        redeemed = amount,
                    }
                },
            }, function(success)
                p:resolve(success)
            end)

            return Citizen.Await(p)
        end,
	},
}

AddEventHandler("Proxy:Shared:ExtendReady", function(component)
	if component == "Vehicles" then
		exports["sandbox-base"]:ExtendComponent(component, _vehDonatorPlates)
	end
end)

AddEventHandler("Vehicles:Server:AddDonatorPlates", function(license)
    Vehicles.DonatorPlates:Add(license)
end)

function TebexAddDonatorPlate(source, args)
	local sid = table.unpack(args)
	sid = tonumber(sid)
	if sid == nil or sid == 0 then
        Logger:Warn(
			"Donator Plate",
			"Provided SID (server ID) was empty.",
			{
				console = true,
				file = false,
				database = true,
				discord = {
					embed = true,
					type = "error",
					webhook = GetConvar("discord_donation_webhook", ''),
				}
			}
		)
		return
	end
	local player = Fetch:Source(sid)
	if player then
		local license = player:GetData("Identifier")
		local success = Vehicles.DonatorPlates:Add(license)
		if success then
			Chat.Send.System:Single(sid, "Successfully Added")
		else
			Chat.Send.System:Single(sid, "Failed")
		end
	end  
end
RegisterCommand("tebexadddonatorplate", TebexAddDonatorPlate, true)