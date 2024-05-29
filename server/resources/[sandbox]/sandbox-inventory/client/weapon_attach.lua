_weapons = {}
local disabled = false
local weaponLimit = 4

spawnedObjs = {}
attachedObjects = {}

local weaponOffsets = {
	[1] = {
		x = 0.1,
		y = -0.155,
		z = 0.21,
		rx = 0.0,
		ry = 150.0,
		rz = 0.0,
		diff = 0.1,
	},
	[2] = {
		x = 0.1,
		y = -0.155,
		z = 0.21,
		rx = 0.0,
		ry = 150.0,
		rz = 0.0,
		diff = 0.2,
	},
	[3] = {
		x = 0.1,
		y = -0.155,
		z = 0.21,
		rx = 180.0,
		ry = -150.0,
		rz = 0.0,
		diff = 0.2,
	},
	[4] = {
		x = 0.1,
		y = -0.155,
		z = 0.21,
		rx = 180.0,
		ry = 180.0,
		rz = 0.0,
		diff = 0.3,
	},
}

function LoadModel(model)
	RequestModel(model)
	local attempts = 0
	while not HasModelLoaded(model) and attempts < 10 do
		Citizen.Wait(100)
		attempts += 1
	end
end

function LoadWeaponModel(weapon)
	RequestWeaponAsset(weapon, 31, 0)
	local attempts = 0
	while not HasWeaponAssetLoaded(weapon) and attempts < 10 do
		Citizen.Wait(100)
		attempts += 1
	end
end

function LoadComponentModel(attachment)
	local componentModel = GetWeaponComponentTypeModel(attachment)
	RequestModel(componentModel)
	local attempts = 0
	while not HasModelLoaded(componentModel) and attempts < 10 do
		Citizen.Wait(100)
		attempts += 1
	end
end

function CountType(id, type)
	local count = 0
	if attachedObjects[id] then
		for k, v in ipairs(attachedObjects[id]) do
			if v.type == type then
				count += 1
			end
		end
	end
	return count
end

function HasAttachedItem(item)
	if attachedObjects[id] then
		for k, v in ipairs(attachedObjects[id]) do
			if v.item == item then
				return k
			end
		end
	end

	return false
end

function DeleteAttached(id)
	if attachedObjects[id] then
		for k, v in ipairs(attachedObjects[id]) do
			DeleteEntity(v.object)
		end
	end
	attachedObjects[id] = {}
end

local function SetupWeaponAttchs(obj, wepHash, attachs, weapon)
	local comps = {}

	if WEAPON_COMPS[weapon] then
		for k, v in ipairs(WEAPON_COMPS[weapon]) do
			if v.type ~= "flashlight" then
				comps[v.type] = v.attachment
			end
		end
	end

	if attachs then
		for k, v in pairs(attachs) do
			if k ~= "flashlight" then
				comps[k] = v.attachment
			end
		end
	end

	for k, v in pairs(comps) do
		local hash = GetHashKey(v)
		if DoesWeaponTakeWeaponComponent(wepHash, hash) then
			if not HasWeaponGotWeaponComponent(obj, hash) then
				LoadComponentModel(hash)
				local componentModel = GetWeaponComponentTypeModel(v)
				GiveWeaponComponentToWeaponObject(obj, hash)
			end
		end
	end
end

local _processing = {}
function CreateBackObjects(tPed, id, props)
	while Weapons == nil do
		Citizen.Wait(1)
	end

	if not LocalPlayer.state.loggedIn then
		return
	end

	if _processing[id] then
		return
	else
		_processing[id] = true
	end

	if DoesEntityExist(tPed) then
		local _, curw = GetCurrentPedWeapon(tPed)
		DeleteAttached(id)
		for k, v in pairs(props) do
			local pInfo = WEAPON_PROPS[v.weapon]
			if pInfo then
				local hasAttchItem = HasAttachedItem(v.item)
				if pInfo.type == "weapon" then
					local wHash = GetHashKey(v.weapon)
					local count = CountType(id, pInfo.type)
					if count < weaponLimit and not v.equipped then
						local bone = GetPedBoneIndex(tPed, 24818)
						--local obj = CreateObject(v.model, 1.0, 1.0, 1.0, 1, 1, 0)

						local coords = GetEntityCoords(tPed)

						LoadWeaponModel(wHash)

						local obj = CreateWeaponObject(wHash, 0, coords.x, coords.y, coords.z, false, 1.0, false)

						while not DoesEntityExist(obj) do
							Citizen.Wait(1)
						end

						RequestWeaponHighDetailModel(obj)

						if v.tint then
							SetWeaponObjectTintIndex(obj, v.tint)
						end

						Entity(obj).state.backWeapon = true
						local offset = weaponOffsets[count + 1]
						table.insert(attachedObjects[id], {
							object = obj,
							type = pInfo.type,
							item = pInfo.item,
							pInfo = pInfo,
							offset = offset,
						})

						if pInfo.override then
							AttachEntityToEntity(
								obj,
								tPed,
								bone,
								pInfo.x,
								pInfo.y,
								pInfo.z,
								pInfo.rx,
								pInfo.ry,
								pInfo.rz,
								0,
								1,
								0,
								1,
								0,
								1
							)
						else
							AttachEntityToEntity(
								obj,
								tPed,
								bone,
								(offset.x + pInfo.x),
								(offset.y + pInfo.y),
								(offset.z + pInfo.z) - offset.diff,
								(offset.rx + pInfo.rx),
								(offset.ry + pInfo.ry),
								(offset.rz + pInfo.rz),
								0,
								1,
								0,
								1,
								0,
								1
							)
						end
						SetupWeaponAttchs(obj, wHash, v.attachments, v.weapon)
						SetEntityCollision(obj, false, true)
						SetEntityCompletelyDisableCollision(obj, false, true)
						SetEntityNoCollisionEntity(obj, PlayerPedId(), false)
					elseif v.equipped and attachedObjects[id][hasAttchItem] ~= nil then
						DeleteEntity(attachedObjects[id][hasAttchItem].object)
						table.remove(attachedObjects[id], hasAttchItem)
					end
				elseif pInfo.type == "melee" then
					LoadModel(pInfo.model)
					local count = CountType(id, pInfo.type)
					if v.equipped and attachedObjects[id][hasAttchItem] ~= nil then
						DeleteEntity(attachedObjects[id][hasAttchItem].object)
						table.remove(attachedObjects[id], hasAttchItem)
					elseif count < weaponLimit and not v.equipped then
						local bone = GetPedBoneIndex(tPed, pInfo.bone or 24818)
						local coords = GetEntityCoords(tPed)
						local obj = CreateObject(pInfo.model, coords.x, coords.y, coords.z, false, true, false)
						Entity(obj).state.backWeapon = true
						table.insert(attachedObjects[id], {
							object = obj,
							type = pInfo.type,
							item = pInfo.item,
							pInfo = pInfo,
							offset = offset,
						})
						AttachEntityToEntity(
							obj,
							tPed,
							bone,
							pInfo.x,
							pInfo.y,
							pInfo.z,
							pInfo.rx,
							pInfo.ry,
							pInfo.rz,
							0,
							1,
							0,
							1,
							0,
							1
						)
						SetEntityCollision(obj, false, true)
						SetEntityCompletelyDisableCollision(obj, false, true)
					end
				elseif pInfo.type == "object" then
					LoadModel(pInfo.model)
					local count = CountType(id, pInfo.type)
					if count < weaponLimit then
						local bone = GetPedBoneIndex(tPed, pInfo.bone or 24818)
						local coords = GetEntityCoords(tPed)
						local obj = CreateObject(pInfo.model, coords.x, coords.y, coords.z, false, true, false)
						-- Entity(obj).state:set("WeaponOwner", id, true)
						table.insert(attachedObjects[id], {
							object = obj,
							type = pInfo.type,
							item = pInfo.item,
							pInfo = pInfo,
							offset = offset,
						})
						AttachEntityToEntity(
							obj,
							tPed,
							bone,
							pInfo.x,
							pInfo.y,
							pInfo.z,
							pInfo.rx,
							pInfo.ry,
							pInfo.rz,
							0,
							1,
							0,
							1,
							0,
							1
						)
						SetEntityCollision(obj, false, true)
						SetEntityCompletelyDisableCollision(obj, false, true)
					end
				end
			end
		end

		_processing[id] = false

		return true
	else
		return false
	end
end

RegisterNetEvent("Characters:Client:Logout", function()
	_processing = {}
end)
