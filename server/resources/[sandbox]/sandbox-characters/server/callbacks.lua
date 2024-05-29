_tempLastLocation = {}
_lastSpawnLocations = {}

_pleaseFuckingWorkSID = {}
_pleaseFuckingWorkID = {}

_fuckingBozos = {}

AddEventHandler("Player:Server:Connected", function(source)
	_fuckingBozos[source] = os.time()
end)

function RegisterCallbacks()
	Citizen.CreateThread(function()
		while true do
			if not (GlobalState["DisableAFK"] or false) then
				for k, v in pairs(_fuckingBozos) do
					if v < (os.time() - (60 * 10)) then
						local pState = Player(k).state
						if not pState.isDev and not pState.isAdmin and not pState.isStaff then
							Punishment:Kick(k, "You Were Kicked For Being AFK On Character Select", "Pwnzor", true)
						else
							Logger:Warn("Characters", "Staff or Admin Was AFK, Removing From Checks")
							_fuckingBozos[k] = nil
						end
					elseif v < (os.time() - (60 * 5)) then
						-- TODO: Implement better alert when at this stage when we have someway to do it
						Execute:Client(k, "Notification", "Warn", "You Will Be Kicked Soon For Being AFK", 58000)
					end
				end
			end
			Citizen.Wait(60000)
		end
	end)
	
	Callbacks:RegisterServerCallback("Characters:GetServerData", function(source, data, cb)
		while Fetch:Source(source) == nil do
			Citizen.Wait(1000)
		end

		local motd = GetConvar("motd", "Welcome to SandboxRP")
		Database.Game:find({
			collection = "changelogs",
			options = {
				sort = {
					date = -1,
				},
			},
			limit = 1,
		}, function(success, results)
			if not success then
				cb({ changelog = nil, motd = "" })
				return
			end

			if #results > 0 then
				cb({ changelog = results[1], motd = motd })
			else
				cb({ changelog = nil, motd = motd })
			end
		end)
	end)

	Callbacks:RegisterServerCallback("Characters:GetCharacters", function(source, data, cb)
		local player = Fetch:Source(source)
		Database.Game:find({
			collection = "characters",
			query = {
				User = player:GetData("AccountID"),
				Deleted = {
					["$ne"] = true,
				},
			},
		}, function(success, results)
			if not success then
				cb(nil)
				return
			end
			local cData = {}

			local charsToFetch = {}
			for k, v in ipairs(results) do
				table.insert(charsToFetch, v._id)
			end

			local p = promise.new()
			Database.Game:find({
				collection = "peds",
				query = {
					Char = {
						["$in"] = charsToFetch,
					},
				},
			}, function(s2, pedData)
				if s2 and pedData then
					p:resolve(pedData)
				else
					p:resolve({})
				end
			end)

			local pedData = Citizen.Await(p)
			local shit = {}

			for k, v in ipairs(pedData) do
				shit[v.Char] = v.Ped
			end

			for k, v in ipairs(results) do
				table.insert(cData, {
					ID = v._id,
					First = v.First,
					Last = v.Last,
					Phone = v.Phone,
					DOB = v.DOB,
					Gender = v.Gender,
					LastPlayed = v.LastPlayed,
					Jobs = v.Jobs,
					SID = v.SID,
					GangChain = v.GangChain,
					Preview = shit[v._id] or false,
				})
			end

			local charLimit = 3
			if player.Permissions:IsStaff() then
				charLimit = 100
			end

			cb(cData, charLimit)
		end)
	end)

	Callbacks:RegisterServerCallback("Characters:CreateCharacter", function(source, data, cb)
		local player = Fetch:Source(source)

		local p = promise.new()
		Database.Game:count({
			collection = "characters",
			query = {
				User = player:GetData("AccountID"),
				Deleted = {
					["$ne"] = true,
				},
			},
		}, function(success, count)
			if success then
				p:resolve(count)
			else
				p:resolve(3)
			end
		end)

		local charCount = Citizen.Await(p)

		if charCount < 3 or player.Permissions:IsStaff() then
			local pNumber = Phone:GeneratePhoneNumber()

			local doc = {
				User = player:GetData("AccountID"),
				First = data.first,
				Last = data.last,
				Phone = pNumber,
				Gender = tonumber(data.gender),
				Bio = data.bio,
				Origin = data.origin,
				DOB = data.dob,
				LastPlayed = -1,
				Jobs = {},
				SID = Sequence:Get("Character"),
				Cash = 1000,
				New = true,
				Licenses = {
					Drivers = {
						Active = true,
						Points = 0,
						Suspended = false,
					},
					Weapons = {
						Active = false,
						Suspended = false,
					},
					Hunting = {
						Active = false,
						Suspended = false,
					},
					Fishing = {
						Active = false,
						Suspended = false,
					},
					Pilot = {
						Active = false,
						Suspended = false,
					},
					Drift = {
						Active = false,
						Suspended = false,
					},
				},
			}

			local extra = Middleware:TriggerEventWithData("Characters:Creating", source, doc)
			for k, v in ipairs(extra) do
				for k2, v2 in pairs(v) do
					if k2 ~= "ID" then
						doc[k2] = v2
					end
				end
			end

			Database.Game:insertOne({
				collection = "characters",
				document = doc,
			}, function(success, result, insertedIds)
				if not success then
					cb(nil)
					return nil
				end
				doc.ID = insertedIds[1]
				TriggerEvent("Characters:Server:CharacterCreated", doc)
				Middleware:TriggerEvent("Characters:Created", source, doc)
				cb(doc)

				Logger:Info(
					"Characters",
					string.format(
						"%s [%s] Created a New Character %s %s (%s)",
						player:GetData("Name"),
						player:GetData("AccountID"),
						doc.First,
						doc.Last,
						doc.SID
					),
					{
						console = true,
						file = true,
						database = true,
					}
				)
			end)
		else
			cb(nil)
		end
	end)

	Callbacks:RegisterServerCallback("Characters:DeleteCharacter", function(source, data, cb)
		local player = Fetch:Source(source)
		Database.Game:findOne({
			collection = "characters",
			query = {
				User = player:GetData("AccountID"),
				_id = data,
			},
		}, function(success, results)
			if not success or not #results then
				cb(nil)
				return
			end
			local deletingChar = results[1]
			Database.Game:updateOne({
				collection = "characters",
				query = {
					User = player:GetData("AccountID"),
					_id = data,
				},
				update = {
					["$set"] = {
						Deleted = true,
					},
				},
			}, function(success, results)
				TriggerEvent("Characters:Server:CharacterDeleted", data, deletingChar.SID)
				cb(success)

				if success then
					Logger:Warn(
						"Characters",
						string.format(
							"%s [%s] Deleted Character %s %s (%s)",
							player:GetData("Name"),
							player:GetData("AccountID"),
							deletingChar.First,
							deletingChar.Last,
							deletingChar.SID
						),
						{
							console = true,
							file = true,
							database = true,
							discord = {
								embed = true,
							},
						}
					)
				end
			end)
		end)
	end)

	Callbacks:RegisterServerCallback("Characters:GetSpawnPoints", function(source, data, cb)
		local player = Fetch:Source(source)
		Database.Game:findOne({
			collection = "characters",
			query = {
				User = player:GetData("AccountID"),
				_id = data,
				Deleted = {
					["$ne"] = true,
				},
			},
			options = {
				projection = {
					SID = 1,
					New = 1,
					Jailed = 1,
					ICU = 1,
					Apartment = 1,
					Jobs = 1,
				},
			},
		}, function(success, results)
			if not success or not #results then
				cb(nil)
				return
			end
			local hasLastLocation = _lastSpawnLocations[results[1].ID]

			if results[1].New then
				cb({
					{
						id = 1,
						label = "Character Creation",
						location = Apartment:GetInteriorLocation(results[1].Apartment or 1),
					},
				})
			elseif results[1].Jailed and not results[1].Jailed.Released ~= nil then
				cb({ Config.PrisonSpawn })
			elseif results[1].ICU and not results[1].ICU.Released then
				cb({ Config.ICUSpawn })
			elseif hasLastLocation and Damage:WasDead(results[1].SID) then
				cb({
					{
						id = "LastLocation",
						label = "Last Location",
						location = {
							x = hasLastLocation.coords.x,
							y = hasLastLocation.coords.y,
							z = hasLastLocation.coords.z,
							h = 0.0,
						},
						icon = "location-smile",
						event = "Characters:GlobalSpawn",
					},
				})
			else
				local spawns = Middleware:TriggerEventWithData("Characters:GetSpawnPoints", source, data, results[1])
				cb(spawns or {})
			end
		end)
	end)

	Callbacks:RegisterServerCallback("Characters:GetCharacterData", function(source, data, cb)
		local player = Fetch:Source(source)
		Database.Game:findOne({
			collection = "characters",
			query = {
				User = player:GetData("AccountID"),
				_id = data,
			},
		}, function(success, results)
			if not success or not #results then
				cb(nil)
				return
			end

			local cData = results[1]
			cData.Source = source
			cData.ID = results[1]._id
			cData._id = nil

			player:SetData("Character", {
				SID = cData.SID,
				First = cData.First,
				Last = cData.Last,
			})

			local store = DataStore:CreateStore(source, "Character", cData)
			ONLINE_CHARACTERS[source] = store

			_pleaseFuckingWorkSID[cData.SID] = source
			_pleaseFuckingWorkID[cData.ID] = source

			GlobalState[string.format("SID:%s", source)] = cData.SID

			Middleware:TriggerEvent("Characters:CharacterSelected", source)

			cb(cData)
		end)
	end)

	Callbacks:RegisterServerCallback("Characters:Logout", function(source, data, cb)
		_fuckingBozos[source] = os.time()
		local c = Fetch:CharacterSource(source)
		if c ~= nil then
			local cData = c:GetData()
			if cData.SID and cData.ID then
				_pleaseFuckingWorkSID[cData.SID] = nil
				_pleaseFuckingWorkID[cData.ID] = nil
			end

			TriggerEvent("Characters:Server:PlayerLoggedOut", source, cData)

			Middleware:TriggerEvent("Characters:Logout", source)
			ONLINE_CHARACTERS[source] = nil
			GlobalState[string.format("SID:%s", source)] = nil
			TriggerClientEvent("Characters:Client:Logout", source)
			Routing:RoutePlayerToHiddenRoute(source)
			DataStore:DeleteStore(source, "Character")
		end
		cb("ok")
	end)

	Callbacks:RegisterServerCallback("Characters:GlobalSpawn", function(source, data, cb)
		Routing:RoutePlayerToGlobalRoute(source)
		cb()
	end)
end

AddEventHandler("Characters:Server:DropCleanup", function(source, cData)
	_fuckingBozos[source] = nil
	ONLINE_CHARACTERS[source] = nil

	GlobalState[string.format("SID:%s", source)] = nil

	if cData and cData.SID and cData.ID then
		_pleaseFuckingWorkSID[cData.SID] = nil
		_pleaseFuckingWorkID[cData.ID] = nil
	end
end)

function HandleLastLocation(source)
	local char = Fetch:CharacterSource(source)

	if char ~= nil then
		local lastLocation = _tempLastLocation[source]
		if lastLocation and type(lastLocation) == "vector3" then
			_lastSpawnLocations[char:GetData("ID")] = {
				coords = lastLocation,
				time = os.time(),
			}
		end
	end

	_tempLastLocation[source] = nil
end

AddEventHandler("Characters:Server:PlayerLoggedOut", function(source, cData)
	local lastLocation = _tempLastLocation[source]
	if lastLocation and type(lastLocation) == "vector3" then
		_lastSpawnLocations[cData.ID] = {
			coords = lastLocation,
			time = os.time(),
		}
	end
end)

function RegisterMiddleware()
	Middleware:Add("Characters:Spawning", function(source)
		_fuckingBozos[source] = nil
		TriggerClientEvent("Characters:Client:Spawned", source)
	end, 100000)
	Middleware:Add("Characters:ForceStore", function(source)
		local char = Fetch:CharacterSource(source)
		if char ~= nil then
			StoreData(source)
		end
	end, 100000)
	Middleware:Add("Characters:Logout", function(source)
		local char = Fetch:CharacterSource(source)
		if char ~= nil then
			StoreData(source)
		end
	end, 10000)

	Middleware:Add("Characters:GetSpawnPoints", function(source, id)
		if id then
			local hasLastLocation = _lastSpawnLocations[id]
			if hasLastLocation and hasLastLocation.time and (os.time() - hasLastLocation.time) <= (60 * 5) then
				return {
					{
						id = "LastLocation",
						label = "Last Location",
						location = {
							x = hasLastLocation.coords.x,
							y = hasLastLocation.coords.y,
							z = hasLastLocation.coords.z,
							h = 0.0,
						},
						icon = "location-smile",
						event = "Characters:GlobalSpawn",
					},
				}
			end
		end
		return {}
	end, 1)

	Middleware:Add("Characters:GetSpawnPoints", function(source)
		local spawns = {}
		for k, v in ipairs(Spawns) do
			v.event = "Characters:GlobalSpawn"
			table.insert(spawns, v)
		end
		return spawns
	end, 5)

	Middleware:Add("playerDropped", function(source, message)
		local char = Fetch:CharacterSource(source)
		if char ~= nil then
			StoreData(source)
		end
	end, 10000)

	Middleware:Add("Characters:Logout", function(source)
		local pState = Player(source).state
		if pState?.tpLocation then
			_tempLastLocation[source] = pState?.tpLocation
		else
			_tempLastLocation[source] = GetEntityCoords(GetPlayerPed(source))
		end
		HandleLastLocation(source)
	end, 1)

	Middleware:Add("playerDropped", HandleLastLocation, 6)
end

AddEventHandler("playerDropped", function()
	local src = source
	if DoesEntityExist(GetPlayerPed(src)) then
		local pState = Player(src).state
		if pState?.tpLocation then
			_tempLastLocation[src] = pState?.tpLocation
		else
			_tempLastLocation[src] = GetEntityCoords(GetPlayerPed(src))
		end
	end
end)

RegisterNetEvent("Characters:Server:LastLocation", function(coords)
	local src = source
	_tempLastLocation[src] = coords
end)
