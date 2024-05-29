local _races = {}
local _tracks = nil
local _trackData = {}

local function LoadTracks()
	_tracks = MySQL.rawExecute.await(
		"SELECT id, name as Name, distance as Distance, type as Type, checkpoints as Checkpoints, created_by as Creator FROM blueline_tracks"
	)
	for k, v in ipairs(_tracks) do
		v.Checkpoints = json.decode(v.Checkpoints)
		v.Fastest = MySQL.rawExecute.await(
			"SELECT l.id, l.track, l.race, l.callsign as alias, l.lap_start, l.lap_end, l.laptime, l.car, l.owned FROM blueline_track_history l WHERE track = ? ORDER BY l.laptime ASC LIMIT 10",
			{
				v.id,
			}
		) or {}
	end
end

AddEventHandler("Characters:Server:PlayerLoggedOut", function(source, cData)
	LeaveAnyRacePD(source)
end)

AddEventHandler("Characters:Server:PlayerDropped", function(source, cData)
	LeaveAnyRacePD(source)
end)

AddEventHandler("Phone:Server:RegisterMiddleware", function()
	LoadTracks()

	Middleware:Add("Characters:Spawning", function(source)
		local char = Fetch:CharacterSource(source)
		TriggerLatentClientEvent("Phone:Client:Blueline:StoreTracks", source, 50000, _tracks)
		TriggerClientEvent("Phone:Client:Blueline:Spawn", source, {
			races = _races,
		})
	end, 2)
	Middleware:Add("Phone:UIReset", function(source)
		TriggerLatentClientEvent("Phone:Client:Blueline:StoreTracks", source, 50000, _tracks)
		TriggerClientEvent("Phone:Client:Blueline:Spawn", source, {
			races = _races,
		})
	end, 2)
end)

function ReloadRaceTracksPD()
	LoadTracks()
	TriggerLatentClientEvent("Phone:Client:Blueline:StoreTracks", -1, 50000, _tracks)
end

function LeaveAnyRacePD(source)
	local char = Fetch:CharacterSource(source)
	if char ~= nil and char:GetData("Callsign") then
		local alias = tostring(char:GetData("Callsign"))
		for k, v in pairs(_races) do
			if v.state == 0 then
				if v.host_id == char:GetData("SID") then
					v.state = -1
					MySQL.query("UPDATE blueline_race_history SET state = ? WHERE id = ?", {
						-1,
						tonumber(k),
					})
					TriggerClientEvent("Phone:Client:Blueline:CancelRace", -1, k)
				else
					if v.racers[alias] ~= nil then
						v.racers[alias] = nil
						TriggerClientEvent("Phone:Client:Blueline:LeaveRace", -1, k, alias)
					end
				end
			end
		end
	end
end

function FinishRacePD(id)
	local cancelled = _races[id].state == 0

	_races[id].time = os.time()
	_races[id].state = 2

	if _races[id].completed ~= nil and #_races[id].completed > 0 then
		local laps = {}
		local updateFastest = false
		local racedTrack = nil
		for k, v in ipairs(_tracks) do
			if v.id == _races[id].track then
				racedTrack = k
				break
			end
		end

		local queries = {}

		for placing, alias in ipairs(_races[id].completed) do
			local fastest = nil

			for k, v in ipairs(_races[id].racers[alias].laps) do
				table.insert(laps, {
					sid = _races[id].racers[alias].sid,
					alias = alias,
					lap_start = v.lap_start,
					lap_end = v.lap_end,
					laptime = (v.lap_end - v.lap_start),
					car = _races[id].racers[alias].car or "UNKNOWN",
					owned = _races[id].racers[alias].isOwned or false,
				})

				if fastest == nil or (v.lap_end - v.lap_start) < (fastest.lap_end - fastest.lap_start) then
					fastest = v
					fastest.alias = alias
				end
			end

			if fastest ~= nil then
				if _tracks[racedTrack].Fastest == nil or #_tracks[racedTrack].Fastest == 0 then
					_tracks[racedTrack].Fastest = {
						{
							time = fastest.time,
							lap_start = fastest.lap_start,
							lap_end = fastest.lap_end,
							format = fastest.format,
							alias = fastest.alias,
							car = _races[id].racers[alias].car or "UNKNOWN",
							owned = _races[id].racers[alias].isOwned or false,
						},
					}
					updateFastest = true
				else
					for i = 1, 10 do
						if
							_tracks[racedTrack].Fastest[i] == nil
							or fastest.lap_end - fastest.lap_start
								< _tracks[racedTrack].Fastest[i].lap_end - _tracks[racedTrack].Fastest[i].lap_start
						then
							table.insert(_tracks[racedTrack].Fastest, i, {
								time = fastest.time,
								lap_start = fastest.lap_start,
								lap_end = fastest.lap_end,
								alias = fastest.alias,
								car = _races[id].racers[alias].car or "UNKNOWN",
								owned = _races[id].racers[alias].isOwned or false,
							})
							_tracks[racedTrack].Fastest = table.slice(_tracks[racedTrack].Fastest, 1, 10)
							updateFastest = true
							break
						end
					end
				end
			end

			_races[id].racers[alias] = {
				place = placing,
				finished = os.time(),
				fastest = fastest,
				laps = _races[id].racers[alias].laps,
				sid = _races[id].racers[alias].sid,
				isOwned = _races[id].racers[alias].isOwned or false,
			}
		end

		if updateFastest then
			TriggerClientEvent("Phone:Client:Blueline:StoreSingleTrack", -1, racedTrack, _tracks[racedTrack])
		end

		table.insert(queries, {
			query = "UPDATE blueline_race_history SET racers = ?, state = ? WHERE id = ?",
			values = {
				json.encode(_races[id].racers),
				2,
				tonumber(id),
			},
		})

		if #laps > 0 then
			local qry =
				"INSERT INTO blueline_track_history (track, race, callsign, lap_start, lap_end, laptime, car, owned) VALUES "
			local params = {}
			for k, v in ipairs(laps) do
				table.insert(params, _races[id].track)
				table.insert(params, id)
				table.insert(params, v.alias)
				table.insert(params, v.lap_start)
				table.insert(params, v.lap_end)
				table.insert(params, v.laptime)
				table.insert(params, v.car or "UNKNOWN")
				table.insert(params, v.owned or false)
				qry = qry .. "(?, ?, ?, ?, ?, ?, ?, ?)"
				if k < #laps then
					qry = qry .. ","
				end
			end

			table.insert(queries, {
				query = qry,
				values = params,
			})
		end

		MySQL.transaction.await(queries)
	end

	for k, v in pairs(_races[id].racers) do
		if v.source ~= nil then
			TriggerClientEvent("Phone:Blueline:NotifyDNF", v.source, id)
		end
	end

	TriggerClientEvent("Phone:Client:Blueline:FinishRace", -1, id, _races[id])
end

-- TODO: Add check for player-owned vehicle
RegisterServerEvent("Phone:Blueline:FinishRace", function(nId, data, laps, plate, vehName)
	local src = source
	local char = Fetch:CharacterSource(src)
	local alias = tostring(char:GetData("Callsign"))

	local vehEnt = Entity(NetworkGetEntityFromNetworkId(nId)).state
	_races[data].racers[alias] = {
		laps = laps,
		sid = char:GetData("SID"),
		isOwned = vehEnt.Owned,
		car = vehName,
	}

	if _races[data].completed == nil then
		_races[data].completed = {}
	end
	table.insert(_races[data].completed, alias)

	if #_races[data].completed == _races[data].total then
		FinishRacePD(data)
	elseif
		#_races[data].completed >= tonumber(_races[data].dnf_start)
		and not _races[data].dnf_started
	then
		_races[data].dnf_started = true
		for k, v in pairs(_races[data].racers) do
			if v.source ~= nil then
				TriggerClientEvent(
					"Phone:Blueline:NotifyDNFStart",
					v.source,
					data,
					tonumber(_races[data].dnf_time)
				)
			end
		end
		Citizen.CreateThread(function()
			Citizen.Wait(tonumber(_races[data].dnf_time) * 1000)
			FinishRacePD(data)
		end)
	end
end)

AddEventHandler("Phone:Server:RegisterCallbacks", function()
	Callbacks:RegisterServerCallback("Phone:Blueline:GetTrack", function(src, data, cb)
		for k, v in ipairs(_tracks) do
			if v.id == data then
				cb(v)
				return
			end
		end
		cb(nil)
	end)

	Callbacks:RegisterServerCallback("Phone:Blueline:SaveTrack", function(src, data, cb)
		local char = Fetch:CharacterSource(src)
		local alias = tostring(char:GetData("Callsign"))

		if alias ~= nil then
			local doc = {
				data.Name,
				data.Distance,
				data.Type,
				json.encode(data.Checkpoints),
				alias,
			}

			doc.id = MySQL.insert.await(
				"INSERT INTO blueline_tracks (name, distance, type, checkpoints, created_by) VALUES(?, ?, ?, ?, ?)",
				doc
			)

			table.insert(_tracks, data)
			TriggerClientEvent("Phone:Client:Blueline:StoreSingleTrack", -1, doc.id, {
				id = doc.id,
				Name = data.Name,
				Distance = data.Distance,
				Type = data.Type,
				Checkpoints = data.Checkpoints,
				created_by = alias,
			})
			cb(true)
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("Phone:Blueline:DeleteTrack", function(src, data, cb)
		local char = Fetch:CharacterSource(src)
		local alias = tostring(char:GetData("Callsign"))
		if alias ~= nil then
			local qrys = {}
			table.insert(qrys, {
				query = "DELETE FROM blueline_track_history WHERE track = ?",
				values = {
					data,
				},
			})
			table.insert(qrys, {
				query = "DELETE FROM blueline_race_history WHERE track = ?",
				values = {
					data,
				},
			})
			table.insert(qrys, {
				query = "DELETE FROM blueline_tracks WHERE id = ?",
				values = {
					data,
				},
			})

			_tracks[data] = nil
			TriggerClientEvent("Phone:Client:Blueline:StoreSingleTrack", -1, data, nil)
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("Phone:Blueline:ResetTrackHistory", function(src, data, cb)
		local char = Fetch:CharacterSource(src)
		local alias = tostring(char:GetData("Callsign"))
		if alias ~= nil then
			MySQL.query("DELETE FROM blueline_track_history WHERE track = ?", {
				data,
			})
			_tracks[data].Fastest = nil
			TriggerClientEvent("Phone:Client:Blueline:StoreSingleTrack", -1, data, _tracks[data])
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("Phone:Blueline:CreateRace", function(src, data, cb)
		local char = Fetch:CharacterSource(src)
		if Jobs.Permissions:HasJob(src, "police", false, false, false, false, "PD_MANAGE_TRIALS") then
			data.host_id = char:GetData("SID")
			data.host_src = src
			data.time = os.time()
			data.racers = {
				[char:GetData("Callsign")] = {
					source = src,
					sid = char:GetData("SID"),
				},
			}
			data.state = 0

			local tmp = nil
			for k, v in ipairs(_tracks) do
				if v.id == data.track then
					tmp = v
				end
			end

			if tmp ~= nil then
				local t = MySQL.insert.await(
					"INSERT INTO blueline_race_history (name, host, track, class) VALUES(?, ?, ?, ?)",
					{
						data.name,
						char:GetData("Callsign"),
						data.track,
						data.class,
					}
				)

				data.id = tostring(t)

				_races[data.id] = table.copy(data)
				_trackData[data.id] = table.copy(tmp)
				for k, v in pairs(Fetch:AllCharacters()) do
					if v ~= nil then
						TriggerClientEvent("Phone:Client:Blueline:CreateRace", v:GetData("Source"), data)
						local dutyData = Jobs.Duty:Get(v:GetData("Source"))
						if v:GetData("Source") ~= src and dutyData?.Id == "police" then
							Phone.Notification:Add(
								v:GetData("Source"),
								string.format("New Event: %s", data.name),
								string.format("%s created an event", v:GetData("Callsign")),
								os.time(),
								10000,
								"blueline",
								{
									view = string.format("view/%s", t),
								}
							)
						end
					end
				end
				cb(data)
			else
				cb({ failed = true, message = "Invalid Track" })
			end
		else
			cb({ failed = true, message = "Insufficient Permissions" })
		end
	end)

	Callbacks:RegisterServerCallback("Phone:Blueline:CancelRace", function(src, data, cb)
		local char = Fetch:CharacterSource(src)

		if _races[data].host_id == char:GetData("SID") then
			_races[data].state = -1
			MySQL.query("UPDATE blueline_race_history SET state = ? WHERE id = ?", {
				-1,
				tonumber(data),
			})
			TriggerClientEvent("Phone:Client:Blueline:CancelRace", -1, data)
			cb(true)
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("Phone:Blueline:StartRace", function(src, data, cb)
		local char = Fetch:CharacterSource(src)
		if _races[data].host_id == char:GetData("SID") then
			local ploc = GetEntityCoords(GetPlayerPed(src))
			local dist = #(
				vector3(
					_trackData[data].Checkpoints[1].coords.x,
					_trackData[data].Checkpoints[1].coords.y,
					_trackData[data].Checkpoints[1].coords.z
				) - ploc
			)

			if dist > 25 then
				cb({ failed = true, message = "Too Far From Starting Point" })
			else
				_races[data].state = 1
				_races[data].total = 0
				for k, v in pairs(_races[data].racers) do
					_races[data].total = _races[data].total + 1
				end

				cb(true)
				TriggerClientEvent("Phone:Client:Blueline:StartRace", -1, data)
			end
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("Phone:Blueline:EndRace", function(src, data, cb)
		local char = Fetch:CharacterSource(src)

		if _races[data].host_id == char:GetData("SID") then
			FinishRacePD(data)
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("Phone:Blueline:JoinRace", function(src, data, cb)
		local char = Fetch:CharacterSource(src)
		local alias = tostring(char:GetData("Callsign"))

		for k, v in ipairs(_races) do
			if v.state == 0 then
				_races[k].racers[alias] = nil
				TriggerClientEvent("Phone:Client:Blueline:LeaveRace", -1, k, alias)
			end
		end

		print(data)
		if Jobs.Permissions:HasJob(src, "police") and alias ~= nil and _races[data].state == 0 then
			if
				_races[data].class ~= "All"
				and CheckVehicleAgainstClass(_races[data].class, char:GetData("Source")) == false
			then
				Phone.Notification:Add(
					char:GetData("Source"),
					"Unable to Join Race",
					"This vehicle is not in the right class.",
					os.time(),
					10000,
					"blueline",
					{}
				)
				cb(false)
			else
				_races[data].racers[alias] = {
					source = src,
					sid = char:GetData("SID"),
				}
				TriggerClientEvent("Phone:Client:Blueline:JoinRace", -1, data, alias)
				cb(_races[data])
			end
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("Phone:Blueline:LeaveRace", function(src, data, cb)
		local char = Fetch:CharacterSource(src)
		local alias = tostring(char:GetData("Callsign"))

		if alias ~= nil and _races[data].state == 0 then
			_races[data].racers[alias] = nil
			TriggerClientEvent("Phone:Client:Blueline:LeaveRace", -1, data, alias)
			cb(true)
		else
			cb(false)
		end
	end)
end)

function CheckVehicleAgainstClass(class, _src)
	local vehEnt = Entity(GetVehiclePedIsIn(GetPlayerPed(_src), false))
	if vehEnt.state.VIN and vehEnt.state.Owned and class == vehEnt.state.Class then
		return true
	end
	return false
end
