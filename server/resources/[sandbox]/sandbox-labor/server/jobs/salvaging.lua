local _JOB = "Salvaging"
local _joiners = {}
local _salvaging = {}

local _lootTable = {
	{ 5, { item = "heavy_glue", min = 10, max = 20 } },
	{ 10, { item = "electronic_parts", min = 10, max = 30 } },
	{ 10, { item = "ironbar", min = 15, max = 35 } },
	{ 15, { item = "scrapmetal", min = 10, max = 20 } },
	{ 18, { item = "plastic", min = 10, max = 20 } },
	{ 17, { item = "copperwire", min = 10, max = 20 } },
	{ 10, { item = "glue", min = 10, max = 20 } },
	{ 15, { item = "rubber", min = 10, max = 20 } },
}

local _deliveryLocs = {
	{ coords = vector3(751.675, 6459.170, 30.389), heading = 63.946 },
	{ coords = vector3(-358.859, 6062.094, 30.500), heading = 40.943 },
	{ coords = vector3(58.984, 2795.010, 56.878), heading = 318.115 },
	{ coords = vector3(1332.288, 4381.922, 43.328), heading = 163.755 },
	{ coords = vector3(-1143.611, 2672.218, 17.178), heading = 223.368 },
	{ coords = vector3(915.404, 3560.406, 32.805), heading = 273.063 },
	{ coords = vector3(2909.706, 4471.410, 47.136), heading = 135.970 },
	{ coords = vector3(678.187, 73.964, 82.138), heading = 264.695 },
	{ coords = vector3(1667.063, -62.022, 173.170), heading = 252.920 },
}

AddEventHandler("Labor:Server:Startup", function()
	Callbacks:RegisterServerCallback("Salvaging:StartJob", function(source, data, cb)
		if _salvaging[data] ~= nil and _salvaging[data].state == 0 then
			Labor.Offers:Start(data, _JOB, "Scrap Cars", 15)
			_salvaging[data].state = 1
			Labor.Workgroups:SendEvent(_joiners[source], string.format("Salvaging:Client:%s:Startup", _joiners[source]))
			cb(true)
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("Salvaging:SalvageCar", function(source, data, cb)
		local char = Fetch:CharacterSource(source)
		if
			char:GetData("TempJob") == _JOB
			and _joiners[source] ~= nil
			and _salvaging[_joiners[source]] ~= nil
			and _salvaging[_joiners[source]].state == 1
		then
			if _salvaging[_joiners[source]].entities[data] == nil then
				_salvaging[_joiners[source]].entities[data] = false
			end

			if not _salvaging[_joiners[source]].entities[data] then
				_salvaging[_joiners[source]].entities[data] = true

				local randomLoot = Utils:WeightedRandom(_lootTable)
				Inventory:AddItem(char:GetData("SID"), randomLoot.item, math.random(randomLoot.max), {}, 1)
				-- local luck = math.random(100)
				-- if luck == 100 then
				-- 	Loot:CustomSet(_highClassLoot, char:GetData("SID"), 1, math.random(5))
				-- elseif luck >= 75 then
				-- 	Loot:CustomSet(_lootTable, char:GetData("SID"), 1, math.random(10))
				-- end

				Inventory:AddItem(char:GetData("SID"), "salvagedparts", math.random(10), {}, 1)
				Labor.Workgroups:SendEvent(
					_joiners[source],
					string.format("Salvaging:Client:%s:Action", _joiners[source]),
					data
				)

				if Labor.Offers:Update(_joiners[source], _JOB, 1, true) then
					_salvaging[_joiners[source]].state = 2
					Labor.Workgroups:SendEvent(
						_joiners[source],
						string.format("Salvaging:Client:%s:EndScrapping", _joiners[source])
					)
					Labor.Offers:Task(_joiners[source], _JOB, "Return To The Yard Manager")
				end
			end
		end
	end)

	Callbacks:RegisterServerCallback("Salvaging:TriggerDelivery", function(source, data, cb)
		local char = Fetch:CharacterSource(source)
		if _salvaging[_joiners[source]].state == 2 then
			_salvaging[_joiners[source]].state = 3
			Inventory:AddItem(char:GetData("SID"), "packaged_parts", 1, {}, 1)
			Labor.Offers:Start(_joiners[source], _JOB, "Deliver Packaged Parts", 1)
			Labor.Workgroups:SendEvent(
				_joiners[source],
				string.format("Salvaging:Client:%s:StartDelivery", _joiners[source]),
				_deliveryLocs[math.random(#_deliveryLocs)]
			)
		else
			Execute:Client(source, "Notification", "Error", "Not On That Step")
		end
	end)

	Callbacks:RegisterServerCallback("Salvaging:EndDelivery", function(source, data, cb)
		local char = Fetch:CharacterSource(source)
		if
			char:GetData("TempJob") == _JOB
			and _joiners[source] ~= nil
			and _salvaging[_joiners[source]] ~= nil
			and _salvaging[_joiners[source]].state == 3
		then
			local count = Inventory.Items:GetCount(char:GetData("SID"), 1, "packaged_parts")
			if (count or 0) > 0 then
				if Inventory.Items:Remove(char:GetData("SID"), 1, "packaged_parts", count) then
					_salvaging[_joiners[source]].state = 4
					Labor.Offers:ManualFinish(_joiners[source], _JOB)
					cb(true)
				else
					Execute:Client(source, "Notification", "Error", "Unable To Remove Packaged Parts")
					cb(false)
				end
			else
				Execute:Client(source, "Notification", "Error", "You Have No Packaged Parts")
				cb(false)
			end
		else
			Execute:Client(source, "Notification", "Error", "Unable To Turn In Packaged Parts")
			cb(false)
		end
	end)
end)

AddEventHandler("Salvaging:Server:OnDuty", function(joiner, members, isWorkgroup)
	_joiners[joiner] = joiner
	_salvaging[joiner] = {
		joiner = joiner,
		isWorkgroup = isWorkgroup,
		started = os.time(),
		entities = {},
		state = 0,
	}

	local char = Fetch:CharacterSource(joiner)
	char:SetData("TempJob", _JOB)
	Phone.Notification:Add(joiner, "Job Activity", "You started a job", os.time(), 6000, "labor", {})
	TriggerClientEvent("Salvaging:Client:OnDuty", joiner, joiner, os.time())

	if #members > 0 then
		for k, v in ipairs(members) do
			_joiners[v.ID] = joiner
			local member = Fetch:CharacterSource(v.ID)
			member:SetData("TempJob", _JOB)
			Phone.Notification:Add(v.ID, "Job Activity", "You started a job", os.time(), 6000, "labor", {})
			TriggerClientEvent("Salvaging:Client:OnDuty", v.ID, joiner, os.time())
		end
	end
	Labor.Offers:Task(joiner, _JOB, "Talk To The Yard Manager")
end)

AddEventHandler("Salvaging:Server:OffDuty", function(source, joiner)
	_joiners[source] = nil
	TriggerClientEvent("Salvaging:Client:OffDuty", source)
end)

AddEventHandler("Salvaging:Server:FinishJob", function(joiner)
	_salvaging[joiner] = nil
end)
