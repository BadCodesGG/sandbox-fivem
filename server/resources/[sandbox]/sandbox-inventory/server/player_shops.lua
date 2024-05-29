function LoadPlayerShops()
    local shops = MySQL.rawExecute.await("SELECT id, name, position, ped_model, owner, owner_bank as bank, job FROM player_shops")
    for k, v in ipairs(shops) do
        _playerShopMods[v.id] = MySQL.rawExecute.await('SELECT sid, name FROM player_shops_moderators WHERE shop = ?', {
            v.id
        })

        GlobalState[string.format("BasicShop:%s", v.id)] = true

        _playerShops[v.id] = {
            id = v.id,
            name = v.name,
            ped_model = v.ped_model,
            position = json.decode(v.position),
            owner = v.owner,
            bank = v.bank,
            job = v.job,
        }
    end
end
