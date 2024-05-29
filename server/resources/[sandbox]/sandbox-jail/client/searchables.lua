_CURRENT_SEARCH = false

RegisterNetEvent("Characters:Client:Spawn")
AddEventHandler("Characters:Client:Spawn", function()
	while not GlobalState.JailSearchLocations do
		Citizen.Wait(100)
	end

	if GlobalState.JailSearchLocations ~= nil then
		for key, data in ipairs(GlobalState.JailSearchLocations) do
			Targeting.Zones:AddBox(
				string.format("prison_search_%s", key),
				"user-ninja",
				data.coords,
				data.width,
				data.length,
				data.options,
				{
					{
						icon = "magnifying-glass",
						text = "Search",
						event = "Prison:Client:Target:Search",
						isEnabled = function(_, entity)
							local jailed = LocalPlayer.state.Character:GetData("Jailed")
							return jailed or (jailed and GlobalState["OS:Time"] < jailed.Release)
						end,
					},
				},
				2.0,
				true
			)
		end
	end
end)

AddEventHandler("Prison:Client:Target:Search", function(entity, data)
	_CURRENT_SEARCH = true

	if LocalPlayer.state.isK9Ped then
		Animations.Emotes:Play("searchk9", false, nil, true)
	else
		Animations.Emotes:Play("mechanic2", false, nil, true) -- or search
	end
	Progress:Progress({
		name = "prison_target_search",
		duration = math.random(12000, 18000),
		label = "Searching Hidden Location",
		useWhileDead = false,
		canCancel = false,
		ignoreModifier = true,
		controlDisables = {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		},
	}, function(cancelled)
		if not cancelled and _CURRENT_SEARCH then
			Callbacks:ServerCallback("Prison:Searchable:GetLootShit", {}, function(success)
				-- if success then
				-- 	print("success")
				-- 	-- UISounds.Play:FrontEnd(-1, "PURCHASE", "HUD_LIQUOR_STORE_SOUNDSET")
				-- else
				-- 	print("failed")
				-- end
				Animations.Emotes:ForceCancel()
				_CURRENT_SEARCH = false
			end)
		else
			_CURRENT_SEARCH = false
		end
	end)
end)

AddEventHandler("Characters:Client:Logout", function()
	_CURRENT_SEARCH = false
end)

AddEventHandler("playerDropped", function()
	_CURRENT_SEARCH = false
end)
