COMPONENTS.Core = {
	_required = { "Init" },
	_name = "base",
}

Citizen.CreateThread(function()
	LocalPlayer.state.PlayerID = PlayerId()
	StatSetInt(`MP0_STAMINA`, 25, true)

	AddStateBagChangeHandler(
		"isAdmin",
		string.format("player:%s", GetPlayerServerId(LocalPlayer.state.PlayerID)),
		function(bagName, key, value, _unused, replicated)
			if value then
				StatSetInt(`MP0_SHOOTING_ABILITY`, 100, true)
			else
				StatSetInt(`MP0_SHOOTING_ABILITY`, 5, true)
			end
		end
	)
end)

_baseThreading = false
function COMPONENTS.Core.Init(self)
	if _baseThreading then
		return
	end
	_baseThreading = true

	ShutdownLoadingScreenNui()
	ShutdownLoadingScreen()

	LocalPlayer.state.ped = PlayerPedId()
	LocalPlayer.state.myPos = GetEntityCoords(LocalPlayer.state.ped)
	LocalPlayer.state.inPauseMenu = IsPauseMenuActive()

	AddTextEntry("FE_THDR_GTAO", "~y~SandboxRP~m~")

	SetScenarioTypeEnabled("WORLD_VEHICLE_STREETRACE", false)
	SetScenarioTypeEnabled("WORLD_VEHICLE_SALTON_DIRT_BIKE", false)
	SetScenarioTypeEnabled("WORLD_VEHICLE_SALTON", false)
	SetScenarioTypeEnabled("WORLD_VEHICLE_POLICE_NEXT_TO_CAR", false)
	SetScenarioTypeEnabled("WORLD_VEHICLE_POLICE_CAR", false)
	SetScenarioTypeEnabled("WORLD_VEHICLE_POLICE_BIKE", false)
	SetScenarioTypeEnabled("WORLD_VEHICLE_MILITARY_PLANES_SMALL", false)
	SetScenarioTypeEnabled("WORLD_VEHICLE_MILITARY_PLANES_BIG", false)
	SetScenarioTypeEnabled("WORLD_VEHICLE_MECHANIC", false)
	SetScenarioTypeEnabled("WORLD_VEHICLE_EMPTY", false)
	SetScenarioTypeEnabled("WORLD_VEHICLE_BUSINESSMEN", false)
	SetScenarioTypeEnabled("WORLD_VEHICLE_BIKE_OFF_ROAD_RACE", false)
	SetStaticEmitterEnabled("LOS_SANTOS_VANILLA_UNICORN_01_STAGE", false)
	SetStaticEmitterEnabled("LOS_SANTOS_VANILLA_UNICORN_02_MAIN_ROOM", false)
	SetStaticEmitterEnabled("LOS_SANTOS_VANILLA_UNICORN_03_BACK_ROOM", false)
	SetStaticEmitterEnabled("collision_9qv4ecm", false) -- Tequila
	SetAudioFlag("DisableFlightMusic", true) -- disable flight music yay
	SetAudioFlag("PoliceScannerDisabled", true) -- disabled police scanners in vehicles

	AddScenarioBlockingArea(-3966.93, -3934.72, 200, 1429.366, -224.4396, 2000, false, true, true, true) -- Disable aircraft spawns

	local centerPoint = vector3(-1324.7, -800.07, 17.71) -- Disable banktruck_baycity
	local radiusSize = 180.0
	AddScenarioBlockingArea(centerPoint - radiusSize, centerPoint + radiusSize, false, true, true, true)
	AddPopMultiplierArea(centerPoint - radiusSize, centerPoint + radiusSize, 0.0, 0.0, false)
	SetPedNonCreationArea(centerPoint - radiusSize, centerPoint + radiusSize)

	local centerPoint = vector3(-45.6, -762.92, 32.93) -- Disable banktruck_sanandreas
	local radiusSize = 180.0
	AddScenarioBlockingArea(centerPoint - radiusSize, centerPoint + radiusSize, false, true, true, true)
	AddPopMultiplierArea(centerPoint - radiusSize, centerPoint + radiusSize, 0.0, 0.0, false)
	SetPedNonCreationArea(centerPoint - radiusSize, centerPoint + radiusSize)

	local centerPoint = vector3(-1191.12, -317.3, 37.86) -- Disable banktruck_boulevard_del_perro
	local radiusSize = 180.0
	AddScenarioBlockingArea(centerPoint - radiusSize, centerPoint + radiusSize, false, true, true, true)
	AddPopMultiplierArea(centerPoint - radiusSize, centerPoint + radiusSize, 0.0, 0.0, false)
	SetPedNonCreationArea(centerPoint - radiusSize, centerPoint + radiusSize)

	local centerPoint = vector3(-1555.09, -266.69, 54.93) -- Disable deathrow peds
	local radiusSize = 180.0
	AddScenarioBlockingArea(centerPoint - radiusSize, centerPoint + radiusSize, false, true, true, true)
	AddPopMultiplierArea(centerPoint - radiusSize, centerPoint + radiusSize, 0.0, 0.0, false)
	SetPedNonCreationArea(centerPoint - radiusSize, centerPoint + radiusSize)

	local centerPoint = vector3(558.14, -195.16, 50.44) -- Disable autoexotics peds
	local radiusSize = 180.0
	AddScenarioBlockingArea(centerPoint - radiusSize, centerPoint + radiusSize, false, true, true, true)
	AddPopMultiplierArea(centerPoint - radiusSize, centerPoint + radiusSize, 0.0, 0.0, false)
	SetPedNonCreationArea(centerPoint - radiusSize, centerPoint + radiusSize)

	local centerPoint = vector3(-737.56, -1504.55, 5.01) -- Disable dreamworks peds
	local radiusSize = 180.0
	AddScenarioBlockingArea(centerPoint - radiusSize, centerPoint + radiusSize, false, true, true, true)
	AddPopMultiplierArea(centerPoint - radiusSize, centerPoint + radiusSize, 0.0, 0.0, false)
	SetPedNonCreationArea(centerPoint - radiusSize, centerPoint + radiusSize)

	local centerPoint = vector3(-1148.49, -2863.15, 13.96) -- Disable Airport helipads
	local radiusSize = 180.0
	AddScenarioBlockingArea(centerPoint - radiusSize, centerPoint + radiusSize, false, true, true, true)
	AddPopMultiplierArea(centerPoint - radiusSize, centerPoint + radiusSize, 0.0, 0.0, false)
	SetPedNonCreationArea(centerPoint - radiusSize, centerPoint + radiusSize)

	Citizen.CreateThread(function()
		while _baseThreading do
			Citizen.Wait(1000)
			local ped = PlayerPedId()
			if ped ~= LocalPlayer.state.ped then
				LocalPlayer.state.ped = ped
				SetEntityProofs(LocalPlayer.state.ped, false, false, false, false, false, true, false, false)
				SetPedDropsWeaponsWhenDead(LocalPlayer.state.ped, false)
				SetPedAmmoToDrop(LocalPlayer.state.ped, 0)

				if GetEntityMaxHealth(ped) ~= 200 then
					SetEntityMaxHealth(ped, 200)
				end
			end
		end
	end)

	Citizen.CreateThread(function()
		while _baseThreading do
			Citizen.Wait(60000)
			collectgarbage("collect")
		end
	end)

	Citizen.CreateThread(function()
		while _baseThreading do
			Citizen.Wait(100)
			LocalPlayer.state.myPos = GetEntityCoords(LocalPlayer.state.ped)
			LocalPlayer.state.inPauseMenu = IsPauseMenuActive()
		end
	end)

	Citizen.CreateThread(function()
		while _baseThreading do
			if NetworkIsPlayerActive(PlayerId()) then
				TriggerEvent("Core:Client:SessionStarted")
				TriggerServerEvent("Core:Server:SessionStarted")
				break
			end
			Citizen.Wait(100)
		end
	end)

	Citizen.CreateThread(function()
		while _baseThreading do
			SetRadarZoom(1200) -- 1200

			if not LocalPlayer.state.wepTest then
				SetVehicleDensityMultiplierThisFrame(0.2)
				SetPedDensityMultiplierThisFrame(0.8)
				SetRandomVehicleDensityMultiplierThisFrame(0.2)
				SetParkedVehicleDensityMultiplierThisFrame(0.5)
				SetScenarioPedDensityMultiplierThisFrame(0.8, 0.8)
			end
			NetworkSetFriendlyFireOption(true)

			if IsPedInCover(LocalPlayer.state.ped, 0) and not IsPedAimingFromCover(LocalPlayer.state.ped) then
				DisablePlayerFiring(LocalPlayer.state.ped, true)
			end

			-- should disable any vehicle rewards
			DisablePlayerVehicleRewards(LocalPlayer.state.ped)

			-- set lockrange to 2.0
			SetPlayerLockonRangeOverride(LocalPlayer.state.PlayerID, 2.0)

			-- should disable headshots
			-- SetPedSuffersCriticalHits(PlayerPedId(), false)

			-- disable distance cop sirens
			DistantCopCarSirens(false)

			Citizen.Wait(1)
		end
	end)

	Citizen.CreateThread(function()
		while _baseThreading do
			SetRadarBigmapEnabled(false, false)
			DisableControlAction(0, 14, true)
			DisableControlAction(0, 15, true)
			DisableControlAction(0, 16, true)
			DisableControlAction(0, 17, true)
			DisableControlAction(0, 37, true)
			DisableControlAction(0, 99, true)
			DisableControlAction(0, 100, true)
			DisableControlAction(0, 116, true)
			DisableControlAction(0, 157, true)
			DisableControlAction(0, 158, true)
			DisableControlAction(0, 159, true)
			DisableControlAction(0, 160, true)
			DisableControlAction(0, 161, true)
			DisableControlAction(0, 162, true)
			DisableControlAction(0, 163, true)
			DisableControlAction(0, 164, true)
			DisableControlAction(0, 165, true)
			DisableControlAction(0, 261, true)
			DisableControlAction(0, 262, true)
			HideHudComponentThisFrame(1)
			HideHudComponentThisFrame(7)
			HideHudComponentThisFrame(9)
			HideHudComponentThisFrame(6)
			HideHudComponentThisFrame(8)
			HideHudComponentThisFrame(19)
			HideHudComponentThisFrame(20)
			--DontTiltMinimapThisFrame()

			Citizen.Wait(1)
		end
	end)

	Citizen.CreateThread(function()
		while _baseThreading do
			InvalidateIdleCam()
			InvalidateVehicleIdleCam()
			Wait(25000)
		end
	end)

	Citizen.CreateThread(function()
		for i = 1, 25 do
			EnableDispatchService(i, false)
		end

		while _baseThreading do
			local ped = PlayerPedId()
			SetPedHelmet(ped, false)
			SetPedConfigFlag(ped, 438, true)
			if IsPedInAnyVehicle(ped, false) then
				if GetPedInVehicleSeat(GetVehiclePedIsIn(ped, false), 0) == ped then
					SetPedConfigFlag(ped, 184, true)
					if GetIsTaskActive(ped, 165) then
						SetPedIntoVehicle(ped, GetVehiclePedIsIn(ped, false), 0)
					end
				end
			end

			SetMaxWantedLevel(0)
			SetCreateRandomCopsNotOnScenarios(false)
			SetCreateRandomCops(false)
			SetCreateRandomCopsOnScenarios(false)

			Citizen.Wait(2)
		end
	end)

	Citizen.CreateThread(function()
		while _baseThreading do
			Citizen.Wait(500)
			local ped = PlayerPedId()
			if not IsPedInAnyVehicle(ped, false) then
				if IsPedUsingActionMode(ped) then
					SetPedUsingActionMode(ped, -1, -1, 1)
				end
			else
				Citizen.Wait(3000)
			end
		end
	end)

	Citizen.CreateThread(function()
		local resetcounter = 0
		local jumpDisabled = false

		while _baseThreading do
			Citizen.Wait(100)
			if jumpDisabled and resetcounter > 0 and IsPedJumping(PlayerPedId()) then
				SetPedToRagdoll(PlayerPedId(), 1000, 1000, 3, 0, 0, 0)
				resetcounter = 0
			end

			if not jumpDisabled and IsPedJumping(PlayerPedId()) then
				jumpDisabled = true
				resetcounter = 10
				Citizen.Wait(1200)
			end

			if resetcounter > 0 then
				resetcounter = resetcounter - 1
			else
				if jumpDisabled then
					resetcounter = 0
					jumpDisabled = false
				end
			end
		end
	end)
end

Citizen.CreateThread(function()
	while not exports or exports[GetCurrentResourceName()] == nil do
		Citizen.Wait(1)
	end

	local ped = PlayerPedId()
	FreezeEntityPosition(ped, true)
	SetEntityVisible(ped, false)
	SetPlayerVisibleLocally(ped, false)

	DoScreenFadeOut(500)
	while IsScreenFadingOut() do
		Citizen.Wait(1)
	end

	COMPONENTS.Core:Init()

	TriggerEvent("Proxy:Shared:RegisterReady")
	for k, v in pairs(COMPONENTS) do
		TriggerEvent("Proxy:Shared:ExtendReady", k)
	end

	Citizen.Wait(1000)

	COMPONENTS.Proxy.ExportsReady = true
	TriggerEvent("Core:Shared:Ready")
	return
end)

AddEventHandler("onResourceStopped", function(resourceName)
	TriggerServerEvent("Core:Server:ResourceStopped", resourceName)
end)
