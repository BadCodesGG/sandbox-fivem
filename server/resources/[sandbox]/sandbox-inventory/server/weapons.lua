_weaponModels = {}

local weaponCheaters = {
	[`WEAPON_ANIMAL`] = "Animal",
	[`WEAPON_COUGAR`] = "Cougar",
	[`WEAPON_ADVANCEDRIFLE`] = "Advanced Rifle",
	[`WEAPON_APPISTOL`] = "AP Pistol",
	[`WEAPON_ASSAULTRIFLE`] = "Assault Rifle",
	[`WEAPON_ASSAULTRIFLE_MK2`] = "Assault Rifke Mk2",
	[`WEAPON_ASSAULTSHOTGUN`] = "Assault Shotgun",
	[`WEAPON_ASSAULTSMG`] = "Assault SMG",
	[`WEAPON_AUTOSHOTGUN`] = "Automatic Shotgun",
	[`WEAPON_BULLPUPRIFLE`] = "Bullpup Rifle",
	[`WEAPON_BULLPUPRIFLE_MK2`] = "Bullpup Rifle Mk2",
	[`WEAPON_BULLPUPSHOTGUN`] = "Bullpup Shotgun",
	[`WEAPON_CARBINERIFLE`] = "Carbine Rifle",
	[`WEAPON_CARBINERIFLE_MK2`] = "PD .762",
	[`WEAPON_COMBATMG`] = "Combat MG",
	[`WEAPON_COMBATMG_MK2`] = "Combat MG Mk2",
	[`WEAPON_COMBATPDW`] = "Combat PDW",
	[`WEAPON_COMBATPISTOL`] = "Combat Pistol",
	[`WEAPON_COMPACTRIFLE`] = "Compact Rifle",
	[`WEAPON_DBSHOTGUN`] = "Double Barrel Shotgun",
	[`WEAPON_DOUBLEACTION`] = "Double Action Revolver",
	[`WEAPON_FLAREGUN`] = "Flare gun",
	[`WEAPON_GUSENBERG`] = "Gusenberg",
	[`WEAPON_HEAVYPISTOL`] = "Heavy Pistol",
	[`WEAPON_HEAVYSHOTGUN`] = "Heavy Shotgun",
	[`WEAPON_HEAVYSNIPER`] = "Heavy Sniper",
	[`WEAPON_HEAVYSNIPER_MK2`] = "Heavy Sniper",
	[`WEAPON_MACHINEPISTOL`] = "Machine Pistol",
	[`WEAPON_MARKSMANPISTOL`] = "Marksman Pistol",
	[`WEAPON_MARKSMANRIFLE`] = "Marksman Rifle",
	[`WEAPON_MARKSMANRIFLE_MK2`] = "Marksman Rifle Mk2",
	[`WEAPON_GLOCK19`] = "PD F19",
	[`WEAPON_GLOCK19_CIV`] = "F19",
	[`WEAPON_FNX45`] = "SB 45 Tactical",
	[`WEAPON_HK416B`] = ".556 LR",
	[`WEAPON_BEANBAG`] = "PD Beanbag",
	[`WEAPON_TASER`] = "Taser",
	[`WEAPON_MG`] = "MG",
	[`WEAPON_MICROSMG`] = "Micro SMG",
	[`WEAPON_MAC10`] = "MAC 10",
	[`WEAPON_MINIGUN`] = "Minigun",
	[`WEAPON_MINISMG`] = "Mini SMG",
	[`WEAPON_MUSKET`] = "Musket",
	[`WEAPON_PISTOL`] = "Pistol",
	[`WEAPON_PISTOL_MK2`] = "PD 9MM",
	[`WEAPON_PISTOL50`] = "Pistol .50",
	[`WEAPON_PUMPSHOTGUN`] = "Pump Shotgun",
	[`WEAPON_PUMPSHOTGUN_MK2`] = "Pump Shotgun Mk2",
	[`WEAPON_RAILGUN`] = "Railgun",
	[`WEAPON_REVOLVER`] = "Revolver",
	[`WEAPON_REVOLVER_MK2`] = "Revolver Mk2",
	[`WEAPON_SAWNOFFSHOTGUN`] = "Sawnoff Shotgun",
	[`WEAPON_SMG`] = "SMG",
	[`WEAPON_SMG_MK2`] = "SIG MPX",
	[`WEAPON_SNIPERRIFLE`] = "Sniper Rifle",
	[`WEAPON_SNIPERRIFLE2`] = "Hunting Rifle",
	[`WEAPON_SNSPISTOL`] = "SNS Pistol",
	[`WEAPON_SNSPISTOL_MK2`] = "SNS Pistol Mk2",
	[`WEAPON_SPECIALCARBINE`] = "Special Carbine",
	[`WEAPON_SPECIALCARBINE_MK2`] = "Special Carbine Mk2",
	[`WEAPON_STINGER`] = "Stinger",
	[`WEAPON_STUNGUN`] = "Stungun",
	[`WEAPON_VINTAGEPISTOL`] = "Vintage Pistol",
	[`VEHICLE_WEAPON_PLAYER_LASER`] = "Vehicle Lasers",
	[`WEAPON_FIRE`] = "Fire",
	[`WEAPON_FLARE`] = "Flare",
	[`WEAPON_FLAREGUN`] = "Flaregun",
	[`WEAPON_MOLOTOV`] = "Molotov",
	[`WEAPON_PETROLCAN`] = "Petrol Can",
	[`WEAPON_HELI_CRASH`] = "Helicopter Crash",
	[`WEAPON_RAMMED_BY_CAR`] = "Rammed by Vehicle",
	[`WEAPON_RUN_OVER_BY_CAR`] = "Ranover by Vehicle",
	[`VEHICLE_WEAPON_SPACE_ROCKET`] = "Vehicle Space Rocket",
	[`VEHICLE_WEAPON_TANK`] = "Tank",
	[`WEAPON_AIRSTRIKE_ROCKET`] = "Airstrike Rocket",
	[`WEAPON_AIR_DEFENCE_GUN`] = "Air Defence Gun",
	[`WEAPON_COMPACTLAUNCHER`] = "Compact Launcher",
	[`WEAPON_EXPLOSION`] = "Explosion",
	[`WEAPON_FIREWORK`] = "Firework",
	[`WEAPON_GRENADE`] = "Grenade",
	[`WEAPON_GRENADELAUNCHER`] = "Grenade Launcher",
	[`WEAPON_HOMINGLAUNCHER`] = "Homing Launcher",
	[`WEAPON_PASSENGER_ROCKET`] = "Passenger Rocket",
	[`WEAPON_PIPEBOMB`] = "Pipe bomb",
	[`WEAPON_PROXMINE`] = "Proximity Mine",
	[`WEAPON_RPG`] = "RPG",
	[`WEAPON_STICKYBOMB`] = "Sticky Bomb",
	[`WEAPON_VEHICLE_ROCKET`] = "Vehicle Rocket",
	[`WEAPON_BZGAS`] = "BZ Gas",
	[`WEAPON_FIREEXTINGUISHER`] = "Fire Extinguisher",
	[`WEAPON_SMOKEGRENADE`] = "Smoke Grenade",
	[`WEAPON_BATTLEAXE`] = "Battleaxe",
	[`WEAPON_BOTTLE`] = "Bottle",
	[`WEAPON_KNIFE`] = "Knife",
	[`WEAPON_MACHETE`] = "Machete",
	[`WEAPON_SWITCHBLADE`] = "Switch Blade",
	[`OBJECT`] = "Object",
	[`VEHICLE_WEAPON_ROTORS`] = "Vehicle Rotors",
	[`WEAPON_BALL`] = "Ball",
	[`WEAPON_BAT`] = "Bat",
	[`WEAPON_CROWBAR`] = "Crowbar",
	[`WEAPON_FLASHLIGHT`] = "Flashlight",
	[`WEAPON_GOLFCLUB`] = "Golfclub",
	[`WEAPON_HAMMER`] = "Hammer",
	[`WEAPON_HATCHET`] = "Hatchet",
	[`WEAPON_HIT_BY_WATER_CANNON`] = "Water Cannon",
	[`WEAPON_KNUCKLE`] = "Knuckle",
	[`WEAPON_NIGHTSTICK`] = "Night Stick",
	[`WEAPON_POOLCUE`] = "Pool Cue",
	[`WEAPON_SNOWBALL`] = "Snowball",
	[`WEAPON_UNARMED`] = "Fist",
	[`WEAPON_WRENCH`] = "Wrench",
	[`WEAPON_DROWNING`] = "Drowned",
	[`WEAPON_DROWNING_IN_VEHICLE`] = "Drowned in Vehicle",
	[`WEAPON_BARBED_WIRE`] = "Barbed Wire",
	[`WEAPON_BLEEDING`] = "Bleed",
	[`WEAPON_ELECTRIC_FENCE`] = "Electric Fence",
	[`WEAPON_EXHAUSTION`] = "Exhaustion",
	[`WEAPON_FALL`] = "Falling",
	[`WEAPON_KATANA`] = "Katana",
	[`WEAPON_SHIV`] = "Shiv",
	[`WEAPON_AR15`] = "SB556A1",
	[`WEAPON_AR15_PD`] = "PD SB556A1",
	[`WEAPON_P90FM`] = "P90",
	[`WEAPON_SLEDGEHAMMER`] = "Sledge Hammer",
	[`WEAPON_LUCILLE`] = "Bat",
	[`WEAPON_DRBAT`] = "Bat",
	[`WEAPON_CRUTCH`] = "Crutch",
	[`WEAPON_PONY`] = "Pony",
	[`WEAPON_SHOVEL`] = "Shovel",
	[`WEAPON_FIVESEVEN`] = "Six Eight",
	[`WEAPON_BENELLIM2`] = "BM2",
	[`WEAPON_BENELLIM2_PD`] = "PD BM2",
	[`WEAPON_DOUBLEBARRELFM`] = "Double Barrel",
	[`WEAPON_M249`] = "M249",
	[`WEAPON_FM1_HK416`] = "Hk416",
	[`WEAPON_FM2_HK416`] = "Hk416",
	[`WEAPON_HK417`] = "HK417",
	[`WEAPON_FM1_M9A3`] = "M9A3",
	[`WEAPON_FM1_HONEYBADGER`] = "Honey Badger",
	[`WEAPON_AK74_1`] = "AK 74",
	[`WEAPON_AK74_2`] = "AK 74",
	[`WEAPON_ASVAL`] = "AS-VAL",
	[`WEAPON_MCXRATTLER`] = "MCX Rattler",
	[`WEAPON_MCXSPEAR`] = "MCX Spear",
	[`WEAPON_MK14`] = "MK14",
	[`WEAPON_MK47BANSHEE2`] = "MK-47 Fullauto",
	[`WEAPON_MK47BANSHEE`] = "MK-47 Semi",
	[`WEAPON_MK47FM`] = "MK-47 Mutant",
	[`WEAPON_NSR9`] = "NSR9",
	[`WEAPON_PM4`] = "M4",
	[`WEAPON_RFB`] = "RFB",
	[`WEAPON_AK47`] = "AK-47",
	[`WEAPON_SA80`] = "L95",
	[`WEAPON_MB47`] = "AK-47M",
	[`WEAPON_G36`] = "G36",
	[`WEAPON_PP19`] = "PP-19",
	[`WEAPON_MPX`] = "MP 9mm",
	[`WEAPON_MINIUZI`] = 'Mini UZI',
	[`WEAPON_MP9A`] = 'MP9',
	[`WEAPON_MP5`] = "SB54",
	[`WEAPON_VECTOR`] = "Vector",
	[`WEAPON_HKUMP`] = "UMP-45",
	[`WEAPON_HKUMP_PD`] = "PD UMP-45",
	[`WEAPON_L5`] = "Desert Eagle K8",
	[`WEAPON_2011`] = "2011 Tactical",
	[`WEAPON_38SNUBNOSE`] = "PD .38 Snubnose",
	[`WEAPON_38SNUBNOSE2`] = ".38 Snubnose",
	[`WEAPON_38SNUBNOSE2`] = ".38 Snubnose",
	[`WEAPON_38SPECIAL`] = ".38 Special",
	[`WEAPON_44MAGNUM`] = ".44 Magnum",
	[`WEAPON_44MAGNUM_PD`] = "PD .44 Magnum",
	[`WEAPON_FM1_CZ75`] = "CZ69",
	[`WEAPON_FN509`] = "SB-509",
	[`WEAPON_SWMP9`] = "S&B9",
	[`WEAPON_FM1_P226`] = "P226",
	[`WEAPON_FIVESEVEN_PD`] = "PD Six Eight",
	[`WEAPON_FM1_P226_PD`] = "PD P226",
	[`WEAPON_2011_PD`] = "PD 2011 Tactical",
}

function tableContains(tbl, value)
	for k, v in ipairs(tbl or {}) do
		if v == value then
			return true
		end
	end
	return false
end

AddEventHandler("Weapons:Shared:DependencyUpdate", WeaponsComponents)
function WeaponsComponents()
	Fetch = exports["sandbox-base"]:FetchComponent("Fetch")
	Logger = exports["sandbox-base"]:FetchComponent("Logger")
	Inventory = exports["sandbox-base"]:FetchComponent("Inventory")
	Weapons = exports["sandbox-base"]:FetchComponent("Weapons")
	Middleware = exports["sandbox-base"]:FetchComponent("Middleware")
	Callbacks = exports["sandbox-base"]:FetchComponent("Callbacks")
	Pwnzor = exports["sandbox-base"]:FetchComponent("Pwnzor")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["sandbox-base"]:RequestDependencies("Weapons", {
		"Fetch",
		"Logger",
		"Inventory",
		"Weapons",
		"Middleware",
		"Callbacks",
		"Pwnzor",
	}, function(error)
		if #error > 0 then
			return
		end
		WeaponsComponents()

		Callbacks:RegisterServerCallback("Weapons:UseThrowable", function(source, data, cb)
			local char = Fetch:CharacterSource(source)
			if char ~= nil then
				if INVENTORY.Items:RemoveSlot(char:GetData("SID"), data.Name, 1, data.Slot, 1) then
					local slotExists = INVENTORY:SlotExists(char:GetData("SID"), data.Slot, 1)
					if not slotExists then
						TriggerClientEvent("Weapons:Client:ForceUnequip", source)
					end

					cb()
				end
			else
				cb()
			end
		end)

		Callbacks:RegisterServerCallback("Weapons:PossibleCheaterWarning", function(source, data, cb)
			local char = Fetch:CharacterSource(source)
			if char then
				Logger:Warn("Pwnzor", string.format("%s %s (%s) Had a Weapon They Weren't Supposed To (%s) (Known: %s)", char:GetData("First"), char:GetData("Last"), char:GetData("SID"), data.h, weaponCheaters[data.h] or "No"), {
					console = true,
					file = false,
					database = true,
					discord = {
						embed = true,
						type = 'error',
						webhook = GetConvar('discord_pwnzor_webhook', ''),
					}
				}, {
					data = data
				})
				Pwnzor:Screenshot(char:GetData("SID"), "Potential Weapon Exploit")
			end
      		cb()
		end)
	end)
end)

AddEventHandler("Characters:Server:PlayerDropped", function(source)
	local plyr = Fetch:Source(source)
	local ped = GetPlayerPed(source)
	for k, v in ipairs(GetAllObjects()) do
		if GetEntityAttachedTo(v) == ped and _weaponModels[GetEntityModel(v)] then
			DeleteEntity(v)
		end
	end
end)

WEAPONS = {
	IsEligible = function(self, source)
		local char = Fetch:CharacterSource(source)
		local licenses = char:GetData("Licenses")
		if licenses ~= nil and licenses.Weapons ~= nil then
			return licenses.Weapons.Active
		else
			return false
		end
	end,
	Save = function(self, source, id, ammo, clip)
		INVENTORY:UpdateMetaData(id, {
			ammo = ammo,
			clip = clip,
		})
	end,
	Purchase = function(self, sid, item, isScratched, isCompanyOwned)
		if not isCompanyOwned then
			local char = Fetch:SID(sid)
			if char ~= nil then
				local hash = GetHashKey(item.name)
				local sn = string.format("SA-%s-%s", math.abs(hash), Sequence:Get(item.name))
				local model = nil
				if itemsDatabase[item.name] then
					model = itemsDatabase[item.name].label
				end

				if isScratched == nil then
					isScratched = false
				end

				MySQL.insert('INSERT INTO firearms (serial, scratched, model, item, owner_sid, owner_name) VALUES(?, ?, ?, ?, ?, ?)', {
					sn,
					isScratched,
					model,
					item.name,
					sid,
					string.format("%s %s", char:GetData("First"), char:GetData("Last"))
				})

				return sn
			end
		else
			local hash = GetHashKey(item.name)
			local sn = string.format("SA-%s-%s", math.abs(hash), Sequence:Get(item.name))
			local model = nil
			if itemsDatabase[item.name] then
				model = itemsDatabase[item.name].label
			end

			if isScratched == nil then
				isScratched = false
			end

			local flags = nil
			if isCompanyOwned.stolen then
				flags = {
					{
						Date = os.time() * 1000,
						Type = "stolen",
						Description = "Stolen In Armed Robbery"
					}
				}
			end

			MySQL.insert('INSERT INTO firearms (serial, scratched, model, item, owner_name) VALUES(?, ?, ?, ?, ?)', {
				sn,
				isScratched,
				model,
				item.name,
				isCompanyOwned.name
			})
			
			return sn
		end
	end,
	GetComponentItem = function(self, type, component)
		for k, v in pairs(itemsDatabase) do
			if v.component ~= nil and v.component.type == type and v.component.string == component then
				return v.name
			end
		end
		return nil
	end,
	EquipAttachment = function(self, source, item)
		local char = Fetch:CharacterSource(source)
		if char ~= nil then
			local p = promise.new()
			Callbacks:ClientCallback(source, "Weapons:Check", {}, function(data)
				if not data then
					Execute:Client(source, "Notification", "Error", "No Weapon Equipped")
					p:resolve(false)
				else
					local itemData = Inventory.Items:GetData(item.Name)
					local weaponData = Inventory.Items:GetData(data.item)
					if itemData ~= nil and itemData.component ~= nil then
						if itemData.component.strings[weaponData.weapon or weaponData.name] ~= nil then
							Callbacks:ClientCallback(
								source,
								"Weapons:EquipAttachment",
								itemData.label,
								function(notCancelled)
									if notCancelled then
										local slotData = INVENTORY:GetItem(data.id)

										if slotData ~= nil then
											slotData.MetaData = json.decode(slotData.MetaData or "{}")

											local unequipItem = nil
											local unequipCreated = nil
											if
												slotData.MetaData.WeaponComponents ~= nil
												and slotData.MetaData.WeaponComponents[itemData.component.type]
													~= nil
											then
												if
													slotData.MetaData.WeaponComponents[itemData.component.type].attachment
													== itemData.component.string
												then
													Execute:Client(
														source,
														"Notification",
														"Error",
														"Attachment Already Equipped"
													)
													return p:resolve(false)
												end
												unequipItem =
													slotData.MetaData.WeaponComponents[itemData.component.type].item
												unequipCreated =
													slotData.MetaData.WeaponComponents[itemData.component.type].created
											end

											local comps = table.copy(slotData.MetaData.WeaponComponents or {})
											comps[itemData.component.type] = {
												type = itemData.component.type,
												item = item.Name,
												created = item.CreateDate,
												attachment = itemData.component.strings[weaponData.weapon or weaponData.name],
											}

											Inventory.Items:RemoveSlot(item.Owner, item.Name, 1, item.Slot, 1)
											if unequipItem ~= nil then
												local returnData = Inventory.Items:GetData(unequipItem)
												if returnData?.component?.returnItem then
													INVENTORY:AddItem(item.Owner, unequipItem, 1, {}, 1, false, false, false, false, false, unequipCreated or os.time())
												end
											end

											INVENTORY:SetMetaDataKey(
												slotData.id,
												"WeaponComponents",
												comps,
												source
											)

											Citizen.Wait(400)

											SetGunPropData(source, char:GetData("SID"), getInventory(source, char:GetData("SID"), 1, false), true)
											TriggerClientEvent("Weapons:Client:UpdateAttachments", source, comps)

											return p:resolve(true)
										else
											return p:resolve(false)
										end
										
									else
										return p:resolve(false)
									end
								end
							)
						else
							Execute:Client(source, "Notification", "Error", "This Does Not Fit On This Weapon")
							return p:resolve(false)
						end
					else
						Execute:Client(source, "Notification", "Error", "Something Was Not Defined")
						return p:resolve(false)
					end
				end
			end)

			return Citizen.Await(p)
		else
			return false
		end
	end,
	RemoveAttachment = function(self, source, slotId, attachment)
		local char = Fetch:CharacterSource(source)
		if char ~= nil then
			local slot = INVENTORY:GetSlot(char:GetData("SID"), slotId, 1)
			if slot ~= nil then
				if slot.MetaData.WeaponComponents ~= nil and slot.MetaData.WeaponComponents[attachment] ~= nil then
					local itemData = Inventory.Items:GetData(slot.MetaData.WeaponComponents[attachment].item)
					if itemData ~= nil then
						INVENTORY:AddItem(char:GetData("SID"), itemData.name, 1, {}, 1, false, false, false, false, false, slot.MetaData.WeaponComponents[attachment].created or os.time())
						slot.MetaData.WeaponComponents[attachment] = nil	
						INVENTORY:SetMetaDataKey(
							slot.id,
							"WeaponComponents",
							slot.MetaData.WeaponComponents,
							source
						)
						TriggerClientEvent("Weapons:Client:UpdateAttachments", source, slot.MetaData.WeaponComponents)
					end
				end
			end
		end
	end,
}

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["sandbox-base"]:RegisterComponent("Weapons", WEAPONS)
end)

RegisterNetEvent("Weapon:Server:UpdateAmmo", function(slot, ammo, clip)
	Weapons:Save(source, slot, ammo, clip)
end)

RegisterNetEvent("Weapon:Server:UpdateAmmoDiff", function(diff, ammo, clip)
	local _src = source
	if diff?.id then
		INVENTORY:UpdateMetaData(diff.id, {
			ammo = ammo,
			clip = clip,
		})
	end
end)

RegisterNetEvent("Weapons:Server:RemoveAttachment", function(slotId, attachment)
	Weapons:RemoveAttachment(source, slotId, attachment)
end)

RegisterNetEvent("Weapons:Server:DoFlashFx", function(coords, netId)
	TriggerEvent("Particles:Server:DoFx", coords, "flash")
	TriggerClientEvent("Weapons:Client:DoFlashFx", -1, coords.x, coords.y, coords.z, 10000, 8, 20.0, netId, 25, 1.6)
end)