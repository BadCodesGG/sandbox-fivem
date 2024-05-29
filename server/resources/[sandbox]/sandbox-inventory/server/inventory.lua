LoadedEntitys = {}
ItemCallbacks = {}
createdInventories = {}

GlobalState["Dropzones"] = {}
_polyInvs = {}
_openInvs = {}
_doingThings = {}
_exitSaving = {}
_govAccount = nil
_hasAttchs = {}

_refreshAttchs = {}
_refreshGangChain = {}

_dropzones = {}

_equipped = {}
_listeners = {}
_cachedProps = {}

_invCounts = {}
_cachedInvs = {}

_playerShops = {}
_playerShopMods = {}

_lastUsedItem = {}

local _defInvSettings = {
	muted = false,
	useBank = true,
}

function split(pString, pPattern)
	local Table = {}  -- NOTE: use {n = 0} in Lua-5.0
	local fpat = "(.-)" .. pPattern
	local last_end = 1
	local s, e, cap = pString:find(fpat, 1)
	while s do
	   if s ~= 1 or cap ~= "" then
	  table.insert(Table,cap)
	   end
	   last_end = e+1
	   s, e, cap = pString:find(fpat, last_end)
	end
	if last_end <= #pString then
	   cap = pString:sub(last_end)
	   table.insert(Table, cap)
	end
	return Table
end

function ValueContined(tbl, value)
	for k, v in ipairs(tbl) do
		if v == value then
			return true
		end
	end
	return false
end

function BuildMetaDataTable(cData, item, existing)
	local itemExist = itemsDatabase[item]
	local MetaData = deepcopy(existing or {})
	
	if itemExist.staticMetadata ~= nil then
		for k, v in pairs(itemExist.staticMetadata) do
			MetaData[k] = v
		end
	end

	if itemExist.type == 2 then
		if not MetaData.SerialNumber and not itemExist.noSerial then
			if MetaData.Scratched then
				MetaData.ScratchedSerialNumber = Weapons:Purchase(cData.SID, itemExist, true, MetaData.Company)
				MetaData.Scratched = nil
			else
				MetaData.SerialNumber = Weapons:Purchase(cData.SID, itemExist, false, MetaData.Company)
			end
			MetaData.Company = nil
		end

		MetaData.ammo = MetaData.ammo or 0
		MetaData.clip = MetaData.clip or 0
	elseif itemExist.type == 10 and not MetaData.Container then
		MetaData.Container = string.format("container:%s", Sequence:Get("Container"))
	elseif itemExist.type == 11 and not MetaData.Quality then
		MetaData.Quality = math.random(100)
	elseif itemExist.name == "govid" then
		local genStr = "Male"
		if cData.Gender == 1 then
			genStr = "Female"
		end
		MetaData.Name = string.format("%s %s", cData.First, cData.Last)
		MetaData.Gender = genStr
		MetaData.PassportID = cData.User
		MetaData.StateID = cData.SID
		MetaData.DOB = cData.DOB
		MetaData.Mugshot = cData.Mugshot
	elseif itemExist.name == "moneybag" and not MetaData.Finish then
		MetaData.Finished = os.time() + (60 * 60 * 24 * math.random(1, 3))
	elseif itemExist.name == "crypto_voucher" and not MetaData.CryptoCoin and not MetaData.Quantity then
		MetaData.CryptoCoin = "MALD"
		MetaData.Quantity = math.random(25, 50)
	elseif itemExist.name == "rep_voucher" and not MetaData.Reputation and not MetaData.Amount then
		MetaData.Reputation = "Farming"
		MetaData.Amount = math.random(1000, 5000)
	elseif itemExist.name == "vpn" then
		MetaData.VpnName = {
			First = Generator.Name:First(),
			Last = Generator.Name:Last(),
		}
	elseif itemExist.name == "cigarette_pack" then
		MetaData.Count = 30
	elseif itemExist.name == "rusty_strawsprinkbox" then
		MetaData.Count = 10
	elseif itemExist.name == "rusty_ringmixbox" then
		MetaData.Count = 6
	elseif itemExist.name == "rusty_ringbox" then
		MetaData.Count = 12
	elseif itemExist.name == "rusty_pd" then
		MetaData.Count = 12
	elseif itemExist.name == "meth_table" and not MetaData.MethTable then
		MetaData.MethTable = Drugs.Meth:GenerateTable(1)
	elseif itemExist.name == "adv_meth_table" and not MetaData.MethTable then
		MetaData.MethTable = Drugs.Meth:GenerateTable(2)
	elseif itemExist.name == "meth_brick" then
			MetaData.Finished = os.time() + (60 * 60 * 24)
	elseif itemExist.name == "moonshine_still" and not MetaData.Still then
		MetaData.Still = Drugs.Moonshine.Still:Generate(1)
	elseif itemExist.name == "moonshine_barrel" and not MetaData.Brew then
		MetaData.Brew = Drugs.Moonshine.Barrel:Generate(1)
	elseif itemExist.name == "paleto_access_codes" and not MetaData.AccessCodes then
		MetaData.AccessCodes = {
			Robbery:GetAccessCodes('paleto')[1]
		}
	elseif itemExist.name == "lsundg_invite" and cData then
		MetaData.Inviter = {
			SID = cData.SID,
			First = cData.First,
			Last = cData.Last
		}
	elseif (itemExist.name == "pd_panic_button" or itemExist.name == "doc_panic_button" or itemExist.name == "ems_panic_button") and cData then
		MetaData.Officer = {
			Callsign = cData.Callsign or "???",
			First = cData.First,
			Last = cData.Last,
			SID = cData.SID,
		}
	elseif itemExist.name == "shark_card" and not MetaData.Amount then
		MetaData.Amount = math.random(5000, 25000)
	end

	return MetaData
end

AddEventHandler("Inventory:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Callbacks = exports["sandbox-base"]:FetchComponent("Callbacks")
	Sequence = exports["sandbox-base"]:FetchComponent("Sequence")
	Logger = exports["sandbox-base"]:FetchComponent("Logger")
	Utils = exports["sandbox-base"]:FetchComponent("Utils")
	Fetch = exports["sandbox-base"]:FetchComponent("Fetch")
	Inventory = exports["sandbox-base"]:FetchComponent("Inventory")
	Chat = exports["sandbox-base"]:FetchComponent("Chat")
	Wallet = exports["sandbox-base"]:FetchComponent("Wallet") 
	Execute = exports["sandbox-base"]:FetchComponent("Execute")
	Middleware = exports["sandbox-base"]:FetchComponent("Middleware")
	Crafting = exports["sandbox-base"]:FetchComponent("Crafting")
	Weapons = exports["sandbox-base"]:FetchComponent("Weapons")
	Jobs = exports["sandbox-base"]:FetchComponent("Jobs")
	Reputation = exports["sandbox-base"]:FetchComponent("Reputation")
	Vehicles = exports["sandbox-base"]:FetchComponent("Vehicles")
	Generator = exports["sandbox-base"]:FetchComponent("Generator")
	Phone = exports["sandbox-base"]:FetchComponent("Phone")
	Banking = exports["sandbox-base"]:FetchComponent("Banking")
	Drugs = exports["sandbox-base"]:FetchComponent("Drugs")
	Robbery = exports["sandbox-base"]:FetchComponent("Robbery")
	Laptop = exports["sandbox-base"]:FetchComponent("Laptop")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["sandbox-base"]:RequestDependencies("Inventory", {
		"Callbacks",
		"Sequence",
		"Fetch",
		"Logger",
		"Utils",
		"Inventory",
		"Chat",
		"Wallet",
		"Middleware",
		"Crafting",
		"Execute",
		"Weapons",
		"Jobs",
		"Reputation",
		"Vehicles",
		"Generator",
		"Phone",
		"Banking",
		"Drugs",
		"Robbery",
		"Laptop",
	}, function(error)
		if #error > 0 then
			return
		end
		RetrieveComponents()

		UpdateDatabaseItems()
		LoadItemsFromDb()
		--LoadItems()
		RegisterCallbacks()
		LoadEntityTypes()
		LoadShops()
		LoadPlayerShops()
		SetupGarbage()

		ClearDropZones()
		ClearBrokenItems()
		ClearLocalVehicleInventories()
		CleanupExpiredCooldowns()
		LoadCraftingCooldowns()

		RegisterCommands()
		RegisterStashCallbacks()
		RegisterTestBench()
		RegisterPublicSchematicBenches()
		RegisterCraftingCallbacks()
		RegisterDonorVanityItemsCallbacks()

        local f = Banking.Accounts:GetOrganization("government")
		if f ~= true then
        	_govAccount = f.Account
		end

		Middleware:Add("Characters:Spawning", function(source)
			TriggerLatentClientEvent("Inventory:Client:PolySetup", source, 50000, _polyInvs)

			local char = Fetch:CharacterSource(source)
			local sid = char:GetData("SID")
			
			_refreshAttchs[sid] = true
			_refreshGangChain[sid] = true
			refreshShit(sid, true)

			TriggerLatentClientEvent("Weapons:Client:SetProps", source, 50000, _cachedProps)
			if char:GetData("InventorySettings") == nil then
				char:SetData("InventorySettings", _defInvSettings)
			end
		end, 1)

		Middleware:Add("Characters:Spawning", function(source)
			local benches = {}
			for k, v in pairs(_types) do
				table.insert(benches, {
					id = v.id,
					label = v.label,
					targeting = v.targeting,
					location = v.location,
					restrictions = v.restrictions,
					canUseSchematics = v.canUseSchematics,
				})
			end
			TriggerLatentClientEvent("Crafting:Client:CreateBenches", source, 50000, benches)
			TriggerLatentClientEvent("Inventory:Client:DropzoneForceUpdate", source, 50000, _dropzones)
			TriggerLatentClientEvent("Inventory:Client:BasicShop:Set", source, 50000, _playerShops)
		end, 2)

		Middleware:Add("Characters:Created", function(source, cData)
			local player = Fetch:Source(source)
			local docs = {}

			local slot = 1
			for k, v in ipairs(Config.StartItems) do
				local metadata = BuildMetaDataTable(cData, v.name)
				
				if v.name == "choplist" then
					metadata.ChopList = Laptop.LSUnderground.Chopping:GenerateList(math.random(4, 8), math.random(3, 5))
					metadata.Owner = cData.SID
				end

				local insData = INVENTORY:AddItem(cData.SID, v.name, v.countTo, metadata, 1, false, false, false, false, slot, false, false, true)
				slot += 1
			end

			return true
		end, 2)
	end)
end)

local function HandleLogout(source, cData)
	for k, v in pairs(_openInvs) do
		if v == source then
			_openInvs[k] = false
		end
	end

	if _listeners[src] then
		RemoveStateBagChangeHandler(_listeners[src])
		_listeners[src] = nil
	end
	_cachedInvs[source] = nil
	_equipped[source] = nil

	TriggerClientEvent("Weapons:Client:ClearWeaponProps", -1, source)

	if cData ~= nil then
		_cachedInvs[string.format("%s-1", cData.SID)] = nil
		_invCounts[cData.SID] = nil
	end

	_lastUsedItem[source] = nil
end
AddEventHandler("Characters:Server:PlayerLoggedOut", HandleLogout)
AddEventHandler("Characters:Server:PlayerDropped", HandleLogout)

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["sandbox-base"]:RegisterComponent("Inventory", INVENTORY)
end)

AddEventHandler("Queue:Server:SessionActive", function(source)
	TriggerLatentClientEvent("Inventory:Client:LoadItems", source, 50000, itemsDatabase)
end)

RegisterNetEvent("Inventory:Server:ReloadItems", function()
	local src = source
	TriggerLatentClientEvent("Inventory:Client:ReceiveReload", source, 50000, itemsDatabase)
end)

RegisterServerEvent("Inventory:server:closePlayerInventory", function()
	local src = source
	local char = Fetch:CharacterSource(src)
	if char ~= nil then
		_openInvs[string.format("%s-%s", char:GetData("SID"), 1)] = false
		refreshShit(char:GetData("SID"), true)
	end
end)

RegisterNetEvent("Inventory:Server:DegradeLastUsed", function(degradeAmt)
	local src = source
	local char = Fetch:CharacterSource(src)
	if char ~= nil then
		if _lastUsedItem[src] then
			local slot = Inventory:GetItem(_lastUsedItem[src])

			if slot then
				local itemData = itemsDatabase[slot.Name]

				local newValue = slot.CreateDate - math.floor(itemData.durability * (degradeAmt / 100))

				if (os.time() - itemData.durability >= newValue) then
					Inventory.Items:RemoveId(slot.Owner, slot.invType, slot)
				else
					Inventory:SetItemCreateDate(slot.id, newValue)
				end
			end

		end
	end
end)

function sendRefreshForClient(_src, owner, invType, slot)
	--local data = Inventory:GetSlot(owner, slot, invType)
	TriggerClientEvent("Inventory:Client:SetSlot", _src, owner, invType, slot)
end

function SetGunPropData(source, sid, inv, isForce)
	local data = {}
	for k, v in ipairs(inv or {}) do
		local itemData = itemsDatabase[v.Name]
		if WEAPON_PROPS[itemData?.weapon or v.Name] then
			local md = json.decode(v.MetaData)
			data[string.format("i-%s", v.id)] = {
				item = v.Name,
				weapon = itemData?.weapon or v.Name,
				tint = md?.WeaponTint or false,
				attachments = md?.WeaponComponents or false,
				slot = v.Slot,
				equipped = _equipped[source] == v.Slot,
			}
		end
	end

	local needsUpdate = isForce
	if not needsUpdate then
		if _cachedProps[source] ~= nil then
			for k, v in pairs(_cachedProps[source]) do
				if data[k] == nil or v.equipped ~= data[k].equipped then
					needsUpdate = true
					break
				end
			end
	
			for k, v in pairs(data) do
				if _cachedProps[source][k] == nil then
					needsUpdate = true
					break
				end
			end
		else
			needsUpdate = true
		end
	end

	if needsUpdate then
		_cachedProps[source] = data
		TriggerLatentClientEvent("Weapons:Client:UpdateProps", -1, 50000, source, data)
	end
end

local function isShopModerator(shop, source)
	local char = Fetch:CharacterSource(source)
	if char then
		local sid = char:GetData("SID")
		if _playerShops[shop] then
			if _playerShops[shop].owner == sid then
				return true
			else
				if _playerShops[shop].job ~= nil then
					return Jobs.Permissions:HasPermissionInJob(source, _playerShops[shop].job, 'JOB_SHOP')
				else
					if _playerShopMods[shop] then
						for k, v in ipairs(_playerShopMods[shop]) do
							if v.sid == sid then
								return true
							end
						end
					end
				end
			end
		end
	end

	return false
end

RegisterNetEvent("Weapons:Server:Equipped", function(state)
	local src = source
	_equipped[src] = tonumber(state)
	local char = Fetch:CharacterSource(src)
	if char ~= nil then
		SetGunPropData(src, char:GetData("SID"), _cachedInvs[src])
	end
end)

AddEventHandler("Queue:Server:SessionActive", function()
	-- local src = source
	-- for k, v in pairs(_cachedProps) do
	-- 	TriggerClientEvent("Weapons:Client:UpdateProps", src, k, v)
	-- end
end)

function refreshShit(sid, adding)
	local char = Fetch:SID(tonumber(sid))
	if char ~= nil then
		local source = char:GetData("Source")
		local inventory = getInventory(source, sid, 1)

		UpdateCharacterItemStates(source, inventory, true)

		if  _refreshGangChain[sid] then
			UpdateCharacterGangChain(source, inventory)
		end

		if _refreshAttchs[sid] ~= nil then
			SetGunPropData(source, sid, inventory)
		end

		TriggerClientEvent("Inventory:Client:Cache", source, {
			size = (LoadedEntitys[1].slots or 10),
			name = char:GetData("First") .. " " .. char:GetData("Last"),
			inventory = inventory,
			invType = 1,
			capacity = LoadedEntitys[1].capacity,
			owner = sid,
			isWeaponEligble = Weapons:IsEligible(source),
			qualifications = char:GetData("Qualifications") or {},
		}, _refreshAttchs[sid] ~= nil)

		_cachedInvs[source] = inventory

		_refreshAttchs[sid] = nil
		_refreshGangChain[sid] = nil
	end
end

function entityPermCheck(source, invType)
	local char = Fetch:CharacterSource(source)

	local shittyInvData = LoadedEntitys[invType]

	if shittyInvData then
		return (
				shittyInvData.restriction == nil
				or (shittyInvData.restriction.job ~= nil and Jobs.Permissions:HasJob(
					source,
					shittyInvData.restriction.job.id,
					shittyInvData.restriction.job.workplace or false,
					shittyInvData.restriction.job.grade or false,
					false,
					false,
					shittyInvData.restriction.job.permissionKey or "JOB_STORAGE"
				) and (not shittyInvData.restriction.job.duty or Player(source).state.onDuty == shittyInvData.restriction.job.id))
				or (shittyInvData.restriction.state and hasValue(
					char:GetData("States"),
					shittyInvData.restriction.state
				))
				or (
					shittyInvData.restriction.rep ~= nil
					and Reputation:GetLevel(source, shittyInvData.restriction.rep.id) >= shittyInvData.restriction.rep.level
				)
				or (shittyInvData.restriction.character ~= nil and shittyInvData.restriction.character == char:GetData(
					"ID"
				))
				or (shittyInvData.restriction.admin and plyr.Permissions:IsAdmin())
			)
	else
		return false
	end
end

function getShopSlot(src, Owner, Type, slotId)
	if LoadedEntitys[tonumber(Type)].shop then
		if entityPermCheck(src, Type) then
			local char = Fetch:CharacterSource(src)
			local slots = getInventory(src, Owner, Type)
			local slot = slots[slotId]
			if slot then
				local item, stack, price = nil, nil, nil
				if itemsDatabase[slot.Name] ~= nil then
					if not slot.job or Jobs.Permissions:HasJob(src, slot.job) then
						return slot
					end
				end
			end
		end
	end

	return nil
end

function getShopSize(src, Owner, Type)
	if LoadedEntitys[tonumber(Type)].shop then
		if entityPermCheck(src, Type) then
			return #getInventory(src, Owner, Type)
		end
	end

	return 0
end

function getInventory(src, Owner, Type, limit)
	if LoadedEntitys[tonumber(Type)].shop then
		local char = Fetch:CharacterSource(src)

		local items = {}
		if entityPermCheck(src, Type) then
			for k, v in ipairs(Config.ShopItemSets[LoadedEntitys[Type].itemSet]) do
				local item, stack, price = nil, nil, nil
				if type(v) == "table" then
					if itemsDatabase[v.item] ~= nil then
						if not v.job or Jobs.Permissions:HasJob(src, v.job) then
							item = v.item
							stack = v.count or itemsDatabase[v.item].isStackable or 1
							price = v.price or itemsDatabase[v.item].price or 0
						end
					end
				else
					if itemsDatabase[v] ~= nil then
						item = v
						stack = itemsDatabase[v].storeStack or itemsDatabase[v].isStackable

						if not itemsDatabase[v].isStackable then
							stack = 1
						end
	
						if itemsDatabase[v].isStackable and stack > itemsDatabase[v].isStackable then
							stack = itemsDatabase[v].isStackable
						end
						price = itemsDatabase[v].price or 0
					end
				end

				if item then
					local doc = {
						Slot = #items + 1,
						Label = itemsDatabase[item].label,
						Count = stack,
						Name = item,
						invType = Type,
						Quality = nil,
						MetaData = {},
						Owner = tostring(Owner),
						Price = price,
					}

					table.insert(items, doc)
				end
			end
		end
		return items
	else
		local inv = MySQL.rawExecute.await('SELECT id, count(*) as Count, owner as Owner, type as invType, item_id as Name, MAX(price) as Price, MAX(quality) AS Quality, information as MetaData, slot as Slot, MIN(creationDate) AS CreateDate FROM inventory WHERE owner = ? AND type = ? GROUP BY slot ORDER BY slot ASC', {
			tostring(Owner),
			Type,
		}) or {}
		_cachedInvs[string.format("%s-%s", Owner, Type)] = inv

		if Type == 1 then
			_invCounts[Owner] = {}
			for k, v in ipairs(inv) do
				_invCounts[Owner][v.Name] = _invCounts[Owner][v.Name] or 0
				_invCounts[Owner][v.Name] += v.Count
			end
		end

		return inv
	end
end

function getSlotCount(invType, vehClass, vehModel, override, owner, src)
	if override then
		return override
	end

	if LoadedEntitys[tonumber(invType)].isTrunk and (vehClass or vehModel) then
		if vehModel and _modelOverride[vehModel] ~= nil then
			return _modelOverride[vehModel].trunk.slots
		else
			return _trunkSizes[vehClass].slots
		end
	elseif LoadedEntitys[tonumber(invType)].isGlovebox and (vehClass or vehModel) then
		if vehModel and _modelOverride[vehModel] ~= nil then
			return _modelOverride[vehModel].glovebox.slots
		else
			return _gloveboxSizes[vehClass].slots
		end
	elseif LoadedEntitys[tonumber(invType)].shop and LoadedEntitys[tonumber(invType)].itemSet ~= nil and Config.ShopItemSets[LoadedEntitys[tonumber(invType)].itemSet] ~= nil then
		return getShopSize(src, owner, invType)
	else
		return LoadedEntitys[tonumber(invType)].slots
	end
end

function getCapacity(invType, vehClass, vehModel, override)
	if override then
		return override
	end

	if LoadedEntitys[tonumber(invType)].isTrunk and (vehClass or vehModel) then
		if vehModel and _modelOverride[vehModel] ~= nil then
			return _modelOverride[vehModel].trunk.capacity
		else
			return _trunkSizes[vehClass].capacity
		end
	elseif LoadedEntitys[tonumber(invType)].isGlovebox and (vehClass or vehModel) then
		if vehModel and _modelOverride[vehModel] ~= nil then
			return _modelOverride[vehModel].glovebox.capacity
		else
			return _gloveboxSizes[vehClass].capacity
		end
	else
		return LoadedEntitys[tonumber(invType)].capacity
	end
end

function CreateStoreLog(inventory, item, count, buyer, metadata, itemId)
	MySQL.insert('INSERT INTO inventory_shop_logs (inventory, item, count, buyer, metadata, itemId) VALUES(?, ?, ?, ?, ?, ?)', {
		inventory, item, count, buyer, json.encode(metadata), itemId
	})
end

function DoMerge(source, data, cb)
	local char = Fetch:CharacterSource(source)

	local item = itemsDatabase[data.name]
	local cash = char:GetData("Cash")

	local entityFrom = LoadedEntitys[tonumber(data.invTypeFrom)]
	local entityTo = LoadedEntitys[tonumber(data.invTypeTo)]

	if data.ownerFrom == nil or data.slotFrom == nil or data.invTypeFrom == nil or data.ownerTo == nil or data.slotTo == nil or data.invTypeTo == nil then
		cb({ reason = "Invalid Move Data" })
		sendRefreshForClient(source, data.ownerFrom, data.invTypeFrom, data.slotFrom)
		sendRefreshForClient(source, data.ownerTo, data.invTypeTo, data.slotTo)
		return
	end

	if data.countTo <= 0 then
		cb({ reason = "Can't Move 0 - Naughty Boy" })
		sendRefreshForClient(source, data.ownerFrom, data.invTypeFrom, data.slotFrom)
		sendRefreshForClient(source, data.ownerTo, data.invTypeTo, data.slotTo)
		return
	end

	if entityFrom.shop then
		local slotFrom = getShopSlot(source, data.ownerFrom, data.invTypeFrom, data.slotFrom)
		local cost = math.ceil(((slotFrom?.Price or item.price) * tonumber(data.countTo)))
		local paymentType = (cash >= cost and 'cash' or (Banking.Balance:Has(char:GetData("BankAccount"), cost) and 'bank' or nil))
		if entityFrom.free or paymentType ~= nil then
			if -- Check if the item is either not a gun, or if it is that they have a Weapons license
				(item.type ~= 2
				or (
					item.type == 2
					and (not item.requiresLicense or item.requiresLicense and Weapons:IsEligible(source))
				))
				and (not item.qualification or hasValue(char:GetData("Qualifications"), item.qualification))
			then
				local paid = cost == 0 or entityFrom.free

				if not paid then
					if paymentType == 'cash' then
						paid = Wallet:Modify(source, -(math.abs(cost)))
					else
						paid = Banking.Balance:Charge(char:GetData("BankAccount"), cost, {
							type = 'bill',
							title = 'Store Purchase',
							description = string.format('Bought x%s %s', data.countTo, item.label),
							data = {}
						})
						Phone.Notification:Add(source, "Bill Payment Successful", false, os.time(), 3000, "bank", {})
					end

					if paid then
						local bonk = storeBankAccounts[tostring(entityFrom.id)]
						if bank then
							pendingShopDeposits[bonk] = pendingShopDeposits[bonk] or { amount = 0, transactions = 0 }
							pendingShopDeposits[bonk].amount += math.floor( (cost * STORE_SHARE_AMOUNT) )
							pendingShopDeposits[bonk].transactions += 1
						end

						pendingShopDeposits[_govAccount] = pendingShopDeposits[_govAccount] or { amount = 0, transactions = 0, tax = true }
						pendingShopDeposits[_govAccount].amount += math.ceil(cost * (1.0 - STORE_SHARE_AMOUNT))
						pendingShopDeposits[_govAccount].transactions += 1
					end
				end

				if paid then
					local insData = INVENTORY:AddItem(char:GetData("SID"), data.name, data.countTo, {}, data.invTypeTo, false, false, false, false, data.slotTo, false, false, false, true)
					CreateStoreLog(data.ownerFrom, data.name, data.countTo or 1, char:GetData("SID"), insData.MetaData, 0)
				end

				sendRefreshForClient(source, data.ownerFrom, data.invTypeFrom, data.slotFrom)
				sendRefreshForClient(source, data.ownerTo, data.invTypeTo, data.slotTo)
				return cb({ success = true })
			else
				sendRefreshForClient(source, data.ownerFrom, data.invTypeFrom, data.slotFrom)
				sendRefreshForClient(source, data.ownerTo, data.invTypeTo, data.slotTo)
				cb({ reason = "Ineligible To Purchase Item" })
			end
		else
			sendRefreshForClient(source, data.ownerFrom, data.invTypeFrom, data.slotFrom)
			sendRefreshForClient(source, data.ownerTo, data.invTypeTo, data.slotTo)
			cb({ reason = "Not Enough Cash" })
		end
	elseif entityFrom.playerShop and data.ownerFrom ~= data.ownerTo and data.invTypeFrom ~= data.invTypeTo then
		if _playerShops[data.ownerFrom] then
			local isMod = isShopModerator(data.ownerFrom, source)
			local slotFrom = INVENTORY:GetSlot(data.ownerFrom, data.slotFrom, data.invTypeFrom)
			local slotTo = INVENTORY:GetSlot(data.ownerTo, data.slotTo, data.invTypeTo)

			if slotFrom ~= nil then
				local cost = math.ceil((slotFrom.Price * tonumber(data.countTo)))
				local paymentType = (cash >= cost and 'cash' or (Banking.Balance:Has(char:GetData("BankAccount"), cost) and 'bank' or nil))
	
				if cost == 0 or paymentType ~= nil or isMod then
					local paid = cost == 0 or isMod

					if not paid then
						if paymentType == 'cash' then
							paid = Wallet:Modify(source, -(math.abs(cost)))
						else
							paid = Banking.Balance:Charge(char:GetData("BankAccount"), cost, {
								type = 'bill',
								title = 'Store Purchase',
								description = string.format('Bought x%s %s From %s', data.countTo, item.label, _playerShops[data.ownerFrom].name),
								data = {}
							})
							Phone.Notification:Add(source, "Bill Payment Successful", string.format('Bought x%s %s From %s', data.countTo, item.label, _playerShops[data.ownerFrom].name), os.time(), 3000, "bank", {})
						end
					end

					if paid then
						if not isMod then
							pendingShopDeposits[_playerShops[data.ownerFrom].bank] = pendingShopDeposits[_playerShops[data.ownerFrom].bank] or { amount = 0, transactions = 0 }
							pendingShopDeposits[_playerShops[data.ownerFrom].bank].amount += math.floor( (cost * STORE_SHARE_AMOUNT) )
							pendingShopDeposits[_playerShops[data.ownerFrom].bank].transactions += 1
	
							pendingShopDeposits[_govAccount] = pendingShopDeposits[_govAccount] or { amount = 0, transactions = 0, tax = true }
							pendingShopDeposits[_govAccount].amount += math.ceil(cost * (1.0 - STORE_SHARE_AMOUNT))
							pendingShopDeposits[_govAccount].transactions += 1
						end

						local ids = MySQL.rawExecute.await("SELECT id, owner, type, slot FROM inventory WHERE slot = ? AND owner = ? and type = ? LIMIT ?", {
							data.slotFrom,
							tostring(data.ownerFrom),
							data.invTypeFrom,
							data.countTo,
						});
			
						local idsFrom = {}
						for k, v in ipairs(ids) do
							table.insert(idsFrom, v.id)
						end
			
						MySQL.update.await('UPDATE inventory SET slot = ?, owner = ?, type = ?, price = ? WHERE id IN (' .. table.concat(idsFrom, ', ') .. ')', {
							data.slotTo,
							tostring(data.ownerTo),
							data.invTypeTo,
							0
						})
						
						if WEAPON_PROPS[item.weapon or item.name] ~= nil then
							_refreshAttchs[data.ownerTo] = source
						end

						if item.gangChain ~= nil then
							_refreshGangChain[data.ownerTo] = source
						end
				
						-- This might be bad, but idk how else to do this other than just not and deal with client UI being incorrect
						getInventory(source, data.ownerFrom, data.invTypeFrom)
						getInventory(source, data.ownerTo, data.invTypeTo)
					
						sendRefreshForClient(source, data.ownerFrom, data.invTypeFrom, data.slotFrom)
						sendRefreshForClient(source, data.ownerTo, data.invTypeTo, data.slotTo)

						return cb({ success = true })
					else
						TriggerClientEvent("StoreFailedPurchase", source, {
							player = {
								inventory = _cachedInvs[string.format("%s-%s", data.ownerTo, data.invTypeTo)],
							},
							secondary = {
								inventory = _cachedInvs[string.format("%s-%s", data.ownerFrom, data.invTypeFrom)],
							}
						})
						sendRefreshForClient(source, data.ownerFrom, data.invTypeFrom, data.slotFrom)
						sendRefreshForClient(source, data.ownerTo, data.invTypeTo, data.slotTo)
						return cb({ reason = "Payment Failed" })
					end
				else
					TriggerClientEvent("StoreFailedPurchase", source, {
						player = {
							inventory = _cachedInvs[string.format("%s-%s", data.ownerTo, data.invTypeTo)],
						},
						secondary = {
							inventory = _cachedInvs[string.format("%s-%s", data.ownerFrom, data.invTypeFrom)],
						}
					})
					sendRefreshForClient(source, data.ownerFrom, data.invTypeFrom, data.slotFrom)
					sendRefreshForClient(source, data.ownerTo, data.invTypeTo, data.slotTo)
					return cb({ reason = "You Cannot Afford That" })
				end
			else
				TriggerClientEvent("StoreFailedPurchase", source, {
					player = {
						inventory = _cachedInvs[string.format("%s-%s", data.ownerTo, data.invTypeTo)],
					},
					secondary = {
						inventory = _cachedInvs[string.format("%s-%s", data.ownerFrom, data.invTypeFrom)],
					}
				})
				sendRefreshForClient(source, data.ownerFrom, data.invTypeFrom, data.slotFrom)
				sendRefreshForClient(source, data.ownerTo, data.invTypeTo, data.slotTo)
				return cb({ reason = "Invalid Item" })
			end
		else
			TriggerClientEvent("StoreFailedPurchase", source, {
				player = {
					inventory = _cachedInvs[string.format("%s-%s", data.ownerTo, data.invTypeTo)],
				},
				secondary = {
					inventory = _cachedInvs[string.format("%s-%s", data.ownerFrom, data.invTypeFrom)],
				}
			})
			sendRefreshForClient(source, data.ownerFrom, data.invTypeFrom, data.slotFrom)
			sendRefreshForClient(source, data.ownerTo, data.invTypeTo, data.slotTo)
			return cb({ reason = "Invalid Shop" })
		end
	else
		if entityTo.playerShop and not isShopModerator(data.ownerFrom, source) then
			sendRefreshForClient(source, data.ownerFrom, data.invTypeFrom, data.slotFrom)
			sendRefreshForClient(source, data.ownerTo, data.invTypeTo, data.slotTo)
			return cb({ reason = "Cannot Do That" })
		end

		local slotFrom = INVENTORY:GetSlot(data.ownerFrom, data.slotFrom, data.invTypeFrom)
		local slotTo = INVENTORY:GetSlot(data.ownerTo, data.slotTo, data.invTypeTo)

		if slotFrom == nil or slotTo == nil then
			cb({ reason = "Item No Longer In That Slot" })
			sendRefreshForClient(source, data.ownerFrom, data.invTypeFrom, data.slotFrom)
			sendRefreshForClient(source, data.ownerTo, data.invTypeTo, data.slotTo)
			return
		end
		
		if entityFrom.playerShop and slotFrom?.Price ~= slotTo?.Price then
			sendRefreshForClient(source, data.ownerFrom, data.invTypeFrom, data.slotFrom)
			sendRefreshForClient(source, data.ownerTo, data.invTypeTo, data.slotTo)
			return cb({ reason = "Item Price Mismatch, Cannot Merge" })
		end

		local ids = MySQL.rawExecute.await("SELECT id, owner, type, slot FROM inventory WHERE slot = ? AND owner = ? AND type = ? LIMIT ?", {
			data.slotFrom,
			tostring(data.ownerFrom),
			data.invTypeFrom,
			data.countTo,
		});

		local idsFrom = {}
		for k, v in ipairs(ids) do
			table.insert(idsFrom, v.id)
		end

		if #idsFrom > 0 then
			MySQL.update.await('UPDATE inventory SET slot = ?, owner = ?, type = ? WHERE id IN (' .. table.concat(idsFrom, ', ') .. ')', {
				data.slotTo,
				tostring(data.ownerTo),
				data.invTypeTo,
			})
		end
		
		if ((data.ownerFrom ~= data.ownerTo) or (data.invTypeFrom ~= data.invTypeTo)) then
			if data.invTypeFrom == 1 then
				local char = Fetch:SID(data.ownerFrom)

				if data.ownerFrom == data.ownerTo then
					if item.type == 2 then
						if (not item.isStackable and item.isStackable ~= -1) or data.countTo == slotFrom.Count then
							TriggerClientEvent(
								"Weapons:Client:Move",
								char:GetData("Source"),
								data.slotFrom,
								data.slotTo
							)
						end
						
						if item.isThrowable then
							TriggerClientEvent(
								"Weapons:Client:UpdateCount",
								char:GetData("Source"),
								data.slotFrom,
								(slotFrom.Count - data.countTo)
							)
							TriggerClientEvent(
								"Weapons:Client:UpdateCount",
								char:GetData("Source"),
								data.slotTo,
								((slotTo?.Count or 0) + data.countTo)
							)
						end
					elseif item.type == 10 then
						TriggerClientEvent(
							"Inventory:Container:Move",
							char:GetData("Source"),
							data.slotFrom,
							data.slotTo
						)
					end
				else
					if not item.isStackable or data.countTo == slotFrom.Count then
						if item.type == 2 then
							TriggerClientEvent(
								"Weapons:Client:Remove",
								char:GetData("Source"),
								slotFrom,
								data.slotFrom,
								{
									owner = data.ownerTo,
									type = data.invTypeTo,
									slot = data.slotTo,
								}
							)
						elseif item.type == 10 then
							TriggerClientEvent(
								"Inventory:Container:Remove",
								char:GetData("Source"),
								slotFrom,
								data.slotFrom
							)
						end
					else
						if item.isThrowable then
							TriggerClientEvent(
								"Weapons:Client:UpdateCount",
								char:GetData("Source"),
								data.slotFrom,
								(slotFrom.Count - data.countTo)
							)
						end
					end
				end
			end
	
			if data.invTypeTo == 1 then
				local char = Fetch:SID(data.ownerTo)
				if item.isThrowable then
					TriggerClientEvent(
						"Weapons:Client:UpdateCount",
						char:GetData("Source"),
						data.slotTo,
						((slotTo?.Count or 0) + data.countTo)
					)
				end
			end

			if data.inventory.position ~= nil then
				CreateDZIfNotExist(source, data.inventory.position)
			end
		end

		if ((data.ownerFrom ~= data.ownerTo) or (data.invTypeFrom ~= data.invTypeTo)) and WEAPON_PROPS[item.weapon or item.name] ~= nil then
			_refreshAttchs[data.ownerFrom] = source
			_refreshAttchs[data.ownerTo] = source
		end

		if ((data.ownerFrom ~= data.ownerTo) or (data.invTypeFrom ~= data.invTypeTo)) and item.gangChain ~= nil then
			_refreshGangChain[data.ownerFrom] = source
			_refreshGangChain[data.ownerTo] = source
		end

		sendRefreshForClient(source, data.ownerFrom, data.invTypeFrom, data.slotFrom)
		sendRefreshForClient(source, data.ownerTo, data.invTypeTo, data.slotTo)

		return cb({ success = true })
	end
end

function DoSwap(source, data, cb)
	local char = Fetch:CharacterSource(source)

	local item = itemsDatabase[data.name]
	local cash = char:GetData("Cash")

	local entityFrom = LoadedEntitys[tonumber(data.invTypeFrom)]
	local entityTo = LoadedEntitys[tonumber(data.invTypeTo)]

	if data.ownerFrom == nil or data.slotFrom == nil or data.invTypeFrom == nil or data.ownerTo == nil or data.slotTo == nil or data.invTypeTo == nil then
		cb({ reason = "Invalid Move Data" })
		sendRefreshForClient(source, data.ownerFrom, data.invTypeFrom, data.slotFrom)
		sendRefreshForClient(source, data.ownerTo, data.invTypeTo, data.slotTo)
		return
	end

	if data.countTo <= 0 then
		cb({ reason = "Can't Move 0 - Naughty Boy" })
		sendRefreshForClient(source, data.ownerFrom, data.invTypeFrom, data.slotFrom)
		sendRefreshForClient(source, data.ownerTo, data.invTypeTo, data.slotTo)
		return
	end

	if entityFrom.shop or (entityFrom.playerShop and ((data.ownerFrom ~= data.ownerTo and data.invTypeFrom ~= data.invTypeTo) or not isShopModerator(data.ownerFrom, source))) then
		cb({ reason = "Illegal Operation" })
		sendRefreshForClient(source, data.ownerFrom, data.invTypeFrom, data.slotFrom)
		sendRefreshForClient(source, data.ownerTo, data.invTypeTo, data.slotTo)
		return
	else
		local slotFrom = INVENTORY:GetSlot(data.ownerFrom, data.slotFrom, data.invTypeFrom)
		local slotTo = INVENTORY:GetSlot(data.ownerTo, data.slotTo, data.invTypeTo)

		if slotFrom == nil or slotTo == nil then
			cb({ reason = "Item No Longer In That Slot" })
			sendRefreshForClient(source, data.ownerFrom, data.invTypeFrom, data.slotFrom)
			sendRefreshForClient(source, data.ownerTo, data.invTypeTo, data.slotTo)
			return
		end

		local ids = MySQL.rawExecute.await("SELECT id, owner, type, slot FROM inventory WHERE (slot = ? AND owner = ? AND type = ?) OR (slot = ? AND owner = ? AND type = ?)", {
			data.slotFrom,
			tostring(data.ownerFrom),
			data.invTypeFrom,
			data.slotTo,
			tostring(data.ownerTo),
			data.invTypeTo,
		});

		local idsFrom = {}
		local idsTo = {}

		for k, v in ipairs(ids) do
			if v.owner == tostring(data.ownerFrom) and v.type == data.invTypeFrom and v.slot == data.slotFrom then
				table.insert(idsFrom, v.id)
			else
				table.insert(idsTo, v.id)
			end
		end

		local queries = {}

		if #idsFrom > 0 then
			table.insert(queries, {
				query = "UPDATE inventory SET slot = ?, owner = ?, type = ? WHERE id IN (" .. table.concat(idsFrom, ', ') .. ")",
				values = {
					data.slotTo,
					tostring(data.ownerTo),
					data.invTypeTo,
				},
			})
		end

		if #idsTo > 0 then
			table.insert(queries, {
				query = "UPDATE inventory SET slot = ?, owner = ?, type = ? WHERE id IN (" .. table.concat(idsTo, ', ') .. ")",
				values = {
					data.slotFrom,
					tostring(data.ownerFrom),
					data.invTypeFrom,
				},
			})
		end

		if #queries > 0 then
			MySQL.transaction.await(queries)
		end

		if (data.ownerFrom ~= data.ownerTo) or (data.invTypeFrom ~= data.invTypeTo) then

			if data.invTypeFrom == 1 then
				local char = Fetch:SID(data.ownerFrom)

				if (data.ownerFrom == data.ownerTo) and (data.invTypeFrom == data.invTypeTo) then -- Within Same Inventory
					if item.type == 2 then
						if (not item.isStackable and item.isStackable ~= -1) or data.countTo == slotFrom.Count then
							TriggerClientEvent(
								"Weapons:Client:Move",
								char:GetData("Source"),
								data.slotFrom,
								data.slotTo
							)
						end
						
						if item.isThrowable then
							TriggerClientEvent(
								"Weapons:Client:UpdateCount",
								char:GetData("Source"),
								data.slotFrom,
								(slotFrom.Count - data.countTo)
							)
							TriggerClientEvent(
								"Weapons:Client:UpdateCount",
								char:GetData("Source"),
								data.slotTo,
								((slotTo?.Count or 0) + data.countTo)
							)
						end
					elseif item.type == 10 then
						TriggerClientEvent(
							"Inventory:Container:Move",
							char:GetData("Source"),
							data.slotFrom,
							data.slotTo
						)
					end
				else
					if not item.isStackable or data.countTo == slotFrom.Count then
						if item.type == 2 then
							TriggerClientEvent(
								"Weapons:Client:Remove",
								char:GetData("Source"),
								slotFrom,
								data.slotFrom,
								{
									owner = data.ownerTo,
									type = data.invTypeTo,
									slot = data.slotTo,
								}
							)
						elseif item.type == 10 then
							TriggerClientEvent(
								"Inventory:Container:Remove",
								char:GetData("Source"),
								slotFrom,
								data.slotFrom
							)
						end
					else
						if item.isThrowable then
							TriggerClientEvent(
								"Weapons:Client:UpdateCount",
								char:GetData("Source"),
								data.slotFrom,
								(slotFrom.Count - data.countTo)
							)
						end
					end
				end
			end
	
			if data.invTypeTo == 1 then
				local char = Fetch:SID(data.ownerTo)
				if item.isThrowable then
					TriggerClientEvent(
						"Weapons:Client:UpdateCount",
						char:GetData("Source"),
						data.slotTo,
						((slotTo?.Count or 0) + data.countTo)
					)
				end
			end

			if data.inventory.position ~= nil then
				CreateDZIfNotExist(source, data.inventory.position)
			end
		end

		if ((data.ownerFrom ~= data.ownerTo) or (data.invTypeFrom ~= data.invTypeTo)) and WEAPON_PROPS[item.weapon or item.name] ~= nil then
			_refreshAttchs[data.ownerFrom] = source
			_refreshAttchs[data.ownerTo] = source
		end

		if ((data.ownerFrom ~= data.ownerTo) or (data.invTypeFrom ~= data.invTypeTo)) and item.gangChain ~= nil then
			_refreshGangChain[data.ownerFrom] = source
			_refreshGangChain[data.ownerTo] = source
		end

		sendRefreshForClient(source, data.ownerFrom, data.invTypeFrom, data.slotFrom)
		sendRefreshForClient(source, data.ownerTo, data.invTypeTo, data.slotTo)

		return cb({ success = true })
	end
end

function DoMove(source, data, cb)
	local char = Fetch:CharacterSource(source)
	
	local item = itemsDatabase[data.name]
	local cash = char:GetData("Cash")

	local entityFrom = LoadedEntitys[tonumber(data.invTypeFrom)]
	local entityTo = LoadedEntitys[tonumber(data.invTypeTo)]

	if data.ownerFrom == nil or data.slotFrom == nil or data.invTypeFrom == nil or data.ownerTo == nil or data.slotTo == nil or data.invTypeTo == nil then
		cb({ reason = "Invalid Move Data" })
		sendRefreshForClient(source, data.ownerFrom, data.invTypeFrom, data.slotFrom)
		sendRefreshForClient(source, data.ownerTo, data.invTypeTo, data.slotTo)
		return
	end

	if data.countTo <= 0 then
		cb({ reason = "Can't Move 0 - Naughty Boy" })
		sendRefreshForClient(source, data.ownerFrom, data.invTypeFrom, data.slotFrom)
		sendRefreshForClient(source, data.ownerTo, data.invTypeTo, data.slotTo)
		return
	end

	if entityFrom.shop then
		local slotFrom = getShopSlot(source, data.ownerFrom, data.invTypeFrom, data.slotFrom)
		local cost = math.ceil(((slotFrom?.Price or item.price) * tonumber(data.countTo)))
		local paymentType = (cash >= cost and 'cash' or (Banking.Balance:Has(char:GetData("BankAccount"), cost) and 'bank' or nil))
		if entityFrom.free or paymentType ~= nil then
			if -- Check if the item is either not a gun, or if it is that they have a Weapons license
				(item.type ~= 2
				or (
					item.type == 2
					and (not item.requiresLicense or item.requiresLicense and Weapons:IsEligible(source))
				))
				and (not item.qualification or hasValue(char:GetData("Qualifications"), item.qualification))
			then
				local paid = cost == 0 or entityFrom.free
				if not paid then
					if paymentType == 'cash' then
						paid = Wallet:Modify(source, -(math.abs(cost)))
					else
						paid = Banking.Balance:Charge(char:GetData("BankAccount"), cost, {
							type = 'bill',
							title = 'Store Purchase',
							description = string.format('Bought x%s %s', data.countTo, item.label),
							data = {}
						})
						Phone.Notification:Add(source, "Bill Payment Successful", string.format('Bought x%s %s', data.countTo, item.label), os.time(), 3000, "bank", {})
					end

					if paid then
						local bonk = storeBankAccounts[entityFrom.id]
						pendingShopDeposits[bonk] = pendingShopDeposits[bonk] or { amount = 0, transactions = 0 }
						pendingShopDeposits[bonk].amount += math.floor( (cost * STORE_SHARE_AMOUNT) )
						pendingShopDeposits[bonk].transactions += 1

						pendingShopDeposits[_govAccount] = pendingShopDeposits[_govAccount] or { amount = 0, transactions = 0, tax = true }
						pendingShopDeposits[_govAccount].amount += math.ceil(cost * (1.0 - STORE_SHARE_AMOUNT))
						pendingShopDeposits[_govAccount].transactions += 1
					end
				end

				if paid then
					local insData = INVENTORY:AddItem(char:GetData("SID"), data.name, data.countTo, {}, data.invTypeTo, false, false, false, false, data.slotTo, false, false, false, true)
					CreateStoreLog(data.ownerFrom, data.name, data.countTo or 1, char:GetData("SID"), insData.MetaData, 0)
				end

				if ((data.ownerFrom ~= data.ownerTo) or (data.invTypeFrom ~= data.invTypeTo)) and WEAPON_PROPS[item.weapon or item.name] ~= nil then
					_refreshAttchs[data.ownerFrom] = source
					_refreshAttchs[data.ownerTo] = source
				end

				if ((data.ownerFrom ~= data.ownerTo) or (data.invTypeFrom ~= data.invTypeTo)) and item.gangChain ~= nil then
					_refreshGangChain[data.ownerFrom] = source
					_refreshGangChain[data.ownerTo] = source
				end

				sendRefreshForClient(source, data.ownerFrom, data.invTypeFrom, data.slotFrom)
				sendRefreshForClient(source, data.ownerTo, data.invTypeTo, data.slotTo)
				return cb({ success = true })
			else
				sendRefreshForClient(source, data.ownerFrom, data.invTypeFrom, data.slotFrom)
				sendRefreshForClient(source, data.ownerTo, data.invTypeTo, data.slotTo)
				cb({ reason = "Ineligible To Purchase Item" })
			end
		else
			sendRefreshForClient(source, data.ownerFrom, data.invTypeFrom, data.slotFrom)
			sendRefreshForClient(source, data.ownerTo, data.invTypeTo, data.slotTo)
			cb({ reason = "Not Enough Cash" })
		end
	elseif entityFrom.playerShop and data.ownerFrom ~= data.ownerTo and data.invTypeFrom ~= data.invTypeTo then
		if _playerShops[data.ownerFrom] then
			local isMod = isShopModerator(data.ownerFrom, source)
			local slotFrom = INVENTORY:GetSlot(data.ownerFrom, data.slotFrom, data.invTypeFrom)
			local slotTo = INVENTORY:GetSlot(data.ownerTo, data.slotTo, data.invTypeTo)

			if slotFrom ~= nil then
				local cost = math.ceil((slotFrom.Price * tonumber(data.countTo)))
				local paymentType = (cash >= cost and 'cash' or (Banking.Balance:Has(char:GetData("BankAccount"), cost) and 'bank' or nil))
				if cost == 0 or paymentType ~= nil or isMod then
					local paid = cost == 0 or isMod
					if not paid then
						if paymentType == 'cash' then
							paid = Wallet:Modify(source, -(math.abs(cost)))
						else
							paid = Banking.Balance:Charge(char:GetData("BankAccount"), cost, {
								type = 'bill',
								title = 'Store Purchase',
								description = string.format('Bought x%s %s From %s', data.countTo, item.label, _playerShops[data.ownerFrom].name),
								data = {}
							})
							Phone.Notification:Add(source, "Bill Payment Successful", string.format('Bought x%s %s From %s', data.countTo, item.label, _playerShops[data.ownerFrom].name), os.time(), 3000, "bank", {})
						end
					end

					if paid then
						if not isMod then
							pendingShopDeposits[_playerShops[data.ownerFrom].bank] = pendingShopDeposits[_playerShops[data.ownerFrom].bank] or { amount = 0, transactions = 0 }
							pendingShopDeposits[_playerShops[data.ownerFrom].bank].amount += math.floor( (cost * STORE_SHARE_AMOUNT) )
							pendingShopDeposits[_playerShops[data.ownerFrom].bank].transactions += 1
	
							pendingShopDeposits[_govAccount] = pendingShopDeposits[_govAccount] or { amount = 0, transactions = 0, tax = true }
							pendingShopDeposits[_govAccount].amount += math.ceil(cost * (1.0 - STORE_SHARE_AMOUNT))
							pendingShopDeposits[_govAccount].transactions += 1
						end

						if data.isSplit then
							local itemIds = MySQL.rawExecute.await('SELECT id FROM inventory WHERE owner = ? AND type = ? AND slot = ? AND item_id = ? ORDER BY id ASC LIMIT ?', {
								tostring(data.ownerFrom),
								data.invTypeFrom,
								tostring(data.slotFrom),
								data.name,
								data.countTo
							})

							local params = {}
							for k, v in ipairs(itemIds) do
								table.insert(params, v.id)
							end
							
							if #params > 0 then
								MySQL.update.await(string.format('UPDATE inventory SET slot = ?, owner = ?, type = ?, price = ? WHERE id IN (%s)', table.concat(params, ',')), {
									data.slotTo,
									tostring(data.ownerTo),
									data.invTypeTo,
									0
								})
							end
						else
							local itemIds = MySQL.rawExecute.await('SELECT id FROM inventory WHERE owner = ? AND type = ? AND slot = ? AND item_id = ? ORDER BY id ASC', {
								tostring(data.ownerFrom),
								data.invTypeFrom,
								data.slotFrom,
								data.name
							})

							local params = {}
							for k, v in ipairs(itemIds) do
								table.insert(params, v.id)
							end
							
							if #params > 0 then
								MySQL.update.await(string.format('UPDATE inventory SET slot = ?, owner = ?, type = ?, price = ? WHERE id IN (%s)', table.concat(params, ',')), {
									data.slotTo,
									tostring(data.ownerTo),
									data.invTypeTo,
									0
								})
							end
						end

						
						if WEAPON_PROPS[item.weapon or item.name] ~= nil then
							_refreshAttchs[data.ownerTo] = source
						end

						if item.gangChain ~= nil then
							_refreshGangChain[data.ownerTo] = source
						end
					
						-- This might be bad, but idk how else to do this other than just not and deal with client UI being incorrect
						getInventory(source, data.ownerFrom, data.invTypeFrom)
						getInventory(source, data.ownerTo, data.invTypeTo)

						sendRefreshForClient(source, data.ownerFrom, data.invTypeFrom, data.slotFrom)
						sendRefreshForClient(source, data.ownerTo, data.invTypeTo, data.slotTo)

						return cb({ success = true })
					else
						TriggerClientEvent("StoreFailedPurchase", source, {
							player = {
								inventory = _cachedInvs[string.format("%s-%s", data.ownerTo, data.invTypeTo)],
							},
							secondary = {
								inventory = _cachedInvs[string.format("%s-%s", data.ownerFrom, data.invTypeFrom)],
							}
						})
						sendRefreshForClient(source, data.ownerFrom, data.invTypeFrom, data.slotFrom)
						sendRefreshForClient(source, data.ownerTo, data.invTypeTo, data.slotTo)
						cb({ reason = "Payment Failed" })
					end
				else
					TriggerClientEvent("StoreFailedPurchase", source, {
						player = {
							inventory = _cachedInvs[string.format("%s-%s", data.ownerTo, data.invTypeTo)],
						},
						secondary = {
							inventory = _cachedInvs[string.format("%s-%s", data.ownerFrom, data.invTypeFrom)],
						}
					})
					sendRefreshForClient(source, data.ownerFrom, data.invTypeFrom, data.slotFrom)
					sendRefreshForClient(source, data.ownerTo, data.invTypeTo, data.slotTo)
					cb({ reason = "You Cannot Afford That" })
				end
			else
				TriggerClientEvent("StoreFailedPurchase", source, {
					player = {
						inventory = _cachedInvs[string.format("%s-%s", data.ownerTo, data.invTypeTo)],
					},
					secondary = {
						inventory = _cachedInvs[string.format("%s-%s", data.ownerFrom, data.invTypeFrom)],
					}
				})
				sendRefreshForClient(source, data.ownerFrom, data.invTypeFrom, data.slotFrom)
				sendRefreshForClient(source, data.ownerTo, data.invTypeTo, data.slotTo)
				return cb({ reason = "Invalid Item" })
			end
		else
			TriggerClientEvent("StoreFailedPurchase", source, {
				player = {
					inventory = _cachedInvs[string.format("%s-%s", data.ownerTo, data.invTypeTo)],
				},
				secondary = {
					inventory = _cachedInvs[string.format("%s-%s", data.ownerFrom, data.invTypeFrom)],
				}
			})
			sendRefreshForClient(source, data.ownerFrom, data.invTypeFrom, data.slotFrom)
			sendRefreshForClient(source, data.ownerTo, data.invTypeTo, data.slotTo)
			return cb({ reason = "Invalid Shop" })
		end
	else
		if entityTo.playerShop and not isShopModerator(data.ownerFrom, source) then
			sendRefreshForClient(source, data.ownerFrom, data.invTypeFrom, data.slotFrom)
			sendRefreshForClient(source, data.ownerTo, data.invTypeTo, data.slotTo)
			return cb({ reason = "Cannot Do That" })
		end

		local slotFrom = INVENTORY:GetSlot(data.ownerFrom, data.slotFrom, data.invTypeFrom)
		local slotTo = INVENTORY:GetSlot(data.ownerTo, data.slotTo, data.invTypeTo)

		if slotFrom == nil then
			cb({ reason = "Item No Longer In That Slot" })
			sendRefreshForClient(source, data.ownerFrom, data.invTypeFrom, data.slotFrom)
			sendRefreshForClient(source, data.ownerTo, data.invTypeTo, data.slotTo)
			return
		end

		if data.isSplit then
			local itemIds = MySQL.rawExecute.await('SELECT id FROM inventory WHERE owner = ? AND type = ? AND slot = ? AND item_id = ? ORDER BY id ASC LIMIT ?', {
				tostring(data.ownerFrom),
				data.invTypeFrom,
				data.slotFrom,
				data.name,
				data.countTo
			})

			local params = {}
			for k, v in ipairs(itemIds) do
				table.insert(params, v.id)
			end
			
			if #params > 0 then
				MySQL.update.await(string.format('UPDATE inventory SET slot = ?, owner = ?, type = ? WHERE id IN (%s)', table.concat(params, ',')), {
					data.slotTo,
					tostring(data.ownerTo),
					data.invTypeTo,
				})
			end
		else
			local itemIds = MySQL.rawExecute.await('SELECT id FROM inventory WHERE owner = ? AND type = ? AND slot = ? AND item_id = ? ORDER BY id ASC', {
				data.ownerFrom,
				data.invTypeFrom,
				data.slotFrom,
				data.name
			})

			local params = {}
			for k, v in ipairs(itemIds) do
				table.insert(params, v.id)
			end
			
			if #params > 0 then
				MySQL.update.await(string.format('UPDATE inventory SET slot = ?, owner = ?, type = ? WHERE id IN (%s)', table.concat(params, ',')), {
					data.slotTo,
					tostring(data.ownerTo),
					data.invTypeTo,
				})
			end
		end
		
		if (data.ownerFrom ~= data.ownerTo) or (data.invTypeFrom ~= data.invTypeTo) then
			if data.invTypeFrom == 1 then
				local char = Fetch:SID(data.ownerFrom)

				if (data.ownerFrom == data.ownerTo) and (data.invTypeFrom == data.invTypeTo) then -- Within Same Inventory
					if item.type == 2 then
						if (not item.isStackable and item.isStackable ~= -1) or data.countTo == slotFrom.Count then
							TriggerClientEvent(
								"Weapons:Client:Move",
								char:GetData("Source"),
								data.slotFrom,
								data.slotTo
							)
						end
						
						if item.isThrowable then
							TriggerClientEvent(
								"Weapons:Client:UpdateCount",
								char:GetData("Source"),
								data.slotFrom,
								(slotFrom.Count - data.countTo)
							)
							TriggerClientEvent(
								"Weapons:Client:UpdateCount",
								char:GetData("Source"),
								data.slotTo,
								((slotTo?.Count or 0) + data.countTo)
							)
						end
					elseif item.type == 10 then
						TriggerClientEvent(
							"Inventory:Container:Move",
							char:GetData("Source"),
							data.slotFrom,
							data.slotTo
						)
					end
				else
					if not item.isStackable or data.countTo == slotFrom.Count then
						if item.type == 2 then
							TriggerClientEvent(
								"Weapons:Client:Remove",
								char:GetData("Source"),
								slotFrom,
								data.slotFrom,
								{
									owner = data.ownerTo,
									type = data.invTypeTo,
									slot = data.slotTo,
								}
							)
						elseif item.type == 10 then
							TriggerClientEvent(
								"Inventory:Container:Remove",
								char:GetData("Source"),
								slotFrom,
								data.slotFrom
							)
						end
					else
						if item.isThrowable then
							TriggerClientEvent(
								"Weapons:Client:UpdateCount",
								char:GetData("Source"),
								data.slotFrom,
								(slotFrom.Count - data.countTo)
							)
						end
					end
				end
			end
	
			if data.invTypeTo == 1 then
				local char = Fetch:SID(data.ownerTo)
				if item.isThrowable then
					TriggerClientEvent(
						"Weapons:Client:UpdateCount",
						char:GetData("Source"),
						data.slotTo,
						((slotTo?.Count or 0) + data.countTo)
					)
				end
			end

			if data.inventory.position ~= nil then
				CreateDZIfNotExist(source, data.inventory.position)
			end
		end

		if ((data.ownerFrom ~= data.ownerTo) or (data.invTypeFrom ~= data.invTypeTo)) and WEAPON_PROPS[item.weapon or item.name] ~= nil then
			_refreshAttchs[data.ownerFrom] = source
			_refreshAttchs[data.ownerTo] = source
		end

		if ((data.ownerFrom ~= data.ownerTo) or (data.invTypeFrom ~= data.invTypeTo)) and item.gangChain ~= nil then
			_refreshGangChain[data.ownerFrom] = source
			_refreshGangChain[data.ownerTo] = source
		end
	
		sendRefreshForClient(source, data.ownerFrom, data.invTypeFrom, data.slotFrom)
		sendRefreshForClient(source, data.ownerTo, data.invTypeTo, data.slotTo)

		return cb({ success = true })
	end
end

function CreateDZIfNotExist(source, coords)
	local route = Player(source).state.currentRoute
	local id = string.format("%s:%s:%s", math.ceil(coords.x), math.ceil(coords.y), route)
	if not INVENTORY:DropExists(route, id) then
		INVENTORY:CreateDropzone(route, coords)
	end
end

function RegisterCallbacks()
	Callbacks:RegisterServerCallback("Inventory:MergeItem", DoMerge)
	Callbacks:RegisterServerCallback("Inventory:SwapItem", DoSwap)
	Callbacks:RegisterServerCallback("Inventory:MoveItem", DoMove)

	Callbacks:RegisterServerCallback("Inventory:OpenTrunk", function(source, data, cb)
		local myCoords = GetEntityCoords(GetPlayerPed(source))
		local veh = NetworkGetEntityFromNetworkId(data.netId)

		if Entity(veh).state.VIN == nil then
			return cb(false)
		end

		local vehCoords = GetEntityCoords(veh)
		local dist = #(vector3(myCoords.x, myCoords.y, myCoords.z) - vector3(vehCoords.x, vehCoords.y, vehCoords.z))
		local lock = GetVehicleDoorLockStatus(veh)
		if dist < 8 and (lock == 0 or lock == 1) then
			INVENTORY:OpenSecondary(source, 4, Entity(veh).state.VIN, data.class or false, data.model or false)
			cb(true)
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("Inventory:UseItem", function(source, data, cb)
		if entityPermCheck(source, data.invType) then
			local slot = INVENTORY:GetOldestInSlot(data.owner, data.slot, data.invType)
			if slot ~= nil then
				_lastUsedItem[source] = slot.id
				INVENTORY.Items:Use(source, slot, cb)
			else
				sendRefreshForClient(source, data.owner, data.invType, data.slot)
				cb(false)
			end
		end
	end)

	Callbacks:RegisterServerCallback("Inventory:UseSlot", function(source, data, cb)
		if data and data.slot then
			local char = Fetch:CharacterSource(source)
			if char then
				local slotFrom = INVENTORY:GetOldestInSlot(char:GetData("SID"), data.slot, 1)
				if slotFrom ~= nil then
					if slotFrom.Count or 0 > 0 then
						_lastUsedItem[source] = slotFrom.id
						INVENTORY.Items:Use(source, slotFrom, function(yea)
							if not yea then
								sendRefreshForClient(source, char:GetData("SID"), 1, slotFrom)
							end
							cb(yea)
						end)
					else
						sendRefreshForClient(source, char:GetData("SID"), 1, slotFrom)
						cb(false)
					end
				else
					sendRefreshForClient(source, char:GetData("SID"), 1, slotFrom)
					cb(false)
				end
			else
				cb(false)
			end
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("Inventory:CheckIfNearDropZone", function(source, data, cb)
		local playerPed = GetPlayerPed(source)
		local playerCoords = GetEntityCoords(playerPed)
		local route = Player(source).state.currentRoute
		cb(INVENTORY:CheckDropZones(route, vector3(playerCoords.x, playerCoords.y, playerCoords.z)))
	end)

	Callbacks:RegisterServerCallback("Inventory:Server:retreiveStores", function(source, data, cb)
		cb(shopLocations)
	end)

	Callbacks:RegisterServerCallback("Inventory:Search", function(source, data, cb)
		local dest = Fetch:CharacterSource(data.serverId)
		if dest ~= nil then
			INVENTORY.Search:Character(source, data.serverId, dest:GetData("SID"))
			cb(dest:GetData("SID"))
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("Inventory:Raid", function(source, data, cb)
		local dest = Fetch:CharacterSource(source)
		local pState = Player(source).state

		if dest and pState.onDuty ~= nil and pState.onDuty == "police" and Jobs.Permissions:HasPermissionInJob(source, 'police', 'PD_RAID') then
			INVENTORY:OpenSecondary(source, data.invType, data.owner, data.class or false, data.model or false, true)
		end
	end)

	Callbacks:RegisterServerCallback("Inventory:Dumpster:Open", function(source, data, cb)
		Callbacks:ClientCallback(source, "Inventory:Compartment:Open", {
			invType = 4000,
			owner = data.identifier,
			}, function()
				INVENTORY:OpenSecondary(source, 4000, data.identifier)
		end)
		cb()
	end)

	Callbacks:RegisterServerCallback("Inventory:CloseSecondary", function(source, inventory, cb)
		if inventory.invType == 1 then
			refreshShit(inventory.owner)
		elseif inventory.invType == 10 then
			local route = Player(source).state.currentRoute
			local exists = INVENTORY:DropExists(route, inventory.owner)
			local hasItems = INVENTORY:HasItems(inventory.owner, 10)
			if inventory.position ~= nil and hasItems and not exists then
				INVENTORY:CreateDropzone(route, inventory.position)
			elseif exists and not hasItems then
				INVENTORY:RemoveDropzone(route, inventory.owner)
			end
		else
			if _refreshAttchs[inventory.owner] then
				_refreshAttchs[inventory.owner] = false
			end

			if _refreshGangChain[inventory.owner] then
				_refreshGangChain[inventory.owner] = false
			end
		end

		_openInvs[string.format("%s-%s", inventory.owner, inventory.invType)] = false

		cb()
	end)

	Callbacks:RegisterServerCallback("Inventory:PlayerShop:AddItem", function(source, data, cb)
		local char = Fetch:CharacterSource(source)
		if char ~= nil then
			local sid = char:GetData("SID")
			if _playerShops[data.ownerTo] ~= nil then
				if isShopModerator(data.ownerTo, source) then
					local slotFrom = INVENTORY:GetSlot(data.ownerFrom, data.slotFrom, data.invTypeFrom)
					if slotFrom ~= nil then
						local item = itemsDatabase[slotFrom.Name]
						local slotTo = INVENTORY:GetSlot(data.ownerTo, data.slotTo, data.invTypeTo)

						if slotTo == nil or slotTo.Price == data.price then
							local itemIds = MySQL.rawExecute.await('SELECT id FROM inventory WHERE owner = ? AND type = ? AND slot = ? AND item_id = ? ORDER BY id ASC LIMIT ?', {
								tostring(data.ownerFrom),
								data.invTypeFrom,
								data.slotFrom,
								slotFrom.Name,
								data.quantity
							})

							local params = {}
							for k, v in ipairs(itemIds) do
								table.insert(params, v.id)
							end
							
							MySQL.update.await(string.format('UPDATE inventory SET slot = ?, owner = ?, type = ?, price = ? WHERE id IN (%s)', table.concat(params, ',')), {
								data.slotTo,
								tostring(data.ownerTo),
								data.invTypeTo,
								data.price
							})

							if item.type == 2 then
								TriggerClientEvent(
									"Weapons:Client:Remove",
									source,
									slotFrom,
									data.slotFrom,
									{
										owner = data.ownerTo,
										type = data.invTypeTo,
										slot = data.slotTo,
									}
								)
							elseif item.type == 10 then
								TriggerClientEvent(
									"Inventory:Container:Remove",
									source,
									slotFrom,
									data.slotFrom
								)
							end

							if WEAPON_PROPS[itemsDatabase[slotFrom.Name].weapon or slotFrom.Name] ~= nil then
								_refreshAttchs[data.ownerFrom] = source
							end

							if itemsDatabase[slotFrom.Name].gangChain ~= nil then
								_refreshGangChain[data.ownerFrom] = source
							end

							cb({
								player = getInventory(source, data.ownerFrom, data.invTypeFrom),
								secondary = getInventory(source, data.ownerTo, data.invTypeTo)
							})
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

		sendRefreshForClient(source, data.ownerFrom, data.invTypeFrom, data.slotFrom)
		sendRefreshForClient(source, data.ownerTo, data.invTypeTo, data.slotTo)
	end)

	Callbacks:RegisterServerCallback("Inventory:PlayerShop:AddModerator", function(source, data, cb)
		local char = Fetch:CharacterSource(source)
		if char ~= nil then
			local sid = char:GetData("SID")
			if _playerShops[data.shop] ~= nil then
				if _playerShops[data.shop].owner == sid then
					local tChar = Fetch:SID(tonumber(data.sid))
					if tChar ~= nil then
						if not isShopModerator(data.shop, tChar:GetData("Source")) then
							INVENTORY.PlayerShops.Moderators:Add(data.shop, tonumber(data.sid), string.format("%s %s", tChar:GetData("First"), tChar:GetData("Last")))
							Execute:Client(source, "Notification", "Success", string.format("%s %s Added As A Shop Moderator", tChar:GetData("First"), tChar:GetData("Last")))
						else
							Execute:Client(source, "Notification", "Error", string.format("%s %s Is Already A Shop Moderator", tChar:GetData("First"), tChar:GetData("Last")))
						end
					else
						Execute:Client(source, "Notification", "Error", "Invalid Target ID")
					end
				else
					Execute:Client(source, "Notification", "Error", "You're Not The Owner Of This Shop")
				end
			else
				Execute:Client(source, "Notification", "Error", "Invalid Shop")
			end
		end
	end)

	Callbacks:RegisterServerCallback("Inventory:PlayerShop:RemoveModerator", function(source, data, cb)
		local char = Fetch:CharacterSource(source)
		if char ~= nil then
			local sid = char:GetData("SID")
			if _playerShops[data.shop] ~= nil then
				if _playerShops[data.shop].owner == sid then
					INVENTORY.PlayerShops.Moderators:Remove(data.shop, data.sid)
					Execute:Client(source, "Notification", "Success", "Shop Moderator Removed")
				else
					Execute:Client(source, "Notification", "Error", "You're Not The Owner Of This Shop")
				end
			else
				Execute:Client(source, "Notification", "Error", "Invalid Shop")
			end
		end
	end)

	Callbacks:RegisterServerCallback("Inventory:PlayerShop:ViewModerators", function(source, data, cb)
		local char = Fetch:CharacterSource(source)
		if char ~= nil then
			local sid = char:GetData("SID")
			if _playerShops[data] and _playerShops[data].owner == sid then
				local list = {}
				for k, v in pairs(_playerShopMods[data] or {}) do
					table.insert(list, {
						label = v.name,
						description = string.format("State ID: %s", v.sid),
						event = "Shop:Client:BasicShop:RemoveModerator",
						data = {
							shop = data,
							sid = v.sid,
							name = v.name
						}
					})
				end

				cb(list)
			else
				cb(false)
			end
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("Inventory:PlayerShop:ChangeState", function(source, data, cb)
		local char = Fetch:CharacterSource(source)
		if char ~= nil then
			if _playerShops[data.id] and isShopModerator(data.id, source) then
				if not _playerShops[data.id].job or Jobs.Permissions:HasPermissionInJob(source, _playerShops[data.id].job, "JOB_SHOP_CONTROL") then
					GlobalState[string.format("BasicShop:%s", data.id)] = data.state

					Execute:Client(source, "Notification", "Success", data.state and "Store Opened" or "Store Closed")

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
end

RegisterNetEvent("Inventory:Server:UpdateSettings", function(data)
	local src = source
	local char = Fetch:CharacterSource(src)
	if char ~= nil then
		local settings = char:GetData("InventorySettings") or _defInvSettings
		for k, v in pairs(data) do
			settings[k] = v
		end
		char:SetData("InventorySettings", settings)
	end
end)

RegisterNetEvent("Inventory:Server:TriggerAction", function(data)
	local src = source
	local char = Fetch:CharacterSource(src)
	if char ~= nil then
		if LoadedEntitys[data.invType] ~= nil and LoadedEntitys[data.invType].action ~= nil then
			TriggerEvent(LoadedEntitys[data.invType].action.event, src, data)
		end
	end
end)

RegisterNetEvent("Inventory:Server:Request", function(secondary)
	local src = source
	local char = Fetch:CharacterSource(src)

	local plyrInvData = {
		size = (LoadedEntitys[1].slots or 10),
		name = char:GetData("First") .. " " .. char:GetData("Last"),
		inventory = {},
		invType = 1,
		capacity = LoadedEntitys[1].capacity,
		owner = char:GetData("SID"),
		isWeaponEligble = Weapons:IsEligible(src),
		qualifications = char:GetData("Qualifications") or {},
		loaded = false,
	}

	if secondary?.crafting then
		local benchDetails = Crafting:GetBench(source, secondary.id)
		if benchDetails ~= nil then
			benchDetails.crafting = true
			benchDetails.bench = secondary.id
	
			TriggerClientEvent("Inventory:Client:Open", src, plyrInvData, benchDetails)
			plyrInvData.inventory = getInventory(src, char:GetData("SID"), 1)
			plyrInvData.loaded = true
			--TriggerClientEvent("Inventory:Client:Cache", src, plyrInvData)
			TriggerClientEvent("Inventory:Client:Load", src, plyrInvData, benchDetails)

		end
	else
		TriggerClientEvent("Inventory:Client:Open", src, plyrInvData, secondary and INVENTORY:GetSecondaryData(src, secondary.invType, secondary.owner, secondary.class or false, secondary.model or false) or nil)
		plyrInvData.inventory = getInventory(src, char:GetData("SID"), 1)
		plyrInvData.loaded = true
		--TriggerClientEvent("Inventory:Client:Cache", src, plyrInvData)
		TriggerClientEvent("Inventory:Client:Load", src, plyrInvData, secondary and INVENTORY:GetSecondary(src, secondary.invType, secondary.owner, secondary.class or false, secondary.model or false) or nil)
	end
end)

local _inUse = {}
INVENTORY = {
	CreateDropzone = function(self, routeId, coords)
		local area = {
			id = string.format("%s:%s:%s", math.ceil(coords.x), math.ceil(coords.y), routeId),
			route = routeId,
			coords = {
				x = coords.x,
				y = coords.y,
				z = coords.z,
			},
		}

		table.insert(_dropzones, area)
		TriggerClientEvent("Inventory:Client:AddDropzone", -1, area)

		return area.id
	end,
	CheckDropZones = function(self, routeId, coords)
		local found = nil

		for k, v in ipairs(_dropzones) do
			if v.route == routeId then
				local dz = v.coords
				local distance = #(vector3(coords.x, coords.y, coords.z) - vector3(dz.x, dz.y, dz.z))
				if distance < 2.0 and (found == nil or distance < found.distance) then
					found = {
						id = v.id,
						position = v.coords,
						distance = distance,
						route = v.route,
					}
				end
			end
		end

		return found
	end,
	RemoveDropzone = function(self, routeId, id)
		for k, v in ipairs(_dropzones) do
			if v.id == id and v.route == routeId then
				if not _doingThings[string.format("%s-%s", id, 10)] then
					table.remove(_dropzones, k)
					TriggerClientEvent("Inventory:Client:RemoveDropzone", -1, id)
				end
				break
			end
		end
	end,
	DropExists = function(self, routeId, id)
		for k, v in ipairs(_dropzones) do
			if v.id == id and v.route == routeId then
				return true
			end
		end

		return false
	end,
	GetInventory = function(self, source, owner, invType)
		return getInventory(source, owner, invType)
	end,
	GetSecondaryData = function(self, _src, invType, Owner, vehClass, vehModel, isRaid, nameOverride, slotOverride, capacityOverride)
		if _src and invType and Owner then
			if entityPermCheck(_src, invType) or (isRaid and Player(_src).state.onDuty == "police") then
				if not _openInvs[string.format("%s-%s", Owner, invType)] or _openInvs[string.format("%s-%s", Owner, invType)] == _src then
					if not LoadedEntitys[invType].shop then
						_openInvs[string.format("%s-%s", Owner, invType)] = _src
					end
					
					local name = nameOverride or (LoadedEntitys[invType].name or "Unknown")
					if LoadedEntitys[invType].shop and shopLocations[Owner] ~= nil then
						name = string.format(
							"%s (%s)",
							shopLocations[Owner].name,
							LoadedEntitys[invType].name
						)
					end

					if LoadedEntitys[invType].playerShop and _playerShops[Owner] then
						name = _playerShops[Owner].name
					end

					local requestedInventory = {
						size = getSlotCount(invType, vehClass, vehModel, slotOverride, Owner, _src),
						name = name,
						class = vehClass,
						model = vehModel,
						capacity = getCapacity(invType, vehClass, vehModel, capacityOverride),
						shop = LoadedEntitys[invType].shop or false,
						playerShop = LoadedEntitys[invType].playerShop or false,
						modifyShop = LoadedEntitys[invType].playerShop and isShopModerator(Owner, _src) or false,
						free = LoadedEntitys[invType].free or false,
						inventory = {},
						invType = invType,
						owner = Owner,
						loaded = false,
						slotOverride = slotOverride,
						capacityOverride = capacityOverride,
					}

					return requestedInventory
				else
					return nil
				end
			end
		end
	end,
	GetSecondary = function(self, _src, invType, Owner, vehClass, vehModel, isRaid, nameOverride, slotOverride, capacityOverride)
		if _src and invType and Owner then
			if entityPermCheck(_src, invType) or (isRaid and Player(_src).state.onDuty == "police") then
				if not _openInvs[string.format("%s-%s", Owner, invType)] or _openInvs[string.format("%s-%s", Owner, invType)] == _src then
					if not LoadedEntitys[invType].shop then
						_openInvs[string.format("%s-%s", Owner, invType)] = _src
					end

					local name = nameOverride or (LoadedEntitys[invType].name or "Unknown")
					if LoadedEntitys[tonumber(invType)].shop and shopLocations[Owner] ~= nil then
						name = string.format(
							"%s (%s)",
							shopLocations[Owner].name,
							LoadedEntitys[tonumber(invType)].name
						)
					end

					if LoadedEntitys[tonumber(invType)].playerShop and _playerShops[Owner] then
						name = _playerShops[Owner].name
					end
	
					local requestedInventory = {
						size = getSlotCount(invType, vehClass, vehModel, slotOverride, Owner, _src),
						name = name,
						class = vehClass,
						model = vehModel,
						capacity = getCapacity(invType, vehClass, vehModel, capacityOverride),
						shop = LoadedEntitys[tonumber(invType)].shop or false,
						free = LoadedEntitys[tonumber(invType)].free or false,
						playerShop = LoadedEntitys[tonumber(invType)].playerShop or false,
						modifyShop = LoadedEntitys[tonumber(invType)].playerShop and isShopModerator(Owner, _src) or false,
						action = LoadedEntitys[tonumber(invType)].action or false,
						inventory = getInventory(_src, Owner, invType),
						invType = invType,
						owner = Owner,
						loaded = true,
						slotOverride = slotOverride,
						capacityOverride = capacityOverride,
					}
					
					return requestedInventory
				else
					return nil
				end
			else
				return nil
			end
		else
			return nil
		end
	end,
	OpenSecondary = function(self, _src, invType, Owner, vehClass, vehModel, isRaid, nameOverride, slotOverride, capacityOverride)
		if _src and invType and Owner then
			local char = Fetch:CharacterSource(_src)

			local plyrInvData = {
				size = (LoadedEntitys[1].slots or 10),
				name = char:GetData("First") .. " " .. char:GetData("Last"),
				inventory = {},
				invType = 1,
				capacity = LoadedEntitys[1].capacity,
				owner = char:GetData("SID"),
				isWeaponEligble = Weapons:IsEligible(_src),
				qualifications = char:GetData("Qualifications") or {},
			}
		
			TriggerEvent("Inventory:Server:Opened", _src, Owner, invType)

			TriggerClientEvent("Inventory:Client:Open", _src, plyrInvData, INVENTORY:GetSecondaryData(_src, invType, Owner, vehClass, vehModel, isRaid, nameOverride, slotOverride, capacityOverride))
		
			plyrInvData.inventory = getInventory(_src, char:GetData("SID"), 1)
			plyrInvData.loaded = true
		
			TriggerClientEvent("Inventory:Client:Cache", _src, plyrInvData)
			TriggerClientEvent("Inventory:Client:Load", _src, plyrInvData, INVENTORY:GetSecondary(_src, invType, Owner, vehClass, vehModel, isRaid, nameOverride, slotOverride, capacityOverride))
		end
	end,
	GetSlots = function(self, Owner, Type)
		local db = MySQL.rawExecute.await('SELECT slot as Slot FROM inventory WHERE owner = ? AND type = ? GROUP BY slot ORDER BY slot', {
			tostring(Owner),
			Type,
		})

		local slots = {}
		for k, v in ipairs(db) do
			table.insert(slots, v.Slot)
		end
		return slots
	end,
	GetSlotCount = function(self, Owner, Type)
		return MySQL.scalar.await('SELECT COUNT(*) as count FROM inventory WHERE owner = ? AND type = ?', {
			tostring(Owner),
			Type,
		})
	end,
	HasItems = function(self, Owner, Type)
		return MySQL.scalar.await('SELECT COUNT(id) as count FROM inventory WHERE owner = ? AND type = ?', {
			tostring(Owner),
			Type,
		}) > 0
	end,
	GetMatchingSlot = function(self, Owner, Name, Count, Type)
		if not itemsDatabase[Name].isStackable then
			return nil
		end

		return (MySQL.scalar.await('SELECT slot as Slot FROM inventory WHERE owner = ? AND type = ? AND item_id = ? GROUP BY slot HAVING COUNT(item_id) <= ?', {
			tostring(Owner),
			Type,
			Name,
			itemsDatabase[Name].isStackable - Count
		}))
	end,
	GetFreeSlotNumbers = function(self, Owner, invType, vehClass, vehModel, src)
		local result = INVENTORY:GetSlots(Owner, invType)
		local occupiedTable = {}
		local unOccupiedSlots = {}
		for k, v in ipairs(result) do
			occupiedTable[v] = true
		end

		local total = 8
		if LoadedEntitys[invType] ~= nil then
			total = getSlotCount(invType, vehClass or false, vehModel or false, false, Owner, src)
		else
			Logger:Error("Inventory", string.format("Entity Type ^2%s^7 Was Attempted To Be Loaded", invType))
		end

		for i = 1, total do
			if not occupiedTable[i] then
				table.insert(unOccupiedSlots, i)
			end
		end

		table.sort(unOccupiedSlots)

		return unOccupiedSlots
	end,
	SlotExists = function(self, Owner, Slot, Type)
		return (MySQL.scalar.await('SELECT id FROM inventory WHERE owner = ? AND type = ? AND slot = ?', {
			tostring(Owner),
			Type,
			Slot
		}) ~= nil)
	end,
	GetSlot = function(self, Owner, Slot, Type)
		local item = MySQL.prepare.await('SELECT id, count(*) as Count, owner as Owner, type as invType, item_id as Name, price as Price, quality AS Quality, information as MetaData, slot as Slot, MIN(creationDate) as CreateDate FROM inventory WHERE owner = ? AND type = ? AND slot = ? GROUP BY slot ORDER BY slot ASC', {
			tostring(Owner),
			Type,
			Slot
		})

		if item ~= nil then
			item.MetaData = json.decode(item.MetaData or "{}")
		end

		return item
	end,
	CountInSlot = function(self, Owner, Slot, Type)
		local t = MySQL.scalar.await('SELECT COUNT(*) as Count FROM inventory WHERE owner = ? AND type = ? AND slot = ?', {
			tostring(Owner),
			Type,
			Slot
		})
		return t
	end,
	GetOldestInSlot = function(self, Owner, Slot, Type)
		local item = MySQL.prepare.await('SELECT id, owner as Owner, type as invType, item_id as Name, price as Price, quality AS Quality, information as MetaData, slot as Slot, creationDate as CreateDate FROM inventory WHERE owner = ? AND type = ? AND slot = ? ORDER BY creationDate ASC LIMIT 1', {
			tostring(Owner),
			Type,
			Slot
		})

		if item ~= nil then
			item.MetaData = json.decode(item.MetaData or "{}")
			item.Count = self:CountInSlot(Owner, Slot, Type)
		end

		return item
	end,
	GetItem = function(self, id)
		return MySQL.prepare.await('SELECT id, count(*) as Count, owner as Owner, type as invType, item_id as Name, price as Price, quality AS Quality, information as MetaData, slot as Slot, creationDate as CreateDate FROM inventory WHERE id = ?', {
			id
		})
	end,
	AddItem = function(self, Owner, Name, Count, md, invType, vehClass, vehModel, entity, isRecurse, Slot, forceCreateDate, quality, skipMetaGen, skipChangeAlert)
		local p = promise.new()

		Citizen.CreateThread(function()
			if vehClass == nil then
				vehClass = false
			end
	
			if vehModel == nil then
				vehModel = false
			end
	
			if entity == nil then
				entity = false
			end
	
			if not Count or not tonumber(Count) or Count <= 0 then
				Count = 1
			end
	
			local itemExist = itemsDatabase[Name]
			if itemExist then
				if invType == 1 and not skipMetaGen then
					if not isRecurse and not skipChangeAlert then
						local char = Fetch:SID(Owner)
						if char ~= nil then
							TriggerClientEvent("Inventory:Client:Changed", char:GetData("Source"), "add", Name, Count)
						end
					end
				end

				local slotsNeeded = math.ceil(Count / (itemExist.isStackable or 1))
				local slots = INVENTORY:GetFreeSlotNumbers(Owner, invType, vehClass, vehModel)
				local slotsData = {}
				if Slot then
					table.insert(slotsData, {
						owner = Owner,
						type = invType,
						slot = Slot
					})
				end
				if #slots < slotsNeeded then
					for k, v in ipairs(slots) do
						table.insert(slotsData, {
							owner = Owner,
							type = invType,
							slot = v
						})
					end

					local char = Fetch:SID(Owner)
					local coords = { x = 900.441, y = -1757.186, z = 21.359 }
					local route = 0
	
					if char ~= nil then
						local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(char:GetData("Source"))))
						coords = { x = x, y = y, z = z - 0.98 }
						route = Player(char:GetData("Source")).state.currentRoute
					elseif entity ~= nil then
						local x, y, z = table.unpack(GetEntityCoords(entity))
						coords = { x = x, y = y, z = z }
						route = GetEntityRoutingBucket(entity)
					end
	
					local dz = INVENTORY:CheckDropZones(route, coords)
					local tOwn = nil
					if dz == nil then
						tOwn = INVENTORY:CreateDropzone(route, coords)
					else
						tOwn = dz.id
					end
	
					local t = INVENTORY:GetFreeSlotNumbers(tOwn, 10, vehClass, vehModel)
					for k, v in ipairs(t) do
						if #slotsData < slotsNeeded then
							table.insert(slotsData, {
								owner = tOwn,
								type = 10,
								slot = v
							})
						else
							break	
						end
					end
				else
					for k, v in ipairs(slots) do
						if #slotsData < slotsNeeded then
							table.insert(slotsData, {
								owner = Owner,
								type = invType,
								slot = v
							})
						else
							break	
						end
					end
				end

				local MetaData = nil
				if not skipMetaGen then
					if invType == 1 then
						local char = Fetch:SID(Owner)
						if char ~= nil then
							if itemExist.name == "choplist" then
								md.Owner = char:GetData("SID")
							end
							MetaData = BuildMetaDataTable(char:GetData(), Name, md or false)
						else
							MetaData = BuildMetaDataTable({}, Name, md or false)
						end
					else
						MetaData = BuildMetaDataTable({}, Name, md or false)
					end
				else
					MetaData = table.copy(md or {})
				end
	
				local retval = {}
				local qualSet = quality ~= nil
				for k, v in ipairs(slotsData) do
					if (itemExist.name == "meth_bag" or itemExist.name == "meth_brick" or itemExist.name == "coke_bag" or itemExist.name == "coke_brick") and not qualSet then
						quality = math.random(1, 100)
					elseif itemExist.name == "choplist" then
						MetaData.ChopList = Laptop.LSUnderground.Chopping:GenerateList(math.random(4, 8), math.random(3, 5))
					end

					local c = Count > (itemExist.isStackable or 1) and (itemExist.isStackable or 1) or Count
					local mSlot = INVENTORY:GetMatchingSlot(v.owner, Name, c, v.type)
					if mSlot == nil then
						retval = INVENTORY:AddSlot(v.owner, Name, c, MetaData, v.slot, v.type, forceCreateDate or false, quality or false)
					else
						retval = INVENTORY:AddSlot(v.owner, Name, c, MetaData, mSlot, v.type, forceCreateDate or false, quality or false)
					end
				end

				if not isRecurse then
					if invType == 1 then
						if WEAPON_PROPS[itemExist.weapon or Name] ~= nil then
							_refreshAttchs[Owner] = true
						end
	
						if itemExist.gangChain ~= nil then
							_refreshGangChain[Owner] = true
						end
						refreshShit(Owner, true)
					end
				end
	
				p:resolve({ id = retval, MetaData = MetaData })
			else
				p:resolve(false)
			end
		end)

		return Citizen.Await(p)
	end,
	AddSlot = function(self, Owner, Name, Count, MetaData, Slot, Type, forceCreateDate, quality)
		local p = promise.new()
		if Count <= 0 then
			Logger:Error("Inventory", "[AddSlot] Cannot Add " .. Count .. " of an Item (" .. Owner .. ":" .. Type .. ")")
			return false
		end

		if Slot == nil then
			local freeSlots = INVENTORY:GetFreeSlotNumbers(Owner, Type)
			if #freeSlots == 0 then
				Logger:Error("Inventory", "[AddSlot] No Available Slots For " .. Owner .. ":" .. Type .. " And Passed Slot Was Nil")
				return false
			end
			Slot = freeSlots[1]
		end

		if itemsDatabase[Name] == nil then
			Logger:Error(
				"Inventory",
				string.format("Slot %s in %s-%s has invalid item %s", Slot, Owner, Type, Name)
			)
			return false
		end



		local created = forceCreateDate or os.time()
		local expiry = -1
		if itemsDatabase[Name].durability ~= nil and itemsDatabase[Name].isDestroyed then
			expiry = created + itemsDatabase[Name].durability
		end

		if Count > 2500 then
			local c = Count
			local queries = {}
			while c > 0 do
				local qry = 'INSERT INTO inventory (owner, type, item_id, slot, quality, information, creationDate, expiryDate) VALUES '
				local params = {}

				local c2 = c > 2500 and 2500 or c

				for i = 1, c2 do
					table.insert(params, tostring(Owner))
					table.insert(params, Type)
					table.insert(params, Name)
					table.insert(params, Slot)
					table.insert(params, quality or 0)
					table.insert(params, json.encode(MetaData))
					table.insert(params, created)
					table.insert(params, expiry)
					qry = qry .. '(?, ?, ?, ?, ?, ?, ?, ?)'
					if i < c2 then
						qry = qry .. ','
					end
				end

				qry = qry .. ';'

				table.insert(queries, {
					query = qry,
					values = params
				})

				c -= c2
			end

			MySQL.transaction(queries, function(r)
				p:resolve(r)
			end)
		else
			local qry = 'INSERT INTO inventory (owner, type, item_id, slot, quality, information, creationDate, expiryDate) VALUES '
			local params = {}

			for i = 1, Count do
				table.insert(params, tostring(Owner))
				table.insert(params, Type)
				table.insert(params, Name)
				table.insert(params, Slot)
				table.insert(params, quality or 0)
				table.insert(params, json.encode(MetaData))
				table.insert(params, created)
				table.insert(params, expiry)
				qry = qry .. '(?, ?, ?, ?, ?, ?, ?, ?)'
				if i < Count then
					qry = qry .. ','
				end
			end
	
			qry = qry .. ';'
	
			MySQL.query(qry, params, function(res)
				p:resolve(res)
			end)
		end

		return Citizen.Await(p)
	end,
	SetItemCreateDate = function(self, id, value)
		MySQL.update.await('UPDATE inventory SET creationDate = ? WHERE id = ?', {
			value,
			id,
		})
	end,
	SetMetaDataKey = function(self, id, key, value, source)
		local slot = INVENTORY:GetItem(id)
		if slot ~= nil then
			local md = json.decode(slot.MetaData or "{}")
			md[key] = value
			MySQL.update.await('UPDATE inventory SET information = ? WHERE id = ?', {
				json.encode(md),
				id,
			})

			if source then
				TriggerClientEvent("Inventory:Client:UpdateMetadata", source, slot.Slot, json.encode(md), key)
			end

			return md
		else
			return {}
		end
	end,
	UpdateMetaData = function(self, id, updatingMeta)
		if type(updatingMeta) ~= "table" then
			return false
		end
		
		local slot = INVENTORY:GetItem(id)
		if slot ~= nil then
			local md = json.decode(slot.MetaData or "{}")

			for k, v in pairs(updatingMeta) do
				md[k] = v
			end

			MySQL.update.await('UPDATE inventory SET information = ? WHERE id = ?', {
				json.encode(md),
				id,
			})

			return md
		else
			return {}
		end
	end,
	Items = {
		GetData = function(self, item)
			return itemsDatabase[item]
		end,
		GetCount = function(self, owner, invType, item)
			local counts = INVENTORY.Items:GetCounts(owner, invType)
			return counts[item] or 0
		end,
		GetCounts = function(self, owner, invType)
			if invType == 1 then
				if _invCounts[owner] == nil then
					getInventory(owner, invType)
				end
				return _invCounts[owner]
			else
				-- non-players shouldn't be counting, so why are we here?
				return {}
			end
		end,
		GetWeights = function(self, owner, invType)
			if invType == 1 then
				if _invCounts[owner] == nil then
					getInventory(owner, invType)
				end
				local weights = 0
				for k, v in pairs(_invCounts[owner]) do
					local itemExist = itemsDatabase[k]
					if itemExist then
						weight += (itemExist.weight * v)
					end
				end
				return weights
			else
				local items = MySQL.rawExecute.await('SELECT id, count(*) as Count, item_id as Name FROM inventory WHERE owner = ? AND type = ? GROUP BY item_id', {
					tostring(owner),
					invType,
				})
	
				local weights = 0
				for k, slot in ipairs(items) do
					weights += (slot.Count * itemsDatabase[slot.Name].weight or 0)
				end
	
				return weights
			end
		end,
		GetFirst = function(self, Owner, Name, invType)
			local item = MySQL.prepare.await("SELECT id, owner as Owner, type as invType, item_id as Name, price as Price, quality AS Quality, information as MetaData, slot as Slot, creationDate as CreateDate FROM inventory WHERE owner = ? AND type = ? AND item_id = ? AND ((expiryDate >= ? AND expiryDate >= 0) OR expiryDate = -1) ORDER BY quality DESC, creationDate ASC LIMIT 1", {
				tostring(Owner),
				invType,
				Name,
				os.time(),
			})

			if item ~= nil then
				item.MetaData = json.decode(item.MetaData or "{}")
			end
			
			return item
		end,
		GetAll = function(self, Owner, Name, invType)
			local items = MySQL.prepare.await("SELECT id, owner as Owner, type as invType, item_id as Name, price as Price, quality AS Quality, information as MetaData, slot as Slot, creationDate as CreateDate FROM inventory WHERE owner = ? AND type = ? AND item_id = ? ORDER BY quality DESC, creationDate ASC", {
				tostring(Owner),
				invType,
				Name,
			})

			if #items > 0 then
				for k, v in ipairs(items) do
					items[k].MetaData = json.decode(items[k].MetaData or "{}")
				end
			end

			return items
		end,
		Has = function(self, owner, invType, item, count)
			return (MySQL.prepare.await('SELECT id, count(id) as Count FROM inventory WHERE owner = ? AND type = ? AND item_id = ? GROUP BY item_id', {
				tostring(owner),
				invType,
				item
			})?.Count or 0) >= (count or 1)
		end,
		HasId = function(self, owner, invType, id)
			return MySQL.prepare.await('SELECT id, count(*) as Count FROM inventory WHERE id = ? AND owner = ? AND type = ?', {
				id,
				tostring(owner),
				invType,
			}) ~= nil
		end,
		HasItems = function(self, source, items)
			local char = Fetch:CharacterSource(source)
			local charId = char:GetData("SID")
			for k, v in ipairs(items) do
				if not INVENTORY.Items:Has(charId, 1, v.item, v.count) then
					return false
				end
			end
			return true
		end,
		HasAnyItems = function(self, source, items)
			local char = Fetch:CharacterSource(source)
			local charId = char:GetData("SID")

			for k, v in ipairs(items) do
				if INVENTORY.Items:Has(charId, 1, v.item, v.count) then
					return true
				end
			end

			return false
		end,
		GetAllOfType = function(self, owner, invType, itemType)
			local f = {}
			local params = {}

			for k, v in pairs(itemsDatabase) do
				if v.type == itemType then
					table.insert(f, string.format('"%s"', v.name))
				end
			end

			local qry = string.format(
				'SELECT id, count(id) as Count, owner as Owner, type as invType, item_id as Name, price as Price, quality AS Quality, information as MetaData, slot as Slot, creationDate as CreateDate FROM inventory WHERE owner = ? AND type = ? AND item_id IN (%s) GROUP BY item_id ORDER BY creationDate ASC',
				table.concat(f, ',')
			)
			return MySQL.rawExecute.await(qry, { tostring(owner), invType })
		end,
		GetAllOfTypeNoStack = function(self, owner, invType, itemType)
			local f = {}
			local params = {}

			for k, v in pairs(itemsDatabase) do
				if v.type == itemType then
					table.insert(f, string.format('"%s"', v.name))
				end
			end

			local qry = string.format(
				'SELECT id, owner as Owner, type as invType, item_id as Name, price as Price, quality AS Quality, information as MetaData, slot as Slot, creationDate as CreateDate FROM inventory WHERE owner = ? AND type = ? AND item_id IN (%s)',
				table.concat(f, ',')
			)
			return MySQL.rawExecute.await(qry, { tostring(owner), invType })
		end,
		RegisterUse = function(self, item, id, cb)
			ItemCallbacks[item] = ItemCallbacks[item] or {}
			ItemCallbacks[item][id] = cb
			if itemsDatabase[item] and not itemsDatabase[item].isUsable then
				itemsDatabase[item].isUsable = true
			end

			if itemsDatabase[item]?.isUsable then
				for k, v in pairs(itemsDatabase) do
					if v.imitate == item then
						v.isUsable = true
					end
				end
			end
		end,
		Use = function(self, source, item, cb)
			if item == nil then
				return cb(false)
			end

			if not itemsDatabase[item.Name]?.isUsable or _inUse[source] then
				return cb(false)
			end

			local itemData = itemsDatabase[item.Name]
			if
				not itemData.durability
				or item ~= nil
					and item.CreateDate ~= nil
					and item.CreateDate + itemData.durability > os.time()
			then
				if itemData.closeUi then
					TriggerClientEvent("Inventory:CloseUI", source)
				end

				if
					itemData.useRestrict == nil
					or (itemData.useRestrict.job ~= nil and Jobs.Permissions:HasJob(
						source,
						itemData.useRestrict.job.id,
						itemData.useRestrict.job.workplace or false,
						itemData.useRestrict.job.grade or false,
						false,
						false,
						itemData.useRestrict.job.permissionKey or false
					) and (not itemData.useRestrict.job.duty or Player(source).state.onDuty == itemData.useRestrict.job.id))
					or (itemData.useRestrict.state and hasValue(char:GetData("States"), itemData.useRestrict.state))
					or (itemData.useRestrict.rep ~= nil and Reputation:GetLevel(source, itemData.useRestrict.rep.id) >= itemData.useRestrict.rep.level)
					or (itemData.useRestrict.character ~= nil and itemData.useRestrict.character == char:GetData("ID"))
					or (itemData.useRestrict.admin and plyr.Permissions:IsAdmin())
				then
					_inUse[source] = true
					TriggerClientEvent("Inventory:Client:InUse", source, _inUse[source])
					TriggerClientEvent("Inventory:Client:Changed", source, itemData.type == 2 and "holster" or "used", item.Name, 0, item.Slot)

					local used = true
					if itemData.animConfig ~= nil then
						used = false
						local p = promise.new()
						Callbacks:ClientCallback(source, "Inventory:ItemUse", itemData.animConfig, function(state)
							p:resolve(state)
						end)
						used = Citizen.Await(p)
					end

					if used then
						local retard = false
						if ItemCallbacks[item.Name] ~= nil then
							for k, callback in pairs(ItemCallbacks[item.Name]) do
								retard = true
								callback(source, item, itemsDatabase[item.Name])
							end
						elseif itemData.imitate and ItemCallbacks[itemData.imitate] ~= nil then
							for k, callback in pairs(ItemCallbacks[itemData.imitate]) do
								retard = true
								callback(source, item, itemsDatabase[item.Name])
							end
						end

						if retard then
							TriggerClientEvent("Markers:ItemAction", source, item)
						end
					end

					local sid = Fetch:CharacterSource(source):GetData("SID")
					if WEAPON_PROPS[item.Name] then
						_refreshAttchs[sid] = true
					end

					if itemData.gangChain ~= nil then
						_refreshGangChain[sid] = true
					end

					local char = Fetch:CharacterSource(source)
					sendRefreshForClient(source, char:GetData("SID"), 1, item.Slot)
					_inUse[source] = false
					TriggerClientEvent("Inventory:Client:InUse", source, _inUse[source])
					cb(used)
				else
					Execute:Client(source, "Notification", "Error", "You Can't Use That")
					cb(false)
				end

			else
				cb(false)
			end
		end,
		Remove = function(self, owner, invType, item, count, skipUpdate)
			local qry = "DELETE FROM inventory WHERE owner = ? AND type = ? AND item_id = ?"
			local vars = {
				tostring(owner),
				invType,
				item,
			}

			if count then
				qry = "DELETE FROM inventory WHERE owner = ? AND type = ? AND item_id = ? ORDER BY slot ASC, creationDate ASC LIMIT ?"
				vars = {
					tostring(owner),
					invType,
					item,
					count,
				}
			end

			local results = MySQL.query.await(qry, vars)

			if not skipUpdate then
				local itemData = itemsDatabase[item]
				if invType == 1 then
					local char = Fetch:SID(owner)
					if char ~= nil then
						local source = char:GetData("Source")
						TriggerClientEvent("Inventory:Client:Changed", source, "removed", item, count)
						if WEAPON_PROPS[itemData?.weapon or item] ~= nil then
							_refreshAttchs[owner] = source
						end
						if itemData?.gangChain ~= nil then
							_refreshGangChain[owner] = source
						end
						refreshShit(owner)
					end
				end
			end
			
			return results.affectedRows >= (count or 0)
		end,
		RemoveId = function(self, owner, invType, item)
			MySQL.query.await("DELETE FROM inventory WHERE id = ?", { item.id })

			if invType == 1 then
				local itemData = itemsDatabase[item.Name]
				local char = Fetch:SID(tonumber(owner))
				if char ~= nil then
					local source = char:GetData("Source")
					TriggerClientEvent("Inventory:Client:Changed", source, "removed", item.Name, 1)
					if WEAPON_PROPS[itemData?.weapon or item.Name] ~= nil then
						_refreshAttchs[owner] = source
					end

					if itemData?.gangChain ~= nil then
						_refreshGangChain[owner] = source
					end

					refreshShit(owner)
				end
			end

			return true
		end,
		RemoveAll = function(self, owner, type, item)
			MySQL.query('DELETE FROM inventory WHERE owner = ? AND type = ? AND item_id = ?', {
				tostring(owner),
				type,
				item,
			})
			return true
		end,
		RemoveSlot = function(self, Owner, Name, Count, Slot, invType)
			local slot = INVENTORY:GetSlot(Owner, Slot, invType)
			if slot == nil then
				Logger:Error(
					"Inventory",
					"Failed to remove " .. Count .. " from Slot " .. Slot .. " for " .. Owner,
					{ console = false }
				)
				return false
			else
				if slot.Count >= Count then
					MySQL.query.await('DELETE FROM inventory WHERE owner = ? AND type = ? AND slot = "?" AND item_id = ? ORDER BY creationDate ASC LIMIT ?', {
						tostring(Owner),
						invType,
						Slot,
						Name,
						Count,
					})
	
					if invType == 1 then
						local itemData = itemsDatabase[item]
						local char = Fetch:SID(Owner)
						if char ~= nil then
							local source = char:GetData("Source")
							TriggerClientEvent("Inventory:Client:Changed", source, "removed", Name, Count)
							if WEAPON_PROPS[itemData?.weapon or item] ~= nil then
								_refreshAttchs[Owner] = source
							end

							if itemData?.gangChain ~= nil then
								_refreshGangChain[Owner] = source
							end

							refreshShit(Owner)
						end
					end
	
					return true
				else
					return false
				end
			end
		end,
		RemoveList = function(self, owner, invType, items)
			for k, v in ipairs(items) do
				INVENTORY.Items:Remove(owner, invType, v.name, v.count)
			end
		end,
		GetWithStaticMetadata = function(self, masterKey, mainIdName, textureIdName, gender, data)
			for k, v in pairs(itemsDatabase) do
				if v.staticMetadata ~= nil
					and v.staticMetadata[masterKey] ~= nil
					and v.staticMetadata[masterKey][gender] ~= nil
					and v.staticMetadata[masterKey][gender][mainIdName] == data[mainIdName]
					and v.staticMetadata[masterKey][gender][textureIdName] == data[textureIdName]
				then
					return k
				end
			end

			return nil
		end,
	},
	Holding = {
		Put = function(self, source)
			Citizen.CreateThread(function()
				local p = promise.new()
				local char = Fetch:CharacterSource(source)
				if char ~= nil then
					local inv = getInventory(source, char:GetData("SID"), 1)

					if #inv > 0 then
						local freeSlots = INVENTORY:GetFreeSlotNumbers(char:GetData("SID"), 2)

						if #inv <= #freeSlots then
							local queries = {}

							for k, v in ipairs(inv) do
								local sid = char:GetData("SID")
								table.insert(queries, {
									query = "UPDATE inventory SET owner = ?, type = ?, slot = ? WHERE owner = ? AND type = ? AND slot = ?", 
									values = {
										tostring(sid),
										2,
										freeSlots[k],
										tostring(sid),
										1,
										v.Slot
									}
								})
							end

							MySQL.transaction.await(queries)
							refreshShit(char:GetData("SID"))

							Execute:Client(source, "Notification", "Success", "Retreived Items")
						else
							Execute:Client(source, "Notification", "Error", "Not Enough Slots Available")
						end
					else
						Execute:Client(source, "Notification", "Error", "No Items To Retreive")
					end
				end
				
				p:resolve(true)
				Citizen.Await(p)
			end)
		end,
		Take = function(self, source)
			Citizen.CreateThread(function()
				local p = promise.new()
				local char = Fetch:CharacterSource(source)
				if char ~= nil then
					local inv = getInventory(source, char:GetData("SID"), 2)

					if #inv > 0 then
						local freeSlots = INVENTORY:GetFreeSlotNumbers(char:GetData("SID"), 1)

						if #inv <= #freeSlots then
							local queries = {}

							for k, v in ipairs(inv) do
								local sid = char:GetData("SID")
								table.insert(queries, {
									query = "UPDATE inventory SET owner = ?, type = ?, slot = ? WHERE owner = ? AND type = ? AND slot = ?", 
									values = {
										tostring(sid),
										1,
										freeSlots[k],
										tostring(sid),
										2,
										v.Slot
									}
								})
							end

							MySQL.transaction.await(queries)
							refreshShit(char:GetData("SID"), true)

							Execute:Client(source, "Notification", "Success", "Retreived Items")
						else
							Execute:Client(source, "Notification", "Error", "Not Enough Slots Available")
						end
					else
						Execute:Client(source, "Notification", "Error", "No Items To Retreive")
					end
				end
				
				p:resolve(true)
				Citizen.Await(p)
			end)
		end,
	},
	Ballistics = {
		Clear = function(self, source, ballisticId, ballisticType)
			Citizen.CreateThread(function()
				local p = promise.new()
				local char = Fetch:CharacterSource(source)
				if char ~= nil then
					local inv = getInventory(source, ballisticId, ballisticType)

					if #inv > 0 then
						local freeSlots = INVENTORY:GetFreeSlotNumbers(char:GetData("SID"), 1)

						if #inv <= #freeSlots then
							local queries = {}

							for k, v in ipairs(inv) do
								local sid = char:GetData("SID")
								table.insert(queries, {
									query = "UPDATE inventory SET owner = ?, type = ?, slot = ? WHERE owner = ? AND type = ? AND slot = ?", 
									values = {
										tostring(sid),
										1,
										freeSlots[k],
										ballisticId,
										ballisticType,
										v.Slot
									}
								})
							end

							MySQL.transaction.await(queries)
							refreshShit(char:GetData("SID"), true)
						end
					end
				end
				
				p:resolve(true)
				Citizen.Await(p)
			end)
		end,
	},
	Container = {
		Open = function(self, src, item, identifier)
			Callbacks:ClientCallback(src, "Inventory:Container:Open", {
				item = item,
				container = ("container:%s"):format(identifier),
			}, function()
				INVENTORY:OpenSecondary(src, itemsDatabase[item.Name].container, ("container:%s"):format(identifier))
			end)
		end,
	},
	Stash = {
		Open = function(self, src, invType, identifier)
			INVENTORY:OpenSecondary(src, invType, ("stash:%s"):format(identifier))
		end,
	},
	Shop = {
		Open = function(self, src, identifier)
			INVENTORY:OpenSecondary(src, 11, ("shop:%s"):format(identifier))
		end,
	},
	Search = {
		Character = function(self, src, tSrc, id)
			Callbacks:ClientCallback(tSrc, "Inventory:ForceClose", {}, function(state)
				Execute:Client(tSrc, "Notification", "Info", "You Were Searched")
				INVENTORY:OpenSecondary(src, 1, id)
			end)
		end,
	},
	Rob = function(self, src, tSrc, id)
		Callbacks:ClientCallback(tSrc, "Inventory:ForceClose", {}, function(state)
			INVENTORY:OpenSecondary(src, 1, id)
		end)
	end,
	Poly = {
		Create = function(self, data)
			table.insert(_polyInvs, data.id)
			GlobalState[string.format("Inventory:%s", data.id)] = data
		end,
		-- Add = {
		-- 	Box = function(self, id, coords, length, width, options, entityId, restrictions)

		-- 	end,
		-- 	Poly = function(self) end,
		-- 	Circle = function(self) end,
		-- },
		Remove = function(self, id)

		end,
	},
	IsOpen = function(self, invType, id)
		return _openInvs[string.format("%s-%s", invType, id)]
	end,
	UpdateGovIDMugshot = function(self, stateId, mugshot)
		if not stateId or type(stateId) ~= "number" then
			return false
		end

		local res = MySQL.prepare.await('SELECT id, information as MetaData FROM inventory WHERE item_id = ? AND JSON_EXTRACT(information, "$.StateID") = ?', { 
			"govid",
			stateId
		})

		local updatingIds = {}
		for k,v in ipairs(res) do
			table.insert(updatingIds, v.id)
		end

		if #updatingIds > 0 then
			MySQL.update.await(string.format('UPDATE inventory SET information = JSON_SET(information, "$.Mugshot", ?) WHERE id IN (%s)', table.concat(updatingIds, ',')), {
				mugshot
			})
		end
		return true
	end,
	PlayerShops = {
		Basic = {
			Create = function(self, name, position, ped, owner, bank, job)
				local id = MySQL.insert.await('INSERT INTO player_shops (name, position, ped_model, owner, job, owner_bank) VALUES(?, ?, ?, ?, ?, ?)', {
					name,
					json.encode(position),
					ped ~= "0" and ped or nil,
					owner,
					job ~= "0" and job or nil,
					bank,
				})
				_playerShops[id] = {
					id = id,
					name = name,
					ped_model = ped ~= "0" and ped or nil,
					position = position,
					owner = owner,
					job = job ~= "0" and job or nil,
					bank = bank,
				}
	
				TriggerClientEvent("Inventory:Client:BasicShop:Create", -1, _playerShops[id])
			end,
			Delete = function(self, id)
				local queries = {}
				table.insert(queries, {
					query = "DELETE FROM player_shops_moderators WHERE shop = ?",
					values = {
						id,
					}
				})
				table.insert(queries, {
					query = "DELETE FROM player_shops WHERE id = ?",
					values = {
						id,
					}
				})
				MySQL.transaction(queries)
				_playerShops[id] = nil
				_playerShopMods[id] = nil
				TriggerClientEvent("Inventory:Client:BasicShop:Delete", -1, id)
			end,
		},
		Moderators = {
			Add = function(self, shop, sid, name)
				MySQL.insert("INSERT INTO player_shops_moderators (shop, sid, name) VALUES(?, ?, ?) ON DUPLICATE KEY UPDATE shop = VALUES(shop), sid = VALUES(sid), name = VALUES(name)", {
					shop,
					sid,
					name
				})
				_playerShopMods[shop] = _playerShopMods[shop] or {}
				table.insert(_playerShopMods[shop], {
					sid = sid,
					name = name,
				})
			end,
			Remove = function(self, shop, sid)
				MySQL.query("DELETE FROM player_shops_moderators WHERE shop = ? AND sid = ?", {
					shop,
					sid,
				})

				_playerShopMods[shop] = _playerShopMods[shop] or {}
				for k, v in ipairs(_playerShopMods[shop]) do
					if v.sid == sid then
						table.remove(_playerShopMods[shop], k)
						break
					end
				end
			end
		}
	},
	ItemTemplate = {
		Create = function(self, itemId, label, description, type, rarity, weight, durability, stackLimit, iconOverride, price, itemData)
			local id = MySQL.query.await('INSERT INTO item_template (description, type, rarity, iconOverride, price, weapon, imitate, isStackable, closeUi, metalic, weight, durability, isDestroyed, isRemoved, gun, requiresLicense, qualification, ammoType, bulletCount, container, staticMetadata, component, animConfig, statusChange, extra, schematic, name, label) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)', {
				description or nil,
				type or 1,
				rarity or 1,
				iconOverride or nil,
				price >= 0 and price or 0,
				itemData?.weapon or nil,
				itemData?.imitate or nil,
				stackLimit or 1,
				itemData?.closeUi or false,
				itemData?.metalic or false,
				weight >= 0 and weight or nil,
				durability >= 0 and durability or nil,
				itemData?.isDestroyed or false,
				itemData?.isRemoved or false,
				type == 2,
				itemData?.requiresLicense or false,
				itemData?.qualification or nil,
				itemData?.ammoType or nil,
				itemData?.bulletCount or 0,
				itemData?.container or nil,
				itemData?.staticMetadata and json.encode(itemData?.staticMetadata) or nil,
				itemData?.component and json.encode(itemData?.component) or nil,
				itemData?.animConfig and json.encode(itemData?.animConfig) or nil,
				itemData?.statusChange and json.encode(itemData?.statusChange) or nil,
				itemData?.extra and json.encode(itemData?.extra) or nil,
				itemData?.schematic or nil,
				itemId,
				label,
			})

			itemsDatabase[itemId] = {
				name = itemId,
				label = label,
				description = description or nil,
				type = type or 1,
				rarity = rarity or 1,
				iconOverride = iconOverride or nil,
				price = price >= 0 and price or 0,
				weapon = itemData?.weapon or nil,
				imitate = itemData?.imitate or nil,
				isStackable = stackLimit or 1,
				closeUi = itemData?.closeUi or false,
				metalic = itemData?.metalic or false,
				weight = weight >= 0 and weight or nil,
				durability = durability >= 0 and durability or nil,
				isDestroyed = itemData?.isDestroyed or false,
				isRemoved = itemData?.isRemoved or false,
				gun = type == 2,
				requiresLicense = itemData?.requiresLicense or false,
				qualification = itemData?.qualification or nil,
				ammoType = itemData?.ammoType or nil,
				bulletCount = itemData?.bulletCount or 0,
				container = itemData?.container or nil,
				staticMetadata = itemData?.staticMetadata or nil,
				component = itemData?.component or nil,
				animConfig = itemData?.animConfig or nil,
				statusChange = itemData?.statusChange or nil,
				schematic = itemData?.schematic or nil,
			}

			if itemData?.extra then
				for k, v in pairs(itemData.extra) do
					itemsDatabase[itemId][k] = v
				end
			end

			SetupItemUses(itemsDatabase[itemId])

			TriggerEvent("Inventory:Server:NewItemCreated", itemId, type)
			TriggerLatentClientEvent("Inventory:Client:NewItemCreated", -1, 50000, itemsDatabase[itemId])

			return itemsDatabase[itemId]
		end,
	}
}

function UpdateCharacterItemStates(source, inventory, adding)
	local char = Fetch:CharacterSource(source)
	if not char then
		return
	end
	local changedState = false
	local playerStates = char:GetData("States") or {}

	local allInventoryStates = {}
	for k, v in ipairs(inventory) do
		local item = itemsDatabase[v.Name]
		if item ~= nil and item.state ~= nil and (item.durability == nil or (os.time() - v.CreateDate < item.durability)) then
			table.insert(allInventoryStates, item.state)
		end
	end

	if adding then
		for item, itemState in pairs(allInventoryStates) do
			if not Utils:DoesTableHaveValue(playerStates, itemState) then
				table.insert(playerStates, itemState)
				changedState = true
			end
		end
	end

	local s = {}
	for i = #playerStates, 1, -1 do
		if
			not Utils:DoesTableHaveValue(allInventoryStates, playerStates[i])
			and string.sub(playerStates[i], 1, string.len("SCRIPT")) ~= "SCRIPT"
			and string.sub(playerStates[i], 1, string.len("ACCESS")) ~= "ACCESS"
		then
			table.remove(playerStates, i)
			changedState = true
		end
	end

	if changedState then
		char:SetData("States", playerStates)
	end
end


function UpdateCharacterGangChain(source, inventory)
	local char = Fetch:CharacterSource(source)
	if not char then
		return
	end

	local gangChains = {}
	for k, v in ipairs(inventory) do
		local item = itemsDatabase[v.Name]
		if item ~= nil and item.gangChain ~= nil then
			table.insert(gangChains, item.gangChain)
		end
	end

	local myGangChain = char:GetData("GangChain") or nil
	if myGangChain ~= nil and not Utils:DoesTableHaveValue(gangChains, myGangChain) then
		char:SetData("GangChain", "NONE")
	end
end