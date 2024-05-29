local _nearPlayers = {}
local _cachedPlayers = {}
local _cachedProps = {}
local _listeners = {}

_spawned = {}

local _loggedIn = false

RegisterNetEvent("Weapons:Client:SetProps", function(props)
	if not _loggedIn then
		_cachedProps = props
		return
	else
		_cachedProps = props

		while not _startup do
			Citizen.Wait(5)
		end

		for id, data in pairs(props) do
			local myId = GetPlayerServerId(LocalPlayer.state.PlayerID)
			local myPed = PlayerPedId()
			local tPed = GetPlayerPed(GetPlayerFromServerId(id))
			if (id == myId and myPed == tPed) or (id ~= myId and myPed ~= tPed and DoesEntityExist(tPed)) then
				CreateBackObjects(tPed, id, data or {})
			end
		end
	end
end)

RegisterNetEvent("Weapons:Client:UpdateProps", function(id, data)
	_cachedProps[id] = data

	if not _loggedIn then
		return 
	end

	while not _startup do
		Citizen.Wait(5)
	end

	local myId = GetPlayerServerId(LocalPlayer.state.PlayerID)
	local myPed = PlayerPedId()
	local tPed = GetPlayerPed(GetPlayerFromServerId(id))
	if (id == myId and myPed == tPed) or (id ~= myId and myPed ~= tPed and DoesEntityExist(tPed)) then
		CreateBackObjects(tPed, id, _cachedProps[id] or {})
	end
end)

RegisterNetEvent("Characters:Client:Spawn", function()
	_loggedIn = true

	while not _startup do
		Citizen.Wait(5)
	end

	Citizen.CreateThread(function()
		while _loggedIn do
			local myId = GetPlayerServerId(LocalPlayer.state.PlayerID)
			local myPed = PlayerPedId()
			for k, v in pairs(attachedObjects) do
				local tPed = GetPlayerPed(GetPlayerFromServerId(k))
				if (not DoesEntityExist(tPed) or (myId ~= k and myPed == tPed)) and _spawned[k] then
					DeleteAttached(k)
                    _spawned[k] = false
				end
			end
			Citizen.Wait(5000)
		end
	end)

	Citizen.CreateThread(function()
		while _loggedIn do
			local myPos = GetEntityCoords(LocalPlayer.state.ped)
			for k, v in ipairs(GetActivePlayers()) do
				if v ~= LocalPlayer.state.PlayerID then
					local id = GetPlayerServerId(v)
					local targetPed = GetPlayerPed(v)
					if DoesEntityExist(targetPed) and targetPed ~= LocalPlayer.state.ped then
						if not _spawned[id] and _cachedProps[id] ~= nil then
							_spawned[id] = true
							CreateBackObjects(targetPed, id, _cachedProps[id] or {})
						end
					elseif _spawned[id] then
						DeleteAttached(id)
						_spawned[id] = false
					end
				end
			end

			Citizen.Wait(2000)
		end
	end)

	Citizen.CreateThread(function()
		local id = GetPlayerServerId(LocalPlayer.state.PlayerID)
		while _cachedProps[id] == nil do
			Citizen.Wait(1)
		end
		CreateBackObjects(PlayerPedId(), id, _cachedProps[id] or {})
	end)
end)

RegisterNetEvent("Characters:Client:Logout", function()
	_loggedIn = false
	for k, v in pairs(_listeners) do
		RemoveStateBagChangeHandler(v)
	end
end)

RegisterNetEvent("Weapons:Client:ClearWeaponProps", function(id)
	DeleteAttached(id)
	_cachedProps[id] = nil
end)
