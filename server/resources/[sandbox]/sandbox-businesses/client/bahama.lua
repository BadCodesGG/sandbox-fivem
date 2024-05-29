local _makingItRain = false

local poleDances = {
	{
		anim = "lapdance",
	},
	{
		anim = "lapdance2",
	},
	{
		anim = "lapdance3",
	},
	{
		anim = "lapdance4",
	},
}

local poles = {
	vector3(-1393.7627, -612.0366, 29.7864),
	vector3(-1390.8264, -616.5738, 29.7864),
	vector3(-1387.8630, -621.1016, 29.7864),
}

AddEventHandler("Businesses:Client:Startup", function()
	Polyzone.Create:Circle("bh_dancers_1", vector3(-1393.78, -612.28, 30.32), 1.53, {
		name = "bh_dancers_1",
		useZ = false,
		minZ = 29.32,
		maxZ = 32.32,
		--debugPoly=true
	})
	Polyzone.Create:Circle("bh_dancers_2", vector3(-1390.82, -616.84, 29.72), 1.55, {
		name = "bh_dancers_2",
		useZ = false,
		minZ = 29.32,
		maxZ = 32.32,
		--debugPoly=true
	})
	Polyzone.Create:Circle("bh_dancers_3", vector3(-1387.79, -621.39, 29.72), 1.5, {
		name = "bh_dancers_3",
		useZ = false,
		minZ = 29.32,
		maxZ = 32.32,
		--debugPoly=true
	})

	Polyzone.Create:Box("bh_makeitrain", vector3(-1390.89, -616.98, 29.32), 6.0, 16.8, {
		heading = 302,
		--debugPoly=true,
		minZ = 28.32,
		maxZ = 34.32,
	})

	Interaction:RegisterMenu("bh_stripper_pole", "Bahama Mamas Dancers", "party-horn", function()
		if
			(
				Polyzone:IsCoordsInZone(GetEntityCoords(LocalPlayer.state.ped), "bh_dancers_1")
				or Polyzone:IsCoordsInZone(GetEntityCoords(LocalPlayer.state.ped), "bh_dancers_2")
				or Polyzone:IsCoordsInZone(GetEntityCoords(LocalPlayer.state.ped), "bh_dancers_3")
			)
			and LocalPlayer.state.onDuty == "bahama"
			and Jobs.Permissions:HasPermissionInJob("bahama", "STRIP_POLE")
		then
			local subMenu = {}

			for k, v in ipairs(poleDances) do
				table.insert(subMenu, {
					icon = "circle-" .. k,
					label = "Dance " .. k,
					action = function()
						TriggerEvent("Businesses:Client:PoleDanceBH", k)
						Interaction:Hide()
					end,
				})
			end

			Interaction:ShowMenu(subMenu)
		else
			Notification:Error("Invalid Permissions")
		end
	end, function()
		return (
			Polyzone:IsCoordsInZone(GetEntityCoords(LocalPlayer.state.ped), "bh_dancers_1")
			or Polyzone:IsCoordsInZone(GetEntityCoords(LocalPlayer.state.ped), "bh_dancers_2")
			or Polyzone:IsCoordsInZone(GetEntityCoords(LocalPlayer.state.ped), "bh_dancers_3")
		) and LocalPlayer.state.onDuty == "bahama"
	end)

	Interaction:RegisterMenu("bh_makeitrain", "Make It Rain", "money-bill-1-wave", function()
		if not _makingItRain and Polyzone:IsCoordsInZone(GetEntityCoords(LocalPlayer.state.ped), "bh_makeitrain") then
			local makeItRain = {
				{
					type = "cash",
					text = "$100 Cash",
					time = math.random(8000, 12000),
				},
				{
					type = "moneyroll",
					text = "Money Rolls",
					time = math.random(8000, 12000),
				},
				{
					type = "moneyband",
					text = "Money Bands",
					time = math.random(8000, 12000),
				},
			}

			local subMenu = {}

			for k, v in ipairs(makeItRain) do
				if v.type == "cash" or Inventory.Check.Player:HasItem(v.type, 1) then
					table.insert(subMenu, {
						icon = "money-bill-1-wave",
						label = v.text,
						action = function()
							local nearestStripper = GetNearbyFuckingStripper()
							if nearestStripper then
								MakeItRainBitchBahama(nearestStripper, v.type, v.time)
							end

							Interaction:Hide()
						end,
					})
				end
			end

			Interaction:ShowMenu(subMenu)
		end
	end, function()
		return Polyzone:IsCoordsInZone(GetEntityCoords(LocalPlayer.state.ped), "bh_makeitrain")
			and GetNearbyFuckingStripper()
	end)
end)

RegisterNetEvent("Businesses:Client:PoleDanceBH", function(dance)
	local pedCoords = GetEntityCoords(LocalPlayer.state.ped)
	for k, v in ipairs(poles) do
		if #(v - pedCoords) <= 1.5 then
			local cPlayer, dist = Game.Players:GetClosestPlayer()

			if dist == -1 or dist > 1.5 then
				local poleDance = poleDances[dance]
				if poleDance then
					-- SetEntityCoords(
					--     PlayerPedId(),
					--     v.x + poleDance.offset.x,
					--     v.y + poleDance.offset.y,
					--     v.z + poleDance.offset.z
					-- )
					-- SetEntityRotation(PlayerPedId(), 0.0, 0.0, 0.0)

					Animations.Emotes:Play(poleDance.anim, false, false, false)
				end
			else
				Notification:Error("Pole Taken")
			end
			return
		end
	end
end)

function MakeItRainBitchBahama(targetSource, cashType, time)
	local targetPlayer = GetPlayerFromServerId(targetSource)
	if targetPlayer == -1 then
		return
	end

	local targetPed = GetPlayerPed(targetPlayer)

	Citizen.CreateThread(function()
		_makingItRain = true
		Animations.Emotes:Play("makeitrain", false, false, false)

		Citizen.Wait(7500)

		while
			_makingItRain
			and LocalPlayer.state.loggedIn
			and Animations.Emotes:Get() == "makeitrain"
			and IsDoingStripperDance(Player(targetSource).state.anim)
			and (#(GetEntityCoords(LocalPlayer.state.ped) - GetEntityCoords(targetPed)) <= 5.0)
		do
			local p = promise.new()
			Callbacks:ServerCallback("BH:MakeItRain", {
				target = targetSource,
				type = cashType,
			}, function(success, cd)
				if not success then
					Notification:Error(cd and "Reached Cooldown" or "Error - Ran Out of Money")
					_makingItRain = false
				end

				p:resolve(success)
			end)

			Citizen.Await(p)
			Citizen.Wait(time)
		end

		_makingItRain = false
		Animations.Emotes:ForceCancel()
	end)
end
