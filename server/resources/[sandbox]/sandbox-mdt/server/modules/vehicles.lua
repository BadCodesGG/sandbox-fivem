function GetVehicleOwnerData(sid)
	local p = promise.new()
	Database.Game:findOne({
		collection = "characters",
		query = {
			SID = sid,
		},
		options = {
			projection = {
				_id = 0,
				First = 1,
				Last = 1,
				SID = 1,
			},
		},
	}, function(success, character)
		if success then
			p:resolve(character[1])
		else
			p:resolve(nil)
		end
	end)

	return Citizen.Await(p)
end

_MDT.Vehicles = {
	Search = function(self, term, page, perPage)
		local p = promise.new()

		local skip = 0
		if page > 1 then
			skip = perPage * (page - 1)
		end

		local orQuery = {
			{
				VIN = {
					['$regex'] = term,
					['$options'] = "i",
				}
			},
			{
				RegisteredPlate = {
					["$regex"] = term,
					["$options"] = "i",
				},
			},
			{
				["$expr"] = {
					["$regexMatch"] = {
						input = {
							["$concat"] = { "$Make", " ", "$Model" },
						},
						regex = term,
						options = "i",
					},
				},
			},
		}

		if term and term:sub(1, 5) == "SID: " then
			local sid = tonumber(term:sub(6, #term))
			if sid then
				orQuery = {
					{
						['Owner.Type'] = 0,
						['Owner.Id'] = sid
					}
				}
			end
		end

		Database.Game:find({
			collection = "vehicles",
			query = {
				["$or"] = orQuery,
			},
			options = {
				skip = skip,
				limit = perPage + 1,
			},
		}, function(success, results)
			if not success then
				p:resolve(false)
				return
			end

			if #results > perPage then -- There is more results for the next pages
				table.remove(results)
				pageCount = page + 1
			end

			p:resolve({
				data = results,
				pages = pageCount,
			})
		end)
		return Citizen.Await(p)
	end,
	View = function(self, VIN)
		local p = promise.new()
		Database.Game:findOne({
			collection = "vehicles",
			query = {
				VIN = VIN,
			},
		}, function(success, results)
			if not success or #results <= 0 then
				p:resolve(false)
				return
			end
			local vehicle = results[1]

			if vehicle.Owner then
				if vehicle.Owner.Type == 0 then
					vehicle.Owner.Person = GetVehicleOwnerData(vehicle.Owner.Id)
				elseif vehicle.Owner.Type == 1 or vehicle.Owner.Type == 2 then
					local jobData = Jobs:DoesExist(vehicle.Owner.Id, vehicle.Owner.Workplace)
					if jobData then
						if jobData.Workplace then
							vehicle.Owner.JobName = string.format('%s (%s)', jobData.Name, jobData.Workplace.Name)
						else
							vehicle.Owner.JobName = jobData.Name
						end
					end
				end

				if vehicle.Owner.Type == 2 then
					vehicle.Owner.JobName = vehicle.Owner.JobName .. " (Dealership Buyback)"
				end
			end

			if vehicle.Storage then
				if vehicle.Storage.Type == 0 then
					vehicle.Storage.Name = Vehicles.Garages:Impound().name
				elseif vehicle.Storage.Type == 1 then
					vehicle.Storage.Name = Vehicles.Garages:Get(vehicle.Storage.Id).name
				elseif vehicle.Storage.Type == 2 then
					local prop = Properties:Get(vehicle.Storage.Id)
					vehicle.Storage.Name = prop?.label
				end
			end

			if vehicle.RegisteredPlate then
				local flagged = Radar:CheckPlate(vehicle.RegisteredPlate)
				if flagged ~= "Vehicle Flagged in MDT" then
					vehicle.RadarFlag = flagged
				end
			end

			p:resolve(vehicle)
		end)
		return Citizen.Await(p)
	end,
	Flags = {
		Add = function(self, VIN, data, plate)
			local p = promise.new()
			Database.Game:updateOne({
				collection = "vehicles",
				query = {
					VIN = VIN,
				},
				update = {
					["$push"] = {
						Flags = data,
					},
				},
			}, function(success, result)
				if success and data.Type and data.Description and plate then
					Radar:AddFlaggedPlate(plate, 'Vehicle Flagged in MDT')
				end
				p:resolve(success)
			end)
			return Citizen.Await(p)
		end,
		Remove = function(self, VIN, flag, plate, removeRadarFlag)
			local p = promise.new()
			Database.Game:updateOne({
				collection = "vehicles",
				query = {
					VIN = VIN,
				},
				update = {
					["$pull"] = {
						Flags = {
							Type = flag
						},
					},
				},
			}, function(success, result)
				p:resolve(success)

				if success and plate and removeRadarFlag then
					local isFlagged = Radar:CheckPlate(plate)
					if isFlagged == "Vehicle Flagged in MDT" then
						Radar:RemoveFlaggedPlate(plate)
					end
				end
			end)
			return Citizen.Await(p)
		end,
	},
	UpdateStrikes = function(self, VIN, strikes)
		local p = promise.new()
		Database.Game:updateOne({
			collection = "vehicles",
			query = {
				VIN = VIN,
			},
			update = {
				["$set"] = {
					Strikes = strikes,
				},
			},
		}, function(success, result)
			p:resolve(success)
		end)
		return Citizen.Await(p)
	end,
	GetStrikes = function(self, VIN)
		local p = promise.new()
		Database.Game:findOne({
			collection = "vehicles",
			query = {
				VIN = VIN,
			},
			options = {
				projection = {
					VIN = 1,
					Strikes = 1,
					RegisteredPlate = 1,
				}
			}
		}, function(success, results)
			if success then
				local veh = results[1]
				local strikes = 0
				if veh and veh.Strikes and #veh.Strikes > 0 then
					strikes = #veh.Strikes
				end

				p:resolve(strikes)
			else
				p:resolve(0)
			end
		end)

		return Citizen.Await(p)
	end
}

AddEventHandler("MDT:Server:RegisterCallbacks", function()
	Callbacks:RegisterServerCallback("MDT:Search:vehicle", function(source, data, cb)
		if CheckMDTPermissions(source, false) then
			cb(MDT.Vehicles:Search(data.term, data.page, data.perPage))
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("MDT:View:vehicle", function(source, data, cb)
		if CheckMDTPermissions(source, false) then
			cb(MDT.Vehicles:View(data))
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("MDT:Create:vehicle-flag", function(source, data, cb)
		if CheckMDTPermissions(source, false, 'police') then
			cb(MDT.Vehicles.Flags:Add(data.parent, data.doc, data.plate))
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("MDT:Delete:vehicle-flag", function(source, data, cb)
		if CheckMDTPermissions(source, false, 'police') then
			cb(MDT.Vehicles.Flags:Remove(data.parent, data.id, data.plate, data.removeRadarFlag))
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("MDT:Update:vehicle-strikes", function(source, data, cb)
		if CheckMDTPermissions(source, false, 'police') then
			cb(MDT.Vehicles:UpdateStrikes(data.VIN, data.strikes))
		else
			cb(false)
		end
	end)
end)
