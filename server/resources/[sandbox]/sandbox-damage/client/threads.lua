_hasKO = false
local _lastDamage = {
    hash = 0,
    source = 0,
    melee = false
}

local damageHistory = {}
local wasDamaged = false

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

local hasBled = false
AddEventHandler("Damage:Client:Triggers:EntityDamaged", function(victim, attacker, pWeapon, isMelee)
    if victim ~= PlayerPedId() then return end

    if LocalPlayer.state.isAdmin and LocalPlayer.state.isGodmode then
        return
    end

    local hit, bone = GetPedLastDamageBone(victim)

	table.insert(damageHistory, {
        hash = pWeapon,
        source = attacker,
        melee = isMelee,
        bone = bone,
    })

	wasDamaged = true

	local armor = GetPedArmour(PlayerPedId())

	if not hasBled and armor <= 0 then
		hasBled = true
		TriggerEvent('Evidence:Client:BleedOnFloor')
		SetTimeout(1000 * 30, function()
			hasBled = false
		end)
	end
	
    -- Execute
    if LocalPlayer.state?.isDead and LocalPlayer.state.deadData?.isMinor and Config.Weapons[pWeapon]?.violent then
		LocalPlayer.state:set("isDead", true, true)
		local deadTime = GetCloudTimeAsInt()
		local releaseTime = deadTime + GetReleaseTime(isMinor)
		LocalPlayer.state:set("deadData", {
			isMinor = false,
		}, true)
		LocalPlayer.state:set("isDeadTime", deadTime, true)
		LocalPlayer.state:set("releaseTime", releaseTime, true)
		Hud.DeathTexts:Hide()
		Hud.DeathTexts:Show("death", deadTime, releaseTime)

		TriggerEvent("Ped:Client:Died")
		TriggerServerEvent("Ped:Server:Died")

		DoDeadEvent()
    end
end)

AddEventHandler("Keybinds:Client:KeyUp:secondary_action", function()
	if (LocalPlayer.state.isDead and not LocalPlayer.state.isHospitalized) and GetCloudTimeAsInt() > LocalPlayer.state.releaseTime and not _respawning then
		_respawning = true
		TriggerServerEvent("Escort:Server:ForceStop")

        Hud.DeathTexts:Release()
		if not LocalPlayer.state.deadData?.isMinor then
			Progress:Progress({
				name = "hospital_action",
				duration = 10000,
				label = "Respawning",
				useWhileDead = true,
				canCancel = true,
				ignoreModifier = true,
				controlDisables = {
					disableMovement = true,
					disableCarMovement = true,
					disableMouse = false,
					disableCombat = true,
				},
				animation = false,
			}, function(status)
				if not status then
					Callbacks:ServerCallback("Hospital:Respawn", {}, function(bedId)
						if bedId ~= nil then
							TriggerServerEvent("Escort:Server:ForceStop")
							_sendToHosp = bedId
							LocalPlayer.state:set("isHospitalized", true, true)
							Citizen.Wait(250)
							Hospital:SendToBed(Config.Beds[_sendToHosp], false, bedId)
						else
							Notification:Error("Unable To Respawn Yet, Please Wait")
						end
					end)
				else
                    Hud.DeathTexts:Show(LocalPlayer.state.deadData?.isMinor and "knockout" or "death", LocalPlayer.state.isDeadTime, LocalPlayer.state.releaseTime)
				end
				_respawning = false
			end)
		else
			Damage:Revive()
			_respawning = false
		end
	end
end)

RegisterNetEvent("Damage:Client:Ticks:Heal", function()
	Buffs:ApplyUniqueBuff("heal_ticks", #LocalPlayer.state.healTicks * 10, false, {
		customMax = #LocalPlayer.state.healTicks * 10,
	})
end)

RegisterNetEvent("Damage:Client:Ticks:Armor", function()
	Buffs:ApplyUniqueBuff("armor_ticks", #LocalPlayer.state.armorTicks * 10, false, {
		customMax = #LocalPlayer.state.armorTicks * 10,
	})
end)

function StartThreads()
	Citizen.CreateThread(function()
		while LocalPlayer.state.loggedIn do
			if wasDamaged then
				TriggerServerEvent("Damage:Server:BoneDamage", damageHistory)
				damageHistory = {}
				wasDamaged = false
			end
			Citizen.Wait(60000)
		end
	end)
	
	LocalPlayer.state.regenRate = 0.0

    Citizen.CreateThread(function()
        while LocalPlayer.state.loggedIn do
            if GetPedStealthMovement(PlayerPedId()) then
                SetPedStealthMovement(PlayerPedId(), 0, 0)
            end
            Citizen.Wait(20)
        end
    end)

	local lastHp = 0
	local lastArmor = 0
    Citizen.CreateThread(function()
        local sid = LocalPlayer.state.Character:GetData("SID")
        while LocalPlayer.state.loggedIn do
            Citizen.Wait((1000 * 60) * 1)
            if LocalPlayer.state.Character ~= nil and sid == LocalPlayer.state.Character:GetData("SID") then
				local hp = GetEntityHealth(LocalPlayer.state.ped)
				local armor = GetPedArmour(LocalPlayer.state.ped)
				if hp ~= lastHp or armor ~= lastArmor then
					lastHp = hp
					lastArmor = armor
					TriggerServerEvent("Damage:Server:StoreHealth", hp, armor)
				end
            end
        end
    end)

	Citizen.CreateThread(function()
		while LocalPlayer.state.loggedIn do
			if not LocalPlayer.state.inCreator then
				Citizen.Wait(10000)
				local max = GetEntityMaxHealth(LocalPlayer.state.ped) - 100

				local s10 = math.ceil(max * 0.10)
				local s25 =math.ceil(max * 0.25)
				local s50 = math.ceil(max * 0.50)

				local myhp = GetEntityHealth(LocalPlayer.state.ped) - 100
				if myhp <= s10 then
					SetFlash(0, 0, 500, math.random(10) * 1000, 500)
				elseif myhp <= s25 then
					SetFlash(0, 0, 500, math.random(5) * 1000, 500)
				elseif myhp <= s50 then
					SetFlash(0, 0, 500, math.random(2) * 1000, 500)
				else
					SetFlash(0, 0, 1, 0, 1)
				end
			else
				Citizen.Wait(30000)
			end
		end
	end)

	local doingthedead = false
	Citizen.CreateThread(function()
		while LocalPlayer.state.loggedIn do
            if not LocalPlayer.state.isDead then
                local player = PlayerPedId()
                if not (LocalPlayer.state.isAdmin and LocalPlayer.state.isGodmode) and IsEntityDead(player) and not doingthedead then
					doingthedead = true
                    local deathHash = GetPedCauseOfDeath(player)
                    if not deathHash or deathHash == 0 then deathHash = _lastDamage.hash end
                    local deathSource = GetPedSourceOfDeath(player)
                    if not deathSource or deathSource == 0 then deathSource = _lastDamage.source end

                    local isMinor = wasMinorDeath(deathHash)

					if not LocalPlayer.state.gameMode then
						if isMinor and _reductions < 6 then
							DAMAGE.Reductions:Increase(1)
						else
							isMinor = false
						end
					end

                    LocalPlayer.state:set("isDead", true, true)

                    local deadTime = GetCloudTimeAsInt()
                    local releaseTime = deadTime + GetReleaseTime(isMinor)

                    LocalPlayer.state:set("deadData", {
                        isMinor = isMinor,
                    }, true)
                    LocalPlayer.state:set("isDeadTime", deadTime, true)
                    LocalPlayer.state:set("releaseTime", releaseTime, true)
					Hud.DeathTexts:Show(isMinor and "knockout" or "death", deadTime, releaseTime)

                    while not LocalPlayer.state.isDead do
                        Citizen.Wait(1)
                    end
                
                    TriggerEvent("Ped:Client:Died")
                    TriggerServerEvent("Ped:Server:Died")
                
                    if (Jail:IsJailed() or not nearPlayer(100.0)) and not Config.Weapons[deathHash]?.minor then
                        TriggerServerEvent("EmergencyAlerts:Server:DoPredefined", "injuredPerson")
                    end
                    Hud:Dead(true)
                    DoDeadEvent()
                    --respawnCd(isMinor)
					doingthedead = false
                end
            else

            end
            Citizen.Wait(100)
		end
	end)

    Citizen.CreateThread(function()
		if _healTickRunning then
			return
		end
		_healTickRunning = true
		while LocalPlayer.state.loggedIn do
			if LocalPlayer.state.healTicks ~= nil then
				local chp = GetEntityHealth(LocalPlayer.state.ped)
				local max = GetEntityMaxHealth(LocalPlayer.state.ped)

				if chp >= max then
					Buffs:RemoveBuffType("heal_ticks")
					LocalPlayer.state:set("healTicks", nil, true)
				else
					local heal = LocalPlayer.state.healTicks[1] or 0
					if chp + heal > max then
						heal = max - chp
					end

					if chp + heal <= max then
						Logger:Trace(
							"Damage",
							string.format("Heal Tick: %s (Original: %s)", heal, LocalPlayer.state.healTicks[1])
						)
						SetEntityHealth(LocalPlayer.state.ped, chp + heal)

						if chp + heal >= max then
							Buffs:RemoveBuffType("heal_ticks")
						end
					end

					local t = LocalPlayer.state.healTicks
					table.remove(t, 1)
					if #t > 0 then
						LocalPlayer.state:set("healTicks", t, true)
					else
						Buffs:RemoveBuffType("heal_ticks")
						LocalPlayer.state:set("healTicks", nil, true)
					end
				end
				Citizen.Wait(10000)
			else
				Citizen.Wait(2000)
			end
		end
		_healTickRunning = false
	end)

	Citizen.CreateThread(function()
		if _armrTickRunning then
			return
		end
		_armrTickRunning = true
		while LocalPlayer.state.loggedIn do
			if LocalPlayer.state.armorTicks ~= nil then
				local car = GetPedArmour(LocalPlayer.state.ped)
				local max = GetPlayerMaxArmour(LocalPlayer.state.PlayerID)

				if car >= max then
					Buffs:RemoveBuffType("armor_ticks")
					LocalPlayer.state:set("armorTicks", nil, true)
				else
					local gen = LocalPlayer.state.armorTicks[1] or 0
					if car + gen > max then
						gen = max - car
					end

					if car + gen <= max then
						Logger:Trace(
							"Damage",
							string.format("Armor Tick: %s (Original: %s)", gen, LocalPlayer.state.armorTicks[1])
						)
						SetPedArmour(LocalPlayer.state.ped, car + gen)

						if chp + heal >= max then
							Buffs:RemoveBuffType("armor_ticks")
						end
					end

					local t = LocalPlayer.state.armorTicks
					table.remove(t, 1)
					if #t > 0 then
						LocalPlayer.state:set("armorTicks", t, true)
					else
						Buffs:RemoveBuffType("armor_ticks")
						LocalPlayer.state:set("armorTicks", nil, true)
					end
				end
				Citizen.Wait(10000)
			else
				Citizen.Wait(2000)
			end
		end
		_armrTickRunning = false
	end)

	Citizen.CreateThread(function()
		while LocalPlayer.state.loggedIn do
			if LocalPlayer.state.isLimping then
				local luck = math.random(100)
				if
					(IsPedJumping(LocalPlayer.state.ped) and luck <= 85)
					or (IsPedSprinting(LocalPlayer.state.ped) and luck <= 4)
				then
					SetPedToRagdoll(LocalPlayer.state.ped, 1500, 2000, 3, true, true, false)
				end

				Citizen.Wait(100)
			else
				Citizen.Wait(2500)
			end
		end
	end)
    
    Citizen.CreateThread(function()
		while LocalPlayer.state.loggedIn do
            if LocalPlayer.state.onPainKillers ~= nil and LocalPlayer.state.onPainKillers > 0 then
				LocalPlayer.state.onPainKillers = LocalPlayer.state.onPainKillers - 1
			elseif LocalPlayer.state.wasOnPainKillers then
				LocalPlayer.state.wasOnPainKillers = false
				-- SetPedToRagdoll(LocalPlayer.state.ped, 1500, 2000, 3, true, true, false)
				-- Notification:Custom(Config.Strings.PainKillersExpired, 5000, "pills", Config.NotifStyle)
			end

			if LocalPlayer.state.onDrugs ~= nil and LocalPlayer.state.onDrugs > 0 then
				LocalPlayer.state.onDrugs = LocalPlayer.state.onDrugs - 1
			elseif LocalPlayer.state.wasOnDrugs then
				LocalPlayer.state.wasOnDrugs = false
				-- SetPedToRagdoll(LocalPlayer.state.ped, 1500, 2000, 3, true, true, false)
				-- Notification:Custom(Config.Strings.AdrenalineExpired, 5000, "pills", Config.NotifStyle)
			end
            
			ApplyLimp(LocalPlayer.state.ped)
			Citizen.Wait(200)
		end
	end)

    Citizen.CreateThread(function()
        while LocalPlayer.state.loggedIn do
            SetPlayerHealthRechargeMultiplier(LocalPlayer.state.PlayerID, LocalPlayer.state.regenRate)
            Citizen.Wait(250)
        end
    end)
end
