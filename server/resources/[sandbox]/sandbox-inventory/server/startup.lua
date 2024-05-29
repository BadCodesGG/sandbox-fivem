STORE_SHARE_AMOUNT = 0.8

repairWindow = (60 * 60 * 24) * 7 -- Give 7 day period before we completely delete item

itemsDatabase = {}
itemClasses = {}
itemsWithState = {}

_schematics = _schematics or {}

itemsLoaded = false
_started = false

_dbItems = {}

function UpdateDatabaseItems()
	-- local queries = {}
	-- for k, v in pairs(_itemsSource) do
	-- 	for k2, v2 in ipairs(v) do
	-- 		local extra = {}
	-- 		if v2.gangChain ~= nil then extra.gangChain = v2.gangChain end
	-- 		if v2.phoneCase ~= nil then extra.phoneCase = v2.phoneCase end
	-- 		if v2.drugState ~= nil then extra.drugState = v2.drugState end
	-- 		if v2.healthModifier ~= nil then extra.healthModifier = v2.healthModifier end
	-- 		if v2.armourModifier ~= nil then extra.armourModifier = v2.armourModifier end
	-- 		if v2.progressModifier ~= nil then extra.progressModifier = v2.progressModifier end
	-- 		if v2.energyModifier ~= nil then extra.energyModifier = v2.energyModifier end
	-- 		if v2.stressTicks ~= nil then extra.stressTicks = v2.stressTicks end
	-- 		if v2.gemProperties ~= nil then extra.gemProperties = v2.gemProperties end

	-- 		table.insert(queries, {
	-- 			query = "INSERT INTO item_template (name, description, type, rarity, iconOverride, price, weapon, imitate, isStackable, closeUi, metalic, weight, durability, isDestroyed, isRemoved, gun, requiresLicense, qualification, ammoType, bulletCount, container, staticMetadata, component, animConfig, statusChange, extra, schematic, state, label) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?) ON DUPLICATE KEY UPDATE description = VALUES(description), type = VALUES(type), rarity = VALUES(rarity), iconOverride = VALUES(iconOverride), price = VALUES(price), weapon = VALUES(weapon), imitate = VALUES(imitate), isStackable = VALUES(isStackable), closeUi = VALUES(closeUi), metalic = VALUES(metalic), weight = VALUES(weight), durability = VALUES(durability), isDestroyed = VALUES(isDestroyed), isRemoved = VALUES(isRemoved), gun = VALUES(gun), requiresLicense = VALUES(requiresLicense), qualification = VALUES(qualification), ammoType = VALUES(ammoType), bulletCount = VALUES(bulletCount), container = VALUES(container), staticMetadata = VALUES(staticMetadata), component = VALUES(component), animConfig = VALUES(animConfig), statusChange = VALUES(statusChange), extra = VALUES(extra), schematic = VALUES(schematic), state = VALUES(state), label = VALUES(label)",
	-- 			values = {
	-- 				v2.name,
	-- 				v2.description or nil,
	-- 				v2.type or 1,
	-- 				v2.rarity or 1,
	-- 				v2.iconOverride or nil,
	-- 				v2.price >= 0 and v2.price or 0,
	-- 				v2.weapon or nil,
	-- 				v2.imitate or nil,
	-- 				v2.isStackable or 1,
	-- 				v2.closeUi or false,
	-- 				v2.metalic or false,
	-- 				v2.weight >= 0 and v2.weight or nil,
	-- 				(v2.durability and v2.durability >= 0 and v2.durability) or nil,
	-- 				v2.isDestroyed or false,
	-- 				v2.isRemoved or false,
	-- 				v2.type == 2,
	-- 				v2.requiresLicense or false,
	-- 				v2.qualification or nil,
	-- 				v2.ammoType or nil,
	-- 				v2.bulletCount or 0,
	-- 				v2.container or nil,
	-- 				v2.staticMetadata and json.encode(v2.staticMetadata) or nil,
	-- 				v2.component and json.encode(v2.component) or nil,
	-- 				v2.animConfig and json.encode(v2.animConfig) or nil,
	-- 				v2.statusChange and json.encode(v2.statusChange) or nil,
	-- 				json.encode(extra),
	-- 				v2.schematic or nil,
	-- 				v2.state or nil,
	-- 				v2.label,
	-- 			}
	-- 		})
	-- 	end
	-- end

	-- MySQL.transaction.await(queries)

	for k, v in pairs(_itemsSource) do
		for k2, v2 in ipairs(v) do
			itemsDatabase[v2.name] = v2
		end
	end
end

function LoadItemsFromDb()
	local iDb = MySQL.query.await("SELECT * FROM item_template WHERE name IS NOT NULL", {})

	for k, v in ipairs(iDb) do
		if v.isStackable == 0 then
			v.isStackable = false
		end

		if v.staticMetadata then
			v.staticMetadata = json.decode(v.staticMetadata)
		end

		if v.component then
			v.component = json.decode(v.component)
		end

		if v.animConfig then
			v.animConfig = json.decode(v.animConfig)
		end

		if v.statusChange then
			v.statusChange = json.decode(v.statusChange)
		end

		if v.extra then
			for k2, v2 in pairs(json.decode(v.extra)) do
				v[k2] = v2
			end
		end

		if not v.isUsable and ItemCallbacks[v.name] ~= nil then
			v.isUsable = true
		end

		itemClasses[v.type] = itemClasses[v.type] or {}
		table.insert(itemClasses[v.type], v.name)
		itemsDatabase[v.name] = v
		_dbItems[v.name] = v
	end

	for k, v in pairs(itemsDatabase) do
		SetupItemUses(v)
	end

	itemsLoaded = true

	RegisterRandomItems()

	Logger:Trace("Inventory", string.format("Loaded ^2%s^7 Items", #iDb))
	TriggerLatentClientEvent("Inventory:Client:LoadItems", -1, 50000, _dbItems)
end

local tmpItems = { '"paleto_access_codes"', '"event_invite"' }
function ClearDropZones()
	local f = MySQL.query.await("DELETE FROM inventory WHERE type = ?", { 10 })

	Logger:Info("Inventory", string.format("Cleaned Up ^2%s^7 Items In Dropzones", f.affectedRows))

	local trash = 0
	local s = {}
	for k, v in pairs(LoadedEntitys) do
		if v.trash then
			table.insert(s, v.id)
		end
	end

	local t = MySQL.query.await("DELETE FROM inventory WHERE type IN (" .. table.concat(s, ",") .. ")")
	trash += t.affectedRows

	Logger:Info("Inventory", string.format("Cleaned Up ^2%s^7 Items In Trash Inventories", trash))
	local delTmp = MySQL.query.await(string.format("DELETE FROM inventory WHERE item_id IN (%s)", table.concat(tmpItems, ",")))
	Logger:Info("Inventory", string.format("Cleaned Up ^2%s^7 Temporary Items", delTmp.affectedRows))
end

function ClearLocalVehicleInventories()
	local d = MySQL.query.await("DELETE FROM inventory WHERE SUBSTRING(owner, 11, 1) = ? AND type = ?", { "B", 4 })
	Logger:Info("Inventory", string.format("Cleaned Up ^2%s^7 Local Vehicle Inventories", d.affectedRows))
end

function countTable(t)
	local c = 0
	for k, v in pairs(t) do
		c += 1
	end
	return c
end

function ClearBrokenItems()
	if _started then
		return
	end
	_started = true
	
	local d = MySQL.query.await("DELETE FROM inventory WHERE expiryDate < ? AND expiryDate >= 0", { os.time() })
	Logger:Info("Inventory", string.format("Cleaned Up ^2%s^7 Degraded Items", d.affectedRows))
	d = nil
	
	Citizen.CreateThread(function()
		while _started do
			Citizen.Wait((1000 * 60) * 30)
			MySQL.query("DELETE FROM inventory WHERE expiryDate < ? AND expiryDate >= 0", { os.time() }, function(d)
				Logger:Info("Inventory", string.format("Cleaned Up ^2%s^7 Degraded Items", d.affectedRows))
			end)
		end
	end)
end

function SetupGarbage()
	if _trashCans then
		for storageId, storage in ipairs(_trashCans) do
			INVENTORY.Poly:Create(storage)
		end
	end
end

function SetupItemUses(itemData)
	if itemData.state ~= nil then
		itemsWithState[itemData.name] = itemData.state
	end

	if itemData.type == 1 and itemsDatabase[itemData.name].statusChange ~= nil then
		INVENTORY.Items:RegisterUse(itemData.name, "StatusConsumable", function(source, item) -- Foo
			INVENTORY.Items:RemoveSlot(item.Owner, item.Name, 1, item.Slot, 1)

			if itemsDatabase[item.Name].statusChange.Add ~= nil then
				for k, v in pairs(itemsDatabase[item.Name].statusChange.Add) do
					TriggerClientEvent("Status:Client:updateStatus", source, k, true, v)
				end
			end

			if itemsDatabase[item.Name].statusChange.Remove ~= nil then
				for k, v in pairs(itemsDatabase[item.Name].statusChange.Remove) do
					TriggerClientEvent("Status:Client:updateStatus", source, k, false, -v)
				end
			end

			if itemsDatabase[item.Name].statusChange.Ignore ~= nil then
				for k, v in pairs(itemsDatabase[item.Name].statusChange.Ignore) do
					Player(source).state[string.format("ignore%s", k)] = v
				end
			end

			if itemsDatabase[item.Name].progressModifier ~= nil then
				Execute:Client(
					source,
					"Progress",
					"Modifier",
					itemsDatabase[item.Name].progressModifier.modifier,
					math.random(
						itemsDatabase[item.Name].progressModifier.min,
						itemsDatabase[item.Name].progressModifier.max
					) * (60 * 1000)
				)
			end

			if itemsDatabase[item.Name].energyModifier ~= nil then
				TriggerClientEvent(
					"Inventory:Client:SpeedyBoi",
					source,
					itemsDatabase[item.Name].energyModifier.modifier,
					itemsDatabase[item.Name].energyModifier.duration * 1000,
					itemsDatabase[item.Name].energyModifier.cooldown * 1000,
					itemsDatabase[item.Name].energyModifier.skipScreenEffects
				)
			end

			if itemsDatabase[item.Name].healthModifier ~= nil then
				TriggerClientEvent("Inventory:Client:HealthModifier", source, itemsDatabase[item.Name].healthModifier)
			end

			if itemsDatabase[item.Name].armourModifier ~= nil then
				TriggerClientEvent("Inventory:Client:ArmourModifier", source, itemsDatabase[item.Name].armourModifier)
			end

			if itemsDatabase[item.Name].stressTicks ~= nil then
				Player(source).state.stressTicks = itemsDatabase[item.Name].stressTicks
				TriggerClientEvent("Status:Client:Ticks:Stress", source)
			end
		end)
	elseif itemData.type == 2 then
		INVENTORY.Items:RegisterUse(itemData.name, "Weapons", function(source, item)
			TriggerClientEvent("Weapons:Client:Use", source, item)
		end)
	elseif itemData.type == 9 then
		INVENTORY.Items:RegisterUse(itemData.name, "Ammo", function(source, item)
			Callbacks:ClientCallback(source, "Weapons:AddAmmo", itemsDatabase[item.Name], function(state)
				if state then
					Inventory.Items:RemoveSlot(item.Owner, item.Name, 1, item.Slot, 1)
				end
			end)
		end)
	elseif itemData.type == 10 then
		INVENTORY.Items:RegisterUse(itemData.name, "Containers", function(source, item)
			INVENTORY.Container:Open(source, item, item.MetaData.Container)
		end)
	elseif itemData.imitate and itemsDatabase[itemData.imitate] ~= nil and itemsDatabase[itemData.imitate].isUsable then
		itemsDatabase[itemData.name].isUsable = true
		itemsDatabase[itemData.name].closeUi = itemsDatabase[itemData.imitate].closeUi
	elseif itemData.gangChain ~= nil then
		INVENTORY.Items:RegisterUse(itemData.name, "GangChains", function(source, item)
			local char = Fetch:CharacterSource(source)
			if itemData.gangChain ~= nil then
				if itemData.gangChain ~= char:GetData("GangChain") then
					TriggerClientEvent("Ped:Client:ChainAnim", source)
					Citizen.Wait(3000)
					char:SetData("GangChain", itemData.gangChain)
				else
					TriggerClientEvent("Ped:Client:ChainAnim", source)
					Citizen.Wait(3000)
					char:SetData("GangChain", "NONE")
				end
			end
		end)
	elseif itemData.type == 16 and itemData.component ~= nil then
		INVENTORY.Items:RegisterUse(itemData.name, "WeaponAttachments", function(source, item)
			Weapons:EquipAttachment(source, item)
		end)
	end

	if itemData.drugState ~= nil then
		INVENTORY.Items:RegisterUse(itemData.name, "DrugStates", function(source, item)
			local char = Fetch:CharacterSource(source)
			if char ~= nil then
				local drugStates = char:GetData("DrugStates") or {}
				drugStates[itemData.drugState.type] = {
					item = itemData.name,
					expires = os.time() + itemData.drugState.duration,
				}
				char:SetData("DrugStates", drugStates)
			end
		end)
	end

	if itemData.phoneCase ~= nil then
		INVENTORY.Items:RegisterUse(itemData.name, "PhoneCase", function(source, item)
			local char = Fetch:CharacterSource(source, true)
			if char ~= nil then
				char:SetData("PhoneCase", itemData.phoneCase)
				INVENTORY.Items:RemoveSlot(item.Owner, item.Name, 1, item.Slot, 1)
			end
		end)
	end
end

function LoadItems()
	local c = 0
	for _, its in pairs(_itemsSource) do
		for k, v in ipairs(its) do
			c = c + 1
			itemClasses[v.type] = itemClasses[v.type] or {}
			table.insert(itemClasses[v.type], v.name)
			itemsDatabase[v.name] = v

			SetupItemUses(v)
		end
	end

	itemsLoaded = true

	RegisterRandomItems()
	Logger:Trace("Inventory", string.format("Loaded ^2%s^7 Items", c))
end

function LoadEntityTypes()
	for k, v in ipairs(_entityTypes) do
		LoadedEntitys[tonumber(v.id)] = v
	end
	Logger:Trace("Inventory", string.format("Loaded ^2%s^7 Inventory Entity Types", #_entityTypes))
end

shopLocations = {}
storeBankAccounts = {}
pendingShopDeposits = {}
local _startingPendingDepositThread = false
function LoadShops()
	Citizen.CreateThread(function()
		Citizen.Wait(10000)

		local f = Banking.Accounts:GetOrganization("dgang")

		for k, v in ipairs(_shops) do
			local id = k
			if v.id ~= nil then
				id = v.id
			else
				v.id = k
			end

			v.restriction = LoadedEntitys[v.entityId].restriction
			shopLocations[string.format("shop:%s", id)] = v
		end

		for k, v in pairs(_entityTypes) do
			storeBankAccounts[v.id] = f.Account
		end

		local t = MySQL.rawExecute.await("SELECT shop, bank FROM shop_bank_accounts")
		for k, v in ipairs(t) do
			storeBankAccounts[v.shop] = v.bank
		end

		Logger:Trace("Inventory", string.format("Loaded ^2%s^7 Shop Locations", #_shops))
	end)

	if not _startingPendingDepositThread then
		_startingPendingDepositThread = true
		Citizen.CreateThread(function()
			while true do
				Citizen.Wait(1000 * 60 * 60)

				for k, v in pairs(pendingShopDeposits) do
					if v.tax then
						Logger:Trace(
							"Inventory",
							string.format(
								"Depositing ^2$%s^7 To ^3%s^7 For Tax On ^2%s^7 Store Transactions",
								v.amount,
								k,
								v.transactions
							)
						)
						Banking.Balance:Deposit(k, v.amount, {
							type = "deposit",
							title = "Sales Tax",
							description = string.format("Deposit For Sales Tax On %s Store Sales", v.transactions),
							data = {},
						}, true)
					else
						Logger:Trace(
							"Inventory",
							string.format(
								"Depositing ^2$%s^7 To ^3%s^7 For ^2%s^7 Store Transactions",
								v.amount,
								k,
								v.transactions
							)
						)
						Banking.Balance:Deposit(k, v.amount, {
							type = "deposit",
							title = "Store Sales",
							description = string.format("Deposit For %s Store Sales", v.transactions),
							data = {},
						}, true)
					end

					pendingShopDeposits[k] = nil
				end
			end
		end)
	end
end

function RegisterCommands()
	Chat:RegisterAdminCommand("storebank", function(source, args, rawCommand)
		MySQL.query.await(
			"INSERT INTO shop_bank_accounts (shop, bank) VALUES(?, ?) ON DUPLICATE KEY UPDATE bank = VALUES(bank)",
			{
				tonumber(args[1]),
				tonumber(args[2]),
			}
		)
		storeBankAccounts[string.format("shop:%s", tonumber(args[1]))] = tonumber(args[2])
	end, {
		help = "Link Bank Account To Shop",
		params = {
			{
				name = "Shop ID",
				help = "Shop Entity ID To Attach Bank Account To",
			},
			{
				name = "Account Number",
				help = "Account Number To Attach Bank Account To",
			},
		},
	}, 2)

	Chat:RegisterAdminCommand("openinv", function(source, args, rawCommand)
		if source == nil or source <= 0 then
			Logger:Info("Inventory", "Source is empty. This is sus.")
			return
		end
		if args[1] == nil or args[1] == "" then
			Logger:Info("Inventory", "Player SID is not valid!")
			return
		end
		local char = Fetch:SID(tonumber(args[1]), true)
		if char == nil then
			Logger:Info("Inventory", "Player does not exist!")
			return
		end
		Logger:Info(
			"Inventory",
			string.format(
				"Opening Secondary Inventory: %s %s (%s)",
				char:GetData("First"),
				char:GetData("Last"),
				char:GetData("SID")
			)
		)
		INVENTORY:OpenSecondary(source, 1, tonumber(args[1]))
	end, {
		help = "Open Secondary Inventory",
		params = {
			{
				name = "State ID",
				help = "Player State ID",
			},
		},
	}, 1)

	Chat:RegisterAdminCommand("removecd", function(source, args, rawCommand)
		RemoveCraftingCooldown(source, args[1], args[2])
	end, {
		help = "Remove Crafting Cooldown From A Bench",
		params = {
			{
				name = "Bench ID",
				help = "Unique ID of the bench to interact with",
			},
			{
				name = "Craft Key",
				help = "Unique key for the craft item",
			},
		},
	}, 2)

	Chat:RegisterAdminCommand("clearinventory", function(source, args, rawCommand)
		local char = Fetch:CharacterSource(source)
		local tChar = Fetch:SID(tonumber(args[1]), true)
		if tChar == nil then
			Execute:Client(source, "Notification", "Error", "This player is not online")
			return
		end

		local sid = char:GetData("SID")
		local tsid = tChar:GetData("SID")

		MySQL.query.await("DELETE FROM inventory WHERE owner = ? AND type = ?", { sid, 1 })
		Execute:Client(
			tChar:GetData("Source"),
			"Notification",
			"Error",
			"Your inventory was cleared by " .. tostring(tsid)
		)
		Execute:Client(source, "Notification", "Success", "You cleared the inventory of " .. tostring(sid))
		refreshShit(tsid, true)
	end, {
		help = "Clear Player Inventory",
		params = {
			{
				name = "SID",
				help = "SID of the Player",
			},
		},
	}, 1)

	Chat:RegisterAdminCommand("clearinventory2", function(source, args, rawCommand)
		local Owner, Type = args[1], tonumber(args[2])

		if Owner and Type then
			MySQL.query.await("DELETE FROM inventory WHERE owner = ? AND type = ?", { Owner, Type })
			Execute:Client(
				source,
				"Notification",
				"Success",
				string.format("You cleared inventory of %s-%s", Owner, Type)
			)
		end
	end, {
		help = "Clear Inventory",
		params = {
			{
				name = "Owner",
				help = "Inventory Owner",
			},
			{
				name = "Type",
				help = "Inventory Type",
			},
		},
	}, 2)

	Chat:RegisterAdminCommand("giveitem", function(source, args, rawCommand)
		local char = Fetch:CharacterSource(source, true)
		if char and tostring(args[1]) ~= nil and tonumber(args[2]) ~= nil then
			local itemExist = itemsDatabase[args[1]]
			if itemExist then
				if itemExist.type ~= 2 then
					INVENTORY:AddItem(char:GetData("SID"), args[1], tonumber(args[2]), {}, 1)
				else
					Execute:Client(
						source,
						"Notification",
						"Error",
						"You can only give items with this command, try /giveweapon"
					)
				end
			else
				Execute:Client(source, "Notification", "Error", "Item not located")
			end
		end
	end, {
		help = "Give Item",
		params = {
			{
				name = "Item Name",
				help = "The name of the Item",
			},
			{
				name = "Item Count",
				help = "The count of the Item",
			},
		},
	}, 2)

	Chat:RegisterAdminCommand("giveweapon", function(source, args, rawCommand)
		local char = Fetch:CharacterSource(source)
		if tostring(args[1]) ~= nil then
			local weapon = string.upper(args[1])
			local itemExist = itemsDatabase[weapon]
			if itemExist then
				if itemExist.type == 2 then
					local sid = char:GetData("SID")
					if itemExist.isThrowable then
						INVENTORY:AddItem(sid, weapon, tonumber(args[2]), { ammo = 1, clip = 0 }, 1)
					else
						local ammo = 0
						if args[2] ~= nil then
							ammo = tonumber(args[2])
						end

						INVENTORY:AddItem(
							sid,
							weapon,
							1,
							{ ammo = ammo, clip = 0, Scratched = args[3] == "1" or nil },
							1
						)
					end
				else
					Execute:Client(
						source,
						"Notification",
						"Error",
						"You can only give weapons with this command, try /giveitem"
					)
				end
			else
				Execute:Client(source, "Notification", "Error", "Weapon not located")
			end
		end
	end, {
		help = "Give Weapon",
		params = {
			{
				name = "Weapon Name",
				help = "The name of the Weapon",
			},
			{
				name = "Ammo",
				help = "[Optional] The amount of ammo with the weapon.",
			},
			{
				name = "Is Scratched?",
				help = "Whether to spawn with a normal serial number registered to you, or a scratched serial number (1 = true, 0 = false).",
			},
		},
	}, 3)

	Chat:RegisterAdminCommand("vanityitemnew", function(source, args, rawCommand)
		local label, image, amount, text, action = args[1], args[2], tonumber(args[3]), args[4], args[5]

		local char = Fetch:CharacterSource(source)
		if char and label and image and amount and amount > 0 then
			local t = Sequence:Get("VanityItem")
			local newItem = INVENTORY.ItemTemplate:Create(
				string.format("vanityitem%s", t),
				label,
				text,
				5,
				3,
				0,
				-1,
				25,
				false,
				0,
				{
					imitate = "vanityitem",
					staticMetadata = {
						CustomItemImage = image,
						CustomItemAction = action,
					},
				}
			)

			INVENTORY:AddItem(char:GetData("SID"), newItem.name, amount, {}, 1)
		else
			Execute:Client(source, "Notification", "Error", "Wrong")
		end
	end, {
		help = "Create a Vanity Item",
		params = {
			{
				name = "Label",
				help = "Item Label",
			},
			{
				name = "Image",
				help = "Item Image URL - Imgur",
			},
			{
				name = "Amount",
				help = "Amount to Give",
			},
			{
				name = "Text",
				help = "Tooltip Text",
			},
			{
				name = "Action ID",
				help = "Unique Item ID If We Want to Assign an Action Later",
			},
		},
	}, 5)

	Chat:RegisterAdminCommand("vanityitem", function(source, args, rawCommand)
		local label, image, amount, text, action = args[1], args[2], tonumber(args[3]), args[4], args[5]
		local char = Fetch:CharacterSource(source)

		if char and label and image and amount and amount > 0 then
			INVENTORY:AddItem(char:GetData("SID"), "vanityitem", amount, {
				CustomItemLabel = label,
				CustomItemImage = image,
				CustomItemText = text or "",
				CustomItemAction = action,
			}, 1)
		else
			Execute:Client(source, "Notification", "Error", "Wrong")
		end
	end, {
		help = "Create a Vanity Item",
		params = {
			{
				name = "Label",
				help = "Item Label",
			},
			{
				name = "Image",
				help = "Item Image URL - Imgur",
			},
			{
				name = "Amount",
				help = "Amount to Give",
			},
			{
				name = "Text",
				help = "Tooltip Text",
			},
			{
				name = "Action ID",
				help = "Unique Item ID If We Want to Assign an Action Later",
			},
		},
	}, -1)

	Chat:RegisterAdminCommand("addpshop", function(source, args, rawCommand)
		local coords = GetEntityCoords(GetPlayerPed(source))
		local h = GetEntityHeading(GetPlayerPed(source))

		INVENTORY.PlayerShops.Basic:Create(args[4], {
			x = coords.x,
			y = coords.y,
			z = coords.z - 0.99,
			h = h,
		}, args[2], tonumber(args[1]), tonumber(args[3]), args[5] ~= "0" and args[5] or nil)
		Execute:Client(source, "Notification", "Success", "Shop Created")
	end, {
		help = "Add New Player Shop",
		params = {
			{
				name = "Owner State ID",
				help = "State ID of shop owner",
			},
			{
				name = "Ped Model",
				help = "Model name of ped to use, 0 to use default",
			},
			{
				name = "Owner Bank Account",
				help = "Bank Account Number To Deposite Money From Sales Into",
			},
			{
				name = "Name",
				help = "Name of shop",
			},
			{
				name = "Job",
				help = "Job ID to link to, 0 to disable",
			},
		},
	}, 5)

	Chat:RegisterAdminCommand("delpshop", function(source, args, rawCommand)
		INVENTORY.PlayerShops.Basic:Delete(tonumber(args[1]))
		Execute:Client(source, "Notification", "Success", "Shop Deleted")
	end, {
		help = "Delete Player Shop",
		params = {
			{
				name = "Shop ID",
				help = "ID of the Player Shop to delete",
			},
		},
	}, 1)

	Chat:RegisterAdminCommand("reloaddbitems", function(source, args, rawCommand)
		LoadItemsFromDb()
		Execute:Client(source, "Notification", "Success", "Items Reloaded & Sent To Clients")
	end, {
		help = "Force reload item defintions from database",
	}, 0)

	Chat:RegisterCommand("reloaditems", function(source, args, rawCommand)
		TriggerClientEvent("Inventory:Client:ReloadItems", source)
	end, {
		help = "Attempts To Force Reload Inventory Items",
	}, 0)
end
