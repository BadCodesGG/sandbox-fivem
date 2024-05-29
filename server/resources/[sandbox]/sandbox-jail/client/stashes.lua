--[[

	player stash
	public stash

]]

RegisterNetEvent("Characters:Client:Spawn")
AddEventHandler("Characters:Client:Spawn", function()
	while not GlobalState.JailStashLocations do
		Citizen.Wait(100)
	end

	if GlobalState.JailStashLocations ~= nil then
		for key, data in ipairs(GlobalState.JailStashLocations) do
			Targeting.Zones:AddBox(
				string.format("prison_stash_%s", key),
				"lock",
				data.coords,
				data.width,
				data.length,
				data.options,
				{
					{
						icon = "box",
						text = data.stashType == "self" and "Open Stash" or "Open Public Stash",
						event = "Prison:Client:Target:Stash",
						data = {
							stashType = data.stashType,
						},
					},
					{
						icon = "bomb",
						text = "Raid Storage",
						event = "Prison:Client:Stash:Raid",
						-- action = function()
						-- 	local unit = GlobalState[string.format("StorageUnit:%s", nearUnit.unitId)]

						-- 	Callbacks:ServerCallback("StorageUnits:PoliceRaid", {
						-- 		unit = nearUnit.unitId
						-- 	}, function(success)
						-- 		if not success then
						-- 			Notification:Error("Error!")
						-- 		else
						-- 			Sounds.Play:Location(LocalPlayer.state.myPos, 10, "breach.ogg", 0.15)
						-- 		end
						-- 	end)
						-- end,
						isEnabled = function()
							return (LocalPlayer.state.onDuty == "police" or LocalPlayer.state.onDuty == "prison")
								and data.stashType == "self"
						end,
					},
				},
				2.0,
				true
			)
		end
	end
end)

AddEventHandler("Prison:Client:Target:Stash", function(entity, data)
	Callbacks:ServerCallback("Inventory:PrisonStash:Open", data.stashType)
end)

AddEventHandler("Prison:Client:Stash:Raid", function(entity, data)
	local menu = {}
	local playerSID = nil

	Input:Show("Prison Stash Raid", "Enter Prisoner State ID", {
		{
			id = "stateid",
			type = "text",
			options = {
				helperText = "Numbers Only - Minimum Length of 1 and a Maximum Length of 6",
				inputProps = {
					pattern = "[0-9]+",
					minlength = 1,
					maxlength = 6,
				},
			},
		},
	}, "Inventory:Client:PrisonStash:Raid", data)
end)

AddEventHandler("Inventory:Client:PrisonStash:Raid", function(values, data)
	if values and values.stateid and #values.stateid >= 1 then
		Callbacks:ServerCallback("Inventory:PrisonStash:Raid", {
			stateid = values.stateid,
		}, function(success)
			-- if success then
			-- 	Notification:Success("Updated Passcode")
			-- else
			-- 	Notification:Error("Failed to Update Passcode")
			-- end
		end)
	end
end)
