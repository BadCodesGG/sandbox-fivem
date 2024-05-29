local _DumpsterEntities = {
	{
		objectID = 666561306,
		description = "Blue Dumpster",
	},
	{
		objectID = 218085040,
		description = "Light Blue Dumpster",
	},
	{
		objectID = -58485588,
		description = "Gray Dumpster",
	},
	{
		objectID = 682791951,
		description = "Big Blue Dumpster",
	},
	{
		objectID = -206690185,
		description = "Big Green Dumpster",
	},
	{
		objectID = 364445978,
		description = "Big Green Skip Bin",
	},
	-- {
	-- 	objectID = 143369,
	-- 	description = "Small Bin",
	-- },
	-- {
	-- 	objectID = -329415894,
	-- 	description = "Small Trash Can",
	-- },
	-- {
	-- 	objectID = 1614656839,
	-- 	description = "Small Trash Can",
	-- },
	-- {
	-- 	objectID = 1437508529,
	-- 	description = "Small Trash Can",
	-- },
	-- {
	-- 	objectID = -1096777189,
	-- 	description = "Small Trash Can",
	-- },
	-- {
	-- 	objectID = -228596739,
	-- 	description = "Small Trash Can",
	-- },
	-- {
	-- 	objectID = 1329570871,
	-- 	description = "Small Trash Can",
	-- },
}

local _searching = false
local _isLocked = nil
local _insideDumpster = false
local _insideCurrentDumpster = nil

AddEventHandler("Labor:Client:Setup", function()
	RegisterDumpsterStartup()
end)

AddEventHandler("Labor:Dumpster:RegisterDumpsters", function()
	RegisterDumpsterStartup()
end)

function RegisterDumpsterStartup()
	for k, v in ipairs(_DumpsterEntities) do
		Targeting:AddObject(v.objectID, "dumpster", {
			{
				icon = "magnifying-glass",
				isEnabled = function(data, entityData)
					if entityData ~= nil and v.objectID == entityData.model then
						return true
					end
					return false
				end,
				text = "Search Trash",
				event = "Inventory:Client:SearchDumpster",
				data = {},
				minDist = 1.5,
			},
			{
				icon = "box-open",
				isEnabled = function(data, entityData)
					if entityData ~= nil and v.objectID == entityData.model then
						return true
					end
					return false
				end,
				text = "Open Trash",
				event = "Inventory:Client:OpenDumpster",
				data = {},
				minDist = 1.5,
			},
			-- {
			-- 	icon = "trash-can-slash",
			-- 	isEnabled = function(data, entityData)
			-- 		if entityData ~= nil and v.objectID == entityData.model then
			-- 			return true
			-- 		end
			-- 		return false
			-- 	end,
			-- 	text = "Hide In Dumpster",
			-- 	event = "Inventory:Client:HideInDumpster",
			-- 	data = {},
			-- 	minDist = 1.5,
			-- },
		}, 2.0)
	end
end

AddEventHandler("Inventory:Client:OpenDumpster", function(entity, data)
	-- print(entity.endCoords, entity.entity, data)
	local _invData = {
		identifier = string.format(
			"dumpster|%s|%s",
			tostring(math.floor(entity.endCoords.x + 10000)),
			tostring(math.floor(entity.endCoords.y + 10000))
		),
	}
	Callbacks:ServerCallback("Inventory:Dumpster:Open", _invData, function(s) end)
end)

AddEventHandler("Inventory:Client:HideInDumpster", function(entity, data)
	-- print(entity.endCoords, entity.entity, data)
	local data = {
		identifier = entity.entity,
		locked = math.random(1, 3),
	}
	Callbacks:ServerCallback("Inventory:Dumpster:HidePlayer", data, function(s, l)
		if not s then
			Notification:Error("You're not in the right state to hide in the dumpster.")
			return
		end
		if data.identifier == nil or type(data.identifier) == "boolean" then
			Notification:Error("This is not a dumpster. Try again.")
			return
		end
		if not l then
			Notification:Error("Dumpster is locked.")
			return
		end
		LocalPlayer.state.inDumpster = true
		_insideCurrentDumpster = data.identifier
		AttachEntityToEntity(
			LocalPlayer.state.ped,
			_insideCurrentDumpster,
			-1,
			0.0,
			-0.2,
			2.0,
			0.0,
			0.0,
			0.0,
			true,
			true,
			true,
			false,
			2,
			true
		)
		Animations.Emotes:Play("laydown_garbage", false, nil, true)
		SetEntityVisible(LocalPlayer.state.ped, false, 0)
		_insideDumpster = true
		_isLocked = false

		TriggerEvent("Inventory:Client:DumpsterHideThread")

		if not LocalPlayer.state.isCuffed and not LocalPlayer.state.isDead then
			Action:Show("dumpsterdiving", "{keybind}secondary_action{/keybind} Exit Trash")
		end
	end)
end)

AddEventHandler("Inventory:Client:SearchDumpster", function(entity, data)
	-- print(entity.endCoords, entity.entity, data)

	Callbacks:ServerCallback("Inventory:Server:AvailableDumpster", entity, function(s)
		if s and entity then
			if entity.entity == nil or type(entity.entity) == "boolean" then
				Notification:Error("This is not a dumpster. Try again.")
				return
			end
			if not _searching then
				_searching = true
				TaskTurnPedToFaceEntity(LocalPlayer.state.ped, entity.entity, 3000)
				Wait(2000)
				local dict = "amb@prop_human_bum_bin@base"
				local anim = "base"
				if LocalPlayer.state.isK9Ped then
					dict = "creatures@rottweiler@move"
					anim = "fetch_pickup"
				end
				Progress:Progress({
					name = "inv_dumpster_search",
					duration = math.random(20, 25) * 1000,
					label = "Searching Trash",
					useWhileDead = false,
					canCancel = true,
					ignoreModifier = true,
					controlDisables = {
						disableMovement = true,
						disableCarMovement = true,
						disableMouse = false,
						disableCombat = true,
					},
					animation = {
						animDict = dict,
						anim = anim,
						flag = 49,
					},
				}, function(status)
					if not status then
						Callbacks:ServerCallback("Inventory:Server:SearchDumpster", entity, function(s) end)
					end
					_searching = false
				end)
			end
		else
			Notification:Error("This dumpster has been searched.")
		end
	end)
end)

AddEventHandler("Keybinds:Client:KeyUp:secondary_action", function()
	if _insideDumpster and LocalPlayer.state.loggedIn then
		ClearPedTasks(LocalPlayer.state.ped)
		DetachEntity(LocalPlayer.state.ped)
		if DoesEntityExist(_insideCurrentDumpster) then
			SetEntityCoords(
				LocalPlayer.state.ped,
				GetOffsetFromEntityInWorldCoords(LocalPlayer.state.ped, 0.0, -0.7, -0.75)
			)
		else
			SetEntityCoords(LocalPlayer.state.ped, GetEntityCoords(LocalPlayer.state.ped))
		end
		SetEntityVisible(LocalPlayer.state.ped, true, 0)
		_insideDumpster = false
		_isLocked = false
		_insideCurrentDumpster = nil
		LocalPlayer.state.inDumpster = false
		Animations.Emotes:ForceCancel()
		Action:Hide("dumpsterdiving")
	end
end)

local _dumpsterHideThreading = false
RegisterNetEvent("Inventory:Client:DumpsterHideThread", function()
	if _dumpsterHideThreading then
		return
	end
	_dumpsterHideThreading = true

	Citizen.CreateThread(function()
		-- Wait till this is synced from server
		while not LocalPlayer.state.inDumpster do
			Citizen.Wait(10)
		end

		while LocalPlayer.state.inDumpster do
			Citizen.Wait(5)

			Weapons:UnequipIfEquipped()

			DisableControls()
		end

		ClearPedTasks(LocalPlayer.state.ped)
		FreezeEntityPosition(LocalPlayer.state.ped, false)
		_dumpsterHideThreading = false
	end)
end)

RegisterNetEvent("Characters:Client:Spawn", function()
	LocalPlayer.state.inDumpster = false
end)

function DisableControls()
	DisableControlAction(0, 30, true) -- disable left/right
	DisableControlAction(0, 31, true) -- disable forward/back
	DisableControlAction(0, 36, true) -- INPUT_DUCK
	DisableControlAction(0, 21, true) -- disable sprint
	DisableControlAction(0, 44, true) -- disable cover
	DisableControlAction(0, 63, true) -- veh turn left
	DisableControlAction(0, 64, true) -- veh turn right
	DisableControlAction(0, 71, true) -- veh forward
	DisableControlAction(0, 72, true) -- veh backwards
	DisableControlAction(0, 75, true) -- disable exit vehicle
	DisablePlayerFiring(PlayerId(), true) -- Disable weapon firing
	DisableControlAction(0, 24, true) -- disable attack
	DisableControlAction(0, 25, true) -- disable aim
	DisableControlAction(1, 37, true) -- disable weapon select
	DisableControlAction(0, 47, true) -- disable weapon
	DisableControlAction(0, 58, true) -- disable weapon
	DisableControlAction(0, 140, true) -- disable melee
	DisableControlAction(0, 141, true) -- disable melee
	DisableControlAction(0, 142, true) -- disable melee
	DisableControlAction(0, 143, true) -- disable melee
	DisableControlAction(0, 263, true) -- disable melee
	DisableControlAction(0, 264, true) -- disable melee
	DisableControlAction(0, 257, true) -- disable melee
end
