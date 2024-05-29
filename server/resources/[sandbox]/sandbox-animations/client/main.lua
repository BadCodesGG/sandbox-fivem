GLOBAL_VEH = nil

IsInAnimation = false

_isPointing = false
_isCrouched = false

walkStyle = "default"
facialExpression = "default"
emoteBinds = {}

_doingStateAnimation = false

AddEventHandler("Animations:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Callbacks = exports["sandbox-base"]:FetchComponent("Callbacks")
	Utils = exports["sandbox-base"]:FetchComponent("Utils")
	Notification = exports["sandbox-base"]:FetchComponent("Notification")
	Menu = exports["sandbox-base"]:FetchComponent("Menu")
	Damage = exports["sandbox-base"]:FetchComponent("Damage")
	Keybinds = exports["sandbox-base"]:FetchComponent("Keybinds")
	Animations = exports["sandbox-base"]:FetchComponent("Animations")
	Targeting = exports["sandbox-base"]:FetchComponent("Targeting")
	Interaction = exports["sandbox-base"]:FetchComponent("Interaction")
	Inventory = exports["sandbox-base"]:FetchComponent("Inventory")
	Hud = exports["sandbox-base"]:FetchComponent("Hud")
	Weapons = exports["sandbox-base"]:FetchComponent("Weapons")
	ListMenu = exports["sandbox-base"]:FetchComponent("ListMenu")
	Input = exports["sandbox-base"]:FetchComponent("Input")
	Sounds = exports["sandbox-base"]:FetchComponent("Sounds")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["sandbox-base"]:RequestDependencies("Animations", {
		"Callbacks",
		"Utils",
		"Notification",
		"Menu",
		"Damage",
		"Keybinds",
		"Animations",
		"Targeting",
		"Interaction",
		"Hud",
		"Weapons",
		"ListMenu",
		"Input",
		"Sounds",
		"Inventory",
	}, function(error)
		if #error > 0 then
			return
		end
		RetrieveComponents()
		RegisterKeybinds()

		RegisterChairTargets()

		Interaction:RegisterMenu("expressions", "Expressions", "face-confounded", function()
			Interaction:Hide()
			Animations:OpenExpressionsMenu()
		end)

		Interaction:RegisterMenu("walks", "Walk Styles", "person-walking", function()
			Interaction:Hide()
			Animations:OpenWalksMenu()
		end)

		Callbacks:RegisterClientCallback("Selfie:Client:UploadPhoto", function(data, cb)
			local options = {
				encoding = "webp",
				quality = 0.8,
				headers = {
					Authorization = string.format("%s", data.token),
				},
			}
			exports["screenshot-basic"]:requestScreenshotUpload(
				string.format("%s", data.api),
				"image",
				options,
				function(data)
					local image = json.decode(data)
					cb(json.encode({ url = image.url }))
				end
			)
		end)
	end)
end)

local pauseListener = nil
AddEventHandler("Characters:Client:Spawn", function()
	Animations.Emotes:Cancel()
	TriggerEvent("Animations:Client:StandUp", true, true)

	pauseListener = AddStateBagChangeHandler(
		"inPauseMenu",
		string.format("player:%s", GetPlayerServerId(LocalPlayer.state.PlayerID)),
		function(bagName, key, value, _unused, replicated)
			if key == "inPauseMenu" then
				if
					value == 1
					and not LocalPlayer.state.isDead
					and not LocalPlayer.state.isCuffed
					and not LocalPlayer.state.isHardCuffed
				then
					if value == 1 and not Animations.Emotes:Get() then
						Animations.Emotes:Play("map", false, nil, true, true)
					end
				else
					if value == false and Animations.Emotes:Get() == "map" then
						Animations.Emotes:ForceCancel()
					end
				end
			end
		end
	)

	Citizen.CreateThread(function()
		while LocalPlayer.state.loggedIn do
			Citizen.Wait(5000)
			if not _isCrouched and not LocalPlayer.state.drunkMovement then
				Animations.PedFeatures:RequestFeaturesUpdate()
			end
		end
	end)

	Citizen.CreateThread(function()
		while LocalPlayer.state.loggedIn do
			Citizen.Wait(5)
			DisableControlAction(0, 36, true)
			if IsDisabledControlJustPressed(0, 36) then
				Animations.PedFeatures:ToggleCrouch()
			end
			if IsInAnimation and IsPedShooting(LocalPlayer.state.ped) then
				Animations.Emotes:ForceCancel()
			end
		end
	end)

	local character = LocalPlayer.state.Character
	if character and character:GetData("Animations") then
		local data = character:GetData("Animations")
		walkStyle, facialExpression, emoteBinds = data.walk, data.expression, data.emoteBinds
		Animations.PedFeatures:RequestFeaturesUpdate()
	else
		walkStyle, facialExpression, emoteBinds =
			Config.DefaultSettings.walk, Config.DefaultSettings.expression, Config.DefaultSettings.emoteBinds
		Animations.PedFeatures:RequestFeaturesUpdate()
	end
end)

RegisterNetEvent("Characters:Client:Logout", function()
	Animations.Emotes:ForceCancel()
	Citizen.Wait(20)

	RemoveStateBagChangeHandler(pauseListener)
	if LocalPlayer.state.anim then
		LocalPlayer.state:set("anim", false, true)
	end
end)

RegisterNetEvent("Vehicles:Client:EnterVehicle", function(veh)
	GLOBAL_VEH = veh
end)

RegisterNetEvent("Vehicles:Client:ExitVehicle", function()
	GLOBAL_VEH = nil
end)

function RegisterKeybinds()
	Keybinds:Add("pointing", "b", "keyboard", "Pointing - Toggle", function()
		if _isPointing then
			StopPointing()
		else
			StartPointing()
		end
	end)

	Keybinds:Add("ragdoll", Config.RagdollKeybind, "keyboard", "Ragdoll - Toggle", function()
		local time = 3500
		Citizen.Wait(350)
		ClearPedSecondaryTask(LocalPlayer.state.ped)
		SetPedToRagdoll(LocalPlayer.state.ped, time, time, 0, 0, 0, 0)
	end)

	Keybinds:Add("emote_cancel", "x", "keyboard", "Emotes - Cancel Current", function()
		Animations.Emotes:Cancel()

		TriggerEvent("Animations:Client:StandUp")
		TriggerEvent("Animations:Client:Selfie", false)
		TriggerEvent("Animations:Client:UsingCamera", false)
	end)

	-- Don't specify and key so then players can set it themselves if they want to use...
	Keybinds:Add("emote_menu", "", "keyboard", "Emotes - Open Menu", function()
		Animations:OpenMainEmoteMenu()
	end)

	-- There are 4 emote binds and by default they use numbers 6, 7, 8 and 9
	for bindNum = 1, 4 do
		Keybinds:Add(
			"emote_bind_" .. bindNum,
			tostring(5 + bindNum),
			"keyboard",
			"Emotes - Bind #" .. bindNum,
			function()
				Animations.EmoteBinds:Use(bindNum)
			end
		)
	end
end
