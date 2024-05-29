local _JOB = "Fishing"
local _joiners = {}
local _fishing = {}

local _fishingCooldowns = {}

AddEventHandler("Labor:Server:Startup", function()
	RegisterFishingItems()

	Callbacks:RegisterServerCallback("Fishing:Catch", function(source, data, cb)
		local char = Fetch:CharacterSource(source)

		if char and data?.toolUsed and data?.zone and data?.difficulty and _fishingZoneBasicBait[data.zone] and (not _fishingCooldowns[source] or _fishingCooldowns[source] <= GetGameTimer()) then
			local toolUsedCount = Inventory.Items:GetCount(char:GetData("SID"), 1, "fishing_" .. data.toolUsed) or 0
			local correctBaitCount = Inventory.Items:GetCount(char:GetData("SID"), 1, _fishingZoneBasicBait[data.zone]) or 0
			local lootTable = {}

			if toolUsedCount > 0 and data.difficulty > 0 then
				local fishLoot = GetFishingLootForZone(data.toolUsed, data.zone)
				local filteredLoot = {}

				for k, v in ipairs(fishLoot) do
					if data.difficulty >= v[3] and (not v[4] or (v[4] and correctBaitCount > 0)) and (not v[5] or (v[5] and data.toolUsed == "net")) then
						table.insert(filteredLoot, v)
					end
				end

				if #filteredLoot > 0 then
					local lootItem = Loot:CustomWeightedSetWithCount(filteredLoot, 0, 0, true)
					if lootItem then
						if FishingConfig.FishItems[lootItem.name] then
							if char:GetData("TempJob") == _JOB and _joiners[source] ~= nil and _fishing[_joiners[source]] ~= nil and (_fishing[_joiners[source]].tool == data.toolUsed) then
								if Labor.Offers:Update(_joiners[source], _JOB, lootItem.count, true) then
									_fishing[_joiners[source]].state = 2
	
									Labor.Workgroups:SendEvent(
										_joiners[source],
										string.format("Fishing:Client:%s:FinishJob", _joiners[source])
									)
									Labor.Offers:ManualFinish(_joiners[source], _JOB)
								end
							end

							if Inventory.Items:Has(char:GetData("SID"), 1, _fishingZoneBasicBait[data.zone], 1) then
								Inventory.Items:Remove(char:GetData("SID"), 1, _fishingZoneBasicBait[data.zone], 1)
							end
						end

						Inventory:AddItem(char:GetData("SID"), lootItem.name, lootItem.count, {}, 1)

						if lootItem.count > 0 then
							local hasToolItem = Inventory.Items:GetFirst(char:GetData("SID"), "fishing_" .. data.toolUsed, 1)
							local mult = 6
							if data.toolUsed == "net" then
								mult = 3
							end

							if hasToolItem then
								local toolData = Inventory.Items:GetData(hasToolItem.Name)
								local newValue = hasToolItem.CreateDate - (60 * 60 * mult * lootItem.count)
								if (os.time() - toolData.durability >= newValue) then
									Inventory.Items:RemoveId(char:GetData("SID"), 1, hasToolItem)
								else
									Inventory:SetItemCreateDate(
										hasToolItem.id,
										newValue
									)
								end
							end
						end
					end

					_fishingCooldowns[source] = GetGameTimer() + 20000

					cb(true)
				else
					cb(false)
				end
			else
				cb(false, true)
			end
		else
			cb(false, true)
		end
	end)

	Callbacks:RegisterServerCallback("Fishing:Sell", function(source, data, cb)
		local char = Fetch:CharacterSource(source)

		local itemData = Inventory.Items:GetData(data)

		if char and itemData then
			local count = Inventory.Items:GetCount(char:GetData("SID"), 1, itemData.name) or 0
			if (count) > 0 then
				if Inventory.Items:Remove(char:GetData("SID"), 1, itemData.name, count) then
					if Player(char:GetData('Source')).state.onDuty == 'police' or Player(char:GetData('Source')).state.onDuty == 'ems' then
						Execute:Client(source, "Notification", "Success", "Thanks for the donation! No money for you kek")
					else
						Wallet:Modify(source, itemData.price * count)
					end
				end
			else
				Execute:Client(source, "Notification", "Error", "You Have No " .. itemData.label)
			end
		end
	end)
end)

function RegisterFishingItems()
	Inventory.Items:RegisterUse("fishing_rod", "Labor", function(source, itemData)
		if _joiners[source] and _fishing[_joiners[source]] ~= nil and _fishing[_joiners[source]].state == 0 then
			_fishing[_joiners[source]].state = 1
			_fishing[_joiners[source]].tool = "rod"
			Labor.Offers:Start(_joiners[source], _JOB, "Catch Fish", 30)
			Labor.Workgroups:SendEvent(
				_joiners[source],
				string.format("Fishing:Client:%s:Startup", _joiners[source])
			)
		end

		TriggerClientEvent("Fishing:Client:StartFishing", source, "rod")
	end)

	Inventory.Items:RegisterUse("fishing_net", "Labor", function(source, itemData)
		local repLvl = Reputation:GetLevel(source, _JOB)

		if repLvl < 3 then
			Execute:Client(source, "Notification", "Error", "Your Net is Tangled and You Don't Know What to Do...")
			return
		end

		if _joiners[source] and _fishing[_joiners[source]] ~= nil and _fishing[_joiners[source]].state == 0 then
			_fishing[_joiners[source]].state = 1
			_fishing[_joiners[source]].tool = "net"
			Labor.Offers:Start(_joiners[source], _JOB, "Catch Fish", 40)
			Labor.Workgroups:SendEvent(
				_joiners[source],
				string.format("Fishing:Client:%s:Startup", _joiners[source])
			)
		end

		TriggerClientEvent("Fishing:Client:StartFishing", source, "net")
	end)

	Inventory.Items:RegisterUse("fishing_boot", "Fishing", function(source, item)
		local char = Fetch:CharacterSource(source)

		if char and Inventory.Items:Remove(char:GetData("SID"), 1, item.Name, 1) then
			Loot:CustomWeightedSetWithCount({
				{ 35, { name = "scrapmetal", min = 1, max = 2 } },
				{ 20, { name = "rubber", min = 1, max = 3 } },
				{ 15, { name = "goldcoins", min = 3, max = 7 } },
				{ 1, { name = "diamond", min = 1, max = 1 } },
				{ 1, { name = "opal", min = 1, max = 1 } },
				{ 10, { name = "ring", min = 2, max = 5 } },
			}, char:GetData("SID"), 1)
		end
	end)

	Inventory.Items:RegisterUse("fishing_chest", "Fishing", function(source, item)
		local char = Fetch:CharacterSource(source)
		if char and Inventory.Items:Remove(char:GetData("SID"), 1, item.Name, 1) then
			Loot:CustomWeightedSetWithCount({
				{ 35, { name = "goldcoins", min = 7, max = 15 } },
				{ 25, { name = "ring", min = 6, max = 12 } },
				{ 18, { name = "goldbar", min = 1, max = 3 } },
				{ 13, { name = "house_art", min = 1, max = 1 } },
				{ 9, { name = "opal", min = 1, max = 2 } },
				{ 7, { name = "valuegoods", min = 1, max = 1 } },
				{ 1, { name = "diamond", min = 1, max = 1 } },
				{ 5, { name = "amethyst", min = 1, max = 2 } },
			}, char:GetData("SID"), 1)
		end
	end)
end

AddEventHandler("Fishing:Server:OnDuty", function(joiner, members, isWorkgroup)
	_joiners[joiner] = joiner
	_fishing[joiner] = {
		joiner = joiner,
		isWorkgroup = isWorkgroup,
		started = os.time(),
		state = 0,
	}

	local char = Fetch:CharacterSource(joiner)
	char:SetData("TempJob", _JOB)
	Phone.Notification:Add(joiner, "Job Activity", "You started a job", os.time(), 6000, "labor", {})
	TriggerClientEvent("Fishing:Client:OnDuty", joiner, joiner, os.time())

	Labor.Offers:Task(joiner, _JOB, "Buy Fishing Equipment & Start Fishing")
	if #members > 0 then
		for k, v in ipairs(members) do
			_joiners[v.ID] = joiner
			local member = Fetch:CharacterSource(v.ID)
			member:SetData("TempJob", _JOB)
			Phone.Notification:Add(v.ID, "Job Activity", "You started a job", os.time(), 6000, "labor", {})
			TriggerClientEvent("Fishing:Client:OnDuty", v.ID, joiner, os.time())
		end
	end
end)

AddEventHandler("Fishing:Server:OffDuty", function(source, joiner)
	_joiners[source] = nil
	TriggerClientEvent("Fishing:Client:OffDuty", source)
end)

AddEventHandler("Fishing:Server:FinishJob", function(joiner)
	_fishing[joiner] = nil
end)
