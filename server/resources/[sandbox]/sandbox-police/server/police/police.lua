local _breached = {}
local _swabCounter = 1

local _generatedNames = {}

AddEventHandler("Police:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Database = exports["sandbox-base"]:FetchComponent("Database")
	Middleware = exports["sandbox-base"]:FetchComponent("Middleware")
	Callbacks = exports["sandbox-base"]:FetchComponent("Callbacks")
	Logger = exports["sandbox-base"]:FetchComponent("Logger")
	Jobs = exports["sandbox-base"]:FetchComponent("Jobs")
	Fetch = exports["sandbox-base"]:FetchComponent("Fetch")
	Chat = exports["sandbox-base"]:FetchComponent("Chat")
	Execute = exports["sandbox-base"]:FetchComponent("Execute")
	Police = exports["sandbox-base"]:FetchComponent("Police")
	Handcuffs = exports["sandbox-base"]:FetchComponent("Handcuffs")
	Inventory = exports["sandbox-base"]:FetchComponent("Inventory")
	Routing = exports["sandbox-base"]:FetchComponent("Routing")
	EmergencyAlerts = exports["sandbox-base"]:FetchComponent("EmergencyAlerts")
	MDT = exports["sandbox-base"]:FetchComponent("MDT")
	Radar = exports["sandbox-base"]:FetchComponent("Radar")
	Generator = exports["sandbox-base"]:FetchComponent("Generator")
	Vehicles = exports["sandbox-base"]:FetchComponent("Vehicles")
	Ped = exports["sandbox-base"]:FetchComponent("Ped")
	Doors = exports["sandbox-base"]:FetchComponent("Doors")
	Robbery = exports["sandbox-base"]:FetchComponent("Robbery")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["sandbox-base"]:RequestDependencies("Police", {
		"Database",
		"Middleware",
		"Callbacks",
		"Logger",
		"Jobs",
		"Fetch",
		"Chat",
		"Execute",
		"Police",
		"Handcuffs",
		"Routing",
		"EmergencyAlerts",
		"MDT",
		"Radar",
		"Generator",
		"Vehicles",
		"Ped",
		"Doors",
		"Robbery"
	}, function(error)
		if #error > 0 then
			return
		end -- Do something to handle if not all dependencies loaded
		RetrieveComponents()
		PoliceItems()
		RegisterCommands()

		GlobalState["PrisonLockdown"] = false
		GlobalState["PrisonCellsLocked"] = false
		GlobalState["PoliceCars"] = Config.PoliceCars
		GlobalState["EMSCars"] = Config.EMSCars

		for k, v in pairs(Config.Armories) do
			Logger:Trace("Police", string.format("Registering Poly Inventory ^2%s^7 For ^3%s^7", v.id, v.name))
			Inventory.Poly:Create(v)
		end

		Inventory.Items:RegisterUse("spikes", "Police", function(source, slot, itemData)
			if GetVehiclePedIsIn(GetPlayerPed(source)) == 0 then
				Callbacks:ClientCallback(source, "Police:DeploySpikes", {}, function(data)
					if data ~= nil then
						TriggerClientEvent("Police:Client:AddDeployedSpike", -1, data.positions, data.h, source)
						
						local newValue = slot.CreateDate - math.ceil(itemData.durability / 4)
						if (os.time() - itemData.durability >= newValue) then
							Inventory.Items:RemoveId(slot.Owner, slot.invType, slot)
						else
							Inventory:SetItemCreateDate(
								slot.id,
								newValue
							)
						end

						Execute:Client(source, "Notification", "Success", "You Deployed Spikes (Despawn In 20s)")
					end
				end)
			end
		end)

		Callbacks:RegisterServerCallback("Police:GSRTest", function(source, data, cb)
			local char = Fetch:CharacterSource(source)

			local pState = Player(source).state
			if pState.onDuty == "police" or pState.onDuty == "ems" then
				local target = Player(data)
				if target ~= nil then
					if target.state?.GSR ~= nil and (os.time() - target.state.GSR) <= (60 * 60) then
						Chat.Send.System:Single(source, "GSR: Positive")
					else
						Chat.Send.System:Single(source, "GSR: Negative")
					end
				else
					Execute:Client(source, "Notification", "Error", "Invalid Target")
				end
			end
		end)

		Callbacks:RegisterServerCallback("Prison:SetLockdown", function(source, data, cb)
			local char = Fetch:CharacterSource(source)
			local pState = Player(source).state
			-- add PD Alert
			if char and (pState.onDuty == "prison" or pState.onDuty == "police") then
				GlobalState["PrisonLockdown"] = not GlobalState["PrisonLockdown"]
				GlobalState["PrisonCellsLocked"] = GlobalState["PrisonLockdown"]
				for i = 1, 27 do
					Doors:SetLock(string.format("prison_cell_%s", i), GlobalState["PrisonCellsLocked"])
				end
				Execute:Client(source, "Notification", "Info", string.format("Cell Door State: %s", GlobalState["PrisonCellsLocked"]), GlobalState["PrisonCellsLocked"] and "Locked" or "Unlocked")
				cb(true, GlobalState["PrisonLockdown"])
			else
				cb(false)
			end
		end)

		Callbacks:RegisterServerCallback("Prison:SetCellState", function(source, data, cb)
			local char = Fetch:CharacterSource(source)
			local pState = Player(source).state

			if char and (pState.onDuty == "prison" or pState.onDuty == "police") then
				GlobalState["PrisonCellsLocked"] = not GlobalState["PrisonCellsLocked"]
				for i = 1, 27 do
					Doors:SetLock(string.format("prison_cell_%s", i), GlobalState["PrisonCellsLocked"])
				end
				Execute:Client(source, "Notification", "Info", string.format("Cell Door State: %s", GlobalState["PrisonCellsLocked"]), GlobalState["PrisonCellsLocked"] and "Locked" or "Unlocked")
				cb(true, GlobalState["PrisonCellsLocked"])
			else
				cb(false)
			end
		end)

		Callbacks:RegisterServerCallback("Police:BACTest", function(source, data, cb)
			local char = Fetch:CharacterSource(source)

			local pState = Player(source).state
			if pState.onDuty == "police" or pState.onDuty == "ems" then
				local target = Player(data)
				if target ~= nil then
					-- Great Code Kapp
					if target.state.isDrunk and target.state.isDrunk > 0 then
						if target.state.isDrunk >= 70 then
							Chat.Send.System:Single(source, "BAC: 0.22% - Above Limit")
						elseif target.state.isDrunk >= 40 then
							Chat.Send.System:Single(source, "BAC: 0.13% - Above Limit")
						elseif target.state.isDrunk >= 30 then
							Chat.Send.System:Single(source, "BAC: 0.1% - Above Limit")
						elseif target.state.isDrunk >= 25 then
							Chat.Send.System:Single(source, "BAC: 0.085% - Above Limit")
						elseif target.state.isDrunk >= 15 then
							Chat.Send.System:Single(source, "BAC: 0.04% - Below Limit")
						else
							Chat.Send.System:Single(source, "BAC: 0.025% - Below Limit")
						end
					else
						Chat.Send.System:Single(source, "BAC: Not Drunk")
					end
				else
					Execute:Client(source, "Notification", "Error", "Invalid Target")
				end
			end

			cb(true)
		end)

		Callbacks:RegisterServerCallback("Police:DNASwab", function(source, data, cb)
			local char = Fetch:CharacterSource(source)

			local pState = Player(source).state
			if char and pState.onDuty == "police" or pState.onDuty == "ems" then
				local tChar = Fetch:CharacterSource(data)
				if tChar ~= nil then

					local coords = GetEntityCoords(GetPlayerPed(data))
					_swabCounter += 1

					Inventory:AddItem(char:GetData('SID'), 'evidence-dna', 1, {
						EvidenceType = 'blood',
						EvidenceId = string.format('%s-%s', os.date('%d%m%y-%H%M%S', os.time()), 950000 + _swabCounter),
						EvidenceCoords = { x = coords.x, y = coords.y, z = coords.z },
						EvidenceDNA = tChar:GetData("SID"),
						EvidenceSwab = true,
						EvidenceDegraded = false,
					}, 1)

					return
				end

				Execute:Client(source, "Notification", "Error", "Invalid Target")
			end
		end)

		Callbacks:RegisterServerCallback("Police:Breach", function(source, data, cb)
			local char = Fetch:CharacterSource(source)

			if (data?.type == nil or data?.property == nil) then
				cb(false)
				return
			end

			if Player(source).state.onDuty == "police" then
				_breached[data.type] = _breached[data.type] or {}

				if data.type == "property" then
					if (_breached[data.type][data.property] or 0) > os.time() then
						cb(true)
						Execute:Client(source, "Properties", "Enter", data.property)
					else
						Callbacks:ClientCallback(source, "Police:Breach", {}, function(s)
							if s then
								_breached[data.type][data.property] = os.time() + (60 * 10)
								Execute:Client(source, "Properties", "Enter", data.property)
								cb(true)
							else
								cb(false)
							end
						end)
					end
				elseif data.type == "robbery" then
					if (_breached[data.type][data.property] or 0) > os.time() then
						TriggerEvent("Labor:Server:HouseRobbery:Breach", source, data.property)

						cb(true)
					else
						Callbacks:ClientCallback(source, "Police:Breach", {}, function(s)
							if s then
								TriggerEvent("Labor:Server:HouseRobbery:Breach", source, data.property)

								cb(true)
							else
								cb(false)
							end
						end)
					end
				elseif data.type == "apartment" then
					local aptTier = Fetch:GetOfflineData(data.property, "Apartment")

					if aptTier ~= nil then
						local id = aptTier or 1
						if id == aptTier then
							if (_breached[data.type][data.property] or 0) > os.time() then
								Execute:Client(source, "Apartment", "Enter", aptTier, data.property)

								return cb(data.property)
							else
								Callbacks:ClientCallback(source, "Police:Breach", {}, function(s)
									if s then
										_breached[data.type][data.property] = os.time() + (60 * 10)
										Execute:Client(source, "Apartment", "Enter", aptTier, data.property)

										return cb(data.property)
									else
										cb(false)
									end
								end)
							end
						else
							Execute:Client(source, "Notification", "Error", "Target Does Not Reside Here")
							return cb(false)
						end
					else
						Execute:Client(source, "Notification", "Error", "Target Not Online")
						return cb(false)
					end
				end
			else
				cb(false)
			end
		end)

		Callbacks:RegisterServerCallback("Police:AccessRifleRack", function(source, data, cb)
			local char = Fetch:CharacterSource(source)
			if char ~= nil then
				local myDuty = Player(source).state.onDuty
				if myDuty == 'police' then
					local veh = GetVehiclePedIsIn(GetPlayerPed(source))
					if veh ~= 0 then
						if Config.PoliceCars[GetEntityModel(veh)] then
							local entState = Entity(veh).state
							if Vehicles.Keys:Has(source, entState.VIN, 'police') then
								Callbacks:ClientCallback(source, "Inventory:Compartment:Open", {
									invType = 3,
									owner = ("pdrack:%s"):format(entState.VIN),
								}, function()
									Inventory:OpenSecondary(source, 3, ("pdrack:%s"):format(entState.VIN))
								end)
							else
								Execute:Client(source, "Notification", "Error", "Can't Access The Locked Compartment")
							end
						else
							Execute:Client(source, "Notification", "Error", "Vehicle Not Outfitted With A Secured Compartment")
						end
					else
						Execute:Client(source, "Notification", "Error", "Not In A Vehicle")
					end
				elseif myDuty == 'prison' then
					local veh = GetVehiclePedIsIn(GetPlayerPed(source))
					if veh ~= 0 then
						if Config.PoliceCars[GetEntityModel(veh)] then
							local entState = Entity(veh).state
							if Vehicles.Keys:Has(source, entState.VIN, 'prison') then
								Callbacks:ClientCallback(source, "Inventory:Compartment:Open", {
									invType = 999,
									owner = ("pdrack:%s"):format(entState.VIN),
								}, function()
									Inventory:OpenSecondary(source, 999, ("pdrack:%s"):format(entState.VIN))
								end)
							else
								Execute:Client(source, "Notification", "Error", "Can't Access The Locked Compartment")
							end
						else
							Execute:Client(source, "Notification", "Error", "Vehicle Not Outfitted With A Secured Compartment")
						end
					else
						Execute:Client(source, "Notification", "Error", "Not In A Vehicle")
					end
				end
			end
		end)

		Callbacks:RegisterServerCallback("Police:RemoveMask", function(source, data, cb)
			local char = Fetch:CharacterSource(source)
			if char ~= nil and Player(source).state.onDuty == "police" then
				local tChar = Fetch:CharacterSource(data)
				if tChar ~= nil then
					Ped.Mask:Unequip(data)
				end
			end
		end)

		Callbacks:RegisterServerCallback("Police:GetRadioChannel", function(source, data, cb)
			local char = Fetch:CharacterSource(source)
			if char ~= nil and Player(source).state.onDuty == "police" then
				local tState = Player(tonumber(data)).state
				if tState and tState?.onRadio then
					Chat.Send.System:Single(source, string.format("Radio Frequency: %s", tState.onRadio))
				else
					Chat.Send.System:Single(source, string.format("Not On Radio"))
				end
			end
		end)
	end)
end)

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["sandbox-base"]:RegisterComponent("Police", POLICE)
end)

RegisterNetEvent("Police:Server:Cuff", function()
	local src = source
	local char = Fetch:CharacterSource(src)
	local pState = Player(src).state
	if char ~= nil and (pState.onDuty == "police" or pState.onDuty == "prison")then
		Handcuffs:HardCuff(src)
	end
end)

RegisterNetEvent("Police:Server:Uncuff", function()
	local src = source
	local char = Fetch:CharacterSource(src)
	local pState = Player(src).state
	if char ~= nil and (pState.onDuty == "police" or pState.onDuty == "prison")then
		Handcuffs:Uncuff(src)
	end
end)

RegisterNetEvent("Police:Server:RunPlate", function(plate, VIN, model)
	local src = source
	local char = Fetch:CharacterSource(src)
	if char ~= nil then
		local myDuty = Player(src).state.onDuty
		if myDuty and myDuty == "police" then
			Police:RunPlate(src, plate, {
				VIN = VIN,
				model = model
			})
		end
	end
end)

RegisterNetEvent("Police:Server:Panic", function(isAlpha)
	local src = source
	local char = Fetch:CharacterSource(src)
	local pState = Player(src).state
	if pState.onDuty == "police" then
		local coords = GetEntityCoords(GetPlayerPed(src))
		Callbacks:ClientCallback(src, "EmergencyAlerts:GetStreetName", coords, function(location)
			if isAlpha then
				EmergencyAlerts:Create("13-A", "Officer Down", {"police_alerts", "ems_alerts"}, location, {
					icon = "circle-exclamation",
					details = string.format(
						"%s - %s %s | %s",
						char:GetData("Callsign"),
						char:GetData("First"),
						char:GetData("Last"),
						pState?.onRadio and string.format("Radio Freq: %s", pState.onRadio) or "Not On Radio"
					)
				}, true, {
					icon = 303,
					size = 1.2,
					color = 26,
					duration = (60 * 10),
				}, 1)
			else
				EmergencyAlerts:Create("13-B", "Officer Down", {"police_alerts", "ems_alerts"}, location, {
					icon = "circle-exclamation",
					details = string.format(
						"%s - %s %s",
						char:GetData("Callsign"),
						char:GetData("First"),
						char:GetData("Last"),
						pState?.onRadio and string.format("Radio Freq: %s", pState.onRadio) or "Not On Radio"
					)
				}, false, {
					icon = 303,
					size = 0.9,
					color = 26,
					duration = (60 * 10),
				}, 1)
			end
		end)
	elseif Player(src).state.onDuty == "prison" then
		local coords = GetEntityCoords(GetPlayerPed(src))
		Callbacks:ClientCallback(src, "EmergencyAlerts:GetStreetName", coords, function(location)
			if isAlpha then
				EmergencyAlerts:Create("13-A", "Corrections Officer Down", {"police_alerts", "doc_alerts", "ems_alerts"}, location, {
					icon = "circle-exclamation",
					details = string.format(
						"%s - %s %s | %s",
						char:GetData("Callsign"),
						char:GetData("First"),
						char:GetData("Last"),
						pState?.onRadio and string.format("Radio Freq: %s", pState.onRadio) or "Not On Radio"
					)
				}, true, {
					icon = 303,
					size = 1.2,
					color = 26,
					duration = (60 * 10),
				}, 1)
			else
				EmergencyAlerts:Create("13-B", "Corrections Officer Down", {"police_alerts", "doc_alerts", "ems_alerts"}, location, {
					icon = "circle-exclamation",
					details = string.format(
						"%s - %s %s | %s",
						char:GetData("Callsign"),
						char:GetData("First"),
						char:GetData("Last"),
						pState?.onRadio and string.format("Radio Freq: %s", pState.onRadio) or "Not On Radio"
					)
				}, false, {
					icon = 303,
					size = 0.9,
					color = 26,
					duration = (60 * 10),
				}, 1)
			end
		end)
	end
end)

RegisterNetEvent('Police:Server:Tackle', function(target)
	local src = source
	if #(GetEntityCoords(GetPlayerPed(src)) - GetEntityCoords(GetPlayerPed(target))) < 5.0 then
		TriggerClientEvent('Police:Client:GetTackled', target)
	end
end)

RegisterNetEvent("Prison:Server:Lockdown:AlertPolice", function(state)
	local src = source
	if state then
		Robbery:TriggerPDAlert(src, GetEntityCoords(GetPlayerPed(src)), "10-98", "Bolingbroke Penitentiary Lockdown", {
			icon = 526,
			size = 0.9,
			color = 1,
			duration = (60 * 5),
		})
	end
	TriggerClientEvent("Prison:Client:JailAlarm", -1, state)
end)

POLICE = {
	IsInBreach = function(self, source, type, id, extraCheck)
		if Player(source)?.state?.onDuty == "police" and (not extraCheck or Jobs.Permissions:HasPermissionInJob(source, 'police', 'PD_RAID')) then
			if _breached[type] and _breached[type][id] and ((_breached[type][id] or 0) > os.time()) then
				if extraCheck then
					local char = Fetch:CharacterSource(source)
					if char then
						Logger:Warn(
							"Police",
							string.format(
								"Police Raid - Character %s %s (%s) - Accessing Property %s (%s)",
								char:GetData("First"),
								char:GetData("Last"),
								char:GetData("SID"),
								id,
								type
							),
							{
								console = true,
								discord = {
									embed = true,
									type = 'info',
								}
							}
						)
					end
				end

				return true
			end
		end
	
		return false
	end,
	RunPlate = function(self, source, plate, wasEntity)
		Database.Game:find({
			collection = "vehicles",
			query = {
				["$or"] = {
					{
						RegisteredPlate = plate,
					},
					{
						FakePlate = plate,
					}
				},
			},
		}, function(success, results)
			if not success or #results == 0 then
				local stolen = Radar:CheckPlate(plate)
				if stolen then
					if not _generatedNames[plate] then
						_generatedNames[plate] = string.format(
							"%s %s",
							Generator.Name:First(),
							Generator.Name:Last()
						)
					end

					if wasEntity then
						Chat.Send.Services:Dispatch(
							source,
							string.format(
								"<b>Owner</b>: %s<br /><b>VIN</b>: %s<br /><b>Make & Model</b>: %s<br /><b>Plate</b>: %s<br /><b>Class</b>: Unknown<br /><br />%s",
								_generatedNames[plate],
								wasEntity.VIN,
								wasEntity.model,
								plate,
								stolen
							)
						)
					else
						Chat.Send.Services:Dispatch(
							source,
							string.format(
								"<b>Owner</b>: %s<br /><b>VIN</b>: Unknown<br /><b>Make & Model</b>: Unknown<br /><b>Plate</b>: %s<br /><b>Class</b>: Unknown<br /><br />%s",
								_generatedNames[plate],
								plate,
								stolen
							)
						)
					end
				elseif wasEntity then
					if not _generatedNames[plate] then
						_generatedNames[plate] = string.format(
							"%s %s",
							Generator.Name:First(),
							Generator.Name:Last()
						)
					end

					Chat.Send.Services:Dispatch(
						source,
						string.format(
							"<b>Owner</b>: %s<br /><b>VIN</b>: %s<br /><b>Make & Model</b>: %s<br /><b>Plate</b>: %s<br /><b>Class</b>: Unknown",
							_generatedNames[plate],
							wasEntity.VIN,
							wasEntity.model,
							plate
						)
					)
				else
					Chat.Send.Services:Dispatch(source, "No Plate Match")
				end
				return
			end

			if #results > 1 then
				Chat.Send.Services:Dispatch(source, "Multiple Matches, Please Use MDT")
			else
				local vehicle = results[1]
				if vehicle.FakePlate and vehicle.FakePlateData then
					local stolen = Radar:CheckPlate(plate)
					if stolen then
						Chat.Send.Services:Dispatch(
							source,
							string.format(
								"<b>Owner</b>: %s (%s)<br /><b>VIN</b>: %s<br /><b>Make & Model</b>: %s<br /><b>Plate</b>: %s<br /><b>Class</b>: Unknown<br /><br />%s",
								vehicle.FakePlateData.OwnerName,
								vehicle.FakePlateData.SID,
								vehicle.FakePlateData.VIN,
								vehicle.FakePlateData.Vehicle or string.format('%s %s', vehicle.Make, vehicle.Model),
								vehicle.FakePlate,
								stolen
							)
						)
					else
						Chat.Send.Services:Dispatch(
							source,
							string.format(
								"<b>Owner</b>: %s (%s)<br /><b>VIN</b>: %s<br /><b>Make & Model</b>: %s<br /><b>Plate</b>: %s<br /><b>Class</b>: Unknown",
								vehicle.FakePlateData.OwnerName,
								vehicle.FakePlateData.SID,
								vehicle.FakePlateData.VIN,
								vehicle.FakePlateData.Vehicle or string.format('%s %s', vehicle.Make, vehicle.Model),
								vehicle.FakePlate
							)
						)
					end
				else
					local ownerName = "Unknown"
					if vehicle.Owner.Type == 0 then
						local owner = MDT.People:View(vehicle.Owner.Id)

						ownerName = string.format("%s %s", owner.First, owner.Last)
					elseif vehicle.Owner.Type == 1 then
						local jobData = Jobs:DoesExist(vehicle.Owner.Id, vehicle.Owner.Workplace)
						if jobData then
							if jobData.Workplace then
								ownerName = string.format('%s (%s)', jobData.Name, jobData.Workplace.Name)
							else
								ownerName = jobData.Name
							end
						end
					end
	
					local stolen = false
					if vehicle.Flags then
						for k, v in ipairs(vehicle.Flags) do
							if v.Type == "stolen" then
								stolen = v.Description
								break
							end
						end
					end
	
					if stolen then
						Chat.Send.Services:Dispatch(
							source,
							string.format(
								"<b>Owner</b>: %s (%s)<br /><b>VIN</b>: %s<br /><b>Make & Model</b>: %s %s<br /><b>Plate</b>: %s<br /><b>Class</b>: %s<br /><br /><b>Vehicle Reported Stolen</b>: %s",
								ownerName,
								vehicle.Owner.Id,
								vehicle.VIN,
								vehicle.Make,
								vehicle.Model,
								vehicle.RegisteredPlate,
								vehicle.Class,
								stolen
							)
						)
					else
						Chat.Send.Services:Dispatch(
							source,
							string.format(
								"Owner: %s (%s)\nVIN: %s\nMake & Model: %s %s\nPlate: %s\nClass: %s",
								ownerName,
								vehicle.Owner.Id,
								vehicle.VIN,
								vehicle.Make,
								vehicle.Model,
								vehicle.RegisteredPlate,
								vehicle.Class
							)
						)
					end
				end
			end
		end)
	end,
	IsPdCar = function(self, model)
		return Config.PoliceCars[model]
	end,
	IsEMSCar = function(self, model)
		return Config.EMSCars[model]
	end,
}

RegisterNetEvent("Police:Server:RemoveSpikes", function()
	TriggerClientEvent("Police:Client:RemoveSpikes", -1, source)
end)

RegisterNetEvent("Police:Server:Slimjim", function()
	local src = source

	if Player(src).state.onDuty == "police" then
		Callbacks:ClientCallback(src, "Vehicles:Slimjim", true, function()
	
		end)
	end
end)