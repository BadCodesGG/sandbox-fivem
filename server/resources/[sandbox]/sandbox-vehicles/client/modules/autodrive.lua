local speed = 20.0
local autopilotActive = false
local keysToDisable = {
	322, -- Esc
	177, -- Backspace
	32, -- W
	34, -- A
	8, -- S
	9, -- D
	23, -- F
	21, -- LShift
	22, -- Space
}

AddEventHandler('Vehicles:Client:StartUp', function()
	Keybinds:Add('veh_toggle_autodrive', 'Y', 'keyboard', 'Vehicle - Toggle Autopilot', function()
		if VEHICLE_INSIDE and DoesEntityExist(VEHICLE_INSIDE) and VEHICLE_SEAT == -1 then
			if Vehicles.Engine:CheckKeys() then -- check if have keys
				StartAutoPilot()
			end
		end
	end)

	Interaction:RegisterMenu("veh_autodrive_danger", false, "skull-crossbones", function()
		StopAutoPilot()
		Citizen.Wait(1000)
		StartAutoPilot(true)
	end, function()
		if VEHICLE_INSIDE and autopilotActive then
			return true
		end
		return false
	end)
end)

function StartAutoPilot(crazyMode)
	local vehicle = GetVehiclePedIsIn(LocalPlayer.state.ped, false)
	if not autopilotActive and vehicle then
		autopilotActive = true
		local destination = GetBlipInfoIdCoord(GetFirstBlipInfoId(8))

		local flags = 49599
		if crazyMode then
			flags = 787263
		end

		-- //If no mark is set, wander.
		if destination == vector3(0, 0, 0) then
			TaskVehicleDriveWander(LocalPlayer.state.ped, vehicle, crazyMode and 200.0 or speed, flags)
			Notification:Info(
				string.format("Autodrive Wander On", Keybinds:GetKey("veh_toggle_autodrive")),
				8000,
				"fas fa-car"
			)
		else
			TaskVehicleDriveToCoordLongrange(
				LocalPlayer.state.ped,
				vehicle,
				destination.x,
				destination.y,
				destination.z,
				crazyMode and 200.0 or speed,
				flags,
				20.0
			)
			Notification:Info(
				string.format("Autodrive To Destination On", Keybinds:GetKey("veh_toggle_autodrive")),
				8000,
				"fas fa-car"
			)
		end

		Citizen.CreateThread(function()
			while autopilotActive do
				if not VEHICLE_INSIDE then
					autopilotActive = false
					break
				end

				for k, v in ipairs(keysToDisable) do
					if IsControlPressed(0, v) then
						autopilotActive = false
						break
					end
				end
				Citizen.Wait(0)
			end

			ClearPedTasks(LocalPlayer.state.ped)
			Notification:Info(
				string.format("Autodrive Off", Keybinds:GetKey("veh_toggle_autodrive")),
				8000,
				"fas fa-car"
			)
		end)
	end
end

function StopAutoPilot()
	if autopilotActive then
		autopilotActive = false
	end
end