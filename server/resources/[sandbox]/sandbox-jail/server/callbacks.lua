function RegisterCallbacks()
	Callbacks:RegisterServerCallback("Jail:SpawnJailed", function(source, data, cb)
		Routing:RoutePlayerToGlobalRoute(source)
		local char = Fetch:CharacterSource(source)
		TriggerClientEvent("Jail:Client:EnterJail", source)
		cb(true)
	end)

	Callbacks:RegisterServerCallback("Jail:Validate", function(source, data, cb)
		if not Jail:IsJailed(source) then
			cb(false)
		else
			if data.type == "logout" then
				cb(true)
			else
				cb(false)
			end
		end
	end)

	Callbacks:RegisterServerCallback("Jail:RetreiveItems", function(source, data, cb)
		Inventory.Holding:Take(source)
	end)

	Callbacks:RegisterServerCallback("Jail:Release", function(source, data, cb)
		cb(Jail:Release(source))
	end)

	Callbacks:RegisterServerCallback("Jail:StartWork", function(source, data, cb)
		Labor.Duty:On("Prison", source, false)
	end)

	Callbacks:RegisterServerCallback("Jail:QuitWork", function(source, data, cb)
		Labor.Duty:Off("Prison", source, false, false)
	end)

	Callbacks:RegisterServerCallback("Jail:MakeItem", function(source, data, cb)
		local char = Fetch:CharacterSource(source)
		if data == "food" or data == "drink" then
			Inventory:AddItem(char:GetData("SID"), string.format("prison_%s", data), 1, {}, 1)
		end
	end)

	Callbacks:RegisterServerCallback("Jail:MakeJuice", function(source, data, cb)
		local char = Fetch:CharacterSource(source)
		if char and data then
			Inventory:AddItem(char:GetData("SID"), data, 1, {}, 1)
		end
	end)

	Callbacks:RegisterServerCallback("Jail:Server:ExploitAttempt", function(source, data, cb)
		local char = Fetch:CharacterSource(source)
		if char then
			if data == 1 then
				Logger:Info(
					"Jail",
					string.format(
						"%s %s (%s) attempted to exploit out of prison in a trunk",
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
							type = "info",
							webhook = GetConvar("discord_log_webhook", ""),
						},
					}
				)
			elseif data == 2 then
				Logger:Info(
					"Jail",
					string.format(
						"%s %s (%s) attempted to exploit out of prison by being escorted out",
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
							type = "info",
							webhook = GetConvar("discord_log_webhook", ""),
						},
					}
				)
			end
		end
	end)
end
