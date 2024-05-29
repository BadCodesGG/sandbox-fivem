local _lsuReps = { Racing = true, Chopping = true, Boosting = true }
local _chopRep = { Chopping = true }
local _boostingReps = { Boosting = true }

local _pendingMarketPickups = {}

LAPTOP.LSUnderground = LAPTOP.LSUnderground or {}

local _timeDelay = os.time() + (60 * math.random(30, 90))

local marketItems = {
	{ item = "racing_crappy", coin = "VRM", price = 3, vpn = false, qty = 50 },
	{ item = "racedongle", coin = "VRM", rep = "Racing", repLvl = 2, price = 20, vpn = false, qty = -1 },
	{ item = "harness", coin = "VRM", rep = "Racing", repLvl = 1, price = 20, vpn = false, qty = -1 },
	{ item = "purgecontroller", coin = "VRM", rep = "Racing", repLvl = 3, price = 50, vpn = true, qty = 5 },

	{ item = "choplist", coin = "VRM", rep = "Chopping", repLvl = 3, price = 25, vpn = true, qty = 25 },
	{ item = "choplist", coin = "MALD", rep = "Chopping", repLvl = 3, price = 50, qty = 100, vpn = true },

	{ item = "boosting_tracking_disabler", coin = "VRM", price = 50, vpn = true, qty = 20 },

	{ item = "fakeplates", coin = "VRM", rep = "Racing", repLvl = 1, price = 20, vpn = true, qty = -1 },
	{ item = "fakeplates", coin = "MALD", price = 50, qty = 5, vpn = true },

	{ item = "nitrous", coin = "VRM", price = 10, vpn = true, qty = -1 },
	{ item = "nitrous", coin = "MALD", price = 40, qty = 10, vpn = true },

	{ item = "alias_changer", coin = "VRM", rep = "Racing", repLvl = 5, price = 2000, qty = 2, vpn = true },
}
local _defMarket = table.copy(marketItems)

local _blacklistedJobs = {
	police = true,
	ems = true,
	government = true,
	prison = true,
}

local locations = {
	{
		coords = vector3(-297.634, -2598.951, 5.196),
		heading = 53.894,
	},
	{
		coords = vector3(-316.383, -1389.651, 31.198),
		heading = 186.513,
	},
	{
		coords = vector3(1743.389, -1488.965, 112.947),
		heading = 250.019,
	},
	{
		coords = vector3(-830.093, -1255.552, 5.584),
		heading = 153.285,
	},
}

AddEventHandler("Laptop:Server:RegisterCallbacks", function()
	Citizen.CreateThread(function()
		local wait = 60 * math.random(120, 240)
		while true do
			Citizen.Wait(wait * 1000)
			marketItems = table.copy(_defMarket)
			Logger:Info("Laptop - LSU", "Market Place Items Restocked")
		end
	end)

	GlobalState.LSUPickupLocation = locations[math.random(#locations)]

	Callbacks:RegisterServerCallback("Laptop:LSUnderground:GetDetails", function(source, data, cb)
		local char = Fetch:CharacterSource(source)
		if char ~= nil then
			local chopLevel = Reputation:GetLevel(source, "Chopping")
			local chops = nil
			if chopLevel >= 3 or hasValue(char:GetData("States") or {}, "ACCESS_CHOPPER") then
				chops = {
					Public = _publicChoplist,
				}

				if chopLevel >= 5 then
					chops["Private"] = _vipChopList
				end

				if not data.phone then
					for k, v in pairs(char:GetData("ChopLists") or {}) do
						chops[string.format("Chop List #%s", k)] = {
							id = k,
							list = v,
						}
					end
				end
			end

			local items = {}
			if not data.phone then
				local hasVpn = hasValue(char:GetData("States"), "PHONE_VPN")
				for k, it in ipairs(marketItems) do
					local v = table.copy(it)
					if
						(v.rep == nil or Reputation:GetLevel(source, v.rep) >= (v.repLvl or 1))
						and (not v.vpn or hasVpn)
						and (
							not v.requireCurrency
							or v.requireCurrency and v.coin ~= nil and Crypto:Has(source, v.coin, v.price)
						)
					then
						if _timeDelay > os.time() then
							v.qty = 0
							v.delayed = true
						end
						v.id = k
						v.itemData = Inventory.Items:GetData(v.item)
						table.insert(items, v)
					end
				end
			end

			local canBoost = false
			local requiredRepLevel = Reputation:GetLevel(source, _boostingRequiredRep.rep)
			if requiredRepLevel and requiredRepLevel >= _boostingRequiredRep.level then
				canBoost = true
			end

			cb({
				chopList = chops,
				reputations = Reputation:ViewList(source, not data.phone and _lsuReps or _chopRep),
				items = items,
				banned = char:GetData("LSUNDGBan"),
				canBoost = canBoost,
			})
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("Laptop:LSUnderground:Market:Checkout", function(source, data, cb)
		local char = Fetch:CharacterSource(source)
		if char ~= nil and data and #data > 0 then
			if os.time() > _timeDelay then
				local requiredCoins = {}

				for k, v in ipairs(data) do
					local wantedItem = marketItems[v.id]

					if wantedItem then
						if not requiredCoins[wantedItem.coin] then
							requiredCoins[wantedItem.coin] = 0
						end

						requiredCoins[wantedItem.coin] += (wantedItem.price * v.quantity)
					end
				end

				local failed = false

				for k, v in ipairs(requiredCoins) do
					if not Crypto:Has(source, k, v) then
						failed = true
					end
				end

				if not failed then
					local quantityLimited = false
					local otherLimited = false
					local hasVpn = hasValue(char:GetData("States"), "PHONE_VPN")

					local boughtItems = {}
					local boughtItemQuantity = 0

					for k, v in ipairs(data) do
						local marketItem = marketItems[v.id]

						if
							(
								marketItem.rep == nil
								or Reputation:GetLevel(source, marketItem.rep) >= (marketItem.repLvl or 1)
							)
							and (not marketItem.vpn or hasVpn)
							and (
								not marketItem.requireCurrency
								or marketItem.requireCurrency and marketItem.coin ~= nil
							)
						then
							if v.qty == -1 or v.qty >= v.quantity then
								if
									Crypto.Exchange:Remove(
										marketItem.coin,
										char:GetData("CryptoWallet"),
										math.floor(marketItem.price * v.quantity)
									)
								then
									table.insert(boughtItems, {
										item = marketItem.item,
										quantity = v.quantity,
									})

									boughtItemQuantity += v.quantity

									marketItems[v.id].qty = marketItems[v.id].qty - v.quantity
								else
									otherLimited = true
								end
							else
								quantityLimited = true
							end
						else
							otherLimited = true
						end
					end

					local extra = ""

					if quantityLimited then
						extra = "Some of Your Items Weren't Delivered Due to Them Going Out of Stock"
					elseif otherLimited then
						extra = "Some of Your Items Weren't Delivered Due Processing Error"
					end

					Laptop.Notification:Add(
						source,
						"Your Order",
						string.format(
							"%s Item(s) Are Waiting for You at Today's Pickup Location. %s",
							boughtItemQuantity,
							extra
						),
						os.time() * 1000,
						25000,
						"lsunderground",
						{},
						{}
					)

					if not _pendingMarketPickups[char:GetData("SID")] then
						_pendingMarketPickups[char:GetData("SID")] = { boughtItems }
					else
						table.insert(_pendingMarketPickups[char:GetData("SID")], boughtItems)
					end

					cb({
						success = true,
						coords = GlobalState.LSUPickupLocation.coords,
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
	end)

	Callbacks:RegisterServerCallback("Laptop:LSUnderground:Market:Collect", function(source, data, cb)
		local char = Fetch:CharacterSource(source)
		if char ~= nil then
			local pendingPickup = _pendingMarketPickups[char:GetData("SID")]
			if pendingPickup then
				for _, list in ipairs(pendingPickup) do
					Citizen.Wait(1)
					for k, v in ipairs(list) do
						Citizen.Wait(1)
						Inventory:AddItem(char:GetData("SID"), v.item, v.quantity, {}, 1)
					end
				end

				_pendingMarketPickups[char:GetData("SID")] = nil
				Laptop.Notification:Add(
					source,
					"Your Order",
					"Thanks for collecting your order.",
					os.time() * 1000,
					10000,
					"lsunderground",
					{},
					{}
				)
			else
				Execute:Client(source, "Notification", "Error", "fack off, not got nufink' for u m8")
			end

			cb(true)
		else
			cb(false)
		end
	end)

	Inventory.Items:RegisterUse("lsundg_invite", "LSUNDG", function(source, item, itemData)
		local char = Fetch:CharacterSource(source)
		local pState = Player(source).state
		if char ~= nil then
			if not pState.onDuty or not _blacklistedJobs[pState.onDuty] then
				if not hasValue(char:GetData("States") or {}, "ACCESS_LSUNDERGROUND") then
					if Inventory.Items:RemoveSlot(item.Owner, item.Name, 1, item.Slot, 1) then
						local states = char:GetData("States") or {}
						table.insert(states, "ACCESS_LSUNDERGROUND")
						char:SetData("States", states)

						if item.MetaData.Inviter ~= nil then
							char:SetData("LSUNDGInviter", item.MetaData.Inviter)
						end

						-- TODO
						--char:SetData("Apps", Laptop.Store.Install:Do("lsunderground", char:GetData("Apps"), "force"))

						Phone.Email:Send(
							source,
							"shadow@ls.undg",
							os.time(),
							"Welcome To LS Underground",
							string.format(
								[[
								Hello %s<br /><br />
								Welcome to the future of the Los Santos racing scene. Someone you know closely has entrusted you enough to vouch for you and provide you an exclusive invite to be part of our mission.<br /><br/>
								Our goal is to build a scene that is comprised of individuals who respect each other and are there to race, and nothing more. We're here to be the enforcers for those who choose to disobey this very basic goal, and reward those who participate cleanly and in good faith.<br /><br />
								A key part of this will also be to deal with Los Santos' "greatest", and ensure they know there are lines that should not be crossed or else dire consequences will come.<br /><br />
								This should be rather apparent, but it will be said regardless, being part of this group must be kept a complete secret from everyone you know. At all times you should operate as if you're being listened in on.
								Our mission relies on remaining in the shadows until the time is right. This mission is bigger than you, if you jeopardize us, you will be eliminated. We are always watching.<br /><br />
								You will be contacted soon, in the meantime check the new program on your laptop.<br />
								- Shadow
							]],
								char:GetData("First")
							)
						)

						Citizen.SetTimeout(5000, function()
							Laptop.Notification:Add(
								source,
								"Program Installed",
								nil,
								os.time() * 1000,
								6000,
								"lsunderground",
								{
									view = "",
								},
								nil
							)
						end)
					end
				else
					Execute:Client(source, "Notification", "Error", "Already A Member Of LS Underground")
				end
			else
				Execute:Client(source, "Notification", "Error", "You Can't Use This Item")
			end
		end
	end)
end)

LAPTOP.LSU = {}
