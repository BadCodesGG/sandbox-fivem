local requiredCharacterData = {
	SID = 1,
	User = 1,
	First = 1,
	Last = 1,
	Gender = 1,
	Origin = 1,
	Jobs = 1,
	DOB = 1,
	Callsign = 1,
	Phone = 1,
	Licenses = 1,
	Qualifications = 1,
	Flags = 1,
	Mugshot = 1,
	MDTSystemAdmin = 1,
	MDTHistory = 1,
	MDTSuspension = 1,
	Attorney = 1,
	LastClockOn = 1,
	TimeClockedOn = 1,
}

function GetCharacterVehiclesData(sid)
	local p = promise.new()

	Database.Game:find({
		collection = "vehicles",
		query = {
			["Owner.Type"] = 0,
			["Owner.Id"] = sid,
		},
		options = {
			projection = {
				_id = 0,
				Type = 1,
				VIN = 1,
				Make = 1,
				Model = 1,
				RegisteredPlate = 1,
			}
		}
	}, function(success, vehicles)
		if not success then
			p:resolve({})
		else
			p:resolve(vehicles)
		end
	end)

	return Citizen.Await(p)
end

_MDT.People = {
	Search = {
		People = function(self, term)
			local p = promise.new()
			Database.Game:find({
				collection = "characters",
				query = {
					["$and"] = {
						{
							["$or"] = {
								{
									["$expr"] = {
										["$regexMatch"] = {
											input = {
												["$concat"] = { "$First", " ", "$Last" },
											},
											regex = term,
											options = "i",
										},
									},
								},
								{
									["$expr"] = {
										["$regexMatch"] = {
											input = {
												["$toString"] = "$SID",
											},
											regex = term,
											options = "i",
										},
									},
								},
							},
						},
						{
							["$or"] = {
								{ Deleted = false },
								{ Deleted = {
									["$exists"] = false,
								} },
							},
						},
					},
				},
				options = {
					projection = requiredCharacterData,
					limit = 12,
				},
			}, function(success, results)
				if not success then
					p:resolve(false)
					return
				end
				p:resolve(results)
			end)
			return Citizen.Await(p)
		end,
	},
	View = function(self, id, requireAllData)
		-- 5 DB Calls Here But IDK what else to do
		local SID = tonumber(id)
		local p = promise.new()
		Database.Game:findOne({
			collection = "characters",
			query = {
				SID = SID,
			},
			options = {
				projection = requiredCharacterData,
			},
		}, function(success, character)
			if not success or #character < 0 then
				p:resolve(false)
				return
			end

			if requireAllData then
				local vehicles = GetCharacterVehiclesData(SID)
				local char = character[1]
				local ownedBusinesses = {}

				if char.Jobs then
					for k, v in ipairs(char.Jobs) do
						local jobData = Jobs:Get(v.Id)
						if jobData.Owner and jobData.Owner == char.SID then
							table.insert(ownedBusinesses, v.Id)
						end
					end
				end

				local parole = MySQL.single.await("SELECT end, total, parole FROM character_parole WHERE SID = ?", {
					SID
				})

				local chargesData = MySQL.query.await("SELECT SID, charges FROM mdt_reports_people WHERE sentenced = ? AND type = ? AND SID = ? AND expunged = ?", {
					1,
					"suspect",
					SID,
					0
				})

				local convictions = {}
				for k,v in ipairs(chargesData) do
					local c = json.decode(v.charges)
					for _, ch in ipairs(c) do
						table.insert(convictions, ch)
					end
				end

				p:resolve({
					data = char,
					parole = parole,
					convictions = convictions,
					vehicles = vehicles,
					ownedBusinesses = ownedBusinesses,
				})
			else
				p:resolve(character[1])
			end
		end)
		return Citizen.Await(p)
	end,
	Update = function(self, requester, id, key, value)
		local p = promise.new()
		local logVal = value
		if type(value) == "table" then
			logVal = json.encode(value)
		end

		local update = {
			["$set"] = {
				[key] = value,
			},
		}

		if requester == -1 then
			update["$push"] = {
				MDTHistory = {
					Time = (os.time() * 1000),
					Char = -1,
					Log = string.format("System Updated Profile, Set %s To %s", key, logVal),
				},
			}
		else
			update["$push"] = {
				MDTHistory = {
					Time = (os.time() * 1000),
					Char = requester:GetData("SID"),
					Log = string.format(
						"%s Updated Profile, Set %s To %s",
						requester:GetData("First") .. " " .. requester:GetData("Last"),
						key,
						logVal
					),
				},
			}
		end

		Database.Game:updateOne({
			collection = "characters",
			query = {
				SID = id,
			},
			update = update,
		}, function(success, results)
			if success then
				local target = Fetch:SID(id)
				if target then
					target:SetData(key, value)
				end

				if key == "Mugshot" then
					Inventory:UpdateGovIDMugshot(id, value)
				end
			end
			p:resolve(success)
		end)
		return Citizen.Await(p)
	end,
}

AddEventHandler("MDT:Server:RegisterCallbacks", function()
	Callbacks:RegisterServerCallback("MDT:InputSearch:people", function(source, data, cb)
		Database.Game:find({
			collection = "characters",
			query = {
				["$and"] = {
					{
						["$or"] = {
							{
								["$expr"] = {
									["$regexMatch"] = {
										input = {
											["$concat"] = { "$First", " ", "$Last" },
										},
										regex = data.term,
										options = "i",
									},
								},
							},
							{
								["$expr"] = {
									["$regexMatch"] = {
										input = {
											["$toString"] = "$SID",
										},
										regex = data.term,
										options = "i",
									},
								},
							},
						},
					},
				},
			},
			options = {
				projection = {
					_id = 0,
					SID = 1,
					First = 1,
					Last = 1,
					DOB = 1,
					Licenses = 1,
				},
				limit = 4,
			},
		}, function(success, results)
			if not success then
				cb({})
			else
				cb(results)
			end
		end)
	end)

	Callbacks:RegisterServerCallback("MDT:InputSearch:job", function(source, data, cb)
		if CheckMDTPermissions(source, false) then
			Database.Game:find({
				collection = "characters",
				query = {
					["$and"] = {
						{
							["$or"] = {
								{
									["$expr"] = {
										["$regexMatch"] = {
											input = {
												["$concat"] = { "$First", " ", "$Last" },
											},
											regex = data.term,
											options = "i",
										},
									},
								},
								{
									["$expr"] = {
										["$regexMatch"] = {
											input = {
												["$toString"] = "$Callsign",
											},
											regex = data.term,
											options = "i",
										},
									},
								},
								{
									["$expr"] = {
										["$regexMatch"] = {
											input = {
												["$toString"] = "$SID",
											},
											regex = data.term,
											options = "i",
										},
									},
								},
							},
						},
						{
							Jobs = {
								["$elemMatch"] = {
									Id = data.job,
								},
							},
						},
					},
				},
				options = {
					projection = {
						_id = 0,
						SID = 1,
						First = 1,
						Last = 1,
						Callsign = 1,	
					},
					limit = 4,
				},
			}, function(success, results)
				if not success then
					cb({})
				else
					cb(results)
				end
			end)
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("MDT:InputSearchSID", function(source, data, cb)
		if CheckMDTPermissions(source, false) then
			Database.Game:findOne({
				collection = "characters",
				query = {
					SID = tonumber(data.term)
				},
				options = {
					projection = {
						_id = 0,
						SID = 1,
						First = 1,
						Last = 1,
						DOB = 1,
						Licenses = 1,
					},
				},
			}, function(success, results)
				if not success then
					cb({})
				else
					cb(results)
				end
			end)
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("MDT:Search:people", function(source, data, cb)
		cb(MDT.People.Search:People(data.term))
	end)

	Callbacks:RegisterServerCallback("MDT:View:person", function(source, data, cb)
		cb(MDT.People:View(data, true))
	end)

	Callbacks:RegisterServerCallback("MDT:Update:person", function(source, data, cb)
		local char = Fetch:CharacterSource(source)
		if char and CheckMDTPermissions(source, false) and data.SID then
			cb(MDT.People:Update(char, data.SID, data.Key, data.Data))
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("MDT:CheckCallsign", function(source, data, cb)
		if CheckMDTPermissions(source, false) then
			Database.Game:findOne({
				collection = "characters",
				query = {
					Callsign = data,
				},
				options = {
					projection = {
						_id = 0,
						SID = 1,
						Callsign = 1,
					},
				},
			}, function(success, results)
				cb(#results == 0)
			end)
		else
			cb(false)
		end
	end)
end)
