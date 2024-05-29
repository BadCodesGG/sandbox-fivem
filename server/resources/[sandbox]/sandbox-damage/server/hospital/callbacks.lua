function HospitalCallbacks()
	Chat:RegisterCommand(
		"icu",
		function(source, args, rawCommand)
			if tonumber(args[1]) then
				local char = Fetch:SID(tonumber(args[1]))
				if char ~= nil then
					Hospital.ICU:Send(char:GetData("Source"))
					Chat.Send.System:Single(source, string.format("%s Has Been Admitted To ICU", args[1]))
				else
					Chat.Send.System:Single(source, "State ID Not Logged In")
				end
			else
				Chat.Send.System:Single(source, "Invalid Arguments")
			end
		end,
		{
			help = "Sends Patient To ICU, Where They Will Remain Until Released By Medical Staff",
			params = {
				{
					name = "Target",
					help = "State ID of target",
				},
			},
		},
		1,
		{
			{
				Id = "ems",
			},
		}
	)
	Chat:RegisterCommand(
		"release",
		function(source, args, rawCommand)
			if tonumber(args[1]) then
				local char = Fetch:SID(tonumber(args[1]))
				if char ~= nil and char:GetData("ICU") ~= nil and not char:GetData("ICU").Released then
					Hospital.ICU:Release(char:GetData("Source"))
					Chat.Send.System:Single(source, string.format("%s Has Been Released From ICU", args[1]))
				else
					Chat.Send.System:Single(source, "State ID Not Logged In")
				end
			else
				Chat.Send.System:Single(source, "Invalid Arguments")
			end
		end,
		{
			help = "Releases a patient from ICU",
			params = {
				{
					name = "Target",
					help = "State ID of target",
				},
			},
		},
		1,
		{
			{
				Id = "ems",
			},
		}
	)

	Callbacks:RegisterServerCallback("Hospital:Treat", function(source, data, cb)
		local char = Fetch:CharacterSource(source)
		local bed = Hospital:RequestBed(source)

		local cost = 1500
		-- if not GlobalState["Duty:ems"] or GlobalState["Duty:ems"] == 0 then
		-- 	cost = 150
		-- end

		Billing:Charge(source, cost, "Medical Services", "Use of facilities at St. Fiacre Medical Center")

		local f = Banking.Accounts:GetOrganization("ems")
		Banking.Balance:Deposit(f.Account, cost / 2, {
			type = "deposit",
			title = "Medical Treatment",
			description = string.format("Medical Bill For %s %s", char:GetData("First"), char:GetData("Last")),
			data = {},
		}, true)

		f = Banking.Accounts:GetOrganization("government")
		Banking.Balance:Deposit(f.Account, cost / 2, {
			type = "deposit",
			title = "Medical Treatment",
			description = string.format("Medical Bill For %s %s", char:GetData("First"), char:GetData("Last")),
			data = {},
		}, true)

		cb(bed)
	end)

	Callbacks:RegisterServerCallback("Hospital:Respawn", function(source, data, cb)
		local char = Fetch:CharacterSource(source)
		if os.time() >= Player(source).state.releaseTime then
			Pwnzor.Players:TempPosIgnore(source)
			local bed = Hospital:RequestBed(source)

			local cost = 1500
			-- if not GlobalState["Duty:ems"] or GlobalState["Duty:ems"] == 0 then
			-- 	cost = 150
			-- end

			Billing:Charge(source, cost, "Medical Services", "Use of facilities at St. Fiacre Medical Center")
			Logger:Info(
				"Robbery",
				string.format(
					"%s %s (%s) Respawned Via Local EMS",
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

			local f = Banking.Accounts:GetOrganization("ems")
			Banking.Balance:Deposit(f.Account, cost / 2, {
				type = "deposit",
				title = "Medical Treatment",
				description = string.format("Medical Bill For %s %s", char:GetData("First"), char:GetData("Last")),
				data = {},
			}, true)

			f = Banking.Accounts:GetOrganization("government")
			Banking.Balance:Deposit(f.Account, cost / 2, {
				type = "deposit",
				title = "Medical Treatment",
				description = string.format("Medical Bill For %s %s", char:GetData("First"), char:GetData("Last")),
				data = {},
			}, true)

			cb(bed)
		else
			cb(nil)
		end
	end)

	Callbacks:RegisterServerCallback("Hospital:FindBed", function(source, data, cb)
		cb(Hospital:FindBed(source, data))
	end)

	Callbacks:RegisterServerCallback("Hospital:OccupyBed", function(source, data, cb)
		cb(Hospital:OccupyBed(source, data))
	end)

	Callbacks:RegisterServerCallback("Hospital:LeaveBed", function(source, data, cb)
		cb(Hospital:LeaveBed(source))
	end)

	Callbacks:RegisterServerCallback("Hospital:RetreiveItems", function(source, data, cb)
		Hospital.ICU:GetItems(source)
	end)

	Callbacks:RegisterServerCallback("Hospital:HiddenRevive", function(source, data, cb)
		local char = Fetch:CharacterSource(source)
		local p = Player(source).state
		if p.isEscorting ~= nil then
			local t = Player(p.isEscorting).state
			if t ~= nil and t.isDead then
				if Crypto.Exchange:Remove("MALD", char:GetData("CryptoWallet"), 20) then
					cb(true)
					local tChar = Fetch:CharacterSource(p.isEscorting)
					if tChar ~= nil then
						Callbacks:ClientCallback(tChar:GetData("Source"), "Damage:Heal", true)
					else
						Execute:Client(source, "Notification", "Error", "Invalid Target")
					end
				else
					cb(false)
					Execute:Client(source, "Notification", "Error", "Not Enough Crypto")
				end
			end
		end
	end)

	Callbacks:RegisterServerCallback("Hospital:SpawnICU", function(source, data, cb)
		Routing:RoutePlayerToGlobalRoute(source)
		local char = Fetch:CharacterSource(source)
		Player(source).state.ICU = false
		TriggerClientEvent("Hospital:Client:ICU:Enter", source)
		cb(true)
	end)
end
