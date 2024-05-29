function PrisonHospitalCallbacks()
	Callbacks:RegisterServerCallback("Hospital:PrisonHospitalRevive", function(source, data, cb)
		local char = Fetch:CharacterSource(source)
		local p = Player(source).state
		local cost = Config.PrisonCheckIn.Cost

		Billing:Charge(source, cost, "Medical Services", "Use of facilities at Bolingbroke Infirmary")

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

		local tChar = Fetch:CharacterSource(source)
		if tChar ~= nil then
			Callbacks:ClientCallback(tChar:GetData("Source"), "Damage:Heal", true)
		else
			Execute:Client(source, "Notification", "Error", "An error has occured. Please report this.")
		end

		cb(true)
	end)
end
