local _repName = "PrisonSearch"

local _lootTables = {
	low = {
		{ 50, { name = "plastic", min = 1, max = 1 } },
		{ 50, { name = "scrapmetal", min = 1, max = 1 } },
		{ 50, { name = "rubber", min = 1, max = 1 } },
		{ 15, { name = "beer", min = 1, max = 1 } },
		{ 15, { name = "wine_bottle", min = 1, max = 1 } },
		{ 10, { name = "petrock", min = 1, max = 1 } },
	},
	medium = {
		{ 10, { name = "screwdriver", min = 1, max = 1 } },
		{ 20, { name = "glue", min = 1, max = 1 } },
	},
	high = {
		{ 15, { name = "electronic_parts", min = 20, max = 40 } },
	},
}

local _jailSearchDays = {
	["0"] = 1, -- Sunday
	["1"] = 2, -- Monday
	["2"] = 1, -- Tuesday
	["3"] = 2, -- Wednesday
	["4"] = 1, -- Thursday
	["5"] = 2, -- Friday
	["6"] = 1, -- Saturday
}

local _jailSearchableLocs = {
	[1] = {
		[1] = {
			type = "box",
			coords = vector3(1720.79, 2567.16, 45.56),
			length = 3.2,
			width = 0.6,
			options = {
				heading = 315,
				-- debugPoly=true,
				minZ = 43.56,
				maxZ = 47.76,
			},
		},
		[2] = {
			type = "box",
			coords = vector3(1661.88, 2551.31, 45.56),
			length = 0.6,
			width = 1.6,
			options = {
				heading = 315,
				-- debugPoly=true,
				minZ = 41.76,
				maxZ = 45.96,
			},
		},
		[3] = {
			type = "box",
			coords = vector3(1604.47, 2564.57, 45.67),
			length = 0.6,
			width = 1.6,
			options = {
				heading = 315,
				-- debugPoly=true,
				minZ = 43.07,
				maxZ = 47.27,
			},
		},
		[4] = {
			type = "box",
			coords = vector3(1691.5, 2566.73, 45.56),
			length = 1.4,
			width = 0.6,
			options = {
				heading = 0,
				-- debugPoly=true,
				minZ = 42.76,
				maxZ = 46.96,
			},
		},
		[5] = {
			type = "box",
			coords = vector3(1637.94, 2529.94, 45.56),
			length = 0.6,
			width = 1.8,
			options = {
				heading = 228,
				-- debugPoly=true,
				minZ = 41.96,
				maxZ = 46.16,
			},
		},
		[6] = {
			type = "box",
			coords = vector3(1663.95, 2513.39, 45.56),
			length = 2.0,
			width = 1.2,
			options = {
				heading = 230,
				-- debugPoly=true,
				minZ = 41.96,
				maxZ = 46.16,
			},
		},
	},
	[2] = {
		[1] = {
			type = "box",
			coords = vector3(1716.32, 2569.73, 45.56),
			length = 1.4,
			width = 0.6,
			options = {
				heading = 0,
				-- debugPoly=true,
				minZ = 43.56,
				maxZ = 47.76,
			},
		},
		[2] = {
			type = "box",
			coords = vector3(1667.58, 2551.56, 45.56),
			length = 0.6,
			width = 1.6,
			options = {
				heading = 315,
				-- debugPoly=true,
				minZ = 41.76,
				maxZ = 45.96,
			},
		},
		[3] = {
			type = "box",
			coords = vector3(1712.14, 2566.71, 45.56),
			length = 1.4,
			width = 0.6,
			options = {
				heading = 0,
				-- debugPoly=true,
				minZ = 42.76,
				maxZ = 46.96,
			},
		},
		[4] = {
			type = "box",
			coords = vector3(1643.39, 2523.44, 45.56),
			length = 0.6,
			width = 1.6,
			options = {
				heading = 320,
				-- debugPoly=true,
				minZ = 41.96,
				maxZ = 46.16,
			},
		},
		[5] = {
			type = "box",
			coords = vector3(1740.27, 2534.2, 43.59),
			length = 1.6,
			width = 1.6,
			options = {
				heading = 230,
				-- debugPoly=true,
				minZ = 39.99,
				maxZ = 44.19,
			},
		},
		[6] = {
			type = "box",
			coords = vector3(1732.0, 2546.28, 43.59),
			length = 1.6,
			width = 1.6,
			options = {
				heading = 210,
				-- debugPoly=true,
				minZ = 40.59,
				maxZ = 44.79,
			},
		},
	},
}

function RegisterPrisonSearchStartup()
	GlobalState.JailSearchLocations = _jailSearchableLocs[_jailSearchDays[tostring(os.date("%w"))]]

	Reputation:Create(_repName, "PrisonSearchRep", {
		{ label = "Rank 1", value = 500 },
		{ label = "Rank 2", value = 1000 },
		{ label = "Rank 3", value = 2500 },
		{ label = "Rank 4", value = 4000 },
		{ label = "Rank 5", value = 5000 },
		{ label = "Pls Stop", value = 7500 },
	}, 1) -- hidden rep

	Callbacks:RegisterServerCallback("Prison:Searchable:GetLootShit", function(source, data, cb)
		if not Jail:IsJailed(source) then
			Execute:Client(source, "Notification", "Error", "You're not jailed.")
			cb(false)
			return
		end
		local char = Fetch:CharacterSource(source)

		if char then
			local _PlayerRep = Reputation:GetLevel(source, _repName) or 0
			local _found = math.random(100) >= math.random(90)
			local _loot = _lootTables.low
			local _rando = math.random(5, 10)

			if _found then
				if _PlayerRep >= 2500 then
					_rando = math.random(12, 18)
				end
				if _PlayerRep >= 1000 then
					_loot = _lootTables.medium
				elseif _PlayerRep >= 4000 then
					_loot = _lootTables.high
				elseif _PlayerRep >= 7500 then
					_loot = _lootTables.high
					-- maybe give a fucking rifle or some shit kekw
				end
				Loot:CustomWeightedSetWithCountAndModifier(_loot, char:GetData("SID"), 1, 1, false)
				Reputation.Modify:Add(source, _repName, _rando)
				Execute:Client(source, "Notification", "Success", "You found something!")
			else
				Reputation.Modify:Add(source, _repName, math.random(1, 3))
				Execute:Client(source, "Notification", "Info", "Nothing was found.")
			end
			cb(true)
		else
			cb(false)
		end
	end)
end
