local _JOB = "Mining"

local _joiners = {}
local _mining = {}

local _miningNodes = {
	{
		{ id = 1, coords = vector3(2938.144, 2772.396, 39.252) },
		{ id = 2, coords = vector3(2952.930, 2769.443, 39.096) },
		{ id = 3, coords = vector3(2928.800, 2789.580, 40.154) },
		{ id = 4, coords = vector3(2922.429, 2798.988, 41.225) },
		{ id = 5, coords = vector3(2977.805, 2790.959, 40.593) },
		{ id = 6, coords = vector3(2987.681, 2813.613, 45.148) },
		{ id = 7, coords = vector3(2978.518, 2828.737, 46.135) },
		{ id = 8, coords = vector3(2970.544, 2845.862, 46.590) },
		{ id = 9, coords = vector3(2998.696, 2758.649, 42.981) },
		{ id = 10, coords = vector3(2991.046, 2750.637, 43.686) },
		{ id = 11, coords = vector3(2977.352, 2741.483, 44.631) },
		{ id = 12, coords = vector3(2941.840, 2741.984, 43.521) },
		{ id = 13, coords = vector3(2929.043, 2759.290, 45.067) },
		{ id = 14, coords = vector3(2911.868, 2778.041, 45.255) },
		{ id = 15, coords = vector3(2907.100, 2788.490, 46.406) },
	},
	{
		{ id = 1, coords = vector3(2659.231, 2905.037, 36.431) },
		{ id = 2, coords = vector3(2648.106, 2906.361, 37.245) },
		{ id = 3, coords = vector3(2643.043, 2911.251, 37.175) },
		{ id = 4, coords = vector3(2645.326, 2916.472, 36.794) },
		{ id = 5, coords = vector3(2668.878, 2936.764, 37.274) },
		{ id = 6, coords = vector3(2675.047, 2935.462, 37.336) },
		{ id = 7, coords = vector3(2718.989, 2939.137, 36.692) },
		{ id = 8, coords = vector3(2725.688, 2937.714, 36.223) },
		{ id = 9, coords = vector3(2731.663, 2933.119, 36.108) },
		{ id = 10, coords = vector3(2740.036, 2928.666, 36.783) },
		{ id = 11, coords = vector3(2746.769, 2944.376, 35.814) },
		{ id = 12, coords = vector3(2757.438, 2939.536, 36.703) },
		{ id = 13, coords = vector3(2761.567, 2937.006, 36.737) },
		{ id = 14, coords = vector3(2785.439, 2919.508, 38.923) },
		{ id = 15, coords = vector3(2795.665, 2900.989, 39.290) },
	},
	{
		{ id = 1, coords = vector3(2926.581, 2922.312, 90.317) },
		{ id = 2, coords = vector3(2934.832, 2930.792, 91.181) },
		{ id = 3, coords = vector3(2945.168, 2944.622, 92.029) },
		{ id = 4, coords = vector3(2947.963, 2951.895, 92.094) },
		{ id = 5, coords = vector3(2960.703, 2967.157, 91.192) },
		{ id = 6, coords = vector3(2969.028, 2977.197, 89.481) },
		{ id = 7, coords = vector3(2972.374, 2983.273, 88.794) },
		{ id = 8, coords = vector3(2978.499, 2992.683, 87.506) },
		{ id = 9, coords = vector3(2983.067, 3006.238, 89.416) },
		{ id = 10, coords = vector3(2989.504, 3018.260, 89.303) },
		{ id = 11, coords = vector3(3000.554, 3031.342, 90.469) },
		{ id = 12, coords = vector3(3013.113, 3038.370, 92.252) },
		{ id = 13, coords = vector3(3045.072, 3034.309, 91.494) },
		{ id = 14, coords = vector3(3059.861, 3018.096, 91.376) },
		{ id = 15, coords = vector3(3073.169, 3008.398, 95.435) },
	},
	{
		{ id = 1, coords = vector3(2985.130, 2707.875, 54.994) },
		{ id = 2, coords = vector3(2982.273, 2699.220, 55.827) },
		{ id = 3, coords = vector3(2968.980, 2693.589, 54.772) },
		{ id = 4, coords = vector3(2957.219, 2692.233, 55.364) },
		{ id = 5, coords = vector3(2935.035, 2711.480, 54.301) },
		{ id = 6, coords = vector3(2916.866, 2741.743, 54.344) },
		{ id = 7, coords = vector3(2905.849, 2757.351, 53.693) },
		{ id = 8, coords = vector3(2899.150, 2764.472, 53.772) },
		{ id = 9, coords = vector3(2884.477, 2796.901, 56.040) },
		{ id = 10, coords = vector3(2874.509, 2772.755, 59.852) },
		{ id = 11, coords = vector3(2889.584, 2750.469, 64.111) },
		{ id = 12, coords = vector3(2895.904, 2743.068, 63.588) },
		{ id = 13, coords = vector3(2908.053, 2730.871, 63.626) },
		{ id = 14, coords = vector3(2917.821, 2710.271, 63.943) },
		{ id = 15, coords = vector3(2924.810, 2703.965, 64.443) },
	},
	{
		{ id = 1, coords = vector3(2983.771, 2959.722, 79.222) },
		{ id = 2, coords = vector3(3000.422, 2970.566, 75.890) },
		{ id = 3, coords = vector3(3008.430, 2982.145, 74.070) },
		{ id = 4, coords = vector3(3018.553, 2994.703, 72.448) },
		{ id = 5, coords = vector3(3027.995, 2996.917, 72.641) },
		{ id = 6, coords = vector3(3041.438, 2979.969, 74.375) },
		{ id = 7, coords = vector3(3048.038, 2960.285, 71.745) },
		{ id = 8, coords = vector3(3048.168, 2937.676, 69.885) },
		{ id = 9, coords = vector3(3046.663, 2928.586, 70.100) },
		{ id = 10, coords = vector3(3044.607, 2912.102, 70.978) },
		{ id = 11, coords = vector3(3027.494, 2887.198, 74.306) },
		{ id = 12, coords = vector3(3022.800, 2870.059, 75.364) },
		{ id = 13, coords = vector3(3009.044, 2869.983, 73.367) },
		{ id = 14, coords = vector3(3026.088, 2850.535, 72.727) },
		{ id = 15, coords = vector3(3041.110, 2822.618, 71.250) },
	},
}

local _payoutCuts = {
	[1] = 0.5,
	[2] = 0.45,
	[3] = 0.4,
	[4] = 0.35,
	[5] = 0.3,
}

local _repHEChance = {
	[1] = 20,
	[2] = 30,
	[3] = 40,
	[4] = 50,
	[5] = 55,
}

local _schemMiningLoot = {
	["0"] = 1, -- Sunday
	["1"] = 1, -- Monday
	["2"] = 2, -- Tuesday
	["3"] = 1, -- Wednesday
	["4"] = 3, -- Thursday
	["5"] = 1, -- Friday
	["6"] = 2, -- Saturday
}

local _gems = {
	diamond = { level = 4 },
	emerald = { level = 5 },
	sapphire = { level = 3 },
	ruby = { level = 3 },
	amethyst = { level = 2 },
	citrine = { level = 2 },
	opal = { level = 1 },
}

local _heOres = {
	{
		label = "Diamond Ore",
		object = `bzzz_mining_diamond001`,
		item = "diamond",
		count = 1,
		factor = 0.85,
		scale = 1.25,
		size = 4,
	},
	{
		label = "Emerald Ore",
		object = `bzzz_mining_emerald001`,
		item = "emerald",
		count = 1,
		factor = 0.85,
		scale = 1.2,
		size = 4,
	},
	{
		label = "Ruby Ore",
		object = `bzzz_mining_ruby001`,
		item = "ruby",
		count = 1,
		factor = 0.85,
		scale = 1.2,
		size = 4,
	},
	{
		label = "Sapphire Ore",
		object = `bzzz_mining_sapphire001`,
		item = "sapphire",
		count = 1,
		factor = 0.85,
		scale = 1.2,
		size = 4,
	},
}

local _valOres = {
	{
		label = "Gold Ore",
		object = `bzzz_mining_gold001`,
		item = "goldore",
		count = 4,
		factor = 0.7,
		scale = 1.10,
		size = 5,
	},
	{
		label = "Silver Ore",
		object = `bzzz_mining_silver001`,
		item = "silverore",
		count = 4,
		factor = 0.6,
		scale = 1.07,
	},
}

local _ores = {
	{
		label = "Iron Ore",
		object = `bzzz_mining_quartz001`,
		item = "ironore",
		count = 4,
	},
	{
		label = "Ore",
		object = `bzzz_mining_nephrite001`,
	},
	{
		label = "Ore",
		object = `bzzz_mining_nephrite001`,
	},
	{
		label = "Ore",
		object = `bzzz_mining_nephrite001`,
	},
}

local antiDouche = {}

local function GenerateNodes(source)
	local nodes = {}
	local template = deepcopy(_miningNodes[math.random(#_miningNodes)])

	if not antiDouche[source] then
		antiDouche[source] = true

		local heCount = 0
		local luck = math.random(100)
		local ultra = math.random(1000000)

		local char = Fetch:CharacterSource(source)
		local repLevel = Reputation:GetLevel(source, "Mining") or 0
		local calcLvl = repLevel
		if calcLvl < 1 then
			calcLvl = 1
		end

		if ultra == 1000000 then
			heCount = 15
			Logger:Warn(
				"Labor",
				string.format(
					"%s %s (%s) Got 1 in a million 15 HE ore node job",
					char:GetData("First"),
					char:GetData("Last"),
					char:GetData("SID")
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
		else
			if luck == 100 then
				heCount = 2
			elseif luck >= (100 - _repHEChance[calcLvl]) then
				heCount = 1
			else
				heCount = 0
			end
		end

		for i = 1, heCount do
			local id = math.random(#template)
			table.insert(nodes, {
				ore = _heOres[math.random(#_heOres)],
				location = template[id].coords,
				luck = 1,
			})
			table.remove(template, id)
		end

		if #template > 0 then
			local nCount = calcLvl

			if nCount > #template then
				nCount = #template
			end

			for i = 1, nCount do
				id = math.random(#template)
				table.insert(nodes, {
					ore = _valOres[math.random(#_valOres)],
					location = template[id].coords,
					luck = 1,
				})
				table.remove(template, id)
			end
		end
	end

	if #template > 0 then
		for k, v in ipairs(template) do
			table.insert(nodes, {
				ore = _ores[math.random(#_ores)],
				location = v.coords,
				luck = math.random(100),
			})
		end
	end

	return nodes
end

AddEventHandler("Labor:Server:Startup", function()
	Callbacks:RegisterServerCallback("Mining:SellStone", function(source, data, cb)
		local char = Fetch:CharacterSource(source)
		local count = Inventory.Items:GetCount(char:GetData("SID"), 1, "crushedrock")
		if (count or 0) > 0 then
			if Inventory.Items:Remove(char:GetData("SID"), 1, "crushedrock", count) then
				Wallet:Modify(source, (3 * count))
				cb(true)
			else
				Execute:Client(source, "Notification", "Error", "Unable To Remove Crushed Rock")
				cb(false)
			end
		else
			Execute:Client(source, "Notification", "Error", "You Have No Crushed Rock")
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("Mining:SellGem", function(source, data, cb)
		local char = Fetch:CharacterSource(source)
		local repLvl = Reputation:GetLevel(source, _JOB)

		if _gems[data] ~= nil and _gems[data].level <= repLvl then
			local itemData = Inventory.Items:GetData(data)
			if itemData ~= nil then
				local count = Inventory.Items:GetCount(char:GetData("SID"), 1, data)

				if count > 0 then
					local totalPayout = 0
					for i = 1, count do
						local item = Inventory.Items:GetFirst(char:GetData("SID"), data, 1)
						if item then
							local payout = itemData.price * ((item.MetaData.Quality / 100) - _payoutCuts[repLvl])
							if payout <= 0 then
								payout = 100
							end
	
							if Inventory.Items:Remove(char:GetData("SID"), 1, data, 1) then
								totalPayout = math.ceil(totalPayout + payout)
							end
						end
					end

					Banking.Balance:Deposit(Banking.Accounts:GetPersonal(char:GetData("SID")).Account, totalPayout, {
						type = "deposit",
						title = "Gems Sale",
						description = string.format("Sold %s x%s", itemData.label, count),
						data = {
							gem = data,
							repLvl = repLvl,
						},
					})
					Execute:Client(
						source,
						"Notification",
						"Info",
						string.format("$%s Has Been Deposited Into Your Account", totalPayout)
					)
				else
					Execute:Client(
						source,
						"Notification",
						"Error",
						string.format("You Don't Have Any %s's", itemData.label)
					)
				end
			end
		end
	end)

	Callbacks:RegisterServerCallback("Mining:StartJob", function(source, data, cb)
		if _mining[_joiners[source]] ~= nil and _mining[_joiners[source]].state == 0 then
			_mining[_joiners[source]].nodes = GenerateNodes(_joiners[source])
			Labor.Offers:Start(_joiners[source], _JOB, "Mine Ore Nodes", 15)
			Labor.Workgroups:SendEvent(_joiners[source], string.format("Mining:Client:%s:Startup", _joiners[source]), _mining[_joiners[source]].nodes)
			_mining[_joiners[source]].state = 1
			cb(true)
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("Mining:Server:MineNode", function(source, data, cb)
		local char = Fetch:CharacterSource(source)
		if char:GetData("TempJob") == _JOB and _joiners[source] ~= nil and _mining[_joiners[source]] ~= nil then
			if _mining[_joiners[source]].state == 1 then
				for i = #_mining[_joiners[source]].nodes, 1, -1 do
					local node = _mining[_joiners[source]].nodes[i]
					if node then
						if
							vector3(node.location.x, node.location.y, node.location.z)
							== vector3(data.location.x, data.location.y, data.location.z)
						then
							Inventory:AddItem(char:GetData("SID"), "crushedrock", math.random(8), {}, 1)

							local luck = math.random(100)
							if node.ore.item then
								if
									(data.failed and luck >= 97)
									or (luck >= 85)
									or (not data.failed and node.luck <= 10)
								then
									if node.ore.count > 1 then
										Inventory:AddItem(
											char:GetData("SID"),
											node.ore.item,
											math.random(node.ore.count),
											{},
											1
										)
									else
										Inventory:AddItem(char:GetData("SID"), node.ore.item, 1, {}, 1)
									end
								end
							else
								if
									(data.failed and luck >= 97)
									or (luck >= 95)
									or (not data.failed and node.luck <= 10)
								then
									Loot:CustomWeightedSetWithCount({
										{ 30, { name = "amethyst", max = 1 } },
										{ 30, { name = "citrine", max = 1 } },
										{ 40, { name = "opal", max = 1 } },
									}, char:GetData("SID"), 1)
								end
							end

							local j = _joiners[source]
							Labor.Workgroups:SendEvent(j, string.format("Mining:Client:%s:RemoveNode", j), node.location)
							if Labor.Offers:Update(j, _JOB, 1, false) then
								antiDouche[j] = false
							elseif not _mining[j].nodes or #_mining[j].nodes == 0 then
								antiDouche[j] = false
								Labor.Offers:ManualFinish(j, _JOB)
							else
								table.remove(_mining[j].nodes, i)
							end

							return
						end
					else
						if not _mining[j].nodes or #_mining[j].nodes == 0 then
							antiDouche[j] = false
							Labor.Offers:ManualFinish(j, _JOB)
						else
							Execute:Client(source, "Notification", "Error", "Invalid Node")
						end
					end
				end
			else
				Execute:Client(source, "Notification", "Error", "Not Currently Requested To Mine Nodes")
			end
		else
			Execute:Client(source, "Notification", "Error", "Incorrect Job")
		end
	end)
end)

AddEventHandler("Mining:Server:OnDuty", function(joiner, members, isWorkgroup)
	_joiners[joiner] = joiner
	_mining[joiner] = {
		joiner = joiner,
		isWorkgroup = isWorkgroup,
		started = os.time(),
		state = 0,
	}

	local char = Fetch:CharacterSource(joiner)
	char:SetData("TempJob", _JOB)
	Phone.Notification:Add(joiner, "Job Activity", "You started a job", os.time(), 6000, "labor", {})
	TriggerClientEvent("Mining:Client:OnDuty", joiner, joiner, os.time())

	Labor.Offers:Task(joiner, _JOB, "Talk To The Foreman")
	if #members > 0 then
		for k, v in ipairs(members) do
			_joiners[v.ID] = joiner
			local member = Fetch:CharacterSource(v.ID)
			member:SetData("TempJob", _JOB)
			Phone.Notification:Add(v.ID, "Job Activity", "You started a job", os.time(), 6000, "labor", {})
			TriggerClientEvent("Mining:Client:OnDuty", v.ID, joiner, os.time())
		end
	end
end)

AddEventHandler("Mining:Server:OffDuty", function(source, joiner)
	_joiners[source] = nil
	TriggerClientEvent("Mining:Client:OffDuty", source)
end)

AddEventHandler("Mining:Server:FinishJob", function(joiner)
	_mining[joiner] = nil
end)
