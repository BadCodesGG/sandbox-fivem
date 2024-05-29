RegisterNetEvent("EmergencyAlerts:Client:Connect", function(url, token)
	SendNUIMessage({
		type = "ALERTS_WS_CONNECT",
		data = {
			url = url,
			token = token,
		},
	})
end)

RegisterNetEvent("EmergencyAlerts:Client:Disconnect", function()
	SendNUIMessage({
		type = "ALERTS_WS_DISCONNECT",
		data = {},
	})
end)

AddEventHandler("EmergencyAlerts:Client:PursuitModeChange", function(mode)
	SendNUIMessage({
		type = "ALERTS_UPDATE_PURSUIT_MODE",
		data = {
			mode = mode,
		},
	})
end)

AddEventHandler("EmergencyAlerts:Client:RadioChannelChange", function(channel)
	SendNUIMessage({
		type = "ALERTS_UPDATE_RADIO_CHANNEL",
		data = {
			channel = channel,
		},
	})
end)