_trackerBlips = {}

_trackedJobs = {
	police = true,
	ems = true,
	prison = true,
}

_emergencyMembersData = {}
_emergencyMembersLocations = {}

RegisterNetEvent("Job:Client:DutyChanged", function(state)
	if state and _trackedJobs[state] then
		Citizen.CreateThread(function()
			local mySID = LocalPlayer.state.Character:GetData("SID")
			Logger:Trace("Tracking", "Start Emergency Tracking")
			while
				LocalPlayer.state.loggedIn
				and LocalPlayer.state.onDuty
				and _trackedJobs[LocalPlayer.state.onDuty]
				and not LocalPlayer.state.trackerDisabled
			do
				Citizen.Wait(1000)
				for k, v in pairs(_emergencyMembersData) do
					if v.SID ~= mySID and v.Job and _trackedJobs[v.Job] and _emergencyMembersLocations[k] then
						local tCoords = _emergencyMembersLocations[k]
						local canTrackAsEntity = IsPlayerCloseEnoughToTrack(k, v)
						local currentData = _trackerBlips[k]

						if not currentData then
							local newBlipId
							if canTrackAsEntity then
								newBlipId = AddBlipForEntity(canTrackAsEntity)
								ShowHeadingIndicatorOnBlip(newBlipId, true)
							else
								newBlipId = AddBlipForCoord(tCoords.x, tCoords.y, tCoords.z)
							end
							ApplyStylingToBlip(newBlipId, v)

							_trackerBlips[k] = {
								blipId = newBlipId,
								entityTracking = canTrackAsEntity,
							}
						elseif currentData and (currentData.entityTracking ~= canTrackAsEntity) then
							RemoveBlip(currentData.blipId)

							local newBlipId
							if canTrackAsEntity then
								newBlipId = AddBlipForEntity(canTrackAsEntity)
								ShowHeadingIndicatorOnBlip(newBlipId, true)
							else
								newBlipId = AddBlipForCoord(tCoords.x, tCoords.y, tCoords.z)
							end

							ApplyStylingToBlip(newBlipId, v)
							_trackerBlips[k] = {
								blipId = newBlipId,
								entityTracking = canTrackAsEntity,
							}
						elseif currentData then
							if not currentData.entityTracking then
								SetBlipCoords(currentData.blipId, tCoords.x, tCoords.y, tCoords.z)
							end
							--ApplyStylingToBlip(currentData.blipId, v)
						end
					end
				end

				for k, v in pairs(_trackerBlips) do
					if not _emergencyMembersData[k] then
						RemoveBlip(v.blipId)
						_trackerBlips[k] = nil
					end
				end
			end

			Logger:Trace("Tracking", "Clear Emergency Tracking")

			for k, v in pairs(_trackerBlips) do
				RemoveBlip(v.blipId)
				_trackerBlips[k] = nil
			end
		end)
	end
end)

RegisterNetEvent("EmergencyAlerts:Client:UpdateMembers", function(data)
	_emergencyMembersData = data

	for k, v in pairs(_trackerBlips) do
		if not _emergencyMembersData[k] then
			RemoveBlip(v.blipId)
			_trackerBlips[k] = nil
		end
	end
end)

RegisterNetEvent("EmergencyAlerts:Client:UpdateMember", function(member)
	if member and member.Source then
		_emergencyMembersData[member.Source] = member

		if _trackerBlips[member.Source] then
			ApplyStylingToBlip(_trackerBlips[member.Source].blipId, member)
		end
	end
end)

RegisterNetEvent("EmergencyAlerts:Client:UpdateTrackers", function(data)
	_emergencyMembersLocations = data
end)

function ApplyStylingToBlip(blip, data)
	SetBlipCategory(blip, 7)

	if data.Job == "police" then
		if data.Workplace == "sast" then
			SetBlipColour(blip, 55)
		elseif data.Workplace == "bcso" then
			SetBlipColour(blip, 31)
		elseif data.Workplace == "guardius" then
			SetBlipColour(blip, 46)
		else
			SetBlipColour(blip, 3)
		end
	elseif data.Job == "prison" then
		if data.Workplace == "corrections" then
			SetBlipColour(blip, 11)
		end
	elseif data.Job == "ems" then
		if data.Workplace == "doctors" then
			SetBlipColour(blip, 62)
		else
			SetBlipColour(blip, 8)
		end
	end

	SetBlipScale(blip, 0.7)
	SetBlipFlashes(blip, false)
	BeginTextCommandSetBlipName("STRING")

	local nameString = string.format("%s. %s", data.First:sub(1, 1), data.Last)
	if data.Callsign then
		nameString = string.format("(%s) %s", data.Callsign, nameString)
	end

	-- if data.dead then
	--     nameString = '[Down] '.. nameString
	-- elseif data.disabledTracker then
	--     nameString = '[Disconnected] '.. nameString
	-- end

	if data.TrackerDisabled then
		nameString = "[Disconnected] " .. nameString

		SetBlipFlashes(blip, true)
	end

	AddTextComponentString(nameString)
	EndTextCommandSetBlipName(blip)
end

function IsPlayerCloseEnoughToTrack(src, data)
	if data.TrackerDisabled then
		return false
	end

	local player = GetPlayerFromServerId(src)
	if player and player ~= -1 then
		local playerPed = GetPlayerPed(player)
		if DoesEntityExist(playerPed) then
			return playerPed
		end
	end
	return false
end

AddEventHandler("MDT:Client:DisableTracker", function(entity, data)
	local playerState = Player(entity.serverId).state
	if
		(playerState.onDuty == "police" or playerState.onDuty == "prison" or playerState.onDuty == "ems")
		and not playerState.trackerDisabled
	then
		Progress:ProgressWithTickEvent({
			name = "disable_police_tracker",
			duration = 10000,
			label = "Disabling Tracker",
			useWhileDead = false,
			canCancel = true,
			ignoreModifier = true,
			controlDisables = {
				disableMovement = true,
				disableCarMovement = true,
				disableMouse = false,
				disableCombat = true,
			},
			animation = {
				animDict = "amb@prop_human_atm@male@idle_a",
				anim = "idle_b",
				flags = 49,
			},
		}, function()
			if
				#(
					GetEntityCoords(LocalPlayer.state.ped)
					- GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(entity.serverId)))
				) <= 3.0
			then
				return
			end
			Progress:Cancel()
		end, function(cancelled)
			if not cancelled then
				if
					(playerState.onDuty == "police" or playerState.onDuty == "prison" or playerState.onDuty == "ems")
					and not playerState.trackerDisabled
				then
					Callbacks:ServerCallback("EmergencyAlerts:DisablePDTracker", entity.serverId, function(success)
						if success then
							Notification:Success("Disabled Their Tracker")
						end
					end)
				end
			end
		end)
	else
		Notification:Error("Unable to Disable Tracker")
	end
end)
