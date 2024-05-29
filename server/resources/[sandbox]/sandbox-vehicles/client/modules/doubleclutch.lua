local _isEnabled = true
local _threshold = 50
local _minGears = 3

Citizen.CreateThread(function()
	while true do
		if VEHICLE_SEAT == -1 and _isEnabled then
			if
				GetVehicleCurrentGear(VEHICLE_INSIDE) < 3
				and GetVehicleCurrentRpm(VEHICLE_INSIDE) == 1.0
				and math.ceil(GetEntitySpeed(VEHICLE_INSIDE) * 2.236936) > _threshold
			then
				local maxGears = GetVehicleHandlingInt(VEHICLE_INSIDE, "CHandlingData", "nInitialDriveGears")

				while GetVehicleCurrentRpm(VEHICLE_INSIDE) > 0.6 and maxGears > _minGears do
					SetVehicleCurrentRpm(VEHICLE_INSIDE, 0.3)
					Citizen.Wait(1)
				end

				Citizen.Wait(800)
			end
		end
		Citizen.Wait(1000)
	end
end)

function toggleDoubleClutchBlock(toggle)
	_isEnabled = toggle
end
exports("toggleDoubleClutchBlock", toggleDoubleClutchBlock)
