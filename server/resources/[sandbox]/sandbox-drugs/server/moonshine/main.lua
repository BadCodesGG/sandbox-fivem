_placedStills = {}
_inProgBrews = {}

_placedBarrels = {}
_inProgAges = {}

local bought = {}

local year = os.date("%Y")
local month = os.date("%m")
local _toolsForSale = {
	{ id = 1, item = "moonshine_still", coin = "MALD", price = 60, qty = 5, vpn = true, limited = {
        id = year + month,
        qty = 5,
    } },
}

_DRUGS = _DRUGS or {}
_DRUGS.Moonshine = {
    Still = {
        Generate = function(self, tier)
            return MySQL.insert.await('INSERT INTO moonshine_stills (created, tier) VALUES(?, ?)', { os.time(), tier })
        end,
        Get = function(self, stillId)
            return MySQL.single.await('SELECT id, tier, created, cooldown, active_cook FROM moonshine_stills WHERE id = ?', { stillId })
        end,
        IsPlaced = function(self, stillId)
            return MySQL.scalar.await('SELECT COUNT(still_id) as Count FROM placed_moonshine_stills WHERE still_id = ?', { stillId }) > 0
        end,
        CreatePlaced = function(self, stillId, owner, tier, coords, heading, created)
            local itemInfo = Inventory.Items:GetData("moonshine_still")
            local stillData = _DRUGS.Moonshine.Still:Get(stillId)
    
            MySQL.insert.await("INSERT INTO placed_moonshine_stills (still_id, owner, placed, expires, coords, heading) VALUES(?, ?, ?, ?, ?, ?)", {
                stillId,
                owner,
                os.time(),
                created + itemInfo.durability,
                json.encode(coords),
                heading,
            })
    
            local cookData = stillData.active_cook ~= nil and json.decode(stillData.active_cook) or {}
    
            _placedStills[stillId] = {
                id = stillId,
                owner = owner,
                tier = tier,
                placed = os.time(),
                expires = created + itemInfo.durability,
                cooldown = stillData.cooldown,
                activeBrew = stillData.active_cook ~= nil,
                pickupReady = os.time() > (cookData?.end_time or 0),
                coords = coords,
                heading = heading,
            }
    
            TriggerClientEvent("Drugs:Client:Moonshine:CreateStill", -1, _placedStills[stillId])
        end,
        RemovePlaced = function(self, stillId)
            local s = MySQL.query.await('DELETE FROM placed_moonshine_stills WHERE still_id = ?', { stillId })
            if s.affectedRows > 0 then
                _placedStills[stillId] = nil
                TriggerClientEvent("Drugs:Client:Moonshine:RemoveStill", -1, stillId)
            end
            return s.affectedRows > 0
        end,
        StartCook = function(self, stillId, cooldown, results)
            MySQL.query.await('UPDATE moonshine_stills SET cooldown = ?, active_cook = ? WHERE id = ?', { cooldown, json.encode(results), stillId })
            _placedStills[stillId].cooldown = cooldown
            _placedStills[stillId].activeBrew = true
            _placedStills[stillId].pickupReady = false
            _inProgBrews[stillId] = results
    
            TriggerClientEvent("Drugs:Client:Moonshine:UpdateStillData", -1, stillId, _placedStills[stillId])
        end,
        FinishCook = function(self, stillId)
            MySQL.query.await('UPDATE moonshine_stills SET active_cook = NULL WHERE id = ?', { stillId })
            _placedStills[stillId].activeBrew = false
            _placedStills[stillId].pickupReady = false
            _inProgBrews[stillId] = nil
            TriggerClientEvent("Drugs:Client:Moonshine:UpdateStillData", -1, stillId, _placedStills[stillId])
        end
    },
    Barrel = {
        Generate = function(self)
            return {
                Quality = math.random(1, 100),
                Drinks = math.random(15, 30),
            }
        end,
        IsPlaced = function(self, barrelId)
            return MySQL.scalar.await('SELECT COUNT(*) as Count FROM placed_moonshine_barrels WHERE barrel_id = ?', { barrelId }) > 0
        end,
        CreatePlaced = function(self, owner, coords, heading, created, brewData)
            local itemInfo = Inventory.Items:GetData("moonshine_barrel")
            local ready = os.time() + (60 * 60 * 24 * 2)

            local barrelId = MySQL.insert.await("INSERT INTO placed_moonshine_barrels (owner, placed, ready, expires, coords, heading, brew_data) VALUES(?, ?, ?, ?, ?, ?, ?)", {
                owner,
                os.time(),
                ready,
                created + itemInfo.durability,
                json.encode(coords),
                heading,
                json.encode(brewData),
            })
    
            _placedBarrels[barrelId] = {
                id = barrelId,
                owner = owner,
                placed = os.time(),
                ready = ready,
                expires = created + itemInfo.durability,
                pickupReady = false,
                coords = coords,
                heading = heading,
                brewData = brewData,
            }

            _inProgAges[barrelId] = ready
    
            TriggerClientEvent("Drugs:Client:Moonshine:CreateBarrel", -1, _placedBarrels[barrelId])
        end,
        RemovePlaced = function(self, barrelId)
            local s = MySQL.query.await('DELETE FROM placed_moonshine_barrels WHERE barrel_id = ?', { barrelId })
            if s.affectedRows > 0 then
                _placedBarrels[barrelId] = nil
                TriggerClientEvent("Drugs:Client:Moonshine:RemoveBarrel", -1, barrelId)
            end
            return s.affectedRows > 0
        end,
    },
}

AddEventHandler("Drugs:Server:Startup", function()
    -- local mPos = _methSellerLocs[tostring(os.date("%w"))]

    Vendor:Create("MoonshineSeller", "ped", "Karen", `S_F_Y_Bartender_01`, {
        coords = vector3(755.504, -1860.620, 48.292),
        heading = 307.963,
        scenario = "WORLD_HUMAN_SMOKING"
    }, _toolsForSale, "jar", "View Offers", false, false, true)

    local stills = MySQL.query.await('SELECT * FROM placed_moonshine_stills WHERE expires > ?', { os.time() })
    for k, v in ipairs(stills) do
        if _placedStills[v.still_id] == nil then
            local stillData = Drugs.Moonshine.Still:Get(v.still_id)

            if stillData ~= nil then
                local coords = json.decode(v.coords)
        
                local cookData = stillData.active_cook ~= nil and json.decode(stillData.active_cook) or {}
                _placedStills[v.still_id] = {
                    id = v.still_id,
                    owner = v.owner,
                    tier = stillData.tier,
                    placed = v.placed,
                    expires = v.expires,
                    cooldown = stillData.cooldown,
                    activeBrew = stillData.active_cook ~= nil,
                    pickupReady = os.time() > (cookData?.end_time or 0),
                    coords = coords,
                    heading = v.heading,
                }
    
                if stillData.active_cook then
                    local f = json.decode(stillData.active_cook)
                    if f.end_time > os.time() then
                        _inProgBrews[v.still_id] = f
                    end
                end
            end
        end
    end

    Logger:Trace("Drugs:Moonshine", string.format("Restored ^2%s^7 Moonshine Stills", #stills))

    local barrels = MySQL.query.await('SELECT * FROM placed_moonshine_barrels WHERE expires > ?', { os.time() })
    for k, v in ipairs(barrels) do
        if _placedBarrels[v.barrel_id] == nil then
            local coords = json.decode(v.coords)

            _placedBarrels[v.barrel_id] = {
                id = v.barrel_id,
                owner = v.owner,
                placed = v.placed,
                ready = v.ready,
                expires = v.expires,
                pickupReady = os.time() > (v.ready or 0),
                coords = coords,
                heading = v.heading,
                brewData = json.decode(v.brew_data),
            }

            if v.ready > os.time() then
                _inProgAges[v.barrel_id] = v.ready
            end
        end
    end

    Logger:Trace("Drugs:Moonshine", string.format("Restored ^2%s^7 Moonshine Barrels", #barrels))

    Middleware:Add("Characters:Spawning", function(source)
        TriggerLatentClientEvent("Drugs:Client:Moonshine:SetupStills", source, 50000, _placedStills)
        TriggerLatentClientEvent("Drugs:Client:Moonshine:SetupBarrels", source, 50000, _placedBarrels)
    end, 1)

    Callbacks:RegisterServerCallback("Drugs:Moonshine:FinishStillPlacement", function(source, data, cb)
        local char = Fetch:CharacterSource(source)
        if char ~= nil then
            local still = Inventory:GetItem(data.data)
            if still.Owner == tostring(char:GetData("SID")) then
                local md = json.decode(still.MetaData)
                local stillData = Drugs.Moonshine.Still:Get(md.Still)
                if Inventory.Items:RemoveId(char:GetData("SID"), 1, still) then
                    Drugs.Moonshine.Still:CreatePlaced(md.Still, char:GetData("SID"), stillData.tier, data.endCoords.coords, data.endCoords.rotation, still.CreateDate)
                    cb(true)
                else
                    cb(false)
                end
            end
        else
            cb(false)
        end
    end)

    Callbacks:RegisterServerCallback("Drugs:Moonshine:PickupStill", function(source, data, cb)
        local char = Fetch:CharacterSource(source)
        local pState = Player(source).state
        if char ~= nil then
            if data then
                if Drugs.Moonshine.Still:IsPlaced(data) then
                    local stillData =Drugs.Moonshine.Still:Get(data)
                    if pState.onDuty == "police" or stillData.owner == char:GetData("SID") then
                        if Drugs.Moonshine.Still:RemovePlaced(data) then
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
    end)

    Callbacks:RegisterServerCallback("Drugs:Moonshine:CheckStill", function(source, data, cb)
        local char = Fetch:CharacterSource(source)
        if char ~= nil then
            if data and _placedStills[data] ~= nil then
                if _placedStills[data].cooldown == nil or os.time() > _placedStills[data].cooldown then
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
    end)

    Callbacks:RegisterServerCallback("Drugs:Moonshine:StartCooking", function(source, data, cb)
        local char = Fetch:CharacterSource(source)
        if char ~= nil then
            if data and _placedStills[data.stillId] ~= nil then
                if _placedStills[data.stillId].cooldown == nil or os.time() > _placedStills[data.stillId].cooldown then
                    local stillData = Drugs.Moonshine.Still:Get(data.stillId)
                    Drugs.Moonshine.Still:StartCook(data.stillId, os.time() + (60 * 60 * 2), {
                        start_time = os.time(),
                        end_time = os.time() + (60 * _stillTiers[stillData.tier]?.cookTime or 30),
                        quality = (data.results.success / data.results.total) * 100
                    })

                    Execute:Client(source, "Notification", "Success", string.format("Brew Started, Will Be Ready In %s Minutes", _stillTiers[stillData.tier]?.cookTime or 30))
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
    end)

    Callbacks:RegisterServerCallback("Drugs:Moonshine:PickupCook", function(source, data, cb)
        local char = Fetch:CharacterSource(source)
        if char ~= nil then
            if data and _placedStills[data] ~= nil then
                local stillData = Drugs.Moonshine.Still:Get(data)
                if stillData.active_cook ~= nil then
                    local cookData = json.decode(stillData.active_cook)
                    if os.time() > cookData.end_time then
                        if Inventory:AddItem(char:GetData("SID"), "moonshine_barrel", 1, {
                            Brew = {
                                Quality = cookData.quality,
                                Drinks = math.random(15, 30),
                            }
                        }, 1, false, false, false, false, false, false, false) then
                            Drugs.Moonshine.Still:FinishCook(data)
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

    Callbacks:RegisterServerCallback("Drugs:Moonshine:GetStillDetails", function(source, data, cb)
        local char = Fetch:CharacterSource(source)
        if char ~= nil then
            if data and _placedStills[data] ~= nil then
                local stillData = Drugs.Moonshine.Still:Get(data)

                local menu = {
                    main = {
                        label = "Still Information",
                        items = {}
                    },
                }

                if stillData.cooldown ~= nil then
                    local timeUntil = stillData.cooldown - os.time()
                    if timeUntil > 0 then
                        table.insert(menu.main.items, {
                            label = "On Cooldown",
                            description = string.format("Available %s (in about %s)</li>", os.date("%m/%d/%Y %I:%M %p", stillData.cooldown), GetFormattedTimeFromSeconds(timeUntil)),
                        })
                    else
                        table.insert(menu.main.items, {
                            label = "Cooldown Expired",
                            description = string.format("Expired at %s</li>", os.date("%m/%d/%Y %I:%M %p", stillData.cooldown)),
                        })
                    end
                else
                    table.insert(menu.main.items, {
                        label = "Not On Cooldown",
                        description = string.format("No Cooldown Information Available"),
                    })
                end

                if stillData.active_cook ~= nil then
                    local cook = json.decode(stillData.active_cook)

                    local timeUntil = cook.end_time - os.time()
                    if timeUntil > 0 then
                        table.insert(menu.main.items, {
                            label = "Brew Status",
                            description = string.format("Finishes at %s (in about %s)", os.date("%m/%d/%Y %I:%M %p", cook.end_time), GetFormattedTimeFromSeconds(timeUntil)),
                        })
                    else
                        table.insert(menu.main.items, {
                            label = "Brew Status",
                            description = string.format("Finished at %s", os.date("%m/%d/%Y %I:%M %p", cook.end_time)),
                        })
                    end
                else
                    table.insert(menu.main.items, {
                        label = "Brew Status",
                        description = string.format("No Active Brew"),
                    })
                end

                cb(menu)
            else
                cb(false)
            end
        else
            cb(false)
        end
    end)

    Callbacks:RegisterServerCallback("Drugs:Moonshine:FinishBarrelPlacement", function(source, data, cb)
        local char = Fetch:CharacterSource(source)
        if char ~= nil then
            local barrel = Inventory:GetItem(data.data)
            if barrel.Owner == tostring(char:GetData("SID")) then
                local md = json.decode(barrel.MetaData)
                if Inventory.Items:RemoveId(char:GetData("SID"), 1, barrel) then
                    Drugs.Moonshine.Barrel:CreatePlaced(char:GetData("SID"), data.endCoords.coords, data.endCoords.rotation, os.time(), md.Brew)
                    cb(true)
                else
                    cb(false)
                end
            end
        else
            cb(false)
        end
    end)

    Callbacks:RegisterServerCallback("Drugs:Moonshine:PickupBarrel", function(source, data, cb)
        local char = Fetch:CharacterSource(source)
        local pState = Player(source).state
        if char ~= nil then
            if data then
                if Drugs.Moonshine.Barrel:IsPlaced(data) then
                    if pState.onDuty == "police" or _placedBarrels[data]?.owner == char:GetData("SID") then
                        if Drugs.Moonshine.Barrel:RemovePlaced(data) then
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
    end)

    Callbacks:RegisterServerCallback("Drugs:Moonshine:GetBarrelDetails", function(source, data, cb)
        local char = Fetch:CharacterSource(source)
        if char ~= nil then
            if data and _placedBarrels[data] ~= nil then
                local menu = {
                    main = {
                        label = "Oak Barrel Information",
                        items = {}
                    },
                }

                if os.time() > _placedBarrels[data]?.ready or 0 then
                    local timeUntil = _placedBarrels[data]?.ready - os.time()
                    table.insert(menu.main.items, {
                        label = "Aging Process Still In Progress",
                        description = string.format("Finishes At %s (in about %s)", os.date("%m/%d/%Y %I:%M %p", _placedBarrels[data]?.ready), GetFormattedTimeFromSeconds(timeUntil)),
                    })
                else
                    local timeUntil = _placedBarrels[data]?.ready - os.time()
                    table.insert(menu.main.items, {
                        label = "Aging Process Finished",
                        description = string.format("Finished At %s", os.date("%m/%d/%Y %I:%M %p", _placedBarrels[data]?.ready)),
                    })
                end

                cb(menu)
            else
                cb(false)
            end
        else
            cb(false)
        end
    end)

    Callbacks:RegisterServerCallback("Drugs:Moonshine:PickupBrew", function(source, data, cb)
        local char = Fetch:CharacterSource(source)
        if char ~= nil then
            local sid = char:GetData("SID")
            if data and _placedBarrels[data] ~= nil then
                if _placedBarrels[data].owner == sid then
                    if Inventory.Items:Has(sid, 1, "moonshine_jar", (_placedBarrels[data].brewData?.Drinks or 15)) then
                        if Inventory.Items:Remove(sid, 1, "moonshine_jar", (_placedBarrels[data].brewData?.Drinks or 15), false) then
                            if Inventory:AddItem(sid, "moonshine", (_placedBarrels[data].brewData?.Drinks or 15), {}, 1, false, false, false, false, false, false, _placedBarrels[data].brewData?.Quality or math.random(1, 100)) then
                                Drugs.Moonshine.Barrel:RemovePlaced(data)
                            else
                                cb(false)
                            end
                        else
                            cb(false)
                        end
                    else
                        Execute:Client(source, "Notification", "Error", string.format("Missing Masson Jars, You Need %s Empty Jars", (_placedBarrels[data].brewData?.Drinks or 15)))
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

    -- Callbacks:RegisterServerCallback("Drugs:Meth:GetItems", function(source, data, cb)
    --     local itms = {}

    --     local char = Fetch:CharacterSource(source)
    --     local hasVpn = hasValue(char:GetData("States"), "PHONE_VPN")

    --     for k, v in ipairs(_toolsForSale) do
    --         _toolsForSale[v.item] = _toolsForSale[v.item] or {}
    --         if (not v.vpn or hasVpn) and not _toolsForSale[v.item][char:GetData("SID")] then
    --             table.insert(itms, v)
    --         end
    --     end

    --     cb(itms)
    -- end)

    -- Callbacks:RegisterServerCallback("Drugs:Meth:BuyItem", function(source, data, cb)
    --     local char = Fetch:CharacterSource(source)
    --     local hasVpn = hasValue(char:GetData("States"), "PHONE_VPN")

    --     for k, v in ipairs(_toolsForSale) do
    --         if v.id == data then
    --             local coinData = Crypto.Coin:Get(v.coin)
    --             if Crypto.Exchange:Remove(v.coin, char:GetData("CryptoWallet"), v.price) then
    --                 Inventory:AddItem(char:GetData("SID"), v.item, 1, {}, 1)
    --                 _toolsForSale[v.item][char:GetData("SID")] = true
    --             else
    --                 Execute:Client(source, "Notification", "Error", string.format("Not Enough %s", coinData.Name), 6000)
    --             end
    --         end
    --     end
    -- end)
end)
