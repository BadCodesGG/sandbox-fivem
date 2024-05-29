RegisterNUICallback("Services:GetServices", function(data, cb)
	Callbacks:ServerCallback("Phone:Services:GetServices", data, function(servicesData)
		cb(servicesData)
	end)
end)

RegisterNUICallback("Services:SetGPS", function(data, cb)
	if data.location then
		DeleteWaypoint()
		SetNewWaypoint(data.location.x, data.location.y)
		Notification:Success("GPS route set")
		cb("OK")
	else
		cb(false)
		Notification:Error("Error setting waypoint.")
	end
end)
