local _gJobs = {
	police = 3000,
	ems = 1500,
}

function DoEscort()
	local cPlayer, Dist = Game.Players:GetClosestPlayer()
	local tarPlayer = GetPlayerServerId(cPlayer)
	local closeDist = 1
	if IsPedSwimming(LocalPlayer.state.ped) then
		LocalPlayer.state.isSwimAttemptEscort = true
		closeDist = 15
	else
		LocalPlayer.state.isSwimAttemptEscort = false
	end

	if LocalPlayer.state.myEscorter == nil and not LocalPlayer.state.isDead then
		if tarPlayer ~= 0 and Dist <= closeDist then
			local tState = Player(tarPlayer).state
			if
				LocalPlayer.state.isEscorting == nil
				and not IsPedInAnyVehicle(LocalPlayer.state.ped, true)
				and not IsPedInAnyVehicle(GetPlayerPed(tarPlayer), true)
				and not Hud:IsDisabledAllowDead()
				and not tState.isHospitalized
				and (tState.isEscorting == nil and tState.myEscorter == nil)
			then
				Escort:DoEscort(tarPlayer, cPlayer)
			elseif LocalPlayer.state.isEscorting ~= nil then
				Escort:StopEscort()
			end
		end
	end
end

function StartEscortThread(t)
	while LocalPlayer.state.isEscorting == nil do
		Citizen.Wait(10)
	end

	Citizen.CreateThread(function()
		local ped = GetPlayerPed(t)
		local myped = PlayerPedId()

		while LocalPlayer.state.isEscorting ~= nil do
			if (not LocalPlayer.state.onDuty or (LocalPlayer.state.onDuty ~= "ems")) and not IsPedSwimming(ped) then
				DisableControlAction(1, 21, true) -- Sprint
			end
			DisableControlAction(1, 23, true) -- F
			Citizen.Wait(5)
		end
	end)

	Citizen.CreateThread(function()
		local ped = GetPlayerPed(t)

		while LocalPlayer.state.isEscorting ~= nil do
			Citizen.Wait(500)
            if not DoesEntityExist(ped) then
                Escort:StopEscort()
            end
		end
	end)
end

RegisterNetEvent("Escort:Client:Escorted", function()
	_fuckSake = true
	while LocalPlayer.state.myEscorter == nil do
		Citizen.Wait(10)
	end

	if LocalPlayer.state.isCuffed then
		TriggerEvent("Handcuffs:Client:DoShittyAnim")
	end

	if LocalPlayer.state.sitting then
		TriggerEvent("Animations:Client:StandUp", true)
	end

	if LocalPlayer.state.doingAction then
		Progress:Cancel()
	end

	Citizen.CreateThread(function()
		local ped = GetPlayerPed(GetPlayerFromServerId(LocalPlayer.state.myEscorter))
		local myped = PlayerPedId()

		while not DoesEntityExist(ped) do
			Citizen.Wait(1)
			ped = GetPlayerPed(GetPlayerFromServerId(LocalPlayer.state.myEscorter))
		end

		local correctedZ = 0
		local escortermodel = GetEntityModel(ped)
		if escortermodel == `sandbox_k9_shepherd` then
			correctedZ = 0.5
		end

		AttachEntityToEntity(
			LocalPlayer.state.ped,
			ped,
			11816,
			0.54,
			0.44,
			0.0 + correctedZ,
			0.0,
			0.0,
			0.0,
			false,
			false,
			false,
			false,
			2,
			true
		)
		while LocalPlayer.state.myEscorter ~= nil do
			DisableControlAction(1, 21, true) -- Sprint
			DisableControlAction(1, 22, true) -- Jump
			DisableControlAction(1, 23, true) -- F
			Citizen.Wait(5)
		end
		DetachEntity(LocalPlayer.state.ped, true, true)
	end)
end)

AddEventHandler("Escort:Client:PutIn", function(entity, data)
	Callbacks:ServerCallback("Escort:DoPutIn", {
		veh = NetworkGetNetworkIdFromEntity(entity.entity),
		class = GetVehicleClass(entity.entity),
		seatCount = GetVehicleModelNumberOfSeats(GetEntityModel(entity.entity)),
	}, function(state) end)
end)

AddEventHandler("Escort:Client:PullOut", function(entity, data)
	local vehmodel = GetEntityModel(entity.entity)
    local vehClass = GetVehicleClass(entity.entity)

    local targetSeat = nil
    local targetPed = nil

    if vehClass == 18 then
        -- Favour Highest Back Seats First
        for i = GetVehicleModelNumberOfSeats(vehmodel), -1, -1 do
            local ent = GetPedInVehicleSeat(entity.entity, i)
            if ent ~= 0 then
                targetSeat = i
                targetPed = ent
                break
            end
        end
    else
        for i = -1, GetVehicleModelNumberOfSeats(vehmodel) do
            local ent = GetPedInVehicleSeat(entity.entity, i)
            if ent ~= 0 then
                targetSeat = i
                targetPed = ent
                break
            end
        end
    end

    if targetSeat and targetPed then
        local dur = 5000
        if _gJobs[LocalPlayer.state.onDuty] ~= nil then
            dur = _gJobs[LocalPlayer.state.onDuty]
        end

        Progress:ProgressWithTickEvent({
            name = "unseat",
            duration = dur,
            label = "Unseating",
            useWhileDead = false,
            canCancel = true,
            animation = false,
            ignoreModifier = true,
            controlDisables = {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            },
        }, function()
            if
                #(GetEntityCoords(LocalPlayer.state.ped) - GetEntityCoords(entity.entity)) <= 5.0
                and GetPedInVehicleSeat(entity.entity, targetSeat) == targetPed
            then
                return
            end
            Progress:Cancel()
        end, function(cancelled)
            if not cancelled then
                local playerId = NetworkGetPlayerIndexFromPed(targetPed)
                Escort:DoEscort(GetPlayerServerId(playerId), playerId)
            end
        end)
    end
end)
