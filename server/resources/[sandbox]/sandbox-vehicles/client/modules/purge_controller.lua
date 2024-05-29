local purgeMenu = nil

AddEventHandler("Vehicles:Client:StartUp", function()
	Callbacks:RegisterClientCallback("Vehicles:UsePurgeColorController", function(data, cb)
		local vehEnt = Entity(VEHICLE_INSIDE)
		if
			VEHICLE_INSIDE
			and DoesEntityExist(VEHICLE_INSIDE)
			and IsEntityAVehicle(VEHICLE_INSIDE)
			and GetPedInVehicleSeat(VEHICLE_INSIDE, -1) == LocalPlayer.state.ped
		then
			if not vehEnt.state.Nitrous then
				Notification:Error("Need Nitrous for this controller to work.")
				cb(false)
				return
			end

			if Police:IsPdCar(VEHICLE_INSIDE) or Police:IsEMSCar(VEHICLE_INSIDE) then
				Notification:Error("How About No")
				cb(false)
				return
			end

			local vehModel = GetEntityModel(VEHICLE_INSIDE)

			if
				IsThisModelABike(vehModel)
				or IsThisModelABicycle(vehModel)
				or IsThisModelAPlane(vehModel)
				or IsThisModelAHeli(vehModel)
				or IsThisModelABoat(vehModel)
			then
				cb(false)
				return
			end

			Progress:Progress({
				name = "vehicle_purge_controller",
				duration = 5000,
				label = "Plugging In Controller",
				useWhileDead = false,
				canCancel = true,
				controlDisables = {
					disableMovement = true,
					disableCarMovement = true,
					disableMouse = false,
					disableCombat = false,
				},
				animation = {
					anim = "mechanic2",
				},
			}, function(cancelled)
				if not cancelled and VEHICLE_INSIDE then
					cb(VehToNet(VEHICLE_INSIDE))
				else
					cb(false)
				end
			end)
		else
			cb(false)
		end
	end)

	Callbacks:RegisterClientCallback("Vehicles:UsePurgeColorControllerMenu", function(data, cb)
		local changingData = {}
		purgeMenu = {}
		purgeMenu = Menu:Create("purge_controller_settings", "Purge Controller")

	 	purgeMenu.Add:Text("Purge Color Picker", { "heading" })

		purgeMenu.Add:ColorPicker({
			current = {r = data?.purgeColor?.r or 255, g = data?.purgeColor?.g or 255, b = data?.purgeColor?.b or 255},
		}, function(retval)
			changingData.purgeColor = {
				r = retval.data.color.r,
				g = retval.data.color.g,
				b = retval.data.color.b,
			}
		end)

		purgeMenu.Add:Text("Purge Spray Location", { "heading" })

		purgeMenu.Add:Select('Select A Location', {
			disabled = false,
			current = data?.purgeLocation or "wheel_rf",
			list = {
				{ label = 'Wheels', value = "wheel_rf" },
				{ label = 'Bonnet/Hood', value = "bonnet" },
			}
		}, function(retval)
			changingData.purgeLocation = retval.data.value
		end)

		purgeMenu.Add:Button("Save & Exit", { error = true }, function()
			purgeMenu:Close()
			cb(changingData)
		end)

		purgeMenu:Show()
	end)
end)

AddEventHandler("Vehicles:Client:ExitVehicle", function()
	ForceCloseVehicleCustoms()
end)

function ForceCloseVehicleCustoms()
	if purgeMenu then
		purgeMenu:Close()
	end
end
