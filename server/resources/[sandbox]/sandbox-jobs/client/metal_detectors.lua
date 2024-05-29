_metalDetectorPropsLoaded = {}

function RegisterMetalDetectors()
	for k, v in ipairs(_metalDetectorPropsLoaded) do
		DeleteObject(v)
	end

	_metalDetectorPropsLoaded = {}

	for k, v in pairs(_metalDetectorLocations) do
		Polyzone.Create:Box(string.format("%s-metal-detector-zone", k), v.coords, v.width, v.length, {
			heading = v.options.heading,
			--debugPoly=true,
			minZ = v.options.minZ,
			maxZ = v.options.maxZ,
		}, {})

		if v.propInfo then
			RequestModel(v.propInfo.model)
			while not HasModelLoaded(v.propInfo.model) do
				Citizen.Wait(1)
			end
			local obj = CreateObject(
				v.propInfo.model,
				vector3(v.propInfo.coords.x, v.propInfo.coords.y, v.propInfo.coords.z - 1),
				false,
				false,
				false
			)
			local heading = v.propInfo.coords.w
			SetEntityHeading(obj, heading)
			FreezeEntityPosition(obj, true)

			table.insert(_metalDetectorPropsLoaded, obj)
		end
	end
end

RegisterNetEvent("MetalDetector:Client:Sync", function(data)
	local _pedc = GetEntityCoords(LocalPlayer.state.ped, true)
	if #(_pedc - data) <= 5.0 then
		PlaySoundFromCoord(-1, "CHECKPOINT_MISSED", data.x, data.y, data.z, "HUD_MINI_GAME_SOUNDSET", 0, 2.5, 1)
	end
end)

AddEventHandler("Polyzone:Enter", function(id, testedPoint, insideZones, data)
	for k, v in pairs(_metalDetectorLocations) do
		if id == string.format("%s-metal-detector-zone", k) then
			if Inventory.Items:HasType(2, 1) then
				Callbacks:ServerCallback("MetalDetector:Server:Sync", v.coords, function() end)
			end
		end
	end
end)

AddEventHandler("Polyzone:Exit", function(id, testedPoint, insideZones, data)
	for k, v in pairs(_metalDetectorLocations) do
		if id == string.format("%s-metal-detector-zone", k) then
			-- do something
		end
	end
end)

AddEventHandler("onResourceStop", function(resourceName)
	if resourceName == GetCurrentResourceName() then
		for k, v in ipairs(_metalDetectorLocations) do
			DeleteObject(v)
		end
	end
end)
