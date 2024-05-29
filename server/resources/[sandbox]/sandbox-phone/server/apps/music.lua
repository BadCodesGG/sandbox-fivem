_royalty = 250 -- amount per play
_maxRoyaltyPerHour = 500 -- max amount per hour
_pendingShopDeposits = {}
_royaltyCompanies = {
	["triad"] = {
		royalty = _royalty,
	},
}
_startingPendingDepositThread = false

AddEventHandler("Phone:Server:RegisterCallbacks", function()
	Callbacks:RegisterServerCallback("Music:Server:SendRoyalties", function(source, data, cb)
		local song = data.title
		local label = string.lower(data.label_name)

		for key, value in pairs(_royaltyCompanies) do
			if string.find(label, key) then
				_pendingShopDeposits[key].royalties[data.id] = _pendingShopDeposits[key].royalties[data.id]
					or { total = 0, song = song, label = label, played = 0 }
				--if _pendingShopDeposits[key].royalties[data.id].total < _maxRoyaltyPerHour then
				_pendingShopDeposits[key].royalties[data.id].total += value.royalty
				_pendingShopDeposits[key].royalties[data.id].played += 1
				--end
			end
		end

		cb(true)
	end)
end)

AddEventHandler("Phone:Server:Startup", function()
	for k, v in pairs(_royaltyCompanies) do
		local t = Banking.Accounts:GetOrganization(k)
		_pendingShopDeposits[k] = {
			bank = t.Account,
			royalties = {},
		}
	end

	if not _startingPendingDepositThread then
		_startingPendingDepositThread = true
		Citizen.CreateThread(function()
			while true do
				Citizen.Wait(1000 * 60 * 60)
				for k, v in pairs(_pendingShopDeposits) do
					for k2, v2 in pairs(v.royalties) do
						Logger:Trace(
							"Phone",
							string.format("Depositing ^2$%s^7 To ^3%s^7 For Royalties", v2.total, v.bank)
						)

						Banking.Balance:Deposit(v.bank, v2.total, {
							type = "deposit",
							title = "Royalty Fee",
							description = string.format("Royalties for %s - Number of Plays %s", v2.song, v2.played),
							data = {
								song = v2.song,
								played = v2.played,
								label = v2.label,
							},
						}, true)

						v.royalties[k2] = nil
					end
				end
			end
		end)
	end
end)
