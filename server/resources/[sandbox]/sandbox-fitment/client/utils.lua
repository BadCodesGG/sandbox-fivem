function SetVehicleFrontTrackWidth(vehicle, width)
	if width then
		SetVehicleWheelXOffset(vehicle, 0, -width / 2)
		SetVehicleWheelXOffset(vehicle, 1, width / 2)
	end
end

function SetVehicleRearTrackWidth(vehicle, width)
	if width then
		SetVehicleWheelXOffset(vehicle, 2, -width / 2)
		SetVehicleWheelXOffset(vehicle, 3, width / 2)
	end
end

function SetVehicleFrontCamber(vehicle, camber)
	if camber then
		SetVehicleWheelYRotation(vehicle, 0, -camber / 2)
		SetVehicleWheelYRotation(vehicle, 1, camber / 2)
	end
end

function SetVehicleRearCamber(vehicle, camber)
	if camber then
		SetVehicleWheelYRotation(vehicle, 2, -camber / 2)
		SetVehicleWheelYRotation(vehicle, 3, camber / 2)
	end
end
