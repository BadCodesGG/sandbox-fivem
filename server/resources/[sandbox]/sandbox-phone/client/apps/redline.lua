--[[
	This code is probably a steaming pile of shit, I beg someone
	that still has a few functioning brain cells to rewrite this
	so it isn't as much of a steaming pile of shit.

	Send Help.
]]
lapTimes = {}
lap_start = nil

local _tracks = {}

local _creator = false
local _size = 20.0
local _pendingTrack = {}

local _activeRace = {}
local _activeTrack = {}
local _inRace = false

local raceBlips = {}
local raceObjs = {}
local checkpointMarkers = {}

local _races = {}

local MAX_SIZE = 75.0
local MIN_SIZE = 10.0

local tempCheckpointObj = {
	l = false,
	r = false,
}

local NotiySent = false
local ForceStop = false

local myVehs = {}
local ghostedEntity = {}

local cCp = 1
local sCp = -1
local cLp = 1

local function SetGPS(checkpoint)
	ClearGpsMultiRoute()
	StartGpsMultiRoute(6, true, false)

	if cCp then
		AddPointToGpsCustomRoute(
			_activeRace.trackData.Checkpoints[cCp].coords.x * 1.0,
			_activeRace.trackData.Checkpoints[cCp].coords.y * 1.0,
			_activeRace.trackData.Checkpoints[cCp].coords.z * 1.0
		)
		if cCp + 1 > #_activeRace.trackData.Checkpoints then
			if sCp ~= -1 then
				AddPointToGpsCustomRoute(
					_activeRace.trackData.Checkpoints[1].coords.x * 1.0,
					_activeRace.trackData.Checkpoints[1].coords.y * 1.0,
					_activeRace.trackData.Checkpoints[1].coords.z * 1.0
				)
			end
		else
			AddPointToGpsCustomRoute(
				_activeRace.trackData.Checkpoints[cCp + 1].coords.x * 1.0,
				_activeRace.trackData.Checkpoints[cCp + 1].coords.y * 1.0,
				_activeRace.trackData.Checkpoints[cCp + 1].coords.z * 1.0
			)
		end
	else
		AddPointToGpsCustomRoute(
			_activeRace.trackData.Checkpoints[1].coords.x * 1.0,
			_activeRace.trackData.Checkpoints[1].coords.y * 1.0,
			_activeRace.trackData.Checkpoints[1].coords.z * 1.0
		)
		AddPointToGpsCustomRoute(
			_activeRace.trackData.Checkpoints[2].coords.x * 1.0,
			_activeRace.trackData.Checkpoints[2].coords.y * 1.0,
			_activeRace.trackData.Checkpoints[2].coords.z * 1.0
		)
	end
	SetGpsMultiRouteRender(true)
end

local function showNonLoopParticle(dict, particleName, coords, scale, time)
	while not HasNamedPtfxAssetLoaded(dict) do
		RequestNamedPtfxAsset(dict)
		Wait(0)
	end

	UseParticleFxAssetNextCall(dict)

	local particleHandle = StartParticleFxLoopedAtCoord(
		particleName,
		coords.x,
		coords.y,
		coords.z + 1.0,
		0.0,
		0.0,
		0.0,
		scale,
		false,
		false,
		false
	)
	SetParticleFxLoopedColour(particleHandle, 0.0, 0.0, 1.0)
	return particleHandle
end


local leftFlare = nil
local rightFlare = nil

local leftFlareOld = nil
local rightFlareOld = nil

local function handleFlare(checkpoint)
	if leftFlareOld then
		StopParticleFxLooped(leftFlareOld, false)
	end
	if rightFlareOld then
		StopParticleFxLooped(rightFlareOld, false)
	end

	leftFlareOld = leftFlare
	rightFlareOld = rightFlare

	if checkpoint then
		local Size = 1.0
		leftFlare = showNonLoopParticle("core", "exp_grd_flare", checkpoint.left, Size)
		rightFlare = showNonLoopParticle("core", "exp_grd_flare", checkpoint.right, Size)
	end
end

local ghosting = false
local ghostingEnded = false
local function UnGhostPlayer()
	ghosting = false
    SetLocalPlayerAsGhost(false)
end

local function GhostPlayer()
	if ghosting then
		return
	end

	if not _activeRace then
		ghosting = false
		ghostingEnded = false
		return
	end

	ghosting = true
    --SetGhostedEntityAlpha(254)
    SetLocalPlayerAsGhost(true)

	Citizen.CreateThread(function()
		while ghosting do
			local myPos = GetEntityCoords(PlayerPedId())
			for k, v in ipairs(GetActivePlayers()) do
				if Player(GetPlayerServerId(v)).state.onDuty == "police" then
					local ped = GetPlayerPed(v)
					if DoesEntityExist(ped) then
						local veh = GetVehiclePedIsIn(ped)
						if DoesEntityExist(veh) then
							if #(myPos - GetEntityCoords(veh)) <= 100.0 then
								Notification:Info("Police Nearby, Race Phasing Disabled")
								ghostingEnded = true
								UnGhostPlayer()
							end
						end
					end
				end
			end
			Citizen.Wait(10)
		end
	end)
end

RegisterNetEvent("Phone:Client:Redline:StoreTracks", function(tracks)
	_tracks = tracks

	if not Phone then return end

	Phone.Data:Set("tracks", _tracks)
end)

RegisterNetEvent("Phone:Client:Redline:StoreSingleTrack", function(tId, track)
	_tracks = _tracks or {}

	local updated = false
	for k, v in ipairs(_tracks) do
		if v.id == tId then
			if track then
				_tracks[k] = track
			else
				table.remove(_tracks, k)
			end
			updated = true
			break
		end
	end

	if not updated and track then
		table.insert(_tracks, track)
	end
	
	if not Phone then return end

	Phone.Data:Set("tracks", _tracks)
end)

RegisterNetEvent("Phone:Client:Redline:Spawn", function(data)
	_races = data.races
	SendNUIMessage({
		type = "EVENT_SPAWN",
		data = data,
	})
end)

RegisterNetEvent("Characters:Client:Logout", function()
	-- TODO: Cleanup if logged out while joined in race
	if _activeRace ~= nil then
		Cleanup()
		_activeRace = nil
	end
end)

RegisterNetEvent("Phone:Client:Redline:CreateRace", function(race)
	_races[race.id] = race
	SendNUIMessage({
		type = "ADD_PENDING_RACE",
		data = {
			race = race,
		},
	})
end)

RegisterNetEvent("Phone:Client:Redline:CancelRace", function(id)
	if _races[id] then
		_races[id].state = -1
	
		SendNUIMessage({
			type = "CANCEL_RACE",
			data = {
				race = id,
				myRace = id == _activeRace?.id,
			},
		})
		if id == _activeRace?.id then
			Cleanup()
		end
	end
end)

RegisterNetEvent("Phone:Client:Redline:FinishRace", function(id, race)
	_races[id] = race

	if _activeRace?.id == id then
		local myAlias = LocalPlayer.state.Character:GetData("Profiles")?.redline?.name
		if myAlias == racer then
			Cleanup()
			ghostingEnded = true
			UnGhostPlayer()

			SendNUIMessage({
				type = "I_RACE",
				data = {
					state = false,
				},
			})
			_activeRace = nil
		end
	end

	SendNUIMessage({
		type = "FINISH_RACE",
		data = {
			id = id,
			race = race,
		},
	})
end)

RegisterNetEvent("Phone:Client:Redline:StartRace", function(id)
	if _races[id] then
		_races[id].state = 1
		SendNUIMessage({
			type = "STATE_UPDATE",
			data = {
				race = id,
				state = 1,
			},
		})
	
		if _activeRace ~= nil and id == _activeRace.id then
			Cleanup()
			StartRace()
		end
	end
end)

RegisterNetEvent("Phone:Client:Redline:JoinRace", function(id, racer, data)
	if _races[id] then
		_races[id].racers[racer] = data
	
		SendNUIMessage({
			type = "JOIN_RACE",
			data = {
				race = id,
				racer = racer,
				racerData = data,
			},
		})
	end
end)

RegisterNetEvent("Phone:Client:Redline:LeaveRace", function(id, racer)
	if _races[id] then
		_races[id].racers[racer] = nil
	
		if _activeRace?.id == id then
			local myAlias = LocalPlayer.state.Character:GetData("Profiles")?.redline?.name
			if myAlias == racer then
				Cleanup()
				ghostingEnded = true
				UnGhostPlayer()
	
				SendNUIMessage({
					type = "I_RACE",
					data = {
						state = false,
					},
				})
				_activeRace = nil
			end
		end
	
		SendNUIMessage({
			type = "LEAVE_RACE",
			data = {
				race = id,
				racer = racer,
			},
		})
	end
end)

RegisterNetEvent("Phone:Redline:NotifyDNFStart", function(id, time)
	SendNUIMessage({
		type = "DNF_START",
		data = {
			time = time,
		},
	})
end)

RegisterNetEvent("Phone:Redline:NotifyDNF", function(id)
	local key = tostring(id)

	if _activeRace?.id == key then
		_activeRace.dnf = true
		Cleanup()
		ghostingEnded = true
		UnGhostPlayer()

		UISounds.Play:FrontEnd(-1, "CHECKPOINT_MISSED", "HUD_MINI_GAME_SOUNDSET")
		SendNUIMessage({
			type = "RACE_DNF",
		})

		SendNUIMessage({
			type = "I_RACE",
			data = {
				state = false,
			},
		})
		_activeRace = nil
	end
end)

RegisterNUICallback("CreateRace", function(data, cb)
	Callbacks:ServerCallback("Phone:Redline:CreateRace", data, function(res)
		if res == nil or res.failed then
			_activeRace = nil
			cb(res or false)
		else
			_activeRace = res

			for k, v in ipairs(_tracks) do
				if v.id == data.track then
					_activeRace.trackData = v
					break
				end
			end

			AddRaceBlip(_activeRace.trackData.Checkpoints[1])
			SetNewWaypoint(
				_activeRace.trackData.Checkpoints[1].coords.x + 0.0,
				_activeRace.trackData.Checkpoints[1].coords.y + 0.0
			)
			cb(res)
		end
	end)
end)

RegisterNUICallback("CancelRace", function(data, cb)
	Callbacks:ServerCallback("Phone:Redline:CancelRace", data, function(res)
		cb(res)
	end)
end)

RegisterNUICallback("PracticeTrack", function(data, cb)
	Callbacks:ServerCallback("Phone:Redline:GetTrack", data, function(res)
		cb(res ~= nil)
		if res ~= nil then
			SetupTrack(res)
			_activeRace = res
		end
	end)
end)

RegisterNUICallback("JoinRace", function(data, cb)
	Callbacks:ServerCallback("Phone:Redline:JoinRace", data, function(res)
		if res then
			_activeRace = res

			for k, v in ipairs(_tracks) do
				if v.id == res.track then
					_activeRace.trackData = v
					break
				end
			end

			AddRaceBlip(_activeRace.trackData.Checkpoints[1])

			SetNewWaypoint(
				_activeRace.trackData.Checkpoints[1].coords.x + 0.0,
				_activeRace.trackData.Checkpoints[1].coords.y + 0.0
			)
		end
		cb(res)
	end)
end)

RegisterNUICallback("LeaveRace", function(data, cb)
	UnGhostPlayer()
	Callbacks:ServerCallback("Phone:Redline:LeaveRace", data, function(res)
		if _activeRace ~= nil then
			_activeRace.dnf = true
			Cleanup()
			UISounds.Play:FrontEnd(-1, "CHECKPOINT_MISSED", "HUD_MINI_GAME_SOUNDSET")
			SendNUIMessage({
				type = "RACE_DNF",
			})
		end
		cb(res)
	end)
end)

RegisterNetEvent("Redline:Client:JoinedEvent", function(res)
	if res then
		_activeRace = res

		for k, v in ipairs(_tracks) do
			if v.id == res.track then
				_activeRace.trackData = v
				break
			end
		end

		AddRaceBlip(_activeRace.trackData.Checkpoints[1])

		SetNewWaypoint(
			_activeRace.trackData.Checkpoints[1].coords.x + 0.0,
			_activeRace.trackData.Checkpoints[1].coords.y + 0.0
		)
	end
end)

RegisterNetEvent("Redline:Client:RemovedFromRace", function()
	if _activeRace ~= nil then
		_activeRace.dnf = true
		Cleanup()
		UISounds.Play:FrontEnd(-1, "CHECKPOINT_MISSED", "HUD_MINI_GAME_SOUNDSET")
		SendNUIMessage({
			type = "RACE_DNF",
		})
	end
end)

RegisterNUICallback("CreateTrack", function(data, cb)
	Callbacks:ServerCallback("Phone:Permissions", {
		redline = { "create" },
	}, function(res)
		cb(res)
		if res then
			_creator = true
			CreatorThread()
		end
	end)
end)

RegisterNUICallback("FinishCreator", function(data, cb)
	_creator = false
	Callbacks:ServerCallback("Phone:Permissions", {
		redline = { "create" },
	}, function(res)
		if res then
			if #_pendingTrack.Checkpoints > 2 then
				_pendingTrack.Name = data.name
				_pendingTrack.Type = data.type
				_pendingTrack.Distance = 0
				for i = 1, #_pendingTrack.Checkpoints do
					if i == #_pendingTrack.Checkpoints and data.type ~= "p2p" then
						_pendingTrack.Distance = _pendingTrack.Distance
							+ #(
								vector3(
									_pendingTrack.Checkpoints[i].coords.x,
									_pendingTrack.Checkpoints[i].coords.y,
									_pendingTrack.Checkpoints[i].coords.z
								)
								- vector3(
									_pendingTrack.Checkpoints[1].coords.x,
									_pendingTrack.Checkpoints[1].coords.y,
									_pendingTrack.Checkpoints[1].coords.z
								)
							)
					elseif i < #_pendingTrack.Checkpoints then
						_pendingTrack.Distance = _pendingTrack.Distance
							+ #(
								vector3(
									_pendingTrack.Checkpoints[i].coords.x,
									_pendingTrack.Checkpoints[i].coords.y,
									_pendingTrack.Checkpoints[i].coords.z
								)
								- vector3(
									_pendingTrack.Checkpoints[i + 1].coords.x,
									_pendingTrack.Checkpoints[i + 1].coords.y,
									_pendingTrack.Checkpoints[i + 1].coords.z
								)
							)
					end
				end
				_pendingTrack.Distance = quickMaths((_pendingTrack.Distance / 1609.34)) .. " Miles"
				Callbacks:ServerCallback("Phone:Redline:SaveTrack", _pendingTrack, function(res2)
					cb(res2)
				end)
			else
				Notification:Error("Not Enough Checkpoints")
				cb(false)
			end
		else
			cb(false)
		end
	end)
end)

RegisterNUICallback("DeleteTrack", function(data, cb)
	Callbacks:ServerCallback("Phone:Permissions", {
		redline = { "create" },
	}, function(res)
		if res then
			Callbacks:ServerCallback("Phone:Redline:DeleteTrack", data, function(res2)
				cb(res2)
			end)
		else
			cb(false)
		end
	end)
end)

RegisterNUICallback("ResetTrackHistory", function(data, cb)
	Callbacks:ServerCallback("Phone:Permissions", {
		redline = { "create" },
	}, function(res)
		if res then
			Callbacks:ServerCallback("Phone:Redline:ResetTrackHistory", data, function(res2)
				cb(res2)
			end)
		else
			cb(false)
		end
	end)
end)

RegisterNUICallback("StopCreator", function(data, cb)
	cb("OK")
	_creator = false
end)

RegisterNUICallback("StartRace", function(data, cb)
	Callbacks:ServerCallback("Phone:Redline:StartRace", _activeRace.id, cb)
end)

RegisterNUICallback("EndRace", function(data, cb)
	Callbacks:ServerCallback("Phone:Redline:EndRace", data, cb)
end)

RegisterNUICallback("SendInvite", function(data, cb)
	Callbacks:ServerCallback("Phone:Redline:SendInvite", data, cb)
end)

RegisterNUICallback("AcceptInvite", function(data, cb)
	Callbacks:ServerCallback("Phone:Redline:AcceptInvite", data, function(res)
		if res then
			_activeRace = res

			for k, v in ipairs(_tracks) do
				if v.id == res.track then
					_activeRace.trackData = v
					break
				end
			end

			AddRaceBlip(_activeRace.trackData.Checkpoints[1])
			SetNewWaypoint(
				_activeRace.trackData.Checkpoints[1].coords.x + 0.0,
				_activeRace.trackData.Checkpoints[1].coords.y + 0.0
			)
		end
		cb(res ~= nil)
	end)
end)

RegisterNUICallback("DeclineInvite", function(data, cb)
	Callbacks:ServerCallback("Phone:Redline:DeclineInvite", data, cb)
end)

RegisterNetEvent("Phone:Client:Redline:ReceiveInvite", function(data)
	Phone.Notification:Add(
		"Received Event Invite",
		string.format("%s Invited You To %s", data.sender, data.event),
		GetCloudTimeAsInt(),
		6000,
		"redline",
		{
			view = "invites",
		},
		nil
	)

	SendNUIMessage({
		type = "NEW_INVITE",
		data = {
			invite = data,
		},
	})
end)

RegisterNUICallback("RemoveFromRace", function(data, cb)
	Callbacks:ServerCallback("Phone:Redline:RemoveRacer", data, cb)
end)

function FinishRace()
	if IsInRacePD() then
		LapDetailsPD()
	else
		if not _activeRace.dnf then
			local veh = GetVehiclePedIsIn(PlayerPedId())

			local vehModel = GetEntityModel(veh)
			local vehName = GetLabelText(GetDisplayNameFromVehicleModel(vehModel))
			if vehName == "NULL" then
				vehName = GetDisplayNameFromVehicleModel(vehModel)
			end

			local vehEnt = Entity(veh)
			if vehEnt and vehEnt.state and vehEnt.state.Make and vehEnt.state.Model then
				vehName = vehEnt.state.Make .. " " .. vehEnt.state.Model
			end

			TriggerServerEvent(
				"Phone:Redline:FinishRace",
				NetworkGetNetworkIdFromEntity(veh),
				_activeRace.id,
				lapTimes,
				GetVehicleNumberPlateText(veh),
				vehName
			)
		else
			SendNUIMessage({
				type = "I_RACE",
				data = {
					state = false,
				},
			})
			_inRace = false
		end
		UnGhostPlayer()
		_activeRace = nil
		lap_start = nil
		lapTimes = {}

		cCp = 1
		sCp = -1
		cLp = 1
	end
end

RegisterNUICallback("LapDetails", function(data, cb)
	cb("OK")
	if IsInRacePD() then
		LapDetailsPD(data)
	else
	end
end)

function SetupTrack(skipBlip)
	Cleanup()
	for k, v in ipairs(_activeRace.trackData.Checkpoints) do
		if not skipBlip then
			AddRaceBlip(v)
		end
	end
end

-- This is a fucking mess that somehow functions? Someone that is sane pls rewrite
function StartRace()
	cCp = 1
	sCp = -1
	cLp = 1
	local cCps = {}

	_inRace = true
	SetupTrack()
	SetGPS()

	handleFlare(_activeRace.trackData.Checkpoints[2])
	handleFlare(_activeRace.trackData.Checkpoints[3])

	local countdownMax = tonumber(_activeRace.countdown) or 20
	local countdown = 0
	while countdown < countdownMax and _activeRace ~= nil and _loggedIn do
		Notification:Info(string.format("Race Starting In %s", countdownMax - countdown))
		UISounds.Play:FrontEnd(-1, "5_SEC_WARNING", "HUD_MINI_GAME_SOUNDSET")
		countdown = countdown + 1
		Citizen.Wait(1000)
	end

	if not _activeRace or not _loggedIn then
		return
	end

	Citizen.CreateThread(function()
		Notification:Info("Race Started")
		UISounds.Play:FrontEnd(-1, "GO", "HUD_MINI_GAME_SOUNDSET")
		SendNUIMessage({
			type = "RACE_START",
			data = {
				totalCheckpoints = #_activeRace.trackData.Checkpoints,
				totalLaps = _activeRace.laps,
				track = _activeRace.trackData,
			},
		})

		if _activeRace ~= nil and _loggedIn and _activeRace.phasing == "timed" then
			GhostPlayer()
			SetTimeout(_activeRace.phasingAdv * 1000, function()
				ghostingEnded = true
				UnGhostPlayer()
			end)
		end

		lap_start = GetGameTimer()
		while _activeRace ~= nil and _loggedIn do
			local myPed = PlayerPedId()
			local myveh = GetVehiclePedIsIn(myPed)
			local myPos = GetEntityCoords(myPed)
			local cp = _activeRace.trackData.Checkpoints[cCp]
			if cp == nil then
				cp = _activeRace.trackData.Checkpoints[1]
			end

			local dist = #(vector3(cp.coords.x, cp.coords.y, cp.coords.z) - myPos)

			if (ghosting and (not myveh or _activeRace.phasing == "none")) or (cp ~= nil and next(cp) ~= nil and dist > 400.0 and ghosting and _activeRace.phasing) then
				UnGhostPlayer()
			elseif _activeRace.phasing ~= "none" and not ghostingEnded and not ghosting and _activeRace ~= nil and dist <= 400.0 and myveh > 0 then
				GhostPlayer()
			end

			if dist <= cp.size or sCp == -1 then
				local blip = raceBlips[cCp]
				if cCp == 1 and #cCps == #_activeRace.trackData.Checkpoints and _activeRace.trackData.Type ~= "p2p" then -- this is lapped race?
					cLp = cLp + 1
					cCps = {}
					if cLp <= tonumber(_activeRace.laps) then
						Notification:Info(string.format("Lap %s", cLp))
						UISounds.Play:FrontEnd(-1, "CHECKPOINT_PERFECT", "HUD_MINI_GAME_SOUNDSET")

						if lap_start ~= nil then
							local lapEnd = GetGameTimer()
							local lapTime = lapEnd - lap_start
							table.insert(lapTimes, {
								lap_start = lap_start,
								lap_end = lapEnd,
								laptime = lapTime,
							})
						end
						lap_start = GetGameTimer()

						SendNUIMessage({
							type = "RACE_LAP",
						})
					end
				end

				if sCp ~= -1 then -- i think this is sprint?
					SetBlipColour(blip, 0)
					table.insert(cCps, cCp)
					UISounds.Play:FrontEnd(-1, "CHECKPOINT_NORMAL", "HUD_MINI_GAME_SOUNDSET")

					if _activeRace.phasing == "checkpoints" and cCp >= (_activeRace.phasingAdv + 1) then
						ghostingEnded = true
						UnGhostPlayer()
					end

					if cCp < #_activeRace.trackData.Checkpoints then
						cCp = cCp + 1
						SendNUIMessage({
							type = "RACE_CP",
							data = {
								cp = #cCps,
							},
						})
					elseif _activeRace.trackData.Type ~= "p2p" then
						cCp = 1
						SendNUIMessage({
							type = "RACE_CP",
							data = {
								cp = #_activeRace.trackData.Checkpoints,
							},
						})
					end
				end

				if
					_activeRace.trackData.Type == "p2p" and #cCps == #_activeRace.trackData.Checkpoints
					or cLp > tonumber(_activeRace.laps)
				then
					Notification:Info("Race Finished")
					Cleanup()
					UISounds.Play:FrontEnd(-1, "FIRST_PLACE", "HUD_MINI_GAME_SOUNDSET")
					SendNUIMessage({
						type = "RACE_END",
					})
					SendNUIMessage({
						type = "I_RACE",
						data = {
							state = false,
						},
					})

					if lap_start ~= nil then
						local lapEnd = GetGameTimer()
						local lapTime = lapEnd - lap_start
						table.insert(lapTimes, {
							lap_start = lap_start,
							lap_end = lapEnd,
							laptime = lapTime,
						})
					end

					FinishRace()

					_inRace = false
					return
				end

				cp = _activeRace.trackData.Checkpoints[cCp]
				if cCp > #_activeRace.trackData.Checkpoints then
					blip = raceBlips[1]
				else
					blip = raceBlips[cCp]
				end
				SetBlipColour(blip, 6)

				-- Like what the fuck is this code?
				local ftr = nil
				if cCp > #_activeRace.trackData.Checkpoints then
					ftr = _activeRace.trackData.Checkpoints[1]
				else
					ftr = _activeRace.trackData.Checkpoints[cCp]
				end

				if
					cLp > tonumber(_activeRace.laps)
					or (_activeRace.trackData.Type == "p2p" and cCp == #_activeRace.trackData.Checkpoints)
				then
					ftr = cp
				end

				if cCp + 1 > #_activeRace.trackData.Checkpoints then
					handleFlare(_activeRace.trackData.Checkpoints[1])
				else
					handleFlare(_activeRace.trackData.Checkpoints[cCp + 1])
				end

				local v = GetVehiclePedIsIn(LocalPlayer.state.ped)
				if v ~= 0 and GetPedInVehicleSeat(v) then
					SetGPS(ftr)
				end
				sCp = cCp
			end

			Citizen.Wait(1)
		end
	end)
end

function Cleanup()
	UnGhostPlayer()
	DeleteWaypoint()
	ClearGpsMultiRoute()
	for k, v in ipairs(raceBlips) do
		RemoveBlip(v)
	end
	raceBlips = {}
	for k, v in pairs(raceObjs) do
		for k2, v2 in ipairs(v) do
			DeleteObject(v2)
		end
	end

	for k, v in pairs(tempCheckpointObj) do
		if v then
			DeleteObject(v)
		end
	end

	
	if leftFlare then
		StopParticleFxLooped(leftFlare, false)
	end
	if leftFlareOld then
		StopParticleFxLooped(leftFlareOld, false)
	end
	if rightFlare then
		StopParticleFxLooped(rightFlare, false)
	end
	if rightFlareOld then
		StopParticleFxLooped(rightFlareOld, false)
	end

	ghostingEnded = false
end

function quickMaths(num)
	return tonumber(string.format("%.2f", num))
end

function AddRaceBlip(data)
	local newBlip = AddBlipForCoord(data.coords.x + 0.0, data.coords.y + 0.0, data.coords.z + 0.0)
	SetBlipAsFriendly(newBlip, true)
	local sprite = 1
	if data.isStart then
		sprite = 38
	end
	SetBlipScale(newBlip, 0.75)
	SetBlipSprite(newBlip, sprite)

	if not data.isStart then
		ShowNumberOnBlip(newBlip, #raceBlips)
	end

	BeginTextCommandSetBlipName("STRING")
	local str = string.format("Checkpoint %s", #raceBlips)
	if data.isStart then
		str = "Start Line"
	end
	SetBlipAsShortRange(newBlip, true)
	AddTextComponentString(str)
	EndTextCommandSetBlipName(newBlip)

	table.insert(raceBlips, newBlip)

	local objData = {}

	if data.isStart then
		local l =
			CreateObject(GetHashKey("prop_beachflag_le"), data.left.x, data.left.y, data.left.z, false, true, false)
		local r =
			CreateObject(GetHashKey("prop_beachflag_le"), data.right.x, data.right.y, data.right.z, false, true, false)
		PlaceObjectOnGroundProperly(l)
		PlaceObjectOnGroundProperly(r)

		SetEntityCollision(l, false, true)
		SetEntityCollision(r, false, true)

		table.insert(objData, l)
		table.insert(objData, r)
	else
		local l =
			CreateObject(GetHashKey("prop_offroad_tyres02"), data.left.x, data.left.y, data.left.z, false, true, false)
		local r = CreateObject(
			GetHashKey("prop_offroad_tyres02"),
			data.right.x,
			data.right.y,
			data.right.z,
			false,
			true,
			false
		)
		PlaceObjectOnGroundProperly(l)
		PlaceObjectOnGroundProperly(r)

		SetEntityCollision(l, false, true)
		SetEntityCollision(r, false, true)

		table.insert(objData, l)
		table.insert(objData, r)
	end

	table.insert(raceObjs, objData)
end

function rotateVector(vector, degrees)
	local rads = math.rad(degrees)
	local x = math.cos(rads) * vector.x - math.sin(rads) * vector.y
	local y = math.sin(rads) * vector.x + math.cos(rads) * vector.y
	return { x = x, y = y, z = vector.z }
end

function enlargeVector(vectorOrigin, vectorAngle, distance)
	local distanceVector = vector3(
		(vectorAngle.x - vectorOrigin.x) * distance,
		(vectorAngle.y - vectorOrigin.y) * distance,
		(vectorAngle.z - vectorOrigin.z) * distance
	)
	return {
		x = quickMaths(vectorOrigin.x + distanceVector.x),
		y = quickMaths(vectorOrigin.y + distanceVector.y),
		z = quickMaths(vectorOrigin.z),
	}
end

function CreateCheckpoint()
	local pPed = PlayerPedId()
	local fX, fY, fZ = table.unpack(GetEntityForwardVector(pPed))
	facingVector = {
		x = fX,
		y = fY,
		z = fZ,
	}
	local pX, pY, pZ = table.unpack(GetEntityCoords(pPed))

	local lcp = _pendingTrack.Checkpoints[#_pendingTrack.Checkpoints]
	local dist = -1

	if lcp ~= nil then
		dist = #(vector3(pX, pY, pZ) - vector3(lcp.coords.x, lcp.coords.y, lcp.coords.z))
	end

	if lcp == nil or dist > 5 then
		local fuckme = rotateVector(facingVector, 90)
		local left = enlargeVector(
			{ x = pX, y = pY, z = pZ },
			{ x = pX + fuckme.x, y = pY + fuckme.y, z = pZ + fuckme.z },
			_size / 2
		)
		local fuckme2 = rotateVector(facingVector, -90)
		local right = enlargeVector(
			{ x = pX, y = pY, z = pZ },
			{ x = pX + fuckme2.x, y = pY + fuckme2.y, z = pZ + fuckme2.z },
			_size / 2
		)
		-- _pendingTrack.Checkpoints[(#_pendingTrack.Checkpoints + 1)] = {
		-- 	coords = {
		-- 		x = quickMaths(pX),
		-- 		y = quickMaths(pY),
		-- 		z = quickMaths(pZ),
		-- 	},
		-- 	facingVector = facingVector,
		-- 	left = left,
		-- 	leftrv = rotateVector(facingVector, 90),
		-- 	right = right,
		-- 	rightrv = rotateVector(facingVector, -90),
		-- 	isStart = #_pendingTrack.Checkpoints == 0,
		-- 	size = _size / 2,
		-- }

		table.insert(_pendingTrack.Checkpoints, {
			coords = {
				x = quickMaths(pX),
				y = quickMaths(pY),
				z = quickMaths(pZ),
			},
			facingVector = facingVector,
			left = left,
			leftrv = rotateVector(facingVector, 90),
			right = right,
			rightrv = rotateVector(facingVector, -90),
			isStart = #_pendingTrack.Checkpoints == 0,
			size = _size / 2,
		})

		AddRaceBlip(_pendingTrack.Checkpoints[#_pendingTrack.Checkpoints])
	else
		Notification:Error("Point Too Close To Last Point")
	end
end

function RemoveCheckpoint()
	if #_pendingTrack.Checkpoints > 0 then
		local cp = _pendingTrack.Checkpoints[#_pendingTrack.Checkpoints]

		RemoveBlip(raceBlips[#_pendingTrack.Checkpoints])
		table.remove(raceBlips, #_pendingTrack.Checkpoints)

		for k, v in ipairs(raceObjs[#_pendingTrack.Checkpoints]) do
			DeleteObject(v)
			table.remove(raceObjs, #_pendingTrack.Checkpoints)
		end

		table.remove(_pendingTrack.Checkpoints, #_pendingTrack.Checkpoints)
	end
end

function DisplayTempCheckpoint()
	local pPed = PlayerPedId()
	local fX, fY, fZ = table.unpack(GetEntityForwardVector(pPed))
	facingVector = {
		x = fX,
		y = fY,
		z = fZ,
	}
	local pX, pY, pZ = table.unpack(GetEntityCoords(pPed))

	local fuckme = rotateVector(facingVector, 90)
	local left = enlargeVector(
		{ x = pX, y = pY, z = pZ },
		{ x = pX + fuckme.x, y = pY + fuckme.y, z = pZ + fuckme.z },
		_size / 2
	)
	local fuckme2 = rotateVector(facingVector, -90)
	local right = enlargeVector(
		{ x = pX, y = pY, z = pZ },
		{ x = pX + fuckme2.x, y = pY + fuckme2.y, z = pZ + fuckme2.z },
		_size / 2
	)

	if not tempCheckpointObj.l then
		tempCheckpointObj.l =
			CreateObject(GetHashKey("prop_offroad_tyres02"), left.x, left.y, left.z, false, true, false)

		tempCheckpointObj.r =
			CreateObject(GetHashKey("prop_offroad_tyres02"), right.x, right.y, right.z, false, true, false)
	end

	SetEntityCoords(tempCheckpointObj.l, left.x, left.y, left.z)
	SetEntityCoords(tempCheckpointObj.r, right.x, right.y, right.z)
	for k, v in pairs(tempCheckpointObj) do
		PlaceObjectOnGroundProperly(v)
		SetEntityCollision(v, false, true)
		FreezeEntityPosition(v, true)
	end
end

function CreatorThread()
	_size = 20.0
	_pendingTrack = {
		Checkpoints = {},
		History = {},
	}

	tempCheckpointObj = {
		l = false,
		r = false,
	}

	Citizen.CreateThread(function()
		while _creator do
			DisplayTempCheckpoint()

			if IsControlPressed(0, 10) then
				_size = _size + 0.5
				if _size > MAX_SIZE then
					_size = MAX_SIZE
				end
			end

			if IsControlPressed(0, 11) then
				_size = _size - 0.5
				if _size < MIN_SIZE then
					_size = MIN_SIZE
				end
			end

			if IsControlJustReleased(0, 38) then
				if IsControlPressed(0, 21) then
					RemoveCheckpoint()
				else
					CreateCheckpoint()
				end
				Wait(1000)
			end

			Citizen.Wait(1)
		end
		Cleanup()
		SendNUIMessage({
			type = "RACE_STATE_CHANGE",
			data = {
				state = null,
			},
		})
	end)
end