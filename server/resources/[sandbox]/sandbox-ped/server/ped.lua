local TemplateData = {
	model = "",
	customization = {
		face = {
			face1 = {
				index = 0,
				texture = 0,
				mix = 50.0,
			},
			face2 = {
				index = 0,
				texture = 0,
				mix = 50.0,
			},
			face3 = {
				index = 0,
				texture = 0,
				mix = 100.0,
			},
			features = {
				0,
				0,
				0,
				0,
				0,
				0,
				0,
				0,
				0,
				0,
				0,
				0,
				0,
				0,
				0,
				0,
				0,
				0,
				0,
				0,
			},
		},
		eyeColor = 0,
		overlay = {
			blemish = {
				id = 0,
				index = 0,
				opacity = 100.0,
				disabled = true,
			},
			facialhair = {
				id = 1,
				index = 0,
				opacity = 100.0,
				disabled = true,
			},
			eyebrows = {
				id = 2,
				index = 0,
				opacity = 100.0,
				disabled = true,
			},
			ageing = {
				id = 3,
				index = 0,
				opacity = 100.0,
				disabled = true,
			},
			makeup = {
				id = 4,
				index = 0,
				opacity = 100.0,
				disabled = true,
			},
			blush = {
				id = 5,
				index = 0,
				opacity = 100.0,
				disabled = true,
			},
			complexion = {
				id = 6,
				index = 0,
				opacity = 100.0,
				disabled = true,
			},
			sundamage = {
				id = 7,
				index = 0,
				opacity = 100.0,
				disabled = true,
			},
			lipstick = {
				id = 8,
				index = 0,
				opacity = 100.0,
				disabled = true,
			},
			freckles = {
				id = 9,
				index = 0,
				opacity = 100.0,
				disabled = true,
			},
			chesthair = {
				id = 10,
				index = 0,
				opacity = 100.0,
				disabled = true,
			},
			bodyblemish = {
				id = 11,
				index = 0,
				opacity = 100.0,
				disabled = true,
			},
			addbodyblemish = {
				id = 12,
				index = 0,
				opacity = 100.0,
				disabled = true,
			},
		},
		colors = {
			hair = {
				color1 = {
					index = 0,
					rgb = "rgb(0, 0, 0)",
				},
				color2 = {
					index = 0,
					rgb = "rgb(0, 0, 0)",
				},
			},
			facialhair = {
				color1 = {
					index = 0,
					rgb = "rgb(0, 0, 0)",
				},
				color2 = {
					index = 0,
					rgb = "rgb(0, 0, 0)",
				},
			},
			eyebrows = {
				color1 = {
					index = 0,
					rgb = "rgb(0, 0, 0)",
				},
				color2 = {
					index = 0,
					rgb = "rgb(0, 0, 0)",
				},
			},
			chesthair = {
				color1 = {
					index = 0,
					rgb = "rgb(0, 0, 0)",
				},
				color2 = {
					index = 0,
					rgb = "rgb(0, 0, 0)",
				},
			},
		},
		components = {
			face = {
				componentId = 0,
				drawableId = 0,
				textureId = 0,
				paletteId = 0,
			},
			mask = {
				componentId = 1,
				drawableId = 0,
				textureId = 0,
				paletteId = 0,
			},
			hair = {
				componentId = 2,
				drawableId = 0,
				textureId = 0,
				paletteId = 0,
			},
			torso = {
				componentId = 3,
				drawableId = 0,
				textureId = 0,
				paletteId = 0,
			},
			leg = {
				componentId = 4,
				drawableId = 0,
				textureId = 0,
				paletteId = 0,
			},
			bag = {
				componentId = 5,
				drawableId = 0,
				textureId = 0,
				paletteId = 0,
			},
			shoes = {
				componentId = 6,
				drawableId = 0,
				textureId = 0,
				paletteId = 0,
			},
			accessory = {
				componentId = 7,
				drawableId = 0,
				textureId = 0,
				paletteId = 0,
			},
			undershirt = {
				componentId = 8,
				drawableId = 0,
				textureId = 0,
				paletteId = 0,
			},
			kevlar = {
				componentId = 9,
				drawableId = 0,
				textureId = 0,
				paletteId = 0,
			},
			badge = {
				componentId = 10,
				drawableId = 0,
				textureId = 0,
				paletteId = 0,
			},
			torso2 = {
				componentId = 11,
				drawableId = 0,
				textureId = 0,
				paletteId = 0,
			},
		},
		props = {
			hat = {
				componentId = 0,
				drawableId = 0,
				textureId = 0,
				disabled = true,
			},
			glass = {
				componentId = 1,
				drawableId = 0,
				textureId = 0,
				disabled = true,
			},
			ear = {
				componentId = 2,
				drawableId = 0,
				textureId = 0,
				disabled = true,
			},
			watch = {
				componentId = 6,
				drawableId = 0,
				textureId = 0,
				disabled = true,
			},
			bracelet = {
				componentId = 7,
				drawableId = 0,
				textureId = 0,
				disabled = true,
			},
		},
		tattoos = {},
	},
}

GlobalState["Ped:Pricing"] = {
	CREATOR = 0,
	BARBER = 100,
	SHOP = 100,
	TATTOO = 100,
	SURGERY = 2500,
}

AddEventHandler("Ped:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Fetch = exports["sandbox-base"]:FetchComponent("Fetch")
	Callbacks = exports["sandbox-base"]:FetchComponent("Callbacks")
	Database = exports["sandbox-base"]:FetchComponent("Database")
	Locations = exports["sandbox-base"]:FetchComponent("Locations")
	Routing = exports["sandbox-base"]:FetchComponent("Routing")
	Logger = exports["sandbox-base"]:FetchComponent("Logger")
	Ped = exports["sandbox-base"]:FetchComponent("Ped")
	Inventory = exports["sandbox-base"]:FetchComponent("Inventory")
	Chat = exports["sandbox-base"]:FetchComponent("Chat")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["sandbox-base"]:RequestDependencies("Ped", {
		"Fetch",
		"Callbacks",
		"Database",
		"Locations",
		"Routing",
		"Logger",
		"Ped",
		"Inventory",
		"Chat",
	}, function(error)
		if #error > 0 then
			return
		end -- Do something to handle if not all dependencies loaded
		RetrieveComponents()
		RegisterCallbacks()
		RegisterItemUses()

		GlobalState["GangChains"] = _gangChains
		GlobalState["ClothingStoreHidden"] = _hideFromStore

		Chat:RegisterCommand("m0", function(source, args, rawCommand)
			local char = Fetch:CharacterSource(source)
			if char ~= nil then
				local ped = char:GetData("Ped")
				if ped.customization.components.mask.drawableId ~= 0 then
					TriggerClientEvent("Ped:Client:MaskAnim", source)
					Citizen.Wait(300)
					Ped.Mask:Unequip(source)
				end
			end
		end, {
			help = "Remove Mask",
		})

		Chat:RegisterCommand("h0", function(source, args, rawCommand)
			local char = Fetch:CharacterSource(source)
			if char ~= nil then
				local ped = char:GetData("Ped")
				if not ped.customization.props.hat.disabled then
					TriggerClientEvent("Ped:Client:HatGlassAnim", source)
					Citizen.Wait(300)
					Ped.Hat:Unequip(source)
				end
			end
		end, {
			help = "Remove Hat",
		})

		Chat:RegisterCommand("h1", function(source, args, rawCommand)
			local char = Fetch:CharacterSource(source)
			if char ~= nil then
				local ped = char:GetData("Ped")
				if not ped.customization.props.hat.disabled then
					TriggerClientEvent("Ped:Client:HatGlassAnim", source)
					Citizen.Wait(300)
					TriggerClientEvent("Ped:Client:Hat", source)
				end
			end
		end, {
			help = "Re-equip Hat If You Had One",
		})

		Chat:RegisterCommand("g1", function(source, args, rawCommand)
			local char = Fetch:CharacterSource(source)
			if char ~= nil then
				local ped = char:GetData("Ped")
				if not ped.customization.props.glass.disabled then
					TriggerClientEvent("Ped:Client:HatGlassAnim", source)
					Citizen.Wait(300)
					TriggerClientEvent("Ped:Client:Glasses", source)
				end
			end
		end, {
			help = "Re-equip Glasses If You Had One",
		})

		Chat:RegisterCommand("g0", function(source, args, rawCommand)
			local char = Fetch:CharacterSource(source)
			if char ~= nil then
				TriggerClientEvent("Ped:Client:RemoveGlasses", source)
			end
		end, {
			help = "Remove Glasses",
		})

		Chat:RegisterAdminCommand("pedwhitelist", function(source, args, rawCommand)
			local sid, model, label = tonumber(args[1]), args[2], args[3]
			if sid and model and label then
				Database.Game:findOne({
					collection = "characters",
					query = {
						SID = sid,
					},
					options = {
						projection = {
							SID = 1,
						}
					}
				}, function(success, results)
					if success and #results > 0 then
						MySQL.insert.await("INSERT INTO whitelisted_peds (sid, model, label) VALUES (?, ?, ?)", {
							sid,
							model,
							label
						})

						Chat.Send.System:Single(source, string.format("Added Whitelisted Ped to State ID %s", sid))
					else
						Chat.Send.System:Single(source, "Invalid State ID")
					end
				end)
			else
				Chat.Send.System:Single(source, "Invalid Arguments")
			end
		end, {
			help = "Add Whitelisted Ped to Character",
			params = {
                {
                    name = "SID",
                    help = "Character State ID",
                },
                {
                    name = "Model",
                    help = "Ped Model e.g. mp_m_freemode_01",
                },
				{
                    name = "Label",
                    help = "Ped Name",
                },
            },
		}, 3)

		Chat:RegisterAdminCommand("pedwhitelistview", function(source, args, rawCommand)
			local sid = tonumber(args[1])
			if sid then
				local res = MySQL.query.await("SELECT model, label FROM whitelisted_peds WHERE sid = ?", {
					sid
				})

				local message = "Whitelisted Peds<br>"
				for k,v in ipairs(res) do
					message = message .. string.format("Model: %s | Label: %s", v.model, v.label)
				end
				Chat.Send.System:Single(source, message)
			else
				Chat.Send.System:Single(source, "Invalid Arguments")
			end
		end, {
			help = "View Whitelisted Peds for Character",
			params = {
                {
                    name = "SID",
                    help = "Character State ID",
                },
            },
		}, 1)

		Chat:RegisterAdminCommand("pedwhitelistremove", function(source, args, rawCommand)
			local sid, model = tonumber(args[1]), args[2]
			if sid and model then
				local d = MySQL.query.await("DELETE FROM whitelisted_peds WHERE SID = ? AND model = ?", {
					sid,
					model,
				})

				if d.affectedRows > 0 then
					Chat.Send.System:Single(source, "Deleted Ped")
				else
					Chat.Send.System:Single(source, "Failed to Delete")
				end
			else
				Chat.Send.System:Single(source, "Invalid Arguments")
			end
		end, {
			help = "Remove Whitelisted Ped from Character",
			params = {
                {
                    name = "SID",
                    help = "Character State ID",
                },
                {
                    name = "Model",
                    help = "Ped Model e.g. mp_m_freemode_01",
                },
            },
		}, 2)
	end)
end)

PED = {
	Save = function(self, char, ped)
		local p = promise.new()

		-- On the Verge of Suicide (WHY??? Apparently it won't update in mongodb unless this is done) 
		if ped?.customization?.face?.features and type(ped.customization.face.features) == "table" then
			for k, v in pairs(ped.customization.face.features) do
				ped.customization.face.features[tostring(k)] = v
			end
		end

		Database.Game:updateOne({
			collection = "peds",
			query = {
				Char = char:GetData("ID"),
			},
			update = {
				["$set"] = {
					Ped = ped,
				},
			},
			options = {
				upsert = true,
			},
		}, function(success, results)
			if not success then
				return
			end
			char:SetData("Ped", ped)

			p:resolve(success)
		end)

		return Citizen.Await(p)
	end,
	ApplyOutfit = function(self, source, outfit)
		local char = Fetch:CharacterSource(source)
		if char ~= nil then
			local ped = char:GetData("Ped")
			ped.customization.components = outfit.data.components or ped.customization.components
			ped.customization.props = outfit.data.props or ped.customization.props
			ped.customization.colors = outfit.data.colors or ped.customization.colors
			ped.customization.overlay = outfit.data.overlay or ped.customization.overlay
			Ped:Save(char, ped)
		end
	end,
	Mask = {
		Equip = function(self, source, data)
			local char = Fetch:CharacterSource(source)
			if char ~= nil then
				local ped = char:GetData("Ped")
				ped.customization.components.mask = data
				Ped:Save(char, ped)
			end
		end,
		Unequip = function(self, source)
			local char = Fetch:CharacterSource(source)
			if char ~= nil then
				local ped = char:GetData("Ped")

				local itemId = Inventory.Items:GetWithStaticMetadata(
					"mask",
					"drawableId",
					"textureId",
					char:GetData("Gender"),
					ped.customization.components.mask
				) or "mask"

				local md = { mask = ped.customization.components.mask }
				if itemId ~= "mask" then
					md = {}
				end

				if Inventory:AddItem(char:GetData("SID"), itemId, 1, md, 1) then
					ped.customization.components.mask = {
						componentId = 1,
						drawableId = 0,
						textureId = 0,
						paletteId = 0,
					}
					Ped:Save(char, ped)
				end
			end
		end,
		UnequipNoItem = function(self, source)
			local char = Fetch:CharacterSource(source)
			if char ~= nil then
				local ped = char:GetData("Ped")
				if ped.customization.components.mask.drawableId ~= 0 then
					TriggerClientEvent("Ped:Client:MaskAnim", source)
					ped.customization.components.mask = {
						componentId = 1,
						drawableId = 0,
						textureId = 0,
						paletteId = 0,
					}
					Ped:Save(char, ped)
				end
			end
		end,
	},
	Hat = {
		Equip = function(self, source, data)
			local char = Fetch:CharacterSource(source)
			if char ~= nil then
				local ped = char:GetData("Ped")
				ped.customization.props.hat = data
				Ped:Save(char, ped)
			end
		end,
		Unequip = function(self, source)
			local char = Fetch:CharacterSource(source)
			if char ~= nil then
				local ped = char:GetData("Ped")

				local itemId = Inventory.Items:GetWithStaticMetadata(
					"hat",
					"drawableId",
					"textureId",
					char:GetData("Gender"),
					ped.customization.props.hat
				) or "hat"

				local md = { hat = ped.customization.props.hat }
				if itemId ~= "hat" then
					md = {}
				end

				if Inventory:AddItem(char:GetData("SID"), itemId, 1, md, 1) then
					ped.customization.props.hat = {
						componentId = 0,
						drawableId = 0,
						textureId = 0,
						disabled = true,
					}
					Ped:Save(char, ped)
				end
			end
		end,
	},
	Necklace = {
		Equip = function(self, source, data)
			local char = Fetch:CharacterSource(source)
			if char ~= nil then
				local ped = char:GetData("Ped")
				ped.customization.components.accessory = data
				Ped:Save(char, ped)
			end
		end,
		Unequip = function(self, source)
			local char = Fetch:CharacterSource(source)
			if char ~= nil then
				local ped = char:GetData("Ped")
				local itemId = Inventory.Items:GetWithStaticMetadata(
					"accessory",
					"drawableId",
					"textureId",
					char:GetData("Gender"),
					ped.customization.components.accessory
				) or "accessory"
				
				if itemId ~= "accessory" then
					if Inventory:AddItem(char:GetData("SID"), itemId, 1, {}, 1) then
						ped.customization.components.accessory = {
							componentId = 7,
							drawableId = 0,
							textureId = 0,
							paletteId = 0,
						}
						Ped:Save(char, ped)
					end
				end
			end
		end,
		UnequipNoItem = function(self, source)
			local char = Fetch:CharacterSource(source)
			if char ~= nil then
				local ped = char:GetData("Ped")
				if ped.customization.components.mask.drawableId ~= 0 then
					TriggerClientEvent("Ped:Client:MaskAnim", source)
					ped.customization.components.mask = {
						componentId = 1,
						drawableId = 0,
						textureId = 0,
						paletteId = 0,
					}
					Ped:Save(char, ped)
				end
			end
		end,
	},
}
AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["sandbox-base"]:RegisterComponent("Ped", PED)
end)

function deepcopy(orig)
	local orig_type = type(orig)
	local copy
	if orig_type == "table" then
		copy = {}
		for orig_key, orig_value in next, orig, nil do
			copy[deepcopy(orig_key)] = deepcopy(orig_value)
		end
		setmetatable(copy, deepcopy(getmetatable(orig)))
	else -- number, string, boolean, etc
		copy = orig
	end
	return copy
end

function RegisterCallbacks()
	Callbacks:RegisterServerCallback("Ped:CheckPed", function(source, data, cb)
		local char = Fetch:CharacterSource(source)
		if char then
			Database.Game:findOne({
				collection = "peds",
				query = {
					Char = char:GetData("ID"),
				},
			}, function(success, results)
				if not success then
					return
				end
				if #results == 0 then
					local tmp = deepcopy(TemplateData)
	
					if char:GetData("Gender") == 0 then
						tmp.model = "mp_m_freemode_01"
					else
						tmp.model = "mp_f_freemode_01"
					end
	
					char:SetData("Ped", tmp)
					cb({
						existed = false,
						ped = tmp,
					})
				else
					local tmp = results[1].Ped
					if tmp.model == "" then
						if char:GetData("Gender") == 0 then
							tmp.model = "mp_m_freemode_01"
						else
							tmp.model = "mp_f_freemode_01"
						end
					end
	
					char:SetData("Ped", tmp)
					cb({
						existed = true,
						ped = tmp,
					})
				end
			end)
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("Ped:MakePayment", function(source, data, cb)
		local char = Fetch:CharacterSource(source)
		local pricing = GlobalState["Ped:Pricing"][data.type]
		if pricing == 0 or char:GetData("Cash") >= pricing then
			char:SetData("Cash", char:GetData("Cash") - pricing)
			cb(true, pricing)
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("Ped:SavePed", function(source, data, cb)
		local char = Fetch:CharacterSource(source)
		cb(Ped:Save(char, data.ped))
	end)

	Callbacks:RegisterServerCallback("Ped:RemoveMask", function(source, data, cb)
		local char = Fetch:CharacterSource(source)
		if char ~= nil then
			local ped = char:GetData("Ped")
			if ped.customization.components.mask.drawableId ~= 0 then
				TriggerClientEvent("Ped:Client:MaskAnim", source)
				Citizen.Wait(500)
				Ped.Mask:Unequip(source)
			end
		end
	end)

	Callbacks:RegisterServerCallback("Ped:RemoveHat", function(source, data, cb)
		local char = Fetch:CharacterSource(source)
		if char ~= nil then
			local ped = char:GetData("Ped")
			if not ped.customization.props.hat.disabled then
				TriggerClientEvent("Ped:Client:HatGlassAnim", source)
				Citizen.Wait(500)
				Ped.Hat:Unequip(source)
			end
		end
	end)

	Callbacks:RegisterServerCallback("Ped:RemoveAccessory", function(source, data, cb)
		local char = Fetch:CharacterSource(source)
		if char ~= nil then
			local ped = char:GetData("Ped")
			if ped.customization.components.accessory.drawableId ~= 0 then
				TriggerClientEvent("Ped:Client:HatGlassAnim", source)
				Citizen.Wait(500)
				Ped.Necklace:Unequip(source)
			end
		end
	end)

	Callbacks:RegisterServerCallback("Ped:GetWhitelistedPeds", function(source, data, cb)
		local char = Fetch:CharacterSource(source)
		if char ~= nil then
			local res = MySQL.query.await("SELECT model, label FROM whitelisted_peds WHERE SID = ?", {
				char:GetData("SID")
			})

			cb(res)
		else
			cb({})
		end
	end)
end
