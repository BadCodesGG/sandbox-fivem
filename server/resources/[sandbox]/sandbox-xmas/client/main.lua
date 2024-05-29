_todaysDayNumber = nil
_existingTree = nil

AddEventHandler("Xmas:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Logger = exports["sandbox-base"]:FetchComponent("Logger")
	Fetch = exports["sandbox-base"]:FetchComponent("Fetch")
	Callbacks = exports["sandbox-base"]:FetchComponent("Callbacks")
	Notification = exports["sandbox-base"]:FetchComponent("Notification")
	Animations = exports["sandbox-base"]:FetchComponent("Animations")
	Polyzone = exports["sandbox-base"]:FetchComponent("Polyzone")
	Progress = exports["sandbox-base"]:FetchComponent("Progress")
	Targeting = exports["sandbox-base"]:FetchComponent("Targeting")
	Sounds = exports["sandbox-base"]:FetchComponent("Sounds")
	Blips = exports["sandbox-base"]:FetchComponent("Blips")
	Interaction = exports["sandbox-base"]:FetchComponent("Interaction")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["sandbox-base"]:RequestDependencies("Xmas", {
		"Logger",
		"Fetch",
		"Callbacks",
		"Notification",
		"Animations",
		"Polyzone",
		"Progress",
		"Targeting",
		"Sounds",
		"Blips",
		"Interaction",
	}, function(error)
		if #error > 0 then
			return
		end
		RetrieveComponents()

		TriggerEvent("Xmas:Client:RegisterStartups")
	end)
end)

RegisterNetEvent("Xmas:Client:Init", function(dayNumber, tree, hasLooted)
	Targeting.Zones:AddBox("legion-present", "gift", vector3(184.33, -963.19, 30.1), 3.0, 5.8, {
		heading = 331,
		--debugPoly=true,
		minZ = 28.7,
		maxZ = 31.9,
	}, {
		{
			icon = "gift",
			text = "Pickup Daily Gift",
			event = "Xmas:Client:Daily",
			isEnabled = function()
				local xmasDaily = LocalPlayer.state.Character:GetData("XmasDaily")
				local xmasDailyCount = LocalPlayer.state.Character:GetData("XmasDailyCount") or 0
				return xmasDaily ~= _todaysDayNumber
					and (
						(_todaysDayNumber ~= 25 and xmasDailyCount < 1)
						or (_todaysDayNumber == 25 and xmasDailyCount < 3)
					)
			end,
		},
	}, 3.0, true)
	Targeting.Zones:Refresh()

	_todaysDayNumber = dayNumber
	SetupTree(tree, hasLooted)
end)

RegisterNetEvent("Xmas:Client:NewTree", function(tree)
	if LocalPlayer.state.loggedIn then
		SetupTree(tree, false)
		Sounds.Play:One("xmas.ogg", 0.05)
	end
end)

RegisterNetEvent("Characters:Client:Logout", function()
	if _existingTree ~= nil then
		DeleteEntity(_existingTree.entity)
		Targeting:RemoveEntity(_existingTree.entity)
		_existingTree = nil
	end
end)

AddEventHandler("Xmas:Client:Daily", function()
	Progress:Progress({
		name = "xmas",
		duration = 15000,
		label = "Picking Up Present",
		canCancel = true,
		controlDisables = {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		},
		animation = {
			animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
			anim = "machinic_loop_mechandplayer",
			flags = 49,
		},
	}, function(cancelled)
		if not cancelled then
			Callbacks:ServerCallback("Xmas:Daily", {})
		end
	end)
end)

AddEventHandler("Xmas:Client:Tree", function()
	Progress:Progress({
		name = "xmas",
		duration = 15000,
		label = "Picking Up Present",
		canCancel = true,
		controlDisables = {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		},
		animation = {
			animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
			anim = "machinic_loop_mechandplayer",
			flags = 49,
		},
	}, function(cancelled)
		if not cancelled then
			Callbacks:ServerCallback("Xmas:Tree", {}, function(s)
				_existingTree.hasLooted = s
			end)
		end
	end)
end)
