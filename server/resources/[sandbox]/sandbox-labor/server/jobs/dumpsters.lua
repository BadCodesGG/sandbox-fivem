local _searchedDumpsters = {}
local _lockedDumpsters = {}
local _dumpsterLockVal = 3
local _repName = "DumpsterDiving"

AddEventHandler("Labor:Server:Startup", function()
	RegisterDumpsterCallbacks()
	RegisterDumpsterStartup()
end)

function RegisterDumpsterStartup()
	Reputation:Create(_repName, "Dumpster Diving", {
		{ label = "Rank 1", value = 1000 },
		{ label = "Rank 2", value = 2500 },
		{ label = "Rank 3", value = 5000 },
		{ label = "Rank 4", value = 10000 },
		{ label = "Rank 5", value = 25000 },
		{ label = "Rank 6", value = 50000 },
		{ label = "Rank 7", value = 100000 },
		{ label = "Rank 8", value = 250000 },
		{ label = "Rank 9", value = 500000 },
		{ label = "Rank 10", value = 1000000 },
	})
end

function RegisterDumpsterCallbacks()
	Callbacks:RegisterServerCallback("Inventory:Server:AvailableDumpster", function(source, data, cb)
		local _dumpsterId = data.entity
		if data and _searchedDumpsters[_dumpsterId] == nil then
			cb(true)
		else
			cb(false)
		end
	end)
	Callbacks:RegisterServerCallback("Inventory:Dumpster:HidePlayer", function(source, data, cb)
		local plyr = Fetch:Source(source)
		local _dumpsterId = data.identifier
		local _locked = data.locked
		if plyr ~= nil then
			if not Player(source).state.isCuffed and not Player(source).state.isDead then
				if _lockedDumpsters[_dumpsterId] == nil then
					if _locked == _dumpsterLockVal then
						_lockedDumpsters[_dumpsterId] = true
					else
						_lockedDumpsters[_dumpsterId] = false
					end
					cb(true, _lockedDumpsters[_dumpsterId])
				else
					cb(true, _lockedDumpsters[_dumpsterId])
				end
			else
				cb(false, false)
			end
		else
			cb(false, false)
		end
	end)
	Callbacks:RegisterServerCallback("Inventory:Server:SearchDumpster", function(source, data, cb)
		local char = Fetch:CharacterSource(source)
		if char ~= nil then
			local _dumpsterId = data.entity
			if data and _searchedDumpsters[_dumpsterId] == nil then
				_searchedDumpsters[_dumpsterId] = true
				local _PlayerRep = Reputation:GetLevel(source, _repName) or 0
				local _found = math.random(100) >= math.random(75)
				if _found then
					if _PlayerRep >= 8 then
						if math.random(100) >= math.random(75) then
							Loot:CustomWeightedSetWithCountAndModifier(
								_dumpsterLoot.high,
								char:GetData("SID"),
								1,
								1,
								false
							)
						end
						if math.random(100) >= math.random(75) then
							Loot:CustomWeightedSetWithCountAndModifier(
								_dumpsterLoot.medium,
								char:GetData("SID"),
								1,
								1,
								false
							)
						end
						Loot:CustomWeightedSetWithCountAndModifier(
							_dumpsterLoot.low,
							char:GetData("SID"),
							1,
							1,
							false
						)
					elseif _PlayerRep <= 7 and _PlayerRep >= 4 then
						if math.random(100) >= math.random(75) then
							Loot:CustomWeightedSetWithCountAndModifier(
								_dumpsterLoot.medium,
								char:GetData("SID"),
								1,
								1,
								false
							)
						end
						Loot:CustomWeightedSetWithCountAndModifier(
							_dumpsterLoot.low,
							char:GetData("SID"),
							1,
							1,
							false
						)
						Loot:CustomWeightedSetWithCountAndModifier(
							_dumpsterLoot.low,
							char:GetData("SID"),
							1,
							1,
							false
						)
					else
						Loot:CustomWeightedSetWithCountAndModifier(
							_dumpsterLoot.low,
							char:GetData("SID"),
							1,
							1,
							false
						)
						Loot:CustomWeightedSetWithCountAndModifier(
							_dumpsterLoot.low,
							char:GetData("SID"),
							1,
							1,
							false
						)
					end
					Reputation.Modify:Add(source, _repName, math.random(5, 10))
					Execute:Client(source, "Notification", "Success", "You found something!")
				else
					Reputation.Modify:Add(source, _repName, math.random(1, 3))
					Execute:Client(source, "Notification", "Info", "Nothing was found.")
				end
				cb(true)
			else
				Execute:Client(source, "Notification", "Error", "This dumpster has been searched already!")
				cb(false)
			end
		else
			cb(false)
		end
	end)
end
