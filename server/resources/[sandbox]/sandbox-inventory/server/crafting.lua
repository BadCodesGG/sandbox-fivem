_recipes = {}
_cooldowns = {}

_schematics = _schematics or {}
_publicSchemData = {}

_benchSchems = {}
_playerSchems = {}

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["sandbox-base"]:RegisterComponent("Crafting", CRAFTING)
end)

_types = {}
_inProg = {}

--[[
    Location for types
]]

-- Dear lua, die.
function deepcopy(orig)
	local orig_type = type(orig)
	local copy
	if orig_type == "table" then
		copy = {}
		for orig_key, orig_value in next, orig, nil do
			copy[deepcopy(orig_key)] = deepcopy(orig_value)
		end
		setmetatable(copy, deepcopy(getmetatable(orig)))
	else -- number, string, boolean, etc
		copy = orig
	end
	return copy
end

function RemoveCraftingCooldown(source, bench, id)
	local plyr = Fetch:Source(source)
	if plyr ~= nil then
		if plyr.Permissions:IsAdmin() then
			local char = Fetch:CharacterSource(source)
			if char ~= nil then
				if _cooldowns[bench] ~= nil then
					Logger:Info("Crafting", string.format("%s %s (%s) Reset Cooldown %s on bench %s", char:GetData("First"), char:GetData("Last"), char:GetData("SID"), id, bench))
					Chat.Send.Server:Single(source, "Cooldown Removed From Bench")
					_cooldowns[bench][id] = nil
					MySQL.query('DELETE FROM crafting_cooldowns WHERE bench = ? AND id = ?', { bench, id })
				else
					Logger:Info("Crafting", string.format("%s %s (%s) Attempted To Remove Cooldown %s From Non-Existent Bench %s", char:GetData("First"), char:GetData("Last"), char:GetData("SID"), id, bench))
					Chat.Send.Server:Single(source, "Not A Valid Bench")
				end
			end
		else
			Logger:Info("Crafting", string.format("%s %s (%s) Attempted To Remove Cooldown %s From Bench %s", char:GetData("First"), char:GetData("Last"), char:GetData("SID"), id, bench))
		end
	end
end

function LoadCraftingCooldowns()
	Citizen.CreateThread(function()
		local cds = MySQL.query.await('SELECT * FROM crafting_cooldowns WHERE expires > ?', { os.time() })

		for k, v in ipairs(cds or {}) do
			_cooldowns[v.bench] = _cooldowns[v.bench] or {}
			_cooldowns[v.bench][v.id] = v.expires
		end
	end)
end

local _cdThreading = false
function CleanupExpiredCooldowns()
	if _cdThreading then return end
	_cdThreading = true

	Citizen.CreateThread(function()
		while _cdThreading do
			for k, v in pairs(_cooldowns) do
				for k2, v2 in pairs(v) do
					if v2 < os.time() then
						_cooldowns[k][k2] = nil
					end
				end
			end

			MySQL.query('DELETE FROM crafting_cooldowns WHERE expires < ?', { os.time() }, function(d)
				if d.affectedRows > 0 then
					Logger:Info("Inventory", string.format("Remove ^2%s^7 Expired Crafting Cooldowns", d.affectedRows))
				end
			end)
			Citizen.Wait(60000)
		end
	end)
end

function InsertCooldown(bench, key, expires)
	_cooldowns[bench] = _cooldowns[bench] or {}

	MySQL.insert('INSERT INTO crafting_cooldowns (bench, id, expires) VALUES(?, ?, ?)', { bench, key, expires })
	_cooldowns[bench][key] = expires
end

CRAFTING = {
	RegisterBench = function(self, id, label, targeting, location, restrictions, recipes, canUseSchematics, isPubSchemTable)
		while not itemsLoaded do
			Citizen.Wait(10)
		end

		_cooldowns[id] = _cooldowns[id] or {}
		_types[id] = {
			id = id,
			label = label,
			targeting = targeting,
			location = location,
			restrictions = restrictions,
			recipes = {},
			canUseSchematics = canUseSchematics or false,
			isPubSchemTable = isPubSchemTable or false,
		}

		for k, v in pairs(recipes) do
			if itemsDatabase[v.result.name] ~= nil then
				v.id = string.format("%s", k)
				table.insert(_types[id].recipes, v)
			end
		end

		if not isPubSchemTable then
			local t = MySQL.rawExecute.await('SELECT schematic FROM bench_schematics WHERE bench = ?', {
				id,
			})

			for k, v in ipairs(t) do
				if itemsDatabase[v.schematic]?.schematic ~= nil and _schematics[itemsDatabase[v.schematic]?.schematic] ~= nil then
					local f = table.copy(_schematics[itemsDatabase[v.schematic].schematic])
					f.id = v.schematic
					table.insert(_types[id].recipes, f)
				end
			end
		end
	end,
	Craft = {
		Start = function(self, crafterSource, crafter, bench, schemId, qty)
			if _types[bench] == nil then
				return { error = true, message = "Invalid Bench" }
			end

			local recipies = _types[bench].recipes
			if _types[bench].isPubSchemTable then
				local t = GetCharacterPublicSchems(crafter, false)
				recipies = {}
				for k, v in ipairs(t[_types[bench].isPubSchemTable] or {}) do
					if itemsDatabase[v]?.schematic ~= nil and _schematics[itemsDatabase[v]?.schematic] ~= nil then
						local f = table.copy(_schematics[itemsDatabase[v]?.schematic])
						f.id = v
						table.insert(recipies, f)
					end
				end
			end

			local recipe = nil
			for k, v in pairs(recipies or {}) do
				if v.id == schemId then
					recipe = v
					break
				end
			end

			if recipe == nil then
				return { error = true, message = "Invalid Recipe" }
			end

			local reagents = {}
			for k, v in ipairs(recipe.items) do
				if reagents[v.name] ~= nil then
					reagents[v.name] = reagents[v.name] + (v.count * qty)
				else
					reagents[v.name] = v.count * qty
				end
			end

			local makingItem = recipe.result
			local reqSlotPerItem = itemsDatabase[makingItem.name].isStackable or 1
			local totalRequiredSlots = math.ceil((makingItem.count * qty) / reqSlotPerItem)
			local freeSlots = INVENTORY:GetFreeSlotNumbers(crafter, 1)
			if #freeSlots < totalRequiredSlots then
				return { error = true, message = "Inventory Full" }
			end

			for k, v in pairs(reagents) do
				if not INVENTORY.Items:Has(crafter, 1, k, v) then
					return { error = true, message = "Missing Ingredients" }
				end
			end

			if _types[bench].isPubSchemTable then
				local bId = string.format("%s:%s", bench, crafter)
				if _cooldowns[bId] and _cooldowns[bId][schemId] ~= nil and _cooldowns[bId][schemId] > (os.time() * 1000) then
					return { error = true, message = "Recipe On Cooldown" }
				end
			else
				if _cooldowns[bench][schemId] ~= nil and _cooldowns[bench][schemId] > (os.time() * 1000) then
					return { error = true, message = "Recipe On Cooldown" }
				end
			end

			for k, v in pairs(reagents) do
				if not INVENTORY.Items:Remove(crafter, 1, k, v, true) then
					return false
				end
			end

			local p = promise.new()

			Citizen.CreateThread(function()
				local meta = {}
				if itemsDatabase[recipe.result.name].type == 2 and not itemsDatabase[recipe.result.name].noSerial then
					meta.Scratched = true
				end
	
				if recipe.cooldown then
					if _types[bench].isPubSchemTable then
						InsertCooldown(string.format("%s:%s", bench, crafter), recipe.id, (os.time() * 1000) + recipe.cooldown)
					else
						InsertCooldown(bench, recipe.id, (os.time() * 1000) + recipe.cooldown)
					end
				end
	
				if INVENTORY:AddItem(crafter, recipe.result.name, recipe.result.count * qty, meta, 1) then
					local inv = getInventory(crafterSource, crafter, 1)
					if _types[bench].isPubSchemTable then
						local bId = string.format("%s:%s", bench, crafter)
						p:resolve({
							inventory = inv,
							cooldowns = _cooldowns[bId],
						})
					else
						p:resolve({
							inventory = inv,
							cooldowns = _cooldowns[bench],
						})
					end
				else
					p:resolve(nil)
				end
			end)

			return Citizen.Await(p)
		end,
	},
	Schematics = {
		Has = function(self, bench, item, stateID)
			if _types[bench] ~= nil then
				if _types[bench].isPubSchemTable then
					if _playerSchems[stateID] ~= nil and _playerSchems[stateID][bench] ~= nil then
						for k, v in ipairs(_playerSchems[stateID][bench]) do
							if v == item then
								return true
							end
						end
					end
				else
					if _benchSchems[bench] ~= nil then
						for k, v in ipairs(_benchSchems[bench]) do
							if v == item then
								return true
							end
						end
					end
				end
			end
			return false
		end,
		HasAny = function(self, stateID, item)
			return MySQL.scalar.await('SELECT COUNT(*) AS count FROM character_schematics c WHERE c.sid = ? AND c.schematic = ?', {
				stateID,
				item,
			}) > 0
		end,
		Add = function(self, bench, item, stateID)
			if _types[bench] ~= nil and _schematics[itemsDatabase[item].schematic] ~= nil then
				if not Crafting.Schematics:Has(bench, item, stateID) then
					if _types[bench].isPubSchemTable then
						if _playerSchems[stateID] == nil then
							GetCharacterPublicSchems(stateID, true)
						end

						MySQL.insert.await('INSERT INTO character_schematics (sid, bench, schematic) VALUES(?, ?, ?)', {
							stateID,
							_types[bench].isPubSchemTable,
							item
						})

						_playerSchems[stateID][_types[bench].isPubSchemTable] = _playerSchems[stateID][_types[bench].isPubSchemTable] or {}
						table.insert(_playerSchems[stateID][_types[bench].isPubSchemTable], item)
					else
						MySQL.insert.await('INSERT INTO bench_schematics (bench, schematic) VALUES(?, ?)', {
							bench,
							item
						})

						local f = table.copy(_schematics[itemsDatabase[item].schematic])
						f.id = item
						table.insert(_types[bench].recipes, f)
					end
				end
			end

			return false
		end,
	},
	GetBench = function(self, source, benchId)
		local char = Fetch:CharacterSource(source)
		if char ~= nil then
			local bench = _types[benchId]
			if
				bench ~= nil
				and char ~= nil
				and (
					not bench.restrictions
					or bench.restrictions.shared
					or (bench.restrictions.interior ~= nil and bench.restrictions.interior == GlobalState[string.format(
						"%s:House",
						source
					)])
					or (bench.restrictions.char ~= nil and bench.restrictions.char == char:GetData("SID"))
					or (bench.restrictions.job ~= nil and Jobs.Permissions:HasJob(
						source,
						bench.restrictions.job.id,
						bench.restrictions.job.workplace,
						bench.restrictions.job.grade,
						false,
						bench.restrictions.job.reqDuty,
						bench.restrictions.job.permissionKey or "JOB_CRAFTING"
					))
					or (
						bench.restrictions.rep ~= nil
						and Reputation:GetLevel(source, bench.restrictions.rep.id) >= bench.restrictions.rep.level
					)
				)
			then
				local recipies = bench.recipes
				local cooldowns = _cooldowns[benchId]
	
				if bench.isPubSchemTable then
					cooldowns = _cooldowns[string.format("%s:%s", benchId, char:GetData("SID"))]

					local all = GetCharacterPublicSchems(char:GetData("SID"), false)
					recipies = {}
					for k, v in ipairs(all[bench.isPubSchemTable] or {}) do
						if itemsDatabase[v]?.schematic ~= nil and _schematics[itemsDatabase[v].schematic] ~= nil then
							local t = deepcopy(_schematics[itemsDatabase[v].schematic])
							t.id = v
							table.insert(recipies, t)
						end
					end
				end

				return {
					recipes = recipies,
					cooldowns = cooldowns,
					canUseSchematics = bench.canUseSchematics,
				}
			else
				return nil
			end
		else
			return nil
		end
	end,
}

function RegisterCraftingCallbacks()
	Callbacks:RegisterServerCallback("Crafting:Craft", function(source, data, cb)
		local char = Fetch:CharacterSource(source)
		if char ~= nil then
			cb(Crafting.Craft:Start(source, char:GetData("SID"), data.bench, data.result, data.qty))
		else
			cb(nil)
		end
	end)

	Callbacks:RegisterServerCallback("Crafting:GetSchematics", function(source, data, cb)
		local char = Fetch:CharacterSource(source)
		if char ~= nil then
			local schems = INVENTORY.Items:GetAllOfType(char:GetData("SID"), 1, 17)
			local list = {}
			for k, v in pairs(schems) do
				local itemData = INVENTORY.Items:GetData(v.Name)
				if itemData?.schematic ~= nil and _schematics[itemData.schematic] ~= nil and not Crafting.Schematics:Has(data.id, itemData.schematic, char:GetData("SID")) then
					local result = INVENTORY.Items:GetData(_schematics[itemData.schematic].result.name)
					if result ~= nil then
						table.insert(list, {
							label = itemData.label,
							description = string.format("Makes: x%s %s", _schematics[itemData.schematic].result.count, result.label),
							event = "Crafting:Client:UseSchematic",
							data = v,
						})
					end
				end
			end

			cb(list)
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("Crafting:UseSchematic", function(source, data, cb)
		local char = Fetch:CharacterSource(source)
		if char ~= nil then
			if INVENTORY.Items:HasId(char:GetData("SID"), 1, data.schematic.id) then
				local bench = _types[data.bench]
				if bench ~= nil then
					if
						bench.canUseSchematics
						and (
							not bench.restrictions
							or bench.restrictions.shared
							or (bench.restrictions.interior ~= nil and bench.restrictions.interior == GlobalState[string.format(
								"%s:House",
								source
							)])
							or (bench.restrictions.char ~= nil and bench.restrictions.char == char:GetData("SID"))
							or (bench.restrictions.job ~= nil and Jobs.Permissions:HasJob(
								source,
								bench.restrictions.job.id,
								bench.restrictions.job.workplace,
								bench.restrictions.job.grade,
								false,
								bench.restrictions.job.reqDuty,
								bench.restrictions.job.permissionKey or "JOB_CRAFTING"
							))
							or (
								bench.restrictions.rep ~= nil
								and Reputation:GetLevel(source, bench.restrictions.rep.id)
									>= bench.restrictions.rep.level
							)
						)
					then
						if INVENTORY.Items:RemoveId(char:GetData("SID"), 1, data.schematic) then
							if Crafting.Schematics:Add(data.bench, data.schematic.Name, char:GetData("SID")) then
								TriggerClientEvent("Crafting:Client:ForceBenchRefresh", source)
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
			else
				cb(false)
			end
		else
			cb(false)
		end
	end)
end

AddEventHandler("Characters:Server:PlayerLoggedOut", function(source, cData)
	if _playerSchems[cData.SID] then
		_playerSchems[cData.SID] = nil
	end
end)

AddEventHandler("Characters:Server:PlayerDropped", function(source, cData)
	if _playerSchems[cData.SID] then
		_playerSchems[cData.SID] = nil
	end
end)

function RegisterTestBench()
	for k, v in ipairs(CraftingTables) do
		Crafting:RegisterBench(
			string.format("crafting-%s", k),
			v.label,
			v.targetConfig,
			v.location,
			v.restriction,
			v.recipes
		)
	end
end

function RegisterPublicSchematicBenches()
	for k, v in ipairs(PublicSchematicTables) do
		Crafting:RegisterBench(
			string.format("public-%s", v.id),
			"Use Tool Bench",
			v.targetConfig,
			v.location,
			{ shared = true },
			{},
			true,
			v.id
		)
	end
end

function GetCharacterPublicSchems(stateID, forceRefresh)
	if _playerSchems[stateID] ~= nil and not forceRefresh then
		return _playerSchems[stateID]
	end

	_playerSchems[stateID] = {}

	local t = MySQL.rawExecute.await('SELECT sid, bench, schematic FROM character_schematics WHERE sid = ?', {
		stateID,
	})

	for k, v in ipairs(t) do
		_playerSchems[stateID][v.bench] = _playerSchems[stateID][v.bench] or {}
		table.insert(_playerSchems[stateID][v.bench], v.schematic)
	end

	return _playerSchems[stateID]
end

AddEventHandler("Jobs:Server:JobUpdate", function(source)
	TriggerClientEvent("Crafting:Client:ForceBenchRefresh", source)
end)