function RegisterBallisticsCallbacks()
	Callbacks:RegisterServerCallback("Evidence:Ballistics:FileGun", function(source, data, cb)
		local char = Fetch:CharacterSource(source)
		if char and data and data.slotNum and data.serial then
			-- Files a Gun So Evidence Can Be Found
			local item = Inventory:GetSlot(char:GetData("SID"), data.slotNum, 1)
			if item and item.MetaData and (item.MetaData.ScratchedSerialNumber or item.MetaData.SerialNumber) then
				local firearmRecord, policeWeapId

				if item.MetaData.ScratchedSerialNumber and item.MetaData.ScratchedSerialNumber == data.serial then
					firearmRecord = MySQL.single.await("SELECT serial, scratched, model, owner_sid, owner_name, police_filed, police_id FROM firearms WHERE serial = ? AND scratched = ?", {
						item.MetaData.ScratchedSerialNumber,
						1
					})
				elseif item.MetaData.SerialNumber and item.MetaData.SerialNumber == data.serial then
					firearmRecord = MySQL.single.await("SELECT serial, scratched, model, owner_sid, owner_name, police_filed, police_id FROM firearms WHERE serial = ? AND scratched = ?", {
						item.MetaData.SerialNumber,
						0
					})
				end

				if firearmRecord then
					if not firearmRecord.police_filed then
						local updated = false
						if item.MetaData.ScratchedSerialNumber or item.MetaData.SerialNumber then
							MySQL.query.await("UPDATE firearms SET police_filed = ? WHERE serial = ?", {
								1,
								firearmRecord.serial,
							})

							if item.MetaData.ScratchedSerialNumber then
								Inventory:SetMetaDataKey(item.id, "PoliceWeaponId", firearmRecord.police_id, source)
							end

							return cb(
								true,
								false,
								GetMatchingEvidenceProjectiles(firearmRecord.serial),
								firearmRecord.scratched and string.format("PWI-%s", firearmRecord.police_id) or nil
							)
						end
					else
						return cb(
							true,
							true,
							GetMatchingEvidenceProjectiles(firearmRecord.serial),
							string.format("PWI-%s", firearmRecord.police_id)
						)
					end
				end
			end
		end
		cb(false)
	end)
end

function RegisterBallisticsItemUses()
	Inventory.Items:RegisterUse("evidence-projectile", "Evidence", function(source, itemData)
		if itemData and itemData.MetaData and itemData.MetaData.EvidenceId and itemData.MetaData.EvidenceWeapon then
			Callbacks:ClientCallback(source, "Polyzone:IsCoordsInZone", {
				coords = GetEntityCoords(GetPlayerPed(source)),
				key = "ballistics",
				val = true,
			}, function(inZone)
				if inZone then
					if not itemData.MetaData.EvidenceDegraded then
						local filedEvidence = GetEvidenceProjectileRecord(itemData.MetaData.EvidenceId)
						local matchingWeapon = MySQL.single.await("SELECT serial, scratched, model, owner_sid, owner_name, police_filed, police_id FROM firearms WHERE serial = ? AND police_filed = ?", {
							itemData.MetaData.EvidenceWeapon.serial,
							1
						})

						if filedEvidence then -- Already Exists
							TriggerClientEvent(
								"Evidence:Client:FiledProjectile",
								source,
								false,
								true,
								true,
								filedEvidence,
								matchingWeapon,
								itemData.MetaData.EvidenceId
							)
						else
							local newFiledEvidence = CreateEvidenceProjectileRecord({
								Id = itemData.MetaData.EvidenceId,
								Weapon = itemData.MetaData.EvidenceWeapon,
								Coords = itemData.MetaData.EvidenceCoords,
								AmmoType = itemData.MetaData.EvidenceAmmoType,
							})

							if newFiledEvidence then
								TriggerClientEvent(
									"Evidence:Client:FiledProjectile",
									source,
									false,
									true,
									false,
									newFiledEvidence,
									matchingWeapon,
									itemData.MetaData.EvidenceId
								)
							else
								TriggerClientEvent("Evidence:Client:FiledProjectile", source, false, false)
							end
						end
					else
						TriggerClientEvent("Evidence:Client:FiledProjectile", source, true)
					end
				end
			end)
		end
	end)

	Inventory.Items:RegisterUse("evidence-dna", "Evidence", function(source, itemData)
		if itemData and itemData.MetaData and itemData.MetaData.EvidenceId and itemData.MetaData.EvidenceDNA then
			Callbacks:ClientCallback(source, "Polyzone:IsCoordsInZone", {
				coords = GetEntityCoords(GetPlayerPed(source)),
				key = "dna",
				val = true,
			}, function(inZone)
				if inZone then
					if not itemData.MetaData.EvidenceDegraded then
						local char = GetCharacter(itemData.MetaData.EvidenceDNA)
						if char then
							TriggerClientEvent(
								"Evidence:Client:RanDNA",
								source,
								false,
								char,
								itemData.MetaData.EvidenceId
							)
						else
							TriggerClientEvent("Evidence:Client:RanDNA", source, false, false)
						end
					else
						TriggerClientEvent("Evidence:Client:RanDNA", source, true)
					end
				end
			end)
		end
	end)
end

function GetEvidenceProjectileRecord(evidenceId)
	local p = promise.new()

	Database.Game:findOne({
		collection = "firearms_projectiles",
		query = {
			Id = evidenceId,
		},
	}, function(success, results)
		if success and #results > 0 and results[1] then
			p:resolve(results[1])
		else
			p:resolve(false)
		end
	end)

	return Citizen.Await(p)
end

function CreateEvidenceProjectileRecord(document)
	local p = promise.new()
	Database.Game:insertOne({
		collection = "firearms_projectiles",
		document = document,
	}, function(success, result, insertId)
		if success then
			p:resolve(document)
		else
			p:resolve(false)
		end
	end)

	return Citizen.Await(p)
end

function GetMatchingEvidenceProjectiles(weaponSerial)
	local p = promise.new()

	Database.Game:find({
		collection = "firearms_projectiles",
		query = {
			["Weapon.serial"] = weaponSerial,
		},
	}, function(success, results)
		if success and #results > 0 then
			local foundEvidence = {}

			for k, v in ipairs(results) do
				table.insert(foundEvidence, v.Id)
			end
			p:resolve(foundEvidence)
		else
			p:resolve({})
		end
	end)

	return Citizen.Await(p)
end

function GetCharacter(stateId)
	local p = promise.new()

	Database.Game:findOne({
		collection = "characters",
		query = {
			SID = stateId,
		},
	}, function(success, results)
		if success and #results > 0 then
			local char = results[1]
			if char and char.SID and char.First and char.Last then
				local thisYear = os.date("%Y")
				local pattern = "(%d+)-(%d+)-(%d+)T(%d+):(%d+):(%d+)"
				local year, month, day, hour, minute, seconds = char.DOB:match(pattern)

				p:resolve({
					SID = char.SID,
					First = char.First,
					Last = char.Last,
					Age = char.DOB and (tonumber(thisYear) - tonumber(year)) or "Unknown",
				})
			end
		else
			p:resolve(false)
		end
	end)

	return Citizen.Await(p)
end

AddEventHandler('Evidence:Server:RunBallistics', function(source, data)
    local char = Fetch:CharacterSource(source)
    if char ~= nil then
		local pState = Player(source).state
		if pState.onDuty == "police" then
            local its = Inventory:GetInventory(source, data.owner, data.invType)
            if #its > 0 then
				local item = its[1]
                local md = json.decode(item.MetaData)
                local itemData = Inventory.Items:GetData(item.Name)
                if itemData ~= nil and itemData.type == 2 then
					if item and md and (md.ScratchedSerialNumber or md.SerialNumber) then
						local firearmRecord, policeWeapId
		
						if md.ScratchedSerialNumber then
							firearmRecord = MySQL.single.await("SELECT serial, scratched, model, owner_sid, owner_name, police_filed, police_id FROM firearms WHERE serial = ? AND scratched = ?", {
								md.ScratchedSerialNumber,
								1
							})
						elseif md.SerialNumber then
							firearmRecord = MySQL.single.await("SELECT serial, scratched, model, owner_sid, owner_name, police_filed, police_id FROM firearms WHERE serial = ? AND scratched = ?", {
								md.SerialNumber,
								0
							})
						end
						
						if firearmRecord then
							if not firearmRecord.police_filed then
								local updated = false
								if md.ScratchedSerialNumber or md.SerialNumber then
									MySQL.query.await("UPDATE firearms SET police_filed = ? WHERE serial = ?", {
										1,
										firearmRecord.serial,
									})
		
									if md.ScratchedSerialNumber then
										Inventory:SetMetaDataKey(item.id, "PoliceWeaponId", firearmRecord.police_id, source)
									end

									Inventory.Ballistics:Clear(source, data.owner, data.invType)
									Callbacks:ClientCallback(source, "Evidence:RunBallistics", {
										true,
										false,
										GetMatchingEvidenceProjectiles(firearmRecord.serial),
										firearmRecord.scratched and string.format("PWI-%s", firearmRecord.police_id) or nil,
										md.SerialNumber or nil
									})
								end
							else
								Inventory.Ballistics:Clear(source, data.owner, data.invType)
								Callbacks:ClientCallback(source, "Evidence:RunBallistics", {
									true,
									true,
									GetMatchingEvidenceProjectiles(firearmRecord.serial),
									string.format("PWI-%s", firearmRecord.police_id),
									md.SerialNumber or nil
								})
							end
						else
							Inventory.Ballistics:Clear(source, data.owner, data.invType)
							Callbacks:ClientCallback(source, "Evidence:RunBallistics", {
								false,
								false,
								false,
								false,
								false,
								nil
							})
						end
					end

				else
					Execute:Client(source, "Notification", "Error", "Item Must Be A Weapon")
                end
            end
		end
    end
end)