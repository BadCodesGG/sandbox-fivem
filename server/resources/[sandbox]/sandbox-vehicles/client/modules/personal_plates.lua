AddEventHandler("Vehicles:Client:StartUp", function()
    Callbacks:RegisterClientCallback("Vehicles:GetPersonalPlate", function(data, cb)
        local target = Targeting:GetEntityPlayerIsLookingAt()
        if target and target.entity and DoesEntityExist(target.entity) and IsEntityAVehicle(target.entity) then
            if Vehicles:HasAccess(target.entity) and (Vehicles.Utils:IsCloseToRearOfVehicle(target.entity) or Vehicles.Utils:IsCloseToFrontOfVehicle(target.entity)) then
                local settingPlate = GetNewPersonalPlate()

                if settingPlate then
                    cb(VehToNet(target.entity), settingPlate)
                else
                    cb(false)
                end
            else
                cb(false)
            end
        else
            cb(false)
        end
    end)

    PedInteraction:Add("donor_plates", `u_f_m_debbie_01`, vector3(-504.405, -182.683, 36.691), 290.319, 25.0, {
        {
          icon = "rectangle-wide",
          text = "Donator License Plate Claim",
          event = "Vehicles:Client:DonatorLicensePlateClaim",
        },
    }, "comment-dollar")
end)

local platePromise
function GetNewPersonalPlate()
    platePromise = promise.new()
    Input:Show("New Personal Plate", "Personal Plate", {
		{
			id = "plate",
			type = "text",
			options = {
				inputProps = {
                    pattern = "[A-HJ-NPR-Z0-9 ]+",
                    maxlength = 8,
                },
                helperText = "Plates cannot include the letters O, Q, I and must include at least 3 characters. SPACES FOR PADDING ARE ADDED AUTOMATICALLY!"
			},
		},
	}, "Vehicles:Client:RecievePersonalPlateInput", {})

    return Citizen.Await(platePromise)
end

AddEventHandler("Vehicles:Client:RecievePersonalPlateInput", function(values)
    if platePromise then
        platePromise:resolve(values?.plate)
        platePromise = nil
    end
end)

AddEventHandler("Input:Closed", function()
    if platePromise then
        platePromise:resolve(false)
        platePromise = nil
    end
end)

AddEventHandler("Vehicles:Client:DonatorLicensePlateClaim", function()
    Callbacks:ServerCallback("Vehicles:CheckDonatorPersonalPlates", {}, function(data)
        if data and data > 0 then

            local menu = {
                main = {
                    label = "Claim Donator License Plates",
                    items = {
                        {
                            label = "Information",
                            description = "Please make sure that there is enough space in your inventory for your new license plates.<br>"
                        },
                    }
                }
            }

            if data == 1 then
                table.insert(menu.main.items, {
                    label = "Claim 1 Plate",
                    event = "Vehicles:Client:DonatorLicensePlateClaimConfirm",
                    data = 1,
                })
            else
                table.insert(menu.main.items, {
                    label = "Claim 1 Plate",
                    event = "Vehicles:Client:DonatorLicensePlateClaimConfirm",
                    data = 1,
                })

                table.insert(menu.main.items, {
                    label = string.format("Claim %s Plates", data),
                    event = "Vehicles:Client:DonatorLicensePlateClaimConfirm",
                    data = data,
                })
            end


            ListMenu:Show(menu)
        else
            Notification:Error("No Plates to Claim")
        end
    end)
end)

AddEventHandler("Vehicles:Client:DonatorLicensePlateClaimConfirm", function(data)
    Callbacks:ServerCallback("Vehicles:ClaimDonatorPersonalPlates", data, function(success)
        if not success then
            Notification:Error("Error")
        end
    end)
end)