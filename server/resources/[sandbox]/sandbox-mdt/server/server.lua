_MDT = _MDT or {}
_bolos = {}
_breakpoints = {
	reduction = 50,
	license = 20,
}

local governmentJobs = {
	police = true,
	government = true,
	ems = true,
	tow = true,
	prison = true,
}

_onDutyUsers = {}
_onDutyLawyers = {}

_dojWorkers = {}

_governmentJobData = {}

local sentencedSuspects = {}

AddEventHandler("MDT:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Fetch = exports["sandbox-base"]:FetchComponent("Fetch")
	Database = exports["sandbox-base"]:FetchComponent("Database")
	Callbacks = exports["sandbox-base"]:FetchComponent("Callbacks")
	Logger = exports["sandbox-base"]:FetchComponent("Logger")
	Utils = exports["sandbox-base"]:FetchComponent("Utils")
	Chat = exports["sandbox-base"]:FetchComponent("Chat")
	Middleware = exports["sandbox-base"]:FetchComponent("Middleware")
	Execute = exports["sandbox-base"]:FetchComponent("Execute")
	Tasks = exports["sandbox-base"]:FetchComponent("Tasks")
	Sequence = exports["sandbox-base"]:FetchComponent("Sequence")
	MDT = exports["sandbox-base"]:FetchComponent("MDT")
	Jobs = exports["sandbox-base"]:FetchComponent("Jobs")
	Inventory = exports["sandbox-base"]:FetchComponent("Inventory")
	Default = exports["sandbox-base"]:FetchComponent("Default")
	Vehicles = exports["sandbox-base"]:FetchComponent("Vehicles")
	Properties = exports["sandbox-base"]:FetchComponent("Properties")
	Radar = exports["sandbox-base"]:FetchComponent("Radar")
	Jail = exports["sandbox-base"]:FetchComponent("Jail")
	EmergencyAlerts = exports["sandbox-base"]:FetchComponent("EmergencyAlerts")
	RegisterChatCommands()
end

AddEventHandler("Core:Shared:Ready", function()
	exports["sandbox-base"]:RequestDependencies("MDT", {
		"Fetch",
		"Database",
		"Callbacks",
		"Logger",
		"Utils",
		"Chat",
		"Phone",
		"Middleware",
		"Execute",
		"Tasks",
		"Sequence",
		"MDT",
		"Jobs",
		"Inventory",
		"Default",
		"Vehicles",
		"Properties",
		"Radar",
		"Jail",
		"EmergencyAlerts",
	}, function(error)
		if #error > 0 then
			return
		end
		RetrieveComponents()
		RegisterMiddleware()
		Startup()
		TriggerEvent("MDT:Server:RegisterCallbacks")

		Citizen.Wait(2500)
		UpdateMDTJobsData()
	end)
end)

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["sandbox-base"]:RegisterComponent("MDT", _MDT)
end)

AddEventHandler("Characters:Server:PlayerLoggedOut", function(source, cData)
	_onDutyLawyers[source] = nil
end)

AddEventHandler("Characters:Server:PlayerDropped", function(source, cData)
	_onDutyLawyers[source] = nil
end)

function RegisterMiddleware()
    Middleware:Add('Characters:Spawning', function(source)
		local char = Fetch:CharacterSource(source)
		if char and char:GetData("Attorney") then
			Citizen.SetTimeout(5000, function()
				TriggerClientEvent("MDT:Client:Login", source, nil, nil, nil, true, {
					governmentJobs = _governmentJobs,
					charges = _charges,
					governmentJobsData = _governmentJobData,
				})
				_onDutyLawyers[source] = char:GetData('SID')
			end)
		end
    end, 50)
end

function UpdateMDTJobsData()
	local newData = {}
	local allJobData = Jobs:GetAll()
	for k, v in ipairs(_governmentJobs) do
		newData[v] = allJobData[v]
	end

	_governmentJobData = newData
	TriggerClientEvent("MDT:Client:SetData", -1, "governmentJobsData", _governmentJobData)
end

AddEventHandler('Jobs:Server:UpdatedCache', function(job)
	if job == -1 or governmentJobs[job] then
		UpdateMDTJobsData()
	end
end)

AddEventHandler('Job:Server:DutyAdd', function(dutyData, source, SID)
	if governmentJobs[dutyData.Id] then
		local job = Jobs.Permissions:HasJob(source, dutyData.Id)
		if job then
			_onDutyUsers[source] = job.Id
			local permissions = Jobs.Permissions:GetPermissionsFromJob(source, job.Id)
	
			TriggerClientEvent("MDT:Client:Login", source, _breakpoints, job, permissions, false, {
				governmentJobs = _governmentJobs,
				charges = _charges,
				governmentJobsData = _governmentJobData,
				permissions = _permissions,
				qualifications = _qualifications,
				bolos = _bolos,
			})

			local char = Fetch:CharacterSource(source)
			if char and job.Id == "government" then
				_dojWorkers[source] = {
					First = char:GetData("First"),
					Last = char:GetData("Last"),
					SID = char:GetData("SID"),
					Phone = char:GetData("Phone"),

					Job = job.Name,
					Workplace = job.Workplace.Name,
					Grade = job.Grade.Name,
				}
			end
		end
	end
end)

AddEventHandler('Jobs:Server:JobUpdate', function(source)
	local dutyData = Jobs.Duty:Get(source)
	if dutyData and governmentJobs[dutyData.Id] then
		local job = Jobs.Permissions:HasJob(source, dutyData.Id)
		if job then
			local permissions = Jobs.Permissions:GetPermissionsFromJob(source, job.Id)
			TriggerClientEvent('MDT:Client:UpdateJobData', source, job, permissions)
		end
	end
end)

AddEventHandler('Job:Server:DutyRemove', function(dutyData, source, SID)
	if governmentJobs[dutyData.Id] then
		_onDutyUsers[source] = nil
		_dojWorkers[source] = nil
		TriggerClientEvent("MDT:Client:Logout", source)
	end
end)

function CheckMDTPermissions(source, permission, jobId)
	local mdtUser = _onDutyUsers[source]
	if mdtUser and (not jobId or jobId == mdtUser or (type(jobId) == 'table' and jobId[mdtUser])) then
		if not permission then
			return true
		end

		if type(permission) == 'string' then
			local hasPerm = Jobs.Permissions:HasPermissionInJob(source, mdtUser, permission)
			if hasPerm then
				return true, mdtUser
			end
		elseif type(permission) == 'table' then
			local jobPermissions = Jobs.Permissions:GetPermissionsFromJob(source, mdtUser)
			for k, v in ipairs(permission) do
				if jobPermissions[v] then
					return true, mdtUser
				end
			end
		end
		
		local char = Fetch:CharacterSource(source)
		if char:GetData('MDTSystemAdmin') then -- They have all permissions
			return true, mdtUser
		end
	end
	return false
end

RegisterNetEvent('MDT:Server:OpenPublicRecords', function()
	local src = source
	local dutyData = Jobs.Duty:Get(src)

	if not _onDutyUsers[src] then
		TriggerClientEvent("MDT:Client:SetMultipleData", src, {
			governmentJobs = _governmentJobs,
			charges = _charges,
			governmentJobsData = _governmentJobData,
			prison = false,
		})
	end

	TriggerClientEvent('MDT:Client:Toggle', src)
end)

RegisterNetEvent('MDT:Server:OpenDOCPublic', function()
	local src = source
	if not _onDutyUsers[src] then
		TriggerClientEvent("MDT:Client:SetMultipleData", src, {
			governmentJobs = _governmentJobs,
			charges = _charges,
			prison = true,
		})
	else
		TriggerClientEvent("MDT:Client:SetMultipleData", src, {
			prison = true,
		})
	end

	TriggerClientEvent('MDT:Client:Toggle', src)
end)

AddEventHandler("MDT:Server:RegisterCallbacks", function()
	Callbacks:RegisterServerCallback("MDT:GetHomeData", function(source, data, cb)
		local gJob = _onDutyUsers[source]
		local warrants = MySQL.query.await("SELECT id, state, report, suspect, title, creatorSID, creatorName, creatorCallsign, issued, expires FROM mdt_warrants WHERE state = ? AND expires > NOW() ORDER BY issued DESC LIMIT 5", {
			"active"
		})

		local notices
		if gJob then
			notices = MySQL.query.await("SELECT `id`, title, created FROM mdt_notices WHERE restricted IN (?, ?, ?)", {
				"public",
				"government",
				gJob,
			})
		else
			notices = MySQL.query.await("SELECT `id`, title, created FROM mdt_notices WHERE restricted = ?", {
				"public",
			})
		end

		local gWorkers = {}
		for k, v in pairs(_dojWorkers) do
			table.insert(gWorkers, v)
		end

		cb({
			warrants = warrants,
			notices = notices,
			govWorkers = gWorkers,
		})
	end)

	Callbacks:RegisterServerCallback("MDT:IssueWarrant", function(source, data, cb)
		local char = Fetch:CharacterSource(source)

		if char and CheckMDTPermissions(source, false) and data.report and data.suspect and data.suspect.id then
			local id = MDT.Warrants:Create(data.report, data.suspect, data.notes, {
				SID = char:GetData("SID"),
				First = char:GetData("First"),
				Last = char:GetData("Last"),
				Callsign = char:GetData("Callsign"),
			})

			if id then
				MySQL.query.await("UPDATE mdt_reports_people SET warrant = ? WHERE type = ? AND SID = ? AND report = ?", {
					id,
					"suspect",
					data.suspect.SID,
					data.report,
				})

				cb(true)
				return
			end
		end

		cb(false)
	end)

	Callbacks:RegisterServerCallback("MDT:SentencePlayer", function(source, data, cb)
		local char = Fetch:CharacterSource(source)

		if CheckMDTPermissions(source, false) and data.report and not data.data.sentenced then
			if not sentencedSuspects[data.report] then
				sentencedSuspects[data.report] = {}
			end
			local transactions = {}

			if data.data.SID and not sentencedSuspects[data.report][data.data.SID] then
				table.insert(transactions, {
					query = "UPDATE mdt_reports_people SET sentenced = ?, sentencedAt = NOW(), points = ?, fine = ?, jail = ?, parole = ?, reduction = ?, revoked = ?, doc = ? WHERE type = ? AND SID = ? AND report = ? AND sentenced = ?",
					values = {
						1,
						data.points,
						data.fine,
						data.jail,
						data.parole?.parole or 0,
						json.encode({
							type = data.sentence.type,
							value = data.sentence.value,
						}),
						json.encode(data.sentence.revoke),
						data.sentence.doc and 1 or 0,
						
						"suspect",
						data.data.SID,
						data.report,
						0
					}
				})

				if data.parole ~= nil then
					table.insert(transactions, {
						query = "INSERT INTO character_parole (SID, end, total, parole, sentence, fine) VALUES (?, FROM_UNIXTIME(?), ?, ?, ?, ?) ON DUPLICATE KEY UPDATE end = VALUES(end), total = VALUES(total), parole = VALUES(parole), sentence = VALUES(sentence), fine = VALUES(fine)",
						values = {
							data.data.SID,
							math.ceil(data.parole["end"]),
							data.parole.total,
							data.parole.parole,
							data.parole.sentence,
							data.parole.fine
						}
					})
				end

				table.insert(transactions, {
					query = "UPDATE mdt_warrants SET state = ? WHERE report = ? AND suspect = ?",
					values = {
						"served",
						data.report,
						data.data.id,
					}
				})

				MySQL.transaction.await(transactions)

				if data.sentence.revoke or data.points > 0 then
					local needsUpdate = false
					local licenseUpdate = {}

					if data.points > 0 then
						needsUpdate = true

						licenseUpdate['$inc'] = {
							['Licenses.Drivers.Points'] = data.points
						}
					end

					if data.sentence.revoke then
						for k, v in pairs(data.sentence.revoke) do
							if v then
								if not licenseUpdate['$set'] then
									licenseUpdate['$set'] = {}
								end

								needsUpdate = true

								if k == 'drivers' then
									licenseUpdate['$set']['Licenses.Drivers.Active'] = false
									licenseUpdate['$set']['Licenses.Drivers.Suspended'] = true
								elseif k == 'weapons' then
									licenseUpdate['$set']['Licenses.Weapons.Active'] = false
									licenseUpdate['$set']['Licenses.Weapons.Suspended'] = true
								elseif k == 'hunting' then
									licenseUpdate['$set']['Licenses.Hunting.Active'] = false
									licenseUpdate['$set']['Licenses.Hunting.Suspended'] = true
								elseif k == 'fishing' then
									licenseUpdate['$set']['Licenses.Fishing.Active'] = false
									licenseUpdate['$set']['Licenses.Fishing.Suspended'] = true
								end
							end
						end
					end

					if needsUpdate then
						local p = promise.new()
						Database.Game:findOneAndUpdate({
							collection = "characters",
							query = {
								SID = data.data.SID,
							},
							update = licenseUpdate,
							options = {
								returnDocument = 'after',
							}
						}, function(success, results)
							if success and results and results.SID then
								if results and results.Licenses then
									local char = Fetch:SID(results.SID)
									if char then
										char:SetData('Licenses', results.Licenses)
									end
								end
							end

							p:resolve(success)
						end)

						Citizen.Await(p)
					end
				end
				cb(true)
			else
				cb(false)
			end
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("MDT:OverturnSentence", function(source, data, cb)
		local char = Fetch:CharacterSource(source)

		if CheckMDTPermissions(source, "DOJ_OVERTURN_CHARGES") and data.report and data.SID then
			Logger:Warn(
				"MDT",
				string.format(
					"%s %s (%s) Overturned Charges From State ID %s on Report %s",
					char:GetData("First"),
					char:GetData("Last"),
					char:GetData("SID"),
					data.SID,
					data.report
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

			MySQL.query.await("UPDATE mdt_reports_people SET type = ? WHERE report = ? AND type = ? AND SID = ? AND sentenced = ?", {
				"suspectOverturned",
				data.report,
				"suspect",
				data.SID,
				1
			})

			cb(true)
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("MDT:RosterView", function(source, data, cb)
		Database.Game:find({
			collection = "characters",
			query = {
				Jobs = {
					["$elemMatch"] = {
						Id = data.job,
					},
				},
			},
			options = {
				projection = {
					_id = 0,
					Mugshot = 1,
					First = 1,
					Last = 1,
					SID = 1,
					Callsign = 1,
					["Jobs.$"] = 1,
				},
			},
		}, function(success, results)
			cb(results or {})
		end)
	end)

	Callbacks:RegisterServerCallback("MDT:RosterSelect", function(source, data, cb)
		Database.Game:findOne({
			collection = "characters",
			query = {
				SID = data.person,
				Jobs = {
					["$elemMatch"] = {
						Id = data.job,
					},
				},
			},
			options = {
				projection = {
					_id = 0,
					Mugshot = 1,
					First = 1,
					Last = 1,
					SID = 1,
					Callsign = 1,
					MDTSuspension = 1,
					MDTSystemAdmin = 1,
					Qualifications = 1,
					Phone = 1,
					TimeClockedOn = 1,
					LastClockOn = 1,
					["Jobs.$"] = 1,
				},
			},
		}, function(success, results)
			if success and results then
				cb(results[1])
			else
				cb(false)
			end
		end)
	end)

	Callbacks:RegisterServerCallback("MDT:RevokeLicenseSuspension", function(source, data, cb)
		local char = Fetch:CharacterSource(source)

		if CheckMDTPermissions(source, 'REVOKE_LICENSE_SUSPENSIONS') then
			local canUpdate = false
			local licenseUpdate = {
				['$set'] = {}
			}

			for k, v in pairs(data.unsuspend) do
				if v then
					canUpdate = true

					licenseUpdate['$set'][string.format('Licenses.%s.Active', k)] = false
					licenseUpdate['$set'][string.format('Licenses.%s.Suspended', k)] = false

					if k == 'Drivers' then
						licenseUpdate['$set']['Licenses.Drivers.Active'] = true
						licenseUpdate['$set']['Licenses.Drivers.Points'] = 0
					end
				end
			end

			if canUpdate then
				Logger:Warn(
					"MDT",
					string.format(
						"%s %s (%s) Revoked License Suspensions: %s From State ID %s",
						char:GetData("First"),
						char:GetData("Last"),
						char:GetData("SID"),
						json.encode(data.unsuspend),
						data.SID
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

				Database.Game:findOneAndUpdate({
					collection = "characters",
					query = {
						SID = data.SID,
					},
					update = licenseUpdate,
					options = {
						returnDocument = 'after',
					}
				}, function(success, results)
					if success and results and results.SID and results.Licenses then
						local char = Fetch:SID(results.SID)
						if char then
							char:SetData('Licenses', results.Licenses)
						end
						cb(results.Licenses)
					else
						cb(false)
					end
				end)
			else
				cb(false)
			end
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("MDT:RemoveLicensePoints", function(source, data, cb)
		local char = Fetch:CharacterSource(source)

		if CheckMDTPermissions(source, 'REVOKE_LICENSE_SUSPENSIONS') and data.SID and data.newPoints then
			Logger:Warn(
				"MDT",
				string.format(
					"%s %s (%s) Changed License Points of State ID %s to %s",
					char:GetData("First"),
					char:GetData("Last"),
					char:GetData("SID"),
					data.SID,
					data.newPoints
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

			Database.Game:findOneAndUpdate({
				collection = "characters",
				query = {
					SID = data.SID,
				},
				update = {
					["$set"] = {
						['Licenses.Drivers.Points'] = data.newPoints
					}
				},
				options = {
					returnDocument = 'after',
				}
			}, function(success, results)
				if success and results and results.SID and results.Licenses then
					local char = Fetch:SID(results.SID)
					if char then
						char:SetData('Licenses', results.Licenses)
					end
					cb(results.Licenses)
				else
					cb(false)
				end
			end)
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("MDT:ClearCriminalRecord", function(source, data, cb)
		local char = Fetch:CharacterSource(source)

		if char and CheckMDTPermissions(source, 'EXPUNGEMENT') and data.SID then
			local u = MySQL.query.await("UPDATE mdt_reports_people SET expunged = ? WHERE type = ? AND sentenced = ? AND SID = ?", {
				1,
				"suspect",
				1,
				data.SID
			})

			if u and u.affectedRows > 0 then
				Logger:Warn(
					"MDT",
					string.format(
						"%s %s (%s) Expunged %s Incidents From State ID %s",
						char:GetData("First"),
						char:GetData("Last"),
						char:GetData("SID"),
						u.affectedRows,
						data.SID
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
			cb(true)
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("MDT:OpenEvidenceLocker", function(source, caseNum, cb)
		local myDuty = Player(source).state.onDuty
		if myDuty and (myDuty == "police" or myDuty == "government") then
			Callbacks:ClientCallback(source, "Inventory:Compartment:Open", {
				invType = 44,
				owner = ("evidencelocker:%s"):format(caseNum),
			}, function()
				Inventory:OpenSecondary(source, 44, ("evidencelocker:%s"):format(caseNum))
			end)
		end
	end)

	Callbacks:RegisterServerCallback("MDT:OpenPersonalLocker", function(source, data, cb)
		local char = Fetch:CharacterSource(source)
		if char and (Jobs.Permissions:HasJob(source, 'police') or Jobs.Permissions:HasJob(source, 'ems') or Jobs.Permissions:HasJob(source, 'prison')) then
			cb(true)

			Callbacks:ClientCallback(source, "Inventory:Compartment:Open", {
				invType = 45,
				owner = ("pdlocker:%s"):format(char:GetData('SID')),
			}, function()
				Inventory:OpenSecondary(source, 45, ("pdlocker:%s"):format(char:GetData('SID')))
			end)
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("MDT:DOCGetPrisoners", function(source, data, cb)
		cb(Jail:GetPrisoners())
	end)

	Callbacks:RegisterServerCallback("MDT:DOCReduceSentence", function(source, data, cb)
		local char = Fetch:CharacterSource(source)
		if char and CheckMDTPermissions(source, 'DOC_REDUCTION') and data.reduction then
			local target = Fetch:SID(data.SID)
			if target then
				if Jail:Reduce(target:GetData("Source"), data.reduction) then
					Logger:Warn(
						"MDT",
						string.format(
							"%s %s (%s) Reduced %s %s (%s) Prison Sentence By %s Months",
							char:GetData("First"),
							char:GetData("Last"),
							char:GetData("SID"),
							target:GetData("First"),
							target:GetData("Last"),
							target:GetData("SID"),
							data.reduction
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
	end)

	local vCooldowns = {}
	Callbacks:RegisterServerCallback("MDT:DOCRequestVisitation", function(source, data, cb)
		local char = Fetch:CharacterSource(source)
		if char and (vCooldowns[source] == nil or vCooldowns[source] <= os.time()) and data.SID then
			local target = Fetch:SID(data.SID)
			if target then
				local jailed = target:GetData("Jailed")
				if jailed and not jailed.Released then
					local dutyData = Jobs.Duty:GetDutyData("prison")
					if dutyData and dutyData.Count > 0 then
						EmergencyAlerts:Create(
							"DOC",
							"Visition Request from Lobby",
							"doc_alerts",
							{
								street1 = "Bolingbroke Penitentiary",
								x = 1852.444, 
								y = 2585.973, 
								z = 45.672
							},
							{ 
								details = string.format("Request to Visit %s %s (%s)", target:GetData("First"), target:GetData("Last"), target:GetData("SID")),
								icon = "info",
							},
							false,
							false,
							nil,
							false
						)
						vCooldowns[source] = os.time() + (3 * 60)
						cb({ success = true })
					else
						cb({
							success = false,
							message = "No DOC Available"
						})
					end
				else
					cb({ success = false })	
				end
			else
				cb({ success = false })	
			end
		else
			cb({
				success = false,
				message = "Please Wait Before Requesting Again"
			})
		end
	end)
end)
