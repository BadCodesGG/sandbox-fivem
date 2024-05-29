local cam = nil

local foTo = 0
function FadeOutWithTimeout(time, timeOut)
	DoScreenFadeOut(time or 500)
	foTo = 0
	while IsScreenFadingOut() and foTo < (timeOut or 3000) do
		foTo += 1
		Citizen.Wait(1)
	end
end

local fiTo = 0
function FadeInWithTimeout(time, timeOut)
	DoScreenFadeIn(time or 500)
	fiTo = 0
	while IsScreenFadingIn() and fiTo < (timeOut or 3000) do
		fiTo += 1
		Citizen.Wait(1)
	end
end

Spawn = {
	Choosing = true,
	InitCamera = function(self)
		
		if not IsScreenFadedOut() then
			FadeOutWithTimeout(500)
		end

		local ped = PlayerPedId()
		TriggerEvent("PAC:IgnoreNextNoclipFlag")
		SetEntityCoords(ped, -972.756, -2701.553, 41.45)
		FreezeEntityPosition(ped, true)
		SetEntityVisible(ped, false)
		SetPlayerVisibleLocally(ped, false)

		TransitionToBlurred(500)
		cam = CreateCamWithParams(
			"DEFAULT_SCRIPTED_CAMERA",
			-972.756,
			-2701.553,
			41.45,
			-12.335,
			0.000,
			118.395,
			100.00,
			false,
			0
		)
		SetCamActiveWithInterp(cam, true, 900, true, true)
		RenderScriptCams(true, false, 1, true, true)
		DisplayRadar(false)
	end,
	Init = function(self)
		FadeInWithTimeout(500)
		Citizen.Wait(500) -- Why the fuck does NUI just not do this without a wait here???
		SetNuiFocus(true, true)
		SendNUIMessage({ type = "APP_SHOW" })
	end,
	SpawnToWorld = function(self, data, cb)
		FadeOutWithTimeout(500)

		local player = PlayerPedId()
		SetTimecycleModifier("default")

		local model = `mp_f_freemode_01`
		if tonumber(data.Gender) == 0 then
			model = `mp_m_freemode_01`
		end

		RequestModel(model)

		while not HasModelLoaded(model) do
			Citizen.Wait(500)
		end
		SetPlayerModel(PlayerId(), model)
		player = PlayerPedId()
		SetPedDefaultComponentVariation(player)
		SetEntityAsMissionEntity(player, true, true)
		SetModelAsNoLongerNeeded(model)

		-- Safety check I guess
		while not IsEntityFocus(player) do
			ClearFocus()
			Citizen.Wait(1)
		end

		Citizen.Wait(300)

		DestroyAllCams(true)
		RenderScriptCams(false, true, 1, true, true)
		FreezeEntityPosition(player, false)

		NetworkSetEntityInvisibleToNetwork(player, false)
		SetEntityVisible(player, true)
		FreezeEntityPosition(player, false)

		cam = nil

		SetPlayerInvincible(PlayerId(), false)
		SetCanAttackFriendly(player, true, true)
		NetworkSetFriendlyFireOption(true)

		SetEntityMaxHealth(player, 200)
		SetEntityHealth(player, data.HP > 100 and data.HP or 200)
		DisplayHud(true)

		TriggerEvent("PAC:IgnoreNextNoclipFlag")
		if data.action ~= nil then
			TriggerEvent(data.action, data.data)
		else
			SetEntityCoords(player, data.spawn.location.x, data.spawn.location.y, data.spawn.location.z)
			FadeInWithTimeout(500)
		end

		LocalPlayer.state.ped = player

		SetNuiFocus(false)

		TriggerScreenblurFadeOut(500)
		cb()
	end,
}

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["sandbox-base"]:RegisterComponent("Spawn", Spawn)
end)
