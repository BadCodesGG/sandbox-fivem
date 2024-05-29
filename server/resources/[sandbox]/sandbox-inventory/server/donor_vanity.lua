function RegisterDonorVanityItemsCallbacks()
	Callbacks:RegisterServerCallback("Inventory:DonorSales:GetPending", function(source, data, cb)
		local plyr = Fetch:Source(source)
		if plyr then
			local pending = Inventory.Donator:GetPending(plyr:GetData("Identifier"), true)
			local mainMenuItems = {}
			for k, v in ipairs(pending) do
				if not v.redeemed then
					table.insert(mainMenuItems, {
						label = string.format("%sx Vanity Item", 1),
						description = string.format("UID: %s", v.id),
						disabled = v.redeemed,
					})
				end
			end

			for k, v in ipairs(pending) do
				if v.redeemed then
					table.insert(mainMenuItems, {
						label = string.format("%sx Vanity Item", 1),
						description = string.format("UID: %s", v.id),
						disabled = v.redeemed,
					})
				end
			end

			cb({
				main = {
					label = "Unredeemed Vanity Item Purchases",
					items = mainMenuItems,
				},
			})
			return
		end

		cb(false)
	end)
	Callbacks:RegisterServerCallback("Inventory:DonorSales:SubmitVanityItem", function(source, data, cb)
		local plyr = Fetch:Source(source)
		if plyr then
			local char = Fetch:CharacterSource(source)
			
			local label = data.vanity_item_label
			local description = data.vanity_item_description
			local image = data.vanity_item_image
			local amount = tonumber(data.vanity_item_amount)
			local action = data.vanity_item_action or ""

			if label and description and image and amount and amount > 0 then
				local sid = char:GetData("SID")
				local pending = Inventory.Donator:GetPending(plyr:GetData("Identifier"), true)
				if #pending > 0 then
					local foundToken = nil
					for k, v in ipairs(pending) do
						if not v.redeemed then
							foundToken = v.id
							break
						end
					end

					if Inventory.Donator:RemovePending(plyr:GetData("Identifier"), foundToken) then
						local t = Sequence:Get("VanityItem")

						local newItem = Inventory.ItemTemplate:Create(
							string.format("vanityitem%s", t),
							label,
							description or "",
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

						MySQL.insert("INSERT INTO donor_created_item (sid, item_id) VALUES(?, ?)", {
							sid,
							newItem.name,
						})

						itemsDatabase[newItem.name].isUsable = true

						INVENTORY:AddItem(sid, newItem.name, amount, {}, 1)

						Execute:Client(source, "Notification", "Success", "Found unused vanity token!")
					else
						Execute:Client(source, "Notification", "Error", "Uh this shouldn't happen.")
					end
				else
					Execute:Client(source, "Notification", "Error", "No vanity tokens found.")
				end
			else
				Execute:Client(
					source,
					"Notification",
					"Error",
					"Something went wrong. Try again and make sure all fields are filled out properly!"
				)
			end

			cb(true)
			return
		end

		cb(false)
	end)
	Callbacks:RegisterServerCallback("Inventory:DonorSales:GetTokens", function(source, data, cb)
		local plyr = Fetch:Source(source)
		if plyr then
			local res = Inventory.Donator:GetPending(plyr:GetData("Identifier"))
			cb({ available = #res or 0 })
		else
			cb(false)
		end
	end)

	Chat:RegisterAdminCommand("adddonatoritem", function(source, args, rawCommand)
		local license = table.unpack(args)

		if license then
			local success = Inventory.Donator:AddPending(license)
			if success then
				Chat.Send.System:Single(source, "Successfully added donator vanity item token")
			else
				Chat.Send.System:Single(source, "Failed to add donator vanity item token")
			end
		end
	end, {
		help = "[Admin] Add a players donator item",
		params = {
			{
				name = "Player Identifier",
				help = "Player License",
			},
		},
	}, 1)

	Chat:RegisterAdminCommand("getdonatoritem", function(source, args, rawCommand)
		local license = table.unpack(args)

		if license then
			local res = Inventory.Donator:GetPending(license, true)
			if res then
				local message = string.format("Player Identifier: %s<br>", license)
				for k, v in ipairs(res) do
					message = message
						.. string.format("<br>ID: %s<br>Redeemed: %s<br>", v.id, v.redeemed and "Yes" or "No")
				end
				Chat.Send.System:Single(source, message)
			else
				Chat.Send.System:Single(source, "Failed")
			end
		end
	end, {
		help = "[Admin] Check donator vanity items",
		params = {
			{
				name = "Player Identifier",
				help = "Player License",
			},
		},
	}, 1)

	Chat:RegisterAdminCommand("removedonatoritem", function(source, args, rawCommand)
		local license, tokenId = table.unpack(args)
		if license and tokenId then
			local success = Inventory.Donator:DeletePending(license, tokenId)
			if success then
				Chat.Send.System:Single(source, "Successfully Removed Token")
			else
				Chat.Send.System:Single(source, "Failed to remove token")
			end
		end
	end, {
		help = "[Admin] Remove donator item",
		params = {
			{
				name = "Player Identifier",
				help = "Player License",
			},
			{
				name = "ID",
				help = "Donator Vanity Item Pending Token",
			},
		},
	}, 2)

	Inventory.Donator = {
		AddPending = function(self, playerIdentifier, itemName, itemCount, data)
			MySQL.insert("INSERT INTO donator_items (player, data, redeemed) VALUES(?, ?, ?)", {
				playerIdentifier,
				data and json.encode(data) or nil,
				false,
			})

			return true
		end,
		GetPending = function(self, playerIdentifier, includeRedeemed)
			local results = {}
			if includeRedeemed then
				results = MySQL.query.await("SELECT id, player, redeemed, data FROM donator_items WHERE player = ?", {
					playerIdentifier,
				})
			else
				results = MySQL.query.await(
					"SELECT id, player, redeemed, data FROM donator_items WHERE player = ? and redeemed = ?",
					{
						playerIdentifier,
						false,
					}
				)
			end

			return results
		end,
		RemovePending = function(self, playerIdentifier, id)
			local res = MySQL.query.await("UPDATE donator_items SET redeemed = ? WHERE id = ? AND player = ?", {
				true,
				id,
				playerIdentifier,
			})

			return res.affectedRows > 0
		end,
		DeletePending = function(self, playerIdentifier, id)
			local res = MySQL.query.await("DELETE FROM donator_items WHERE id = ? AND player = ?", {
				id,
				playerIdentifier,
			})

			return res.affectedRows > 0
		end,
	}
end

function TebexAddVanityItem(source, args)
	local sid = table.unpack(args)
	sid = tonumber(sid)
	if sid == nil or sid == 0 then
		Logger:Warn("Donator Vanity Item", "Provided SID (server ID) was empty.", {
			console = true,
			file = false,
			database = true,
			discord = {
				embed = true,
				type = "error",
				webhook = GetConvar("discord_donation_webhook", ""),
			},
		})
		return
	end
	local player = Fetch:Source(sid)
	if player then
		local license = player:GetData("Identifier")
		if license then
			local success = Inventory.Donator:AddPending(license)
			if success then
				Chat.Send.System:Single(sid, "Successfully Added Donator Vanity Item Token")
			else
				Chat.Send.System:Single(sid, "Failed")
			end
		end
	end
end
RegisterCommand("tebexaddvanityitem", TebexAddVanityItem, true)
