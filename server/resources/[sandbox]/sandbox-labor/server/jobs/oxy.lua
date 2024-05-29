local _JOB = "OxyRun"

local _joiners = {}
local _sellers = {}
local _cooldowns = {}

local _oxyCars = {}

local _loot = {}

local _wasDoingIllegalShit = {}

local _availableRuns = 10
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000 * 60 * 60)
		_availableRuns += math.random(2, 5)
	end
end)

AddEventHandler("Labor:Server:Startup", function()
	WaitList:Create("oxyrun", "individual_time", {
		event = "Labor:Server:OxyRun:Queue",
		delay = (1000 * 60) * 5,
		-- min = 10000,
		-- max = 12000,
	})

	Chat:RegisterAdminCommand("addoxyrun", function(source, args, rawCommand)
		if tonumber(args[1]) then
			_availableRuns = _availableRuns + tonumber(args[1])
		else
			return Chat.Send.System:Single(source, "Invalid Amount")
		end
	end, {
		help = "Add Available Oxy Runs",
		params = {
			{
				name = "Number",
				help = "Number of Oxy Runs To Add To Available Pool",
			},
		},
	}, 1)

	Callbacks:RegisterServerCallback("OxyRun:Enable", function(source, data, cb)
		local char = Fetch:CharacterSource(source)
		local states = char:GetData("States") or {}
		if not hasValue(states, "SCRIPT_OXY_RUN") then
			table.insert(states, "SCRIPT_OXY_RUN")
			char:SetData("States", states)
			Phone.Notification:Add(
				source,
				"New Job Available",
				"A new job is available, check it out.",
				os.time(),
				6000,
				"labor",
				{}
			)
		end
	end)

	Callbacks:RegisterServerCallback("OxyRun:Disable", function(source, data, cb)
		local char = Fetch:CharacterSource(source)
		local states = char:GetData("States") or {}
		if hasValue(states, "SCRIPT_OXY_RUN") then
			for k, v in ipairs(states) do
				if v == "SCRIPT_OXY_RUN" then
					table.remove(states, k)
					char:SetData("States", states)
					break
				end
			end
		end
	end)

	Callbacks:RegisterServerCallback("OxyRun:EnteredCar", function(source, data, cb)
		local char = Fetch:CharacterSource(source)
		if
			char:GetData("TempJob") == _JOB
			and _joiners[source] ~= nil
			and _sellers[_joiners[source]] ~= nil
			and _sellers[_joiners[source]].state == 1
		then
			if not Vehicles.Owned:GetActive(data.VIN) then
				if #Inventory:GetFreeSlotNumbers(data.VIN, 4, data.Class, data.Model) >= 10 then
					local exp = os.time() + (60 * 20)
					_cooldowns[char:GetData("ID")] = exp
					if isWorkgroup then
						if #members > 0 then
							for k, v in ipairs(members) do
								_cooldowns[v.CharID] = exp
							end
						end
					end

					_sellers[_joiners[source]].vehicle = data
					_sellers[_joiners[source]].state = 2
					Labor.Offers:Task(_joiners[source], _JOB, "Go To The Pickup Location")

					Citizen.CreateThread(function()
						local ending = false
						local ent = NetworkGetEntityFromNetworkId(_sellers[_joiners[source]].vehicle.NetId)
						while _sellers[_joiners[source]] ~= nil do
							if not ending then
								if ent ~= nil and not DoesEntityExist(ent) then
									Logger:Trace("OxyRun", "Vehicle No Longer Exists")
									ending = true
									Labor.Workgroups:SendEvent(
										_joiners[source],
										string.format("OxyRun:Client:%s:VehiclePoofed", _joiners[source])
									)
								end
							end
							Citizen.Wait(10)
						end
					end)

					Labor.Workgroups:SendEvent(
						_joiners[source],
						string.format("OxyRun:Client:%s:StartPickup", _joiners[source]),
						_oxyPickups[_selectedOxyPickup],
						data
					)
				else
					Phone.Notification:Add(
						_joiners[source],
						"Job Activity",
						"Not Enough Room In This Vehicles Trunk",
						os.time(),
						6000,
						"labor",
						{}
					)
				end
			end
		end
	end)

	Callbacks:RegisterServerCallback("OxyRun:EnteredPickup", function(source, data, cb)
		local char = Fetch:CharacterSource(source)
		if
			char:GetData("TempJob") == _JOB
			and _joiners[source] ~= nil
			and _sellers[_joiners[source]] ~= nil
			and (_sellers[_joiners[source]].state == 2 or _sellers[_joiners[source]].state == 3)
		then
			if _sellers[_joiners[source]].state == 2 then
				_sellers[_joiners[source]].state = 3
				Labor.Offers:Start(_joiners[source], _JOB, "Receive Product", 10)
			end
			Labor.Workgroups:SendEvent(
				_joiners[source],
				string.format("OxyRun:Client:%s:EligiblePickup", _joiners[source])
			)
		end
	end)

	Callbacks:RegisterServerCallback("OxyRun:CancelPickup", function(source, data, cb)
		local char = Fetch:CharacterSource(source)
		if char:GetData("TempJob") == _JOB and _joiners[source] ~= nil and _sellers[_joiners[source]] ~= nil then
			Inventory.Items:Remove(_sellers[_joiners[source]].vehicle.VIN, 4, "contraband", false)
		end
	end)

	Callbacks:RegisterServerCallback("OxyRun:CheckPickup", function(source, data, cb)
		local char = Fetch:CharacterSource(source)
		if
			char:GetData("TempJob") == _JOB
			and _joiners[source] ~= nil
			and _sellers[_joiners[source]] ~= nil
			and _sellers[_joiners[source]].state == 3
		then
			if
				#Inventory:GetFreeSlotNumbers(
					_sellers[_joiners[source]].vehicle.VIN,
					4,
					_sellers[_joiners[source]].vehicle.Class,
					_sellers[_joiners[source]].vehicle.Model
				) >= 10
			then
				cb(true)
			else
				cb(false)
			end
		end
	end)

	Callbacks:RegisterServerCallback("OxyRun:PickupProduct", function(source, data, cb)
		local char = Fetch:CharacterSource(source)

		if
			char:GetData("TempJob") == _JOB
			and _joiners[source] ~= nil
			and _sellers[_joiners[source]] ~= nil
			and _sellers[_joiners[source]].state == 3
		then
			local veh = GetVehiclePedIsIn(GetPlayerPed(source))
			local vEnt = Entity(veh).state
			if
				#Inventory:GetFreeSlotNumbers(
					vEnt.VIN,
					4,
					_sellers[_joiners[source]].vehicle.Class,
					_sellers[_joiners[source]].vehicle.Model
				) >= 1
			then
				Inventory:AddItem(
					vEnt.VIN,
					"contraband",
					1,
					{},
					4,
					_sellers[_joiners[source]].vehicle.Class,
					_sellers[_joiners[source]].vehicle.Model,
					veh
				)

				local exp = os.time() + (60 * 20)
				_cooldowns[char:GetData("ID")] = exp
				if _sellers[_joiners[source]].isWorkgroup then
					if #_sellers[_joiners[source]].members > 0 then
						for k, v in ipairs(_sellers[_joiners[source]].members) do
							_cooldowns[v.CharID] = exp
						end
					end
				end

				if Labor.Offers:Update(_joiners[source], _JOB, 1, true) then
					_sellers[_joiners[source]].state = 4
					local rand = math.random(#_oxyLocations)
					_sellers[_joiners[source]].location = rand

					Labor.Offers:Task(_joiners[source], _JOB, "Head To The Sale Spot")
					Labor.Workgroups:SendEvent(
						_joiners[source],
						string.format("OxyRun:Client:%s:StartSale", _joiners[source]),
						_oxyLocations[rand]
					)
				end
			else
			end
		end
	end)

	Callbacks:RegisterServerCallback("OxyRun:EnteredArea", function(source, data, cb)
		local char = Fetch:CharacterSource(source)
		if
			char:GetData("TempJob") == _JOB
			and _joiners[source] ~= nil
			and _sellers[_joiners[source]] ~= nil
			and _sellers[_joiners[source]].state == 4
		then
			_sellers[_joiners[source]].state = 5
			Labor.Offers:Start(_joiners[source], _JOB, "Wait For Buyers", 10)
			Labor.Workgroups:SendEvent(
				_joiners[source],
				string.format("OxyRun:Client:%s:Near", _joiners[source])
			)

			Citizen.CreateThread(function()
				Citizen.Wait(math.random(1, 2) * 60000)
				while
					_joiners[source] ~= nil
					and _sellers[_joiners[source]] ~= nil
					and _sellers[_joiners[source]].state == 5
				do
					if not _sellers[_joiners[source]].pending then
						local p = promise.new()

						local randPed = math.random(#PedModels)
						Callbacks:ClientCallback(_joiners[source], "OxyRun:GetSpawn", {
							veh = Vehicles.RandomModel:DClass(),
							ped = PedModels[randPed],
						}, function(veh, ped)
							if veh then
								Entity(NetworkGetEntityFromNetworkId(veh)).state.oxyBuying = _joiners[source]
								_sellers[_joiners[source]].pending = {
									veh = veh,
									ped = ped,
								}
								Labor.Workgroups:SendEvent(
									_joiners[source],
									string.format("OxyRun:Client:%s:Spawn", _joiners[source]),
									_sellers[_joiners[source]].pending
								)
							else
								_sellers[_joiners[source]].pending = nil

								if ped and DoesEntityExist(ped) then
									DeleteEntity(NetworkGetNetworkIdFromEntity(ped))
								end
							end

							p:resolve(veh ~= nil)
						end)
						if Citizen.Await(p) then
							Citizen.Wait(math.random(30) * 1000)
						else
							Citizen.Wait(2000)
						end
					else
						Citizen.Wait(5000)
					end
				end
			end)
		end
	end)

	Callbacks:RegisterServerCallback("OxyRun:DeleteShit", function(source, data, cb)
		if _joiners[source] and _sellers[_joiners[source]].pending ~= nil then
			_sellers[_joiners[source]].cars[_sellers[_joiners[source]].pending.veh] = false
			DeleteEntity(NetworkGetEntityFromNetworkId(_sellers[_joiners[source]].pending.ped))
			DeleteEntity(NetworkGetEntityFromNetworkId(_sellers[_joiners[source]].pending.veh))
			_sellers[_joiners[source]].pending = nil
		end
	end)

	Callbacks:RegisterServerCallback("OxyRun:SellProduct", function(source, data, cb)
		local char = Fetch:CharacterSource(source)
		if
			char:GetData("TempJob") == _JOB
			and _joiners[source] ~= nil
			and _sellers[_joiners[source]] ~= nil
			and _sellers[_joiners[source]].state == 5
			and _sellers[_joiners[source]].pending ~= nil
			and not _sellers[_joiners[source]].cars[data]
		then
			_sellers[_joiners[source]].cars[data] = true

			local exp = os.time() + (60 * 20)
			_cooldowns[char:GetData("ID")] = exp
			if _sellers[_joiners[source]].isWorkgroup then
				if #_sellers[_joiners[source]].members > 0 then
					for k, v in ipairs(_sellers[_joiners[source]].members) do
						_cooldowns[v.CharID] = exp
					end
				end
			end

			if Inventory.Items:Remove(char:GetData("SID"), 1, "contraband", 1) then
				Labor.Workgroups:SendEvent(
					_joiners[source],
					string.format("OxyRun:Client:%s:Action", _joiners[source])
				)
				local c = deepcopy(_sellers[_joiners[source]].pending)
				Entity(NetworkGetEntityFromNetworkId(c.veh)).state.oxyBuying = nil

				local cashAdd = math.random(200) + 200

				if math.random(100) >= 80 then
					Inventory:AddItem(char:GetData("SID"), "oxy", math.random(3), {}, 1)
				end

				local repLevel = Reputation:GetLevel(source, "OxyRun") or 0
				local chance = 90

				if repLevel >= 5 then
					chance = 50
					if math.random(200) <= 1 then
						Inventory:AddItem(char:GetData("SID"), "vpn", 1, {}, 1)
					end
				elseif repLevel >= 3 then
					chance = 70
				elseif repLevel >= 1 then
					chance = 82
				end

				local calcLvl = repLevel
				if calcLvl < 1 then
					calcLvl = 1
				end

				local rollCount = Inventory.Items:GetCount(char:GetData("SID"), 1, "moneyroll")
				if rollCount > 0 then
					local rb = math.random(100)
					if rb >= chance then
						local take = math.random(2,  (3 * calcLvl))
						if rollCount <= 5 or take > rollCount then
							take = rollCount
						end
						local itemData = Inventory.Items:GetData("moneyroll")

						if itemData and Inventory.Items:Remove(char:GetData("SID"), 1, "moneyroll", take) then
							cashAdd += (itemData.price * take)
						end
					end
				end

				local bandCount = Inventory.Items:GetCount(char:GetData("SID"), 1, "moneyband")
				if bandCount > 0 then
					local bb = math.random(100)
					if bb >= chance then
						local take = math.random(1,  (2 * calcLvl))
						if bandCount <= 3 or take > bandCount then
							take = bandCount
						end
						local itemData = Inventory.Items:GetData("moneyband")

						if itemData and Inventory.Items:Remove(char:GetData("SID"), 1, "moneyband", take) then
							cashAdd += (itemData.price * take)
						end
					end
				end

				Wallet:Modify(source, math.floor(cashAdd * 0.7))

				if Labor.Offers:Update(_joiners[source], _JOB, 1, true) then
					_sellers[_joiners[source]].state = 6
					Labor.Offers:Task(_joiners[source], _JOB, "Dump & Destroy The Vehicle")
					Labor.Workgroups:SendEvent(
						_joiners[source],
						string.format("OxyRun:Client:%s:EndSale", _joiners[source])
					)
				end

				cb(true)
			else
				cb(false)
			end
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("OxyRun:DestroyVehicle", function(source, data, cb)
		local char = Fetch:CharacterSource(source)
		if char:GetData("TempJob") == _JOB and _joiners[source] ~= nil and _sellers[_joiners[source]] ~= nil then
			if _sellers[_joiners[source]].state == 6 then
				_sellers[_joiners[source]].state = 7
				Labor.Offers:ManualFinish(_joiners[source], _JOB)
			else
				Phone.Notification:Add(
					_joiners[source],
					"Job Activity",
					"Vehicle Was Destroyed",
					os.time(),
					6000,
					"labor",
					{}
				)

				if _sellers[_joiners[source]].isWorkgroup then
					if #_sellers[_joiners[source]].members > 0 then
						for k, v in ipairs(_sellers[_joiners[source]].members) do
							Phone.Notification:Add(
								v.ID,
								"Job Activity",
								"Vehicle Was Destroyed",
								os.time(),
								6000,
								"labor",
								{}
							)
						end
					end
				end

				Labor.Offers:Fail(_joiners[source], _JOB)
			end
		end
	end)

	Callbacks:RegisterServerCallback("OxyRun:VehiclePoofed", function(source, data, cb)
		local char = Fetch:CharacterSource(source)
		if char:GetData("TempJob") == _JOB and _joiners[source] ~= nil and _sellers[_joiners[source]] ~= nil then
			if _sellers[_joiners[source]].state == 6 then
				_sellers[_joiners[source]].state = 7
				Labor.Offers:ManualFinish(_joiners[source], _JOB)
			else
				Phone.Notification:Add(
					_joiners[source],
					"Job Activity",
					"Vehicle Was Lost",
					os.time(),
					6000,
					"labor",
					{}
				)

				if _sellers[_joiners[source]].isWorkgroup then
					if #_sellers[_joiners[source]].members > 0 then
						for k, v in ipairs(_sellers[_joiners[source]].members) do
							Phone.Notification:Add(
								v.ID,
								"Job Activity",
								"Vehicle Was Lost",
								os.time(),
								6000,
								"labor",
								{}
							)
						end
					end
				end

				if _sellers[_joiners[source]].pending ~= nil then
					_sellers[_joiners[source]].cars[NetworkGetEntityFromNetworkId(_sellers[_joiners[source]].pending.veh)] = false
					DeleteEntity(NetworkGetEntityFromNetworkId(_sellers[_joiners[source]].pending.ped))
					DeleteEntity(NetworkGetEntityFromNetworkId(_sellers[_joiners[source]].pending.veh))
				end
	
				Labor.Offers:Fail(_joiners[source], _JOB)
			end
		end
	end)

	Callbacks:RegisterServerCallback("OxyRun:LeftZone", function(source, data, cb)
		local char = Fetch:CharacterSource(source)
		if
			char:GetData("TempJob") == _JOB
			and _joiners[source] ~= nil
			and _joiners[source] == source
			and _sellers[_joiners[source]] ~= nil
			and _sellers[_joiners[source]].state < 6
		then
			Phone.Notification:Add(
				_joiners[source],
				"Job Activity",
				"You Left The Sale Area",
				os.time(),
				6000,
				"labor",
				{}
			)

			if _sellers[_joiners[source]].isWorkgroup then
				if #_sellers[_joiners[source]].members > 0 then
					for k, v in ipairs(_sellers[_joiners[source]].members) do
						Phone.Notification:Add(
							v.ID,
							"Job Activity",
							"You Left The Sale Area",
							os.time(),
							6000,
							"labor",
							{}
						)
					end
				end
			end

			if _sellers[_joiners[source]].pending ~= nil then
				_sellers[_joiners[source]].cars[NetworkGetEntityFromNetworkId(_sellers[_joiners[source]].pending.veh)] = false
				DeleteEntity(NetworkGetEntityFromNetworkId(_sellers[_joiners[source]].pending.ped))
				DeleteEntity(NetworkGetEntityFromNetworkId(_sellers[_joiners[source]].pending.veh))
			end

			Labor.Offers:Fail(_joiners[source], _JOB)
		end
	end)
end)

AddEventHandler("Characters:Server:PlayerLoggedOut", function(source, cData)
	if _wasDoingIllegalShit[source] then
		if cData ~= nil then
			Inventory.Items:Remove(cData.SID, 1, "contraband", false, true)
		end
		_wasDoingIllegalShit[source] = nil
	end
end)

AddEventHandler("Characters:Server:PlayerDropped", function(source, cData)
	if _wasDoingIllegalShit[source] then
		if cData ~= nil then
			Inventory.Items:Remove(cData.SID, 1, "contraband", false, true)
		end
		_wasDoingIllegalShit[source] = nil
	end
end)

AddEventHandler("Labor:Server:OxyRun:Queue", function(source, data)
	if _joiners[source] ~= nil then
		if _availableRuns <= 0 then
			Labor.Offers:Cancel(_joiners[source], _JOB)
			Labor.Duty:Off(_JOB, _joiners[source], false, true)
			Phone.Notification:Add(
				_joiners[source],
				"Job Activity",
				"Sorry, ran out of jobs",
				os.time(),
				6000,
				"labor",
				{}
			)
			if isWorkgroup then
				if #_sellers[_joiners[source]].members > 0 then
					for k, v in ipairs(members) do
						Phone.Notification:Add(
							v.ID,
							"Job Activity",
							"Sorry, ran out of jobs",
							os.time(),
							6000,
							"labor",
							{}
						)
					end
				end
			end
			return
		end

		_sellers[_joiners[source]].state = 1
		_offers[_joiners[source]].noExpire = false
		Labor.Offers:Task(_joiners[source], _JOB, "Find A Vehicle")
		TriggerClientEvent(string.format("OxyRun:Client:%s:Receive", _joiners[source]), -1)
	end

	WaitList.Interact:Remove("oxyrun", source)
end)

AddEventHandler('entityRemoved', function(entity)
    if GetEntityType(entity) == 2 then
        local ent = Entity(entity)
        if ent?.state?.oxyBuying and _sellers[ent?.state?.oxyBuying]?.pending then
            Logger:Warn("Vehicles", string.format("Oxy Vehicle For %s Deleted Unexpectedly, Clearing To Spawn New Vehicle", ent?.state?.oxyBuying))
			_sellers[_joiners[source]].cars[NetworkGetEntityFromNetworkId(_sellers[ent?.state?.oxyBuying].pending.veh)] = false
			DeleteEntity(NetworkGetEntityFromNetworkId(_sellers[ent?.state?.oxyBuying].pending.ped))
			DeleteEntity(NetworkGetEntityFromNetworkId(_sellers[ent?.state?.oxyBuying].pending.veh))
			_sellers[ent?.state?.oxyBuying].pending = nil
        end
    end
end)

AddEventHandler("OxyRun:Server:OnDuty", function(joiner, members, isWorkgroup)
	if _availableRuns <= 0 then
		Labor.Offers:Cancel(joiner, _JOB)
		Labor.Duty:Off(_JOB, joiner, false, true)
		Phone.Notification:Add(joiner, "Job Activity", "No Jobs Available", os.time(), 6000, "labor", {})
		if isWorkgroup then
			if #members > 0 then
				for k, v in ipairs(members) do
					Phone.Notification:Add(
						v.ID,
						"Job Activity",
						"No Jobs Available",
						os.time(),
						6000,
						"labor",
						{}
					)
				end
			end
		end
		return
	end

	local char = Fetch:CharacterSource(joiner)
	if char == nil then
		Labor.Offers:Cancel(joiner, _JOB)
		Labor.Duty:Off(_JOB, joiner, false, true)
		return
	end

	if (_cooldowns[char:GetData("ID")] or 0) > os.time() then
		Labor.Offers:Cancel(joiner, _JOB)
		Labor.Duty:Off(_JOB, joiner, false, true)
		Phone.Notification:Add(
			joiner,
			"Job Activity",
			"Not Eligible For Another Run",
			os.time(),
			6000,
			"labor",
			{}
		)
		if isWorkgroup then
			if #members > 0 then
				for k, v in ipairs(members) do
					Phone.Notification:Add(
						v.ID,
						"Job Activity",
						"Your Group Is Not Eligible For Another Run. Please Wait",
						os.time(),
						6000,
						"labor",
						{}
					)
				end
			end
		end

		return
	elseif isWorkgroup then
		if #members > 0 then
			for k, v in ipairs(members) do
				if (_cooldowns[v.CharID] or 0) > os.time() then
					Labor.Offers:Cancel(joiner, _JOB)
					Labor.Duty:Off(_JOB, joiner, false, true)
					Phone.Notification:Add(
						joiner,
						"Job Activity",
						"Cannot Give You A Job With This Group. Please Wait",
						os.time(),
						6000,
						"labor",
						{}
					)
					if isWorkgroup then
						if #members > 0 then
							for k2, v2 in ipairs(members) do
								if v.ID == v2.ID then
									Phone.Notification:Add(
										v2.ID,
										"Job Activity",
										"Not Eligible For Another Run. Please Wait",
										os.time(),
										6000,
										"labor",
										{}
									)
								else
									Phone.Notification:Add(
										v2.ID,
										"Job Activity",
										"Your Group Is Not Eligible For Another Run. Please Wait",
										os.time(),
										6000,
										"labor",
										{}
									)
								end
							end
						end
					end

					return
				end
			end
		end
	end

	_joiners[joiner] = joiner
	_sellers[joiner] = {
		joiner = joiner,
		members = members,
		isWorkgroup = isWorkgroup,
		started = os.time(),
		cars = {},
		state = 0,
	}

	local char = Fetch:CharacterSource(joiner)
	char:SetData("TempJob", _JOB)
	TriggerClientEvent("OxyRun:Client:OnDuty", joiner, joiner, os.time())
	_wasDoingIllegalShit[joiner] = true

	Labor.Offers:Task(joiner, _JOB, "Wait For A Job")
	if #members > 0 then
		for k, v in ipairs(members) do
			_joiners[v.ID] = joiner
			local member = Fetch:CharacterSource(v.ID)
			member:SetData("TempJob", _JOB)
			TriggerClientEvent("OxyRun:Client:OnDuty", v.ID, joiner, os.time())
			_wasDoingIllegalShit[v.ID] = true
		end
	end

	_offers[joiner].noExpire = true
	WaitList.Interact:Add("oxyrun", joiner, {
		joiner = joiner,
	})
end)

AddEventHandler("OxyRun:Server:OffDuty", function(source, joiner)
	WaitList.Interact:Remove("oxyrun", _joiners[source])
	_joiners[source] = nil
	TriggerClientEvent("OxyRun:Client:OffDuty", source)
end)

function Cleanup(src)
	local joiner = src
	if _sellers[joiner] ~= nil then
		if _sellers[joiner].isWorkgroup then
			if #_sellers[joiner].members > 0 then
				for k, v in ipairs(_sellers[joiner].members) do
					local mChar = Fetch:CharacterSource(v.ID)
					if mChar ~= nil then
						Inventory.Items:Remove(mChar:GetData("SID"), 1, "contraband", false)
					end
				end
			end
		end

		local jChar = Fetch:CharacterSource(joiner)
		if jChar ~= nil then
			Inventory.Items:Remove(jChar:GetData("SID"), 1, "contraband", false)
		end

		if _sellers[joiner].vehicle ~= nil then
			Inventory.Items:Remove(_sellers[joiner].vehicle.VIN, 4, "contraband", false)
		end

		_availableRuns = _availableRuns - 1
		_sellers[joiner] = nil
	end
end

AddEventHandler("OxyRun:Server:FinishJob", Cleanup)
AddEventHandler("OxyRun:Server:CancelJob", Cleanup)
