AddEventHandler('Businesses:Server:Startup', function()
    Callbacks:RegisterServerCallback('BH:MakeItRain', function(source, data, cb)
        local char = Fetch:CharacterSource(source)
        local targetChar = Fetch:CharacterSource(data?.target)

        if char and targetChar and data?.type and Player(targetChar:GetData('Source')).state.onDuty == 'bahama' then
            local itemData = Inventory.Items:GetData(data.type)
            if data.type == 'cash' then
                if Wallet:Modify(char:GetData('Source'), -100) then
                    Wallet:Modify(targetChar:GetData('Source'), 100)
                    return cb(true)
                end
            elseif itemData then
                if Inventory.Items:Has(char:GetData('SID'), 1, data.type, 1) then
                    if Inventory.Items:Remove(char:GetData('SID'), 1, data.type, 1) then
                        Wallet:Modify(targetChar:GetData('Source'), math.floor(itemData.price * 0.1))
                        Wallet:Modify(char:GetData('Source'), math.floor(itemData.price * 0.8))

						local f = Banking.Accounts:GetOrganization("bahama")
						Banking.Balance:Deposit(f.Account, math.floor(itemData.price * 0.05), {
							type = "deposit",
							title = "Private Dances",
							description = string.format("5%% Tax On %s Private Dances",  math.floor(itemData.price)),
							data = data,
						}, true)

                        return cb(true)
                    end
                end
            end
        end

        cb(false)
    end)
end)