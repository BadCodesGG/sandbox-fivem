local koDict = "mini@cpr@char_b@cpr_def"
local koAnim = "cpr_pumpchest_idle"

local deadDict = "dead"
local deadAnim = "dead_d"

local vehDict = "veh@low@front_ps@idle_duck"
local vehAnim = "sit"

local drownDict = "dam_ko"
local drownAnim = "drown"

Citizen.CreateThread(function()
	loadAnimDict(koDict)
	loadAnimDict(deadDict)
	loadAnimDict(vehDict)
end)

function ApplyLimp(ped)
	local shouldLimp = (GetEntityHealth(ped) - 100) <= math.floor((GetEntityMaxHealth(ped) - 100) / 4)
	if shouldLimp and not (LocalPlayer.state.onPainKillers or 0 > 0) then
		if not LocalPlayer.state.isLimping then
			LocalPlayer.state.isLimping = true
			Animations.PedFeatures:RequestFeaturesUpdate()
		end
	else
		if LocalPlayer.state.isLimping then
			LocalPlayer.state.isLimping = false
			Animations.PedFeatures:RequestFeaturesUpdate()
		end
	end
end

function GetReleaseTime(isMinor)
	if LocalPlayer.state.isDead then
		if isMinor then
			return 60 * 1
		else
			if LocalPlayer.state.onDuty == "police" or LocalPlayer.state.onDuty == "ems" then
				return 60 * 3
			else
				return 60 * 5
			end
		end
	else
		return 0
	end
end

function wasMinorDeath(hash)
	if Config.Weapons[hash] == nil or not Config.Weapons[hash].minor then
		return false
	else
		return true
	end
end

local changeHandler = nil
RegisterNetEvent("Characters:Client:Spawn", function()
	-- changeHandler = AddStateBagChangeHandler(
	-- 	"isDead",
	-- 	string.format("player:%s", GetPlayerServerId(LocalPlayer.state.PlayerID)),
	-- 	function(bagName, key, value, _unused, replicated)
	-- 		DoDeadEvent()
	-- 	end
	-- )
end)

RegisterNetEvent("Characters:Client:Logout", function()
	if changeHandler ~= nil then
		RemoveStateBagChangeHandler(changeHandler)
		changeHandler = nil
	end
end)

function DoDeadEvent()
	if LocalPlayer.state.isDead then
		Weapons:UnequipIfEquippedNoAnim()
		if not LocalPlayer.state.gameMode then
			Buffs:RemoveBuffType("weakness")
			DisableControls()
			DeadAnimLoop()
		else
			Hud.DeathTexts:Hide()
			TriggerEvent(string.format("Damage:Client:Gamemode:%s:Died", LocalPlayer.state.gameMode))
		end
	else
		Hud.DeathTexts:Hide()
		ClearPedTasksImmediately(PlayerPedId())
		SetEntityInvincible(PlayerPedId(), LocalPlayer.state.isAdmin and LocalPlayer.state.isGodmode or false)
	end
end

local deathLooping = false
local aDict = deadDict
local aAnim = deadAnim

function DeadAnimLoop()
	Citizen.CreateThread(function()
		local ped = PlayerPedId()

		aDict = deadDict
		aAnim = deadAnim

		local seat = 0
		local veh = GetVehiclePedIsIn(ped)
		if veh ~= 0 then
			local m = GetEntityModel(veh)
			for k = -1, GetVehicleModelNumberOfSeats(m) do
				if GetPedInVehicleSeat(veh, k) == ped then
					seat = k
				end
			end
		end

		DoScreenFadeOut(1000)
		while not IsScreenFadedOut() do
			Citizen.Wait(10)
		end

		AnimpostfxPlay("DeathFailMPIn", 100.0, true)

		local loc = GetEntityCoords(ped)
		NetworkResurrectLocalPlayer(loc, true, true, false)

		if not veh then
			ClearPedTasksImmediately(ped)
		else
			TaskWarpPedIntoVehicle(ped, veh, seat)
			Citizen.Wait(300)
		end
	
		if (type(LocalPlayer.state.deadData) == "table") and LocalPlayer.state?.deadData?.isMinor then
			aDict = koDict
			aAnim = koAnim
		end
		
		DoScreenFadeIn(1000)

		SetEntityHealth(ped, 200)

		if not deathLooping then
			deathLooping = true

			while LocalPlayer.state.loggedIn and LocalPlayer.state.isDead and not LocalPlayer.state.isHospitalized do
				ped = PlayerPedId()
	
				if not LocalPlayer.state?.deadData?.isMinor then
					SetEntityInvincible(ped, true)
				else
					SetEntityInvincible(ped, false)
				end
	
				if IsPedInAnyVehicle(ped) then
					TaskPlayAnim(ped, vehDict, vehAnim, 8.0, -8, -1, 1, 0, 0, 0, 0)
				elseif IsEntityInWater(ped) then
					TaskPlayAnim(ped, drownDict, drownAnim, 8.0, -8, -1, 1, 0, 0, 0, 0)
				elseif LocalPlayer.state.inTrunk then
					-- dosomething?
				else
					TaskPlayAnim(ped, aDict, aAnim, 1.0, 1.0, -1, 1, 0, 0, 0, 0)
				end
				Citizen.Wait(100)
			end
	
			AnimpostfxStop("DeathFailMPIn")
	
			Hud.DeathTexts:Hide()
			ClearPedTasksImmediately(ped)
			SetEntityInvincible(ped, LocalPlayer.state.isAdmin and LocalPlayer.state.isGodmode or false)

			deathLooping = false
		end
	end)
end

local disabling = false
function DisableControls()
	if disabling then return end
	disabling = true
	Citizen.CreateThread(function()
		while LocalPlayer.state.loggedIn and LocalPlayer.state.isDead do
			DisableControlAction(0, 30, true) -- disable left/right
			DisableControlAction(0, 31, true) -- disable forward/back
			DisableControlAction(0, 36, true) -- INPUT_DUCK
			DisableControlAction(0, 21, true) -- disable sprint
			DisableControlAction(0, 44, true) -- disable cover
			DisableControlAction(0, 63, true) -- veh turn left
			DisableControlAction(0, 64, true) -- veh turn right
			DisableControlAction(0, 71, true) -- veh forward
			DisableControlAction(0, 72, true) -- veh backwards
			DisableControlAction(0, 75, true) -- disable exit vehicle
			DisablePlayerFiring(PlayerId(), true) -- Disable weapon firing
			DisableControlAction(0, 24, true) -- disable attack
			DisableControlAction(0, 25, true) -- disable aim
			DisableControlAction(1, 37, true) -- disable weapon select
			DisableControlAction(0, 47, true) -- disable weapon
			DisableControlAction(0, 58, true) -- disable weapon
			DisableControlAction(0, 140, true) -- disable melee
			DisableControlAction(0, 141, true) -- disable melee
			DisableControlAction(0, 142, true) -- disable melee
			DisableControlAction(0, 143, true) -- disable melee
			DisableControlAction(0, 263, true) -- disable melee
			DisableControlAction(0, 264, true) -- disable melee
			DisableControlAction(0, 257, true) -- disable melee
			Citizen.Wait(1)
		end
		disabling = false
	end)
end

function nearPlayer(dist)
	local peds = GetGamePool("CPed")
	local myCoords = GetEntityCoords(LocalPlayer.state.ped)
	for _, ped in ipairs(peds) do
		if ped ~= LocalPlayer.state.ped and IsPedAPlayer(ped) then
			local entCoords = GetEntityCoords(ped)
			if #(entCoords - myCoords) <= dist then
				return true
			end
		end
	end

	return false
end
