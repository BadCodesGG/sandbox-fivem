WhitelistedWep = {
	[`weapon_sniperrifle`] = true,
	[`weapon_sniperrifle2`] = true,
	[`weapon_heavysniper`] = true,
	[`weapon_heavysniper_mk2`] = true,
	[`weapon_marksmanrifle`] = true,
	[`weapon_marksmanrifle_mk2`] = true,
	[`weapon_precisionrifle`] = true,
	[`weapon_taser`] = true,
}

Citizen.CreateThread(function()
	Citizen.Wait(30000)
	while true do
		if LocalPlayer.state.loggedIn and not LocalPlayer.state.inCCTVCam and not LocalPlayer.state.inHeliCam then
			local ped = PlayerPedId()
			local weapon = GetSelectedPedWeapon(ped)
			
			if (IsPedArmed(ped, 1) or IsPedArmed(ped, 2) or IsPedArmed(ped, 4)) and not WhitelistedWep[weapon] then
				local CamFov = GetGameplayCamFov()
				local CamFovCar = GetFinalRenderedCamFov()
				local CamPos = GetFollowPedCamViewMode()
				local CamPosVeh = GetFollowVehicleCamViewMode()
				local inVeh = IsPedInAnyVehicle(ped, false)

				if not inVeh and (CamPos == 0 or CamPos == 1 or CamPos == 2) and CamFov > 60.2 then
					Callbacks:ServerCallback("Pwnzor:FOV", { fov = CamFov })
				elseif not inVeh and CamPos == 4 and CamFov > 58.0 then
					Callbacks:ServerCallback("Pwnzor:FOV", { fov = CamFov })
				elseif CamFov < 31.7 then
					Callbacks:ServerCallback("Pwnzor:FOV", { fov = CamFov })
				elseif inVeh then
					if CamPosVeh == 4 and CamFovCar > 60.6 then
						Callbacks:ServerCallback("Pwnzor:FOV", { fov = CamFovCar })
					elseif CamPosVeh == 0 or CamPosVeh == 1 or CamPosVeh == 2 then
						local veh = GetVehiclePedIsUsing(ped)
						if
							GetVehicleClass(veh) == 8
							or GetVehicleClass(veh) == 9
							or GetVehicleClass(veh) == 10
							or GetVehicleClass(veh) == 11
							or GetVehicleClass(veh) == 15
							or GetVehicleClass(veh) == 16
							or GetVehicleClass(veh) == 18
						then
							if CamFovCar > 62.6 then
								Callbacks:ServerCallback("Pwnzor:FOV", { fov = CamFovCar })
							end
						else
							if CamFovCar > 60.2 then
								Callbacks:ServerCallback("Pwnzor:FOV", { fov = CamFovCar })
							end
						end
					end
				end
			end
		end
		Citizen.Wait(15000)
	end
end)
