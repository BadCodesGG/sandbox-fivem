AddEventHandler("Vehicles:Client:BecameDriver", function(vehicle, seat)
	local vehState = Entity(vehicle).state
	if vehState and vehState.testDrive then
		TriggerServerEvent("Vehicles:Server:TestDriveTime", VehToNet(vehicle))
	end
end)
