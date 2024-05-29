-- CRYPTO SETTINGS
local _awardedCoin = "VRM"
local _awardedAmount = 5
local _cryptoPayout = 16

local _reqForCrypto = 5

local _races = {}
local _raceInvites = {}
local _trackData = {}
local _tracks = nil

local _raceItems = {
	{ item = "racing_crappy", coin = "MALD", price = 10, qty = 100, vpn = false },
	{ item = "racedongle", coin = "VRM", rep = "Racing", repLvl = 3, price = 20, qty = 5, vpn = false },
	{ item = "purgecontroller", coin = "VRM", rep = "Racing", repLvl = 3, price = 50, qty = 5, vpn = false },
	{ item = "harness", coin = "VRM", rep = "Racing", repLvl = 1, price = 20, qty = 5, vpn = false },

	{ item = "alias_changer", coin = "VRM", rep = "Racing", repLvl = 5, price = 2000, qty = 2, vpn = true },

	{
		item = "lsundg_invite",
		coin = "VRM",
		price = 100,
		qty = -1,
		vpn = true,
		state = "ACCESS_LSUNDG_INVITE",
		limited = {
			id = 1,
			qty = 5,
		},
	},

	-- --	{ item = "racedongle", coin = "MALD", rep = "Racing", repLvl = 3, price = 30, qty = 25, vpn = true },
	--{ item = "choplist", coin = "VRM", rep = "Chopping", repLvl = 3, price = 25, qty = 100, vpn = true },
	--{ item = "choplist", coin = "MALD", rep = "Chopping", repLvl = 3, price = 50, qty = 100, vpn = true },
	-- 	{ item = "fakeplates", coin = "VRM", rep = "Racing", repLvl = 1, price = 20, qty = 5, vpn = true },
	-- 	{ item = "fakeplates", coin = "MALD", price = 48, qty = 2, vpn = true },

	{ item = "nitrous", coin = "VRM", price = 10, qty = 10, vpn = true },
	-- 	{ item = "nitrous", coin = "MALD", price = 50, qty = 10, vpn = true },
}

function table.slice(tbl, first, last, step)
	local sliced = {}

	for i = first or 1, last or #tbl, step or 1 do
		sliced[#sliced + 1] = tbl[i]
	end

	return sliced
end

function IsRedlineRace(id)
	return _races[id] ~= nil
end

local function LoadTracks()
	_tracks = MySQL.rawExecute.await(
		"SELECT id, name as Name, distance as Distance, type as Type, checkpoints as Checkpoints, created_by as Creator FROM redline_tracks"
	)
	for k, v in ipairs(_tracks) do
		v.Checkpoints = json.decode(v.Checkpoints)
		v.Fastest = MySQL.rawExecute.await(
			"SELECT l.id, l.track, l.race, c.name as alias, l.lap_start, l.lap_end, l.laptime, l.car, l.owned FROM redline_track_history l LEFT JOIN character_app_profiles c ON c.sid = l.sid AND c.app = ? WHERE track = ? ORDER BY l.laptime ASC LIMIT 10",
			{
				'redline',
				v.id,
			}
		)
	end
end

AddEventHandler("Characters:Server:PlayerLoggedOut", function(source, cData)
	LeaveAnyRace(source)
	if cData.Profiles?.redline?.name ~= nil then
		for k, v in pairs(_raceInvites) do
			if v[cData.Profiles.redline.name] then
				v[cData.Profiles.redline.name] = nil
			end
		end
	end
end)

AddEventHandler("Characters:Server:PlayerDropped", function(source, cData)
	LeaveAnyRace(source)
	if cData.Profiles?.redline?.name ~= nil then
		for k, v in pairs(_raceInvites) do
			if v[cData.Profiles.redline.name] then
				v[cData.Profiles.redline.name] = nil
			end
		end
	end
end)

AddEventHandler("Phone:Server:RegisterMiddleware", function()
	Inventory.Items:RegisterUse("alias_changer", "LSUNDG", function(source, item, itemData)
		local char = Fetch:CharacterSource(source)
		local _AppName = "redline"
		if char ~= nil then
			local profiles = char:GetData("Profiles") or {}

			if profiles[_AppName] ~= nil then
				local queries = {}
				table.insert(queries, {
					query = "INSERT INTO app_profile_history (sid, app, name, picture, meta) VALUES(?, ?, ?, ?, ?)",
					values = {
						char:GetData("SID"),
						_AppName,
						profiles[_AppName].name,
						profiles[_AppName].picture,
						json.encode(profiles[_AppName].meta or {}),
					},
				})
				table.insert(queries, {
					query = "DELETE FROM character_app_profiles WHERE sid = ? AND app = ?",
					values = {
						char:GetData("SID"),
						_AppName,
					},
				})
				MySQL.transaction(queries)

				Inventory.Items:RemoveSlot(item.Owner, item.Name, 1, item.Slot, 1)

				profiles[_AppName] = nil
				char:SetData("Profiles", profiles)
				Execute:Client(source, "Notification", "Success", string.format(
					"Alias Cleared For %s %s (%s) For %s",
					char:GetData("First"),
					char:GetData("Last"),
					char:GetData("SID"),
					_AppName
				))
			else
			end
		else
			Execute:Client(source, "Notification", "Error", "An error has occured clearing your alias. Please contact IT.")
		end
	end)
	Inventory.Items:RegisterUse("event_invite", "LSUNDG", function(source, item, itemData)
		local char = Fetch:CharacterSource(source)
		if char ~= nil then
			if item.MetaData.Event and _races[item.MetaData.Event] then
				local sid = char:GetData("SID")
				local alias = char:GetData("Profiles")?.redline?.name
				if alias then
					for k, v in ipairs(_races) do
						if v.state == 0 then
							if _races[k].racers[alias] ~= nil then
								_races[k].racers[alias] = nil
								TriggerClientEvent("Phone:Client:Redline:LeaveRace", -1, k, alias)
							end
						end
					end
	
					if
						_races[item.MetaData.Event].class ~= "All"
						and not CheckVehicleAgainstClass(_races[item.MetaData.Event].class, source)
					then
						Phone.Notification:Add(
							source,
							"Unable to Join Race",
							"This vehicle is not in the right class.",
							os.time(),
							10000,
							"redline",
							{}
						)
						return
					else
						_races[item.MetaData.Event].racers[alias] = {
							source = source,
							sid = sid,
						}
						TriggerClientEvent("Redline:Client:JoinedEvent", source, _races[item.MetaData.Event])
						TriggerClientEvent("Phone:Client:Redline:JoinRace", -1, item.MetaData.Event, alias, _races[item.MetaData.Event].racers[alias])

						
						Phone.Notification:Add(
							source,
							"Joined Event",
							string.format("You Have Joined %s", _races[item.MetaData.Event].name),
							os.time(),
							10000,
							"redline",
							{}
						)

						_raceInvites[item.MetaData.Event][string.lower(alias)] = nil

						Inventory.Items:RemoveSlot(item.Owner, item.Name, 1, item.Slot, item.invType)
					end
				end
			else
				Execute:Client(source, "Notification", "Error", "Invalid Event ID")
			end
		end
	end)

	Vendor:Create("RaceGear", "poly", "Race Gear", false, {
		coords = vector3(707.286, -967.542, 30.468),
		length = 0.8,
		width = 0.6,
		options = {
			heading = 185,
			--debugPoly=true,
			minZ = 28.97,
			maxZ = 32.97,
		},
	}, _raceItems, "flag-checkered", "View Items", false, false, true, 60 * math.random(30, 60), 60 * math.random(240, 360))

	LoadTracks()

	Middleware:Add("Characters:Spawning", function(source)
		local char = Fetch:CharacterSource(source)
		local alias = char:GetData("Alias") or {}
		local profiles = char:GetData("Profiles") or {}

		if alias.redline then
			local rid = MySQL.insert.await("INSERT INTO character_app_profiles (app, sid, name) VALUES(?, ?, ?)", {
				"redline",
				char:GetData("SID"),
				alias.redline,
			})

			profiles.redline = {
				sid = char:GetData("SID"),
				app = "redline",
				name = alias.redline,
				picture = nil,
				meta = {},
			}

			alias.redline = nil
			char:SetData("Alias", alias)
			char:SetData("Profiles", profiles)
		end
	end, 2)

	Middleware:Add("Characters:Spawning", function(source)
		local char = Fetch:CharacterSource(source)
		TriggerLatentClientEvent("Phone:Client:Redline:StoreTracks", source, 50000, _tracks)
		TriggerClientEvent("Phone:Client:Redline:Spawn", source, {
			races = _races,
		})
	end, 2)
	Middleware:Add("Phone:UIReset", function(source)
		TriggerLatentClientEvent("Phone:Client:Redline:StoreTracks", source, 50000, _tracks)
		TriggerClientEvent("Phone:Client:Redline:Spawn", source, {
			races = _races,
		})
	end, 2)
end)

AddEventHandler("Phone:Server:UpdateProfile", function(source, data)
	if data.app == "redline" then
		local char = Fetch:CharacterSource(source)
		if char ~= nil then
			local sid = char:GetData("SID")
			local count = MySQL.scalar.await("SELECT COUNT(*) FROM character_app_profiles WHERE app = ? AND name = ? AND sid != ?", {
				"redline",
				data.name,
				sid
			})

			if count == 0 then
				MySQL.prepare.await(
					"INSERT INTO character_app_profiles (sid, app, name, picture, meta) VALUES(?, ?, ?, ?, ?) ON DUPLICATE KEY UPDATE name = VALUES(name), picture = VALUES(picture), meta = VALUES(meta)",
					{
						char:GetData("SID"),
						"redline",
						data.name,
						data.picture,
						json.encode(data.meta or {}),
					}
				)
	
				local profiles = char:GetData("Profiles") or {}
				profiles["redline"] = {
					sid = char:GetData("SID"),
					app = "redline",
					name = data.name,
					picture = data.picture,
					meta = data.meta or {},
				}
				char:SetData("Profiles", profiles)
			else
				Execute:Client(source, "Notification", "Error", "Alias already in use")
			end
		end
	end
end)

function ReloadRaceTracks()
	LoadTracks()
	TriggerLatentClientEvent("Phone:Client:Redline:StoreTracks", -1, 50000, _tracks)
end

function LeaveAnyRace(source)
	local char = Fetch:CharacterSource(source)
	if char ~= nil then
		local alias = char:GetData("Profiles")?.redline?.name
		if alias ~= nil then
			for k, v in pairs(_races) do
				if v.state == 0 then
					if v.host_id == char:GetData("SID") then
						v.state = -1
						MySQL.query("UPDATE redline_race_history SET state = ? WHERE id = ?", {
							-1,
							k,
						})
						TriggerClientEvent("Phone:Client:Redline:CancelRace", -1, k)
					else
						if v.racers[alias] ~= nil then
							v.racers[alias] = nil
							TriggerClientEvent("Phone:Client:Redline:LeaveRace", -1, k, alias)
						end
					end
				end
			end
		end
	end
end

function FinishRace(id, forceEnd)
	local key = tostring(id)
	if _races[key].state == 2 then
		return
	end

	_raceInvites[key] = nil

	local cancelled = _races[key].state == 0

	_races[key].time = os.time()
	_races[key].state = 2

	if (_races[key].completed ~= nil and #_races[key].completed > 0) or forceEnd then
		local laps = {}
		local updateFastest = false
		local racedTrack = nil
		for k, v in ipairs(_tracks) do
			if v.id == _races[key].track then
				racedTrack = k
				break
			end
		end

		_races[key].competitive = false
		if (_races[key].total >= _reqForCrypto) and (_trackData[key].Type == "p2p" or tonumber(_races[key].laps) > 1) then
			_races[key].competitive = true
		end

		local queries = {}

		for placing, alias in ipairs(_races[key].completed or {}) do
			local fastest = nil
			local pCash = 0
			local pCrypto = 0

			if _races[key].total < 2 then
				pCash = _races[key].buyin
			else
				if placing == 1 or placing == 2 and _races[key].total == 2 then
					pCash = (_races[key].buyin * _races[key].total) / 2
					if _races[key].total >= _reqForCrypto then
						pCrypto = _cryptoPayout / 2
					end
				elseif placing == 2 and _races[key].total > 2 then
					pCash = (_races[key].buyin * _races[key].total) / 4
					if _races[key].total >= _reqForCrypto then
						pCrypto = _cryptoPayout / 4
					end
				elseif placing == 3 or placing == 4 then
					pCash = (_races[key].buyin * _races[key].total) / 8
					if _races[key].total >= _reqForCrypto then
						pCrypto = _cryptoPayout / 8
					end
				end
			end

			for k, v in ipairs(_races[key].racers[alias].laps) do
				table.insert(laps, {
					sid = _races[key].racers[alias].sid,
					lap_start = v.lap_start,
					lap_end = v.lap_end,
					laptime = (v.lap_end - v.lap_start),
					car = _races[key].racers[alias].car or "UNKNOWN",
					owned = _races[key].racers[alias].isOwned or false,
				})
				if fastest == nil or (v.lap_end - v.lap_start) < (fastest.lap_end - fastest.lap_start) then
					fastest = v
					fastest.alias = alias
				end
			end

			if _races[key].total >= _reqForCrypto then
				if fastest ~= nil then
					if _tracks[racedTrack].Fastest == nil or #_tracks[racedTrack].Fastest == 0 then
						_tracks[racedTrack].Fastest = {
							{
								time = fastest.time,
								lap_start = fastest.lap_start,
								lap_end = fastest.lap_end,
								format = fastest.format,
								alias = fastest.alias,
								car = _races[key].racers[alias].car or "UNKNOWN",
								owned = _races[key].racers[alias].isOwned or false,
							},
						}
						pCrypto = pCrypto + _awardedAmount
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
									format = fastest.format,
									alias = fastest.alias,
									car = _races[key].racers[alias].car or "UNKNOWN",
									owned = _races[key].racers[alias].isOwned or false,
								})
								_tracks[racedTrack].Fastest = table.slice(_tracks[racedTrack].Fastest, 1, 10)
								pCrypto = pCrypto + _awardedAmount
								updateFastest = true
								break
							end
						end
					end
				end
			end

			_races[key].racers[alias] = {
				place = placing,
				finished = os.time(),
				fastest = fastest,
				laps = _races[key].racers[alias].laps,
				sid = _races[key].racers[alias].sid,
				isOwned = _races[key].racers[alias].isOwned or false,
				car = _races[key].racers[alias].car or "UNKNOWN",
				reward = {
					cash = pCash,
					coin = _awardedCoin,
					crypto = pCrypto,
				},
			}

			table.insert(queries, {
				query = "INSERT INTO redline_racer_history (sid, placing, winnings, vehicle, vehicle_class, track) VALUES(?, ?, ?, ?, ?, ?)",
				values = {
					_races[key].racers[alias].sid,
					placing or -1,
					json.encode(_races[key].racers[alias].reward) or "{}",
					_races[key].racers[alias].car or "UNKNOWN",
					_races[key].class or "D",
					_races[key].track,
				},
			})
		end

		if updateFastest then
			--UpdateFastest(_tracks[racedTrack].id, _tracks[racedTrack].Fastest)
			TriggerClientEvent("Phone:Client:Redline:StoreSingleTrack", -1, racedTrack, _tracks[racedTrack])
		end

		table.insert(queries, {
			query = "UPDATE redline_race_history SET racers = ?, state = ? WHERE id = ?",
			values = {
				json.encode(_races[key].racers),
				2,
				id,
			},
		})

		if #laps > 0 then
			local qry =
				"INSERT INTO redline_track_history (track, race, sid, lap_start, lap_end, laptime, car, owned) VALUES "
			local params = {}
			for k, v in ipairs(laps) do
				table.insert(params, _races[key].track)
				table.insert(params, id)
				table.insert(params, v.sid)
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

	for k, v in pairs(_races[key].racers) do
		if v.source ~= nil then
			TriggerClientEvent("Phone:Redline:NotifyDNF", v.source, id)
		end
	end

	TriggerClientEvent("Phone:Client:Redline:FinishRace", -1, key, _races[key])
	Payout(_races[key].total, _races[key].racers, _races[key].competitive)

	for k, v in pairs(Fetch:AllCharacters()) do
		if v ~= nil then
			local dutyData = Jobs.Duty:Get(v:GetData("Source"))
			if hasValue(v:GetData("States") or {}, "RACE_DONGLE") and (not dutyData or dutyData.Id ~= "police") then
				Phone.Notification:Add(
					v:GetData("Source"),
					string.format("%s", cancelled and "Event Cancelled" or "Event Finished"),
					string.format("%s has %s", _races[key].name, cancelled and "been cancelled" or "finished"),
					os.time(),
					10000,
					"redline",
					{
						view = string.format("view/%s", key),
					}
				)
			end
		end
	end
end

-- TODO: Add payout for crypto
function Payout(numRacers, results, isCompetitive)
	for k, v in pairs(results) do
		if isCompetitive and v.place ~= nil then
			local char = Fetch:SID(v.sid)
			if char ~= nil then
				Reputation.Modify:Add(char:GetData("Source"), "Racing", 25 + (25 * (numRacers - v.place)))
				if v.reward ~= nil and v.reward.crypto > 0 then
					Crypto.Exchange:Add(_awardedCoin, char:GetData("CryptoWallet"), v.reward.crypto)
				end
			end
		end
	end
end

-- TODO: Add check for player-owned vehicle
RegisterServerEvent("Phone:Redline:FinishRace", function(nId, data, laps, plate, vehName)
	local src = source
	local char = Fetch:CharacterSource(src)
	local alias = char:GetData("Profiles").redline.name

	local key = tostring(data)

	local vehEnt = Entity(NetworkGetEntityFromNetworkId(nId)).state
	_races[key].racers[alias] = {
		laps = laps,
		sid = char:GetData("SID"),
		isOwned = vehEnt.Owned,
		car = vehName,
	}

	if _races[key].completed == nil then
		_races[key].completed = {}
	end
	table.insert(_races[key].completed, alias)

	if #_races[key].completed == _races[key].total then
		FinishRace(tonumber(data))
	elseif
		#_races[key].completed >= tonumber(_races[key].dnf_start)
		and not _races[key].dnf_started
	then
		_races[key].dnf_started = true
		for k, v in pairs(_races[key].racers) do
			if v.source ~= nil then
				TriggerClientEvent(
					"Phone:Redline:NotifyDNFStart",
					v.source,
					tonumber(data),
					tonumber(_races[key].dnf_time)
				)
			end
		end
		Citizen.CreateThread(function()
			Citizen.Wait(tonumber(_races[key].dnf_time) * 1000)
			FinishRace(tonumber(data))
		end)
	end
end)

AddEventHandler("Phone:Server:RegisterCallbacks", function()
	Callbacks:RegisterServerCallback("Phone:Redline:GetTrack", function(src, data, cb)
		for k, v in ipairs(_tracks) do
			if v.id == data then
				cb(v)
				return
			end
		end
		cb(nil)
	end)

	Callbacks:RegisterServerCallback("Phone:Redline:SaveTrack", function(src, data, cb)
		local char = Fetch:CharacterSource(src)
		local alias = char:GetData("Profiles").redline.name

		if alias ~= nil then
			local doc = {
				data.Name,
				data.Distance,
				data.Type,
				json.encode(data.Checkpoints),
				alias,
			}

			doc.id = MySQL.insert.await(
				"INSERT INTO redline_tracks (name, distance, type, checkpoints, created_by) VALUES(?, ?, ?, ?, ?)",
				doc
			)

			table.insert(_tracks, table.copy(doc))
			TriggerClientEvent("Phone:Client:Redline:StoreSingleTrack", -1, doc.id, {
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

	Callbacks:RegisterServerCallback("Phone:Redline:DeleteTrack", function(src, data, cb)
		local char = Fetch:CharacterSource(src)
		local alias = char:GetData("Profiles").redline.name

		local myPerms = char:GetData("PhonePermissions")

		local isAdmin = myPerms?.redline?.create ~= nil

		if alias ~= nil and isAdmin then
			local qrys = {}
			table.insert(qrys, {
				query = "DELETE FROM redline_track_history WHERE track = ?",
				values = {
					tonumber(data),
				},
			})
			table.insert(qrys, {
				query = "DELETE FROM redline_race_history WHERE track = ?",
				values = {
					tonumber(data),
				},
			})
			table.insert(qrys, {
				query = "DELETE FROM redline_racer_history WHERE track = ?",
				values = {
					tonumber(data),
				},
			})
			table.insert(qrys, {
				query = "DELETE FROM redline_tracks WHERE id = ?",
				values = {
					tonumber(data),
				},
			})

			MySQL.transaction.await(qrys)

			for k, v in ipairs(_tracks) do
				if v.id == tonumber(data) then
					table.remove(_tracks, k)
					break
				end
			end

			TriggerClientEvent("Phone:Client:Redline:StoreSingleTrack", -1, tonumber(data), nil)
			cb(true)
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("Phone:Redline:ResetTrackHistory", function(src, data, cb)
		local char = Fetch:CharacterSource(src)
		local alias = char:GetData("Profiles").redline.name
		if alias ~= nil then
			MySQL.query("DELETE FROM redline_track_history WHERE track = ?", {
				data,
			})
			_tracks[data].Fastest = nil
			TriggerClientEvent("Phone:Client:Redline:StoreSingleTrack", -1, data, _tracks[data])
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("Phone:Redline:CreateRace", function(src, data, cb)
		local char = Fetch:CharacterSource(src)
		if hasValue(char:GetData("States") or {}, "RACE_DONGLE") then
			if char:GetData("Profiles")?.redline then
				if (tonumber(data.laps) or 1) <= 0 then
					data.laps = 1
				end

				data.host_id = char:GetData("SID")
				data.host_src = src
				data.time = os.time()

				if data.phasing ~= "none" then
					data.phasingAdv = tonumber(data.phasingAdv)
				end

				data.racers = {
					[char:GetData("Profiles").redline.name] = {
						source = src,
						sid = char:GetData("SID"),
					},
				}
				data.state = 0
	
				local tmp = nil
				for k, v in ipairs(_tracks) do
					if v.id == data.track then
						tmp = v
						break
					end
				end
	
				if tmp ~= nil then
					local tId = MySQL.insert.await(
						"INSERT INTO redline_race_history (name, buyin, host, track, class, race_config) VALUES(?, ?, ?, ?, ?, ?)",
						{
							data.name,
							data.buyin,
							char:GetData("SID"),
							data.track,
							data.class,
							json.encode(data),
						}
					)

					if data.phasing == "checkpoints" and data.phasingAdv < 1 then
						data.phasingAdv = 1
						Logger:Info(
							"Robbery",
							string.format(
								"%s %s (%s) Made A Race With Checkpoint Phasing With A Checkpoint Count Under 1 (%s)",
								char:GetData("First"),
								char:GetData("Last"),
								char:GetData("SID"),
								data.phasingAdv
							),
							{
								console = true,
								file = true,
								database = true,
								discord = {
									embed = true,
									type = "info",
									webhook = GetConvar("discord_log_webhook", ""),
								},
							}
						)
					elseif data.phasing == "checkpoints" and data.phasingAdv > 10 then
						data.phasingAdv = 10
						Logger:Info(
							"Robbery",
							string.format(
								"%s %s (%s) Made A Race With Checkpoint Phasing With A Checkpoint Count Over 10 (%s)",
								char:GetData("First"),
								char:GetData("Last"),
								char:GetData("SID"),
								data.phasingAdv
							),
							{
								console = true,
								file = true,
								database = true,
								discord = {
									embed = true,
									type = "info",
									webhook = GetConvar("discord_log_webhook", ""),
								},
							}
						)
					elseif data.phasing == "timed" and data.phasingAdv < 3 then
						data.phasingAdv = 3
						Logger:Info(
							"Robbery",
							string.format(
								"%s %s (%s) Made A Race With Time Phasing With A Timer Less Than 3sec (%s)",
								char:GetData("First"),
								char:GetData("Last"),
								char:GetData("SID"),
								data.phasingAdv
							),
							{
								console = true,
								file = true,
								database = true,
								discord = {
									embed = true,
									type = "info",
									webhook = GetConvar("discord_log_webhook", ""),
								},
							}
						)
					elseif data.phasing == "timed" and data.phasingAdv > 60 then
						data.phasingAdv = 60
						Logger:Info(
							"Robbery",
							string.format(
								"%s %s (%s) Made A Race With Time Phasing With A Timer Greater Than 60sec (%s)",
								char:GetData("First"),
								char:GetData("Last"),
								char:GetData("SID"),
								data.phasingAdv
							),
							{
								console = true,
								file = true,
								database = true,
								discord = {
									embed = true,
									type = "info",
									webhook = GetConvar("discord_log_webhook", ""),
								},
							}
						)
					end

					local key = tostring(tId)

					data.id = key
					_races[key] = table.copy(data)
					_raceInvites[key] = {}
					_trackData[key] = table.copy(tmp)
					for k, v in pairs(Fetch:AllCharacters()) do
						if v ~= nil then
							TriggerClientEvent("Phone:Client:Redline:CreateRace", v:GetData("Source"), data)
							local dutyData = Jobs.Duty:Get(v:GetData("Source"))
							if
								v:GetData("Source") ~= src
								and hasValue(v:GetData("States") or {}, "RACE_DONGLE")
								and (not dutyData or dutyData.Id ~= "police")
							then
								Phone.Notification:Add(
									v:GetData("Source"),
									string.format("New Event: %s", data.name),
									string.format("%s created an event", char:GetData("Profiles").redline.name),
									os.time(),
									10000,
									"redline",
									{
										view = string.format("view/%s", key),
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
				cb({ failed = true, message = "Missing Redline Profile" })
			end
		else
			cb({ failed = true, message = "Insufficient Permissions" })
		end
	end)

	Callbacks:RegisterServerCallback("Phone:Redline:CancelRace", function(src, key, cb)
		local char = Fetch:CharacterSource(src)
		if
			_races[key].host_id == char:GetData("SID")
			and hasValue(char:GetData("States") or {}, "RACE_DONGLE")
		then
			_races[key].state = -1
			MySQL.query("UPDATE redline_race_history SET state = ? WHERE id = ?", {
				-1,
				tonumber(key),
			})
			TriggerClientEvent("Phone:Client:Redline:CancelRace", -1, key)
			cb(true)
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("Phone:Redline:StartRace", function(src, key, cb)
		local char = Fetch:CharacterSource(src)
		if
			_races[key].host_id == char:GetData("SID")
			and hasValue(char:GetData("States") or {}, "RACE_DONGLE")
		then
			local ploc = GetEntityCoords(GetPlayerPed(src))
			local dist = #(
				vector3(
					_trackData[key].Checkpoints[1].coords.x,
					_trackData[key].Checkpoints[1].coords.y,
					_trackData[key].Checkpoints[1].coords.z
				) - ploc
			)

			if
				_races[key].class ~= "All"
				and CheckVehicleAgainstClass(_races[key].class, char:GetData("Source")) == false
			then
				Phone.Notification:Add(
					char:GetData("Source"),
					"Unable to Join Race",
					"This vehicle is not in the right class.",
					os.time(),
					10000,
					"redline",
					{}
				)
				cb({ failed = true, message = "Unable to create race due to wrong vehicle class." })
			else
				if dist > 25 then
					cb({ failed = true, message = "Too Far From Starting Point" })
				else
					_races[key].state = 1
					_races[key].total = 0
					for k, v in pairs(_races[key].racers) do
						_races[key].total += 1
					end

					Robbery:TriggerPDAlert(
						src,
						vector3(
							_trackData[key].Checkpoints[1].coords.x,
							_trackData[key].Checkpoints[1].coords.y,
							_trackData[key].Checkpoints[1].coords.z
						),
						"10-94",
						string.format("Illegal Street Racing [%s]", _races[key].class),
						{
							icon = 227,
							size = 0.9,
							color = 31,
							duration = (60 * 5),
						}
					)

					cb(true)
					TriggerClientEvent("Phone:Client:Redline:StartRace", -1, key)
				end
			end
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("Phone:Redline:EndRace", function(src, data, cb)
		local char = Fetch:CharacterSource(src)
		local key = tostring(data)
		if _races[key].host_id == char:GetData("SID") then
			FinishRace(tonumber(data), true)
			cb(true)
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("Phone:Redline:JoinRace", function(src, data, cb)
		local char = Fetch:CharacterSource(src)
		local alias = char:GetData("Profiles")?.redline?.name

		local key = tostring(data)

		if not alias then
			cb(false)
			return
		end

		if _races[key].access == "invite" and not _raceInvites[key][alias] then
			cb(false)
			return
		end

		for k, v in ipairs(_races) do
			if v.state == 0 then
				if _races[k].racers[alias] ~= nil then
					_races[k].racers[alias] = nil
					TriggerClientEvent("Phone:Client:Redline:LeaveRace", -1, k, alias)
				end
			end
		end

		if alias ~= nil and _races[key].state == 0 then
			if
				_races[key].class ~= "All"
				and CheckVehicleAgainstClass(_races[key].class, char:GetData("Source")) == false
			then
				Phone.Notification:Add(
					char:GetData("Source"),
					"Unable to Join Race",
					"This vehicle is not in the right class.",
					os.time(),
					10000,
					"redline",
					{}
				)
				cb(false)
			else
				_races[key].racers[alias] = {
					source = src,
					sid = char:GetData("SID"),
				}
				cb(_races[key])
				TriggerClientEvent("Phone:Client:Redline:JoinRace", -1, key, alias, _races[key].racers[alias])
			end
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("Phone:Redline:LeaveRace", function(src, data, cb)
		local char = Fetch:CharacterSource(src)
		local alias = char:GetData("Profiles").redline.name
		local key = tostring(data)
		if alias ~= nil and _races[key].state == 0 then
			_races[key].racers[alias] = nil
			TriggerClientEvent("Phone:Client:Redline:LeaveRace", -1, key, alias)
			cb(true)
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("Phone:Redline:RemoveRacer", function(src, data, cb)
		local char = Fetch:CharacterSource(src)
		if char ~= nil then
			local sid = char:GetData("SID")
			local alias = char:GetData("Profiles")?.redline?.name
			local key = tostring(data.id)
			if alias ~= nil and _races[key].state == 0 and _races[key].host_id == sid then
				if data.alias ~= alias then
					local tSid = MySQL.scalar.await('SELECT sid FROM character_app_profiles WHERE app = ? AND name = ?', {
						'redline',
						data.alias
					})

					if tSid ~= nil then
						_races[key].racers[data.alias] = nil

						local tChar = Fetch:SID(tSid)
						if tChar ~= nil then
							TriggerClientEvent("Phone:Client:Redline:RemovedFromRace", tChar:GetData("Source"))
						end

						cb(true)
						TriggerClientEvent("Phone:Client:Redline:LeaveRace", -1, key, data.alias)
					else
						cb(false)
					end
				else
					cb(false)
				end
			else
				cb(false)
			end
		end
	end)

	Callbacks:RegisterServerCallback("Phone:Redline:SendInvite", function(src, data, cb)
		local char = Fetch:CharacterSource(src)
		if char ~= nil then
			local sid = char:GetData("SID")
			local alias = char:GetData("Profiles")?.redline?.name
			local key = tostring(data.id)
			if alias ~= nil and _races[key].state == 0 and _races[key].host_id == sid then
				if data.alias ~= alias and not _raceInvites[key][string.lower(data.alias)] then
					local tSid = MySQL.scalar.await('SELECT sid FROM character_app_profiles WHERE app = ? AND name = ?', {
						'redline',
						string.lower(data.alias)
					})

					if tSid ~= nil then
						local tChar = Fetch:SID(tSid)
						if tChar ~= nil then
							_raceInvites[key][string.lower(data.alias)] = {
								id = key,
								sender = alias,
								event = _races[key].name,
								expires = os.time() + (60 * 5),
							}
							TriggerClientEvent("Phone:Client:Redline:ReceiveInvite", tChar:GetData("Source"), _raceInvites[key][string.lower(data.alias)])
							cb(true)
						else
							cb(false)
						end
					else
						cb(false)
					end
				else
					cb(false)
				end
			else
				cb(false)
			end
		end
	end)

	Callbacks:RegisterServerCallback("Phone:Redline:AcceptInvite", function(src, data, cb)
		local char = Fetch:CharacterSource(src)
		if char ~= nil then
			local sid = char:GetData("SID")
			local alias = char:GetData("Profiles")?.redline?.name
			local key = tostring(data)
			if alias ~= nil and _races[key].state == 0 then
				if _raceInvites[key] ~= nil and _raceInvites[key][string.lower(alias)] ~= nil and _raceInvites[key][string.lower(alias)].expires >= os.time() then
					for k, v in ipairs(_races) do
						if v.state == 0 then
							if _races[k].racers[alias] ~= nil then
								_races[k].racers[alias] = nil
								TriggerClientEvent("Phone:Client:Redline:LeaveRace", -1, k, alias)
							end
						end
					end

					if
						_races[key].class ~= "All"
						and not CheckVehicleAgainstClass(_races[key].class, src)
					then
						Phone.Notification:Add(
							src,
							"Unable to Join Race",
							"This vehicle is not in the right class.",
							os.time(),
							10000,
							"redline",
							{}
						)
						cb(nil)
					else
						_races[key].racers[alias] = {
							source = src,
							sid = sid,
						}
						cb(_races[key])
						TriggerClientEvent("Phone:Client:Redline:JoinRace", -1, key, alias, _races[key].racers[alias])
						_raceInvites[key][string.lower(alias)] = nil
					end
				else
					cb(nil)
				end
			else
				cb(nil)
			end
		end
	end)

	Callbacks:RegisterServerCallback("Phone:Redline:DeclineInvite", function(src, data, cb)
		local char = Fetch:CharacterSource(src)
		if char ~= nil then
			local sid = char:GetData("SID")
			local alias = char:GetData("Profiles")?.redline?.name
			local key = tostring(data.id)
			if alias ~= nil and (not _races[key] or _races[key]?.state == 0) then
				if _raceInvites[key] ~= nil and _raceInvites[key][string.lower(alias)] ~= nil and _raceInvites[key][string.lower(alias)].expires >= os.time() then
					_raceInvites[key][string.lower(alias)] = nil
				else
					cb(false)
				end
			else
				cb(false)
			end
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
