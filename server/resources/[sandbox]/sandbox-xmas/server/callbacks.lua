function RegisterCallbacks()
	Callbacks:RegisterServerCallback("Xmas:Server:PickupSnowball", function(source, data, cb)
		local char = Fetch:CharacterSource(source)
		if char ~= nil then
			local sid = char:GetData("SID")
			Inventory:AddItem(sid, "WEAPON_SNOWBALL", 0, { ammo = 1, clip = 0 }, 1)
		end
	end)

	Callbacks:RegisterServerCallback("Xmas:Daily", function(source, data, cb)
		local char = Fetch:CharacterSource(source)
		if char ~= nil then
			local sid = char:GetData("SID")
			local daily = char:GetData("XmasDaily")
			local dailyCount = char:GetData("XmasDailyCount") or 0
			if
				_currentDate.month == XMAS_MONTH
				and (daily == nil or daily ~= _currentDate.day)
				and ((_currentDate.day ~= 25 and dailyCount < 1) or (_currentDate.day == 25 and dailyCount < 3))
			then
				Logger:Info(
					"Xmas",
					string.format(
						"%s %s (%s) Looted Daily Present From Legion Igloo",
						char:GetData("First"),
						char:GetData("Last"),
						sid
					),
					{
						console = true,
						file = false,
						database = true,
						discord = {
							embed = true,
							type = "error",
							webhook = GetConvar("discord_loot_webhook", ""),
						},
					}
				)
				Inventory:AddItem(sid, "present_daily", 1, {}, 1)
				char:SetData("XmasDaily", _currentDate.day)
			end
		end
	end)

	Callbacks:RegisterServerCallback("Xmas:Tree", function(source, data, cb)
		local char = Fetch:CharacterSource(source)
		if char ~= nil then
			local sid = char:GetData("SID")
			if not _treeLooted[sid] then
				Logger:Trace(
					"Xmas",
					string.format(
						"%s %s (%s) Looted Present From Christmas Tree",
						char:GetData("First"),
						char:GetData("Last"),
						sid
					),
					{
						console = true,
						file = false,
						database = true,
						discord = {
							embed = true,
							type = "error",
							webhook = GetConvar("discord_loot_webhook", ""),
						},
					}
				)
				Inventory:AddItem(sid, "present", 1, {}, 1)
				_treeLooted[sid] = true
				cb(true)
			else
				cb(true)
			end
		else
			cb(true)
		end
	end)
end
