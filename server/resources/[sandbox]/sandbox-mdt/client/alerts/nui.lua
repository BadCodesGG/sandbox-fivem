RegisterNUICallback("CloseAlerts", function(data, cb)
	cb("OK")
	EmergencyAlerts:Close()
end)

RegisterNUICallback("ReceiveAlert", function(data, cb)
	if data and data.id then
		if data.panic then
			Sounds.Play:Distance(15, "panic.ogg", 0.5)
		else
			Sounds.Play:One("alert_normal.ogg", 0.5)
		end

		if data.blip and type(data.blip) == "table" and data.location ~= nil then
			data.blip.id = string.format("emrg-%s", data.id)
			data.blip.title = string.format("%s", data.title)

			local eB = Blips:Add(data.blip.id, data.blip.title, data.location, data.blip.icon, data.blip.color, data.blip.size, 2, false, data.blip.flashing)
			SetBlipFlashes(eB, isPanic)
			table.insert(_alertBlips, {
				id = data.blip.id,
				time = GetCloudTimeAsInt() + data.blip.duration,
				blip = eB,
			})

			if isArea then
				local eAB = AddBlipForRadius(data.location.x, data.location.y, data.location.z, 100.0)
				SetBlipColour(eAB, data.blip.color)
				SetBlipAlpha(eAB, 90)
				table.insert(_alertBlips, {
					id = data.blip.id,
					time = GetCloudTimeAsInt() + data.blip.duration,
					blip = eAB,
				})
			end
		end
	end
	cb("OK")
end)

RegisterNUICallback("RemoveAlert", function(data, cb)
	if data and data.id then
		local id = string.format("emrg-%s", data.id)
        Blips:Remove(id)

		for k, v in ipairs(_alertBlips) do
			if v.id == id then
				RemoveBlip(v.blip)
			end
		end
	end

	cb("OK")
end)

RegisterNUICallback("AssignedToAlert", function(data, cb)
	UISounds.Play:FrontEnd(-1, "Menu_Accept", "Phone_SoundSet_Default")
	cb("OK")
end)

RegisterNUICallback("RouteAlert", function(data, cb)
	cb("OK")
	if data.location then
		UISounds.Play:FrontEnd(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET")
		EmergencyAlerts:Close()

		if data.blip then
			local f = false
			for k, v in ipairs(_alertBlips) do
				if v.id == string.format("emrg-%s", data.id) then
					v.time = GetCloudTimeAsInt() + data.blip.duration
					f = true
					break
				end
			end

			if not f then
				local eB = Blips:Add(
					string.format("emrg-%s", data.id),
					data.title,
					data.location,
					data.blip.icon,
					data.blip.color,
					data.blip.size,
					2
				)
				table.insert(_alertBlips, {
					id = string.format("emrg-%s", data.id),
					time = GetCloudTimeAsInt() + data.blip.duration,
					blip = eB,
				})
				SetBlipFlashes(eB, data.panic)
			end
		end

		ClearGpsPlayerWaypoint()
		SetNewWaypoint(data.location.x, data.location.y)
		Notification:Info("Alert Location Marked")
	end
end)

RegisterNUICallback("ViewCamera", function(data, cb)
	cb('OK')
	if data.camera then
		UISounds.Play:FrontEnd(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET")
		EmergencyAlerts:Close()
		Callbacks:ServerCallback("CCTV:ViewGroup", data.camera)
	end
end)

RegisterNUICallback("SwapToRadio", function(data, cb)
	cb("OK")
	UISounds.Play:FrontEnd(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET")
	TriggerEvent("Radio:Client:SetChannelFromInput", data.radio)
end)
