Citizen.CreateThread(function()
	while GetIsLoadingScreenActive() do
		Citizen.Wait(0)
	end
	SendNUIMessage({
		type = "APP_SHOW",
	})
end)

local loadTo = 0
function loadModel(model)
	RequestModel(model)
	loadTo = 0
	while not HasModelLoaded(model) and loadTo < 500 do
		loadTo += 1
		Citizen.Wait(100)
	end
end

local previews = {
	vector4(682.282, 584.414, 129.461, 205.768),
	vector4(684.203, 585.349, 129.461, 194.392),
	vector4(680.347, 582.919, 129.461, 239.809),
	vector4(679.232, 585.493, 129.461, 236.240),
	vector4(682.157, 587.705, 129.461, 199.840),
}
local peds = {}

RegisterNUICallback("GetData", function(data, cb)
	cb("ok")

	while LocalPlayer.state.ID == nil do
		Citizen.Wait(1)
	end

	for k, v in ipairs(peds) do
		DeleteEntity(v)
	end

	Callbacks:ServerCallback("Characters:GetServerData", {}, function(serverData)
		SendNUIMessage({
			type = "LOADING_SHOW",
			data = { message = "Getting Character Data" },
		})

		FadeOutWithTimeout(500)

		Callbacks:ServerCallback("Characters:GetCharacters", {}, function(characters, characterLimit)
			local ped = PlayerPedId()
			TriggerEvent("PAC:IgnoreNextNoclipFlag")
			SetEntityCoords(ped, 685.865, 576.222, 132.841, 0.0, 0.0, 0.0, false)
			FreezeEntityPosition(ped, true)
			SetEntityVisible(ped, false)
			SetPlayerVisibleLocally(ped, false)

			local interior = GetInteriorFromEntity(ped)
			if interior ~= 0 then
				local roomHash = GetRoomKeyFromEntity(ped)
				ForceRoomForEntity(ped, interior, roomHash)
			end

			Citizen.Wait(250)

			local cam2 = CreateCamWithParams(
				"DEFAULT_SCRIPTED_CAMERA",
				685.865,
				576.222,
				132.841,
				338.730,
				0.00,
				0.00,
				75.00,
				false,
				0
			)
			SetCamActiveWithInterp(cam2, cam, 1000, true, true)
			RenderScriptCams(true, false, 1, true, true)

			TriggerScreenblurFadeOut(500)
			cam = cam2

			for k, v in ipairs(characters) do
				if previews[k] then
					if v.Preview then
						loadModel(GetHashKey(v.Preview.model))
						local ped = CreatePed(
							5,
							GetHashKey(v.Preview.model),
							previews[k][1],
							previews[k][2],
							previews[k][3],
							previews[k][4],
							false,
							true
						)

						local t = 0
						while not DoesEntityExist(ped) and t < 2500 do
							t += 1
							Citizen.Wait(1)
						end

						if DoesEntityExist(ped) then
							SetEntityCoords(ped, previews[k][1], previews[k][2], previews[k][3], 0.0, 0.0, 0.0, false)
							FreezeEntityPosition(ped, true)
							Ped:Preview(ped, tonumber(v.Gender), v.Preview, false, v.GangChain)
	
							table.insert(peds, ped)
						end
					else
						loadModel(tonumber(v.Gender) == 0 and `mp_m_freemode_01` or `mp_f_freemode_01`)
						local ped = CreatePed(
							5,
							tonumber(v.Gender) == 0 and `mp_m_freemode_01` or `mp_f_freemode_01`,
							previews[k][1],
							previews[k][2],
							previews[k][3],
							previews[k][4],
							false,
							true
						)

						local t = 0
						while not DoesEntityExist(ped) and t < 2500 do
							t += 1
							Citizen.Wait(1)
						end

						if DoesEntityExist(ped) then
							SetEntityCoords(ped, previews[k][1], previews[k][2], previews[k][3], 0.0, 0.0, 0.0, false)
							FreezeEntityPosition(ped, true)
	
							table.insert(peds, ped)
						end
					end
				end
			end

			SendNUIMessage({
				type = "SET_DATA",
				data = {
					changelog = serverData.changelog,
					motd = serverData.motd,
					characters = characters,
					characterLimit = characterLimit,
				},
			})
			SendNUIMessage({ type = "LOADING_HIDE" })
			SendNUIMessage({
				type = "SET_STATE",
				data = { state = "STATE_CHARACTERS" },
			})

			FadeInWithTimeout(500)
		end)
	end)
end)

RegisterNUICallback("CreateCharacter", function(data, cb)
	cb("ok")
	Callbacks:ServerCallback("Characters:CreateCharacter", data, function(character)
		if character ~= nil then
			SendNUIMessage({
				type = "CREATE_CHARACTER",
				data = { character = character },
			})
		end

		SendNUIMessage({
			type = "SET_STATE",
			data = { state = "STATE_CHARACTERS" },
		})
		SendNUIMessage({ type = "LOADING_HIDE" })
	end)
end)

RegisterNUICallback("DeleteCharacter", function(data, cb)
	cb("ok")
	Callbacks:ServerCallback("Characters:DeleteCharacter", data.id, function(status)
		if status then
			SendNUIMessage({
				type = "DELETE_CHARACTER",
				data = { id = data.id },
			})
		end
		SendNUIMessage({ type = "LOADING_HIDE" })
	end)
end)

RegisterNUICallback("SelectCharacter", function(data, cb)
	cb("ok")
	Callbacks:ServerCallback("Characters:GetSpawnPoints", data.id, function(spawns)
		if spawns then
			SendNUIMessage({
				type = "SET_SPAWNS",
				data = { spawns = spawns },
			})
			SendNUIMessage({
				type = "SET_STATE",
				data = { state = "STATE_SPAWN" },
			})
		end

		SendNUIMessage({ type = "LOADING_HIDE" })
	end)
end)

RegisterNUICallback("PlayCharacter", function(data, cb)
	cb("ok")

	FadeOutWithTimeout(500)

	Callbacks:ServerCallback("Characters:GetCharacterData", data.character.ID, function(cData)
		cData.spawn = data.spawn
		TriggerEvent("Characters:Client:SetData", -1, cData, function()
			exports["sandbox-base"]:FetchComponent("Spawn"):SpawnToWorld(cData, function()
				LocalPlayer.state.canUsePhone = true
				if data.spawn.event ~= nil then
					Callbacks:ServerCallback(data.spawn.event, data.spawn, function()
						LocalPlayer.state.Char = cData.ID
						LocalPlayer.state:set('SID', cData.SID, true)
						TriggerServerEvent("Characters:Server:Spawning")
						FadeInWithTimeout(500)
					end)
				else
					LocalPlayer.state:set('SID', cData.SID, true)
					TriggerServerEvent("Characters:Server:Spawning")

					FadeInWithTimeout(500)
				end
			end)
		end)

		for k, v in ipairs(peds) do
			DeleteEntity(v)
		end
	end)
end)

RegisterNetEvent("Characters:Client:Spawned", function()
	TriggerEvent("Characters:Client:Spawn")
	TriggerServerEvent("Characters:Server:Spawn")
	SetNuiFocus(false)
	SendNUIMessage({ type = "APP_HIDE" })
	SendNUIMessage({ type = "LOADING_HIDE" })
	LocalPlayer.state.loggedIn = true
end)
