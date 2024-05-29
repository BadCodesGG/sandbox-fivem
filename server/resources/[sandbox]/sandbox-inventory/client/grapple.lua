local EARLY_STOP_MULTIPLIER = 0.5
local DEFAULT_GTA_FALL_DISTANCE = 8.3
local DEFAULT_OPTIONS = { waitTime = 0.5, grappleSpeed = 20.0 }

local GRAPPLEHASH = `WEAPON_BULLPUPSHOTGUN`

CAN_GRAPPLE_HERE = true

Grapple = {}

Citizen.CreateThread(function()
	RopeLoadTextures()
end)

local function DirectionToRotation(dir, roll)
	local x, y, z
	z = -(math.deg(math.atan2(dir.x, dir.y)))
	local rotpos = vector3(dir.z, #vector2(dir.x, dir.y), 0.0)
	x = math.deg(math.atan2(rotpos.x, rotpos.y))
	y = roll
	return vector3(x, y, z)
end

local function RotationToDirection(rot)
	local rotZ = math.rad(rot.z)
	local rotX = math.rad(rot.x)
	local cosOfRotX = math.abs(math.cos(rotX))
	return vector3(-(math.sin(rotZ)) * cosOfRotX, math.cos(rotZ) * cosOfRotX, math.sin(rotX))
end

local function RayCastGamePlayCamera(dist)
	local camRot = GetGameplayCamRot()
	local camPos = GetGameplayCamCoord()
	local dir = RotationToDirection(camRot)

	local dest = camPos + (dir * dist)
	local ray = StartShapeTestRay(camPos, dest, 17, -1, 0)
	local _, hit, endPos, surfaceNormal, entityHit = GetShapeTestResult(ray)
	if hit == 0 then
		endPos = dest
	end
	return hit, endPos, entityHit, surfaceNormal
end

function GrappleCurrentAimPoint(dist)
	return RayCastGamePlayCamera(dist or 40)
end

local function _ensureOptions(options)
	for k, v in pairs(DEFAULT_OPTIONS) do
		if options[k] == nil then
			options[k] = v
		end
	end
end

local function _waitForFall(pid, ped, stopDistance)
	SetPlayerFallDistance(pid, 10.0)
	while GetEntityHeightAboveGround(ped) > stopDistance do
		SetPedCanRagdoll(ped, false)
		Wait(0)
	end
	SetPlayerFallDistance(pid, DEFAULT_GTA_FALL_DISTANCE)
end

local function PinRope(rope, ped, boneId, dest)
	PinRopeVertex(rope, 0, dest)
	PinRopeVertex(rope, GetRopeVertexCount(rope) - 1, GetPedBoneCoords(ped, boneId, 0.0, 0.0, 0.0))
end

function Grapple.new(dest, options)
	local self = {}
	options = options or {}
	_ensureOptions(options)
	local grappleId = math.random((-2 ^ 32) + 1, 2 ^ 32 - 1)
	if options.grappleId then
		grappleId = options.grappleId
	end
	local pid = PlayerId()
	if options.plyServerId then
		pid = GetPlayerFromServerId(options.plyServerId)
	end

	local ped = GetPlayerPed(pid)
	local oldPedRef = ped
	local heading = GetEntityHeading(ped)
	local start = GetEntityCoords(ped)
	local notMyPed = options.plyServerId and options.plyServerId ~= GetPlayerServerId(PlayerId())
	local fromStartToDest = dest - start
	local dir = fromStartToDest / #fromStartToDest
	local length = #fromStartToDest
	local finished = false
	local rope
	if pid ~= -1 then
		rope = AddRope(dest, 0.0, 0.0, 0.0, 0.0, 4, 0.0, 0.0, 1.0, false, false, false, 5.0, false)
		LoadRopeData(rope, 4)
		local headingToSet = GetEntityHeading(ped)
		ped = ClonePed(ped, 0, 0, 0)
		SetEntityHeading(ped, headingToSet)
		SetEntityAlpha(oldPedRef, 0, 0)
		local objs = GetGamePool("CObject")
		for k, v in ipairs(objs) do
			if Entity(v).state.backWeapon and IsEntityAttachedToEntity(v, oldPedRef) then
				SetEntityAlpha(v, 0, 0)
			end
		end
	end

	local function _setupDestroyEventHandler()
		local event = nil
		local eventName = string.format("Inventory:Client:Grapple:DestroyRope:%s", grappleId or -1)
		RegisterNetEvent(eventName)
		event = AddEventHandler(eventName, function()
			self.destroy(false)
			RemoveEventHandler(event)
		end)
	end

	function self._handleRope(rope, ped, boneIndex, dest)
		Citizen.CreateThread(function()
			while not finished do
				PinRope(rope, ped, boneIndex, dest)
				Wait(0)
			end
			DeleteChildRope(rope)
			DeleteRope(rope)
		end)
	end

	function self.activateSync()
		if pid == -1 then
			return
		end
		local distTraveled = 0.0
		local currentPos = start
		local lastPos = currentPos
		local rotationMultiplier = -1
		local rot = DirectionToRotation(-dir * rotationMultiplier, 0.0)
		local lastRot = rot

		rot = rot + vector3(90.0 * rotationMultiplier, 0.0, 0.0)
		Wait(options.waitTime * 1000)
		while not finished and distTraveled < length do
			local fwdPerFrame = dir * options.grappleSpeed * GetFrameTime()
			distTraveled = distTraveled + #fwdPerFrame
			if distTraveled > length then
				distTraveled = length
				currentPos = dest
			else
				currentPos = currentPos + fwdPerFrame
			end
			SetEntityCoords(ped, currentPos)
			SetEntityRotation(ped, rot)
			if distTraveled > 3 and HasEntityCollidedWithAnything(ped) == 1 then
				SetEntityCoords(ped, lastPos - (dir * EARLY_STOP_MULTIPLIER))
				SetEntityRotation(ped, lastRot)
				break
			end
			lastPos = currentPos
			lastRot = rot
			if not notMyPed then
				SetGameplayCamFollowPedThisUpdate(ped)
			end
			Wait(0)
		end
		if not notMyPed then
			SetEntityCoords(oldPedRef, GetEntityCoords(ped))
			SetEntityRotation(oldPedRef, GetEntityRotation(ped))
		else
			FreezeEntityPosition(ped, true, true)
		end

		self.destroy()
		_waitForFall(pid, ped, 3.0)

		Citizen.CreateThread(function()
			Citizen.Wait(200)
			local objs = GetGamePool("CObject")
			for k, v in ipairs(objs) do
				if Entity(v).state.backWeapon and IsEntityAttachedToEntity(v, oldPedRef) then
					SetEntityAlpha(v, 255, 0)
				end
			end
		end)
	end

	function self.activate()
		CreateThread(self.activateSync)
	end

	function self.destroy(shouldTriggerDestroyEvent)
		finished = true
		if shouldTriggerDestroyEvent or shouldTriggerDestroyEvent == nil then
			if pid ~= -1 then
				Citizen.CreateThread(function()
					if notMyPed then
						loopCount = 0
						while #(GetEntityCoords(ped) - GetEntityCoords(oldPedRef)) > 2 and (loopCount < 20) do
							loopCount = loopCount + 1
							Wait(32)
						end
					end

					DeleteEntity(ped)
					SetEntityAlpha(oldPedRef, 255, 0)
				end)
			end
			TriggerServerEvent("Inventory:Server:Grapple:DestroyRope", grappleId)
		end
	end

	if pid ~= -1 then
		self._handleRope(rope, ped, 0x49D9, dest)
		if notMyPed then
			self.activate()
		end
	end
	if options.plyServerId == nil then
		TriggerServerEvent("Inventory:Server:Grapple:CreateRope", grappleId, dest)
	else
		_setupDestroyEventHandler()
	end
	return self
end

local _grappleEquipped = false
local shownGrappleButton = false
local function GrappleThreads()
	local ply = PlayerId()

	Citizen.CreateThread(function()
		while _grappleEquipped and _equippedHash == GRAPPLEHASH do
			local freeAiming = IsPlayerFreeAiming(ply)
			local hit, pos, _, _ = GrappleCurrentAimPoint(40)
			if not shownGrappleButton and freeAiming and hit == 1 and CAN_GRAPPLE_HERE then
				shownGrappleButton = true
				Action:Show("grapple", "{key}Shoot{/key} To Grapple")
			elseif shownGrappleButton and ((not freeAiming) or hit ~= 1 or not CAN_GRAPPLE_HERE) then
				shownGrappleButton = false
				Action:Hide("grapple")
			end
			Wait(250)
		end
	end)

	Citizen.CreateThread(function()
		while _grappleEquipped and _equippedHash == GRAPPLEHASH do
			local freeAiming = IsPlayerFreeAiming(ply)
			if IsControlJustReleased(0, 257) and freeAiming and _grappleEquipped and CAN_GRAPPLE_HERE then
				local hit, pos, _, _ = GrappleCurrentAimPoint(40)
				if hit == 1 then
					_grappleEquipped = false
					Action:Hide("grapple")
					shownGrappleButton = false
					local grapple = Grapple.new(pos)
					grapple.activate()
					TriggerServerEvent("Inventory:Server:DegradeLastUsed", 25)
					Citizen.Wait(1000)
					Weapons:UnequipIfEquippedNoAnim()
				end
			end
			Citizen.Wait(0)
		end
	end)
end

RegisterNetEvent("Weapons:Client:Changed", function(item)
	if not item then
		_grappleEquipped = false
	else
		if GetHashKey(_items[item.Name].weapon or item.Name) == GRAPPLEHASH then
			_grappleEquipped = true
			GrappleThreads()
		end
	end
end)

RegisterNetEvent("Inventory:Client:Grapple:CreateRope", function(plyServerId, grappleId, dest)
	if plyServerId == GetPlayerServerId(PlayerId()) then
		return
	end
	Grapple.new(dest, { plyServerId = plyServerId, grappleId = grappleId })
end)
