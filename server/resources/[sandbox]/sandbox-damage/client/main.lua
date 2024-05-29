_reductions = 0

AddEventHandler("Damage:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Callbacks = exports["sandbox-base"]:FetchComponent("Callbacks")
	Damage = exports["sandbox-base"]:FetchComponent("Damage")
	Logger = exports["sandbox-base"]:FetchComponent("Logger")
	Notification = exports["sandbox-base"]:FetchComponent("Notification")
	Hud = exports["sandbox-base"]:FetchComponent("Hud")
	Buffs = exports["sandbox-base"]:FetchComponent("Buffs")
	Targeting = exports["sandbox-base"]:FetchComponent("Targeting")
	Status = exports["sandbox-base"]:FetchComponent("Status")
	--Hospital = exports["sandbox-base"]:FetchComponent("Hospital")
	Progress = exports["sandbox-base"]:FetchComponent("Progress")
	EmergencyAlerts = exports["sandbox-base"]:FetchComponent("EmergencyAlerts")
	PedInteraction = exports["sandbox-base"]:FetchComponent("PedInteraction")
	Keybinds = exports["sandbox-base"]:FetchComponent("Keybinds")
	Jail = exports["sandbox-base"]:FetchComponent("Jail")
	Sounds = exports["sandbox-base"]:FetchComponent("Sounds")
	Animations = exports["sandbox-base"]:FetchComponent("Animations")
	Weapons = exports["sandbox-base"]:FetchComponent("Weapons")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["sandbox-base"]:RequestDependencies("Damage", {
		"Callbacks",
		"Damage",
		"Logger",
		"Notification",
		"Hud",
        "Buffs",
		"Targeting",
		"Status",
		--"Hospital",
		"Progress",
		"EmergencyAlerts",
		"PedInteraction",
		"Keybinds",
		"Jail",
		"Sounds",
		"Animations",
        "Weapons",
	}, function(error)
		if #error > 0 then
			return
		end
		RetrieveComponents()

        Callbacks:RegisterClientCallback("Damage:Heal", function(s)
            if s then
                LocalPlayer.state.deadData = {}
                Damage.Reductions:Reset()
            end
            Damage:Revive()
        end)

        Callbacks:RegisterClientCallback("Damage:FieldStabalize", function(s)
            Damage:Revive(true)
        end)

        Callbacks:RegisterClientCallback("Damage:Kill", function()
            ApplyDamageToPed(LocalPlayer.state.ped, 10000)
        end)

        Callbacks:RegisterClientCallback("Damage:Admin:Godmode", function(s)
            if s then
                Buffs:ApplyBuff("godmode")
            else
                Buffs:RemoveBuffType("godmode")
            end
        end)
	end)
end)

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["sandbox-base"]:RegisterComponent("Damage", DAMAGE)
end)

RegisterNetEvent("Characters:Client:Spawned", function()
    StartThreads()
    
    Buffs:RegisterBuff("weakness", "face-head-bandage", "#FF0049", -1, "permanent")
    Buffs:RegisterBuff("godmode", "shield-quartered", "#FFBB04", -1, "permanent")

    _reductions = LocalPlayer.state.Character:GetData("HPReductions") or 0
    if _reductions > 0 then
        Buffs:ApplyUniqueBuff("weakness", -1)
    else
        Buffs:RemoveBuffType("weakness")
    end
    Damage:CalculateMaxHp()

    if LocalPlayer.state.isDead then
        Hud.DeathTexts:Show(LocalPlayer.state.deadData?.isMinor and "knockout" or "death", LocalPlayer.state.isDeadTime, LocalPlayer.state.releaseTime)
        Hud:Dead(true)
        DoDeadEvent()
    end
end)

RegisterNetEvent("Characters:Client:Logout", function()
    if LocalPlayer.state.isDead then
        AnimpostfxStop("DeathFailMPIn")
        Hud.DeathTexts:Hide()
        ClearPedTasksImmediately(ped)

        LocalPlayer.state:set("isDead", false, true)
        LocalPlayer.state:set("deadData", false, true)
        LocalPlayer.state:set("isDeadTime", false, true)
        LocalPlayer.state:set("releaseTime", false, true)
    end

    Buffs:RemoveBuffType("weakness")
end)

RegisterNetEvent('UI:Client:Reset', function(apps)
    if not LocalPlayer.state.isDead and not LocalPlayer.state.isHospitalized then
        Hud.DeathTexts:Hide()
        Hud:Dead(false)
        if _reductions > 0 then
			Buffs:ApplyUniqueBuff("weakness", -1)
        else
			Buffs:RemoveBuffType("weakness")
        end
    end
end)

DAMAGE = {
    Reductions = {
        Increase = function(self, amt)
            _reductions += amt
			Buffs:ApplyUniqueBuff("weakness", -1)
            Callbacks:ServerCallback("Damage:SyncReductions", _reductions)
            Damage:CalculateMaxHp()
        end,
        Reset = function(self)
            _reductions = 0
			Buffs:RemoveBuffType("weakness")
            Callbacks:ServerCallback("Damage:SyncReductions", _reductions)
            Damage:CalculateMaxHp()
        end,
    },
    CalculateMaxHp = function(self)
        local ped = PlayerPedId()
        local curr = GetEntityHealth(ped)
        local currMax = GetEntityMaxHealth(ped)

        local mod = 0.25 * _reductions
        if mod > 0.8 then
            mod = 0.8
        end

        local newMax = 100 + math.ceil(100 * (1.0 - mod))

        SetEntityMaxHealth(ped, newMax)

        local newHp = curr
        if curr > newMax then
            SetEntityHealth(ped, newMax)
        end

        Hud:ForceHP()
    end,
    WasDead = function(self, sid)
        return _deadCunts[sid] ~= nil
    end,
    Revive = function(self, fieldTreat)
        local player = PlayerPedId()

        if LocalPlayer.state.isDead then
            DoScreenFadeOut(1000)
            while not IsScreenFadedOut() do
                Citizen.Wait(10)
            end
        end

        local wasDead = LocalPlayer.state.isDead
        local wasMinor = LocalPlayer.state.deadData?.isMinor

        if LocalPlayer.state.isDead then
            LocalPlayer.state:set("isDead", false, true)
        end
        if LocalPlayer.state.deadData then
            LocalPlayer.state:set("deadData", false, true)
        end
        if LocalPlayer.state.isDeadTime then
            LocalPlayer.state:set("isDeadTime", false, true)
        end
        if LocalPlayer.state.releaseTime then
            LocalPlayer.state:set("releaseTime", false, true)
        end

        local veh = GetVehiclePedIsIn(player)
        local seat = 0
		if veh ~= 0 then
			local m = GetEntityModel(veh)
			for k = -1, GetVehicleModelNumberOfSeats(m) do
				if GetPedInVehicleSeat(veh, k) == player then
					seat = k
				end
			end
		end

        -- if IsPedDeadOrDying(player) then
        --     local loc = GetEntityCoords(player)
        --     NetworkResurrectLocalPlayer(loc, true, true, false)
        -- end

		if veh == 0 then
			--ClearPedTasksImmediately(player)
		else
			Citizen.Wait(300)
			TaskWarpPedIntoVehicle(player, veh, seat)
			Citizen.Wait(300)
		end

        TriggerServerEvent("Damage:Server:Revived", wasMinor, fieldTreat)
        Hud:Dead(false)

        if not LocalPlayer.state.isHospitalized and wasDead then
            Hud.DeathTexts:Hide()
            SetEntityInvincible(player, LocalPlayer.state.isAdmin and LocalPlayer.state.isGodmode or false)
        end

        if _reductions > 0 then
			Buffs:ApplyUniqueBuff("weakness", -1)
        else
			Buffs:RemoveBuffType("weakness")
        end

        
        local mod = 0.25 * _reductions
        if mod > 0.8 then
            mod = 0.8
        end
        local newMax = 100 + math.ceil(100 * (1.0 - mod))

        SetEntityHealth(player, newMax)
        SetPlayerSprint(PlayerId(), true)
        ClearPedBloodDamage(player)

        if not fieldTreat then
            Status:Reset()
        end

        DoScreenFadeIn(1000)

        if not LocalPlayer.state.isHospitalized and wasDead and veh == 0 then
            Animations.Emotes:Play("reviveshit", false, 1750, true)
        end
    end,
	Died = function(self)

	end,
	Apply = {
		StandardDamage = function(self, value, armorFirst, forceKill)
            if forceKill and not _hasKO then
                _hasKO = true
            end
            
			ApplyDamageToPed(LocalPlayer.state.ped, value, armorFirst)
		end,
    }
}