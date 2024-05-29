_inPickup = false
_inLogout = false
_doingMugshot = false

AddEventHandler("Jail:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Callbacks = exports["sandbox-base"]:FetchComponent("Callbacks")
	Logger = exports["sandbox-base"]:FetchComponent("Logger")
	Blips = exports["sandbox-base"]:FetchComponent("Blips")
	Characters = exports["sandbox-base"]:FetchComponent("Characters")
	Animations = exports["sandbox-base"]:FetchComponent("Animations")
	Targeting = exports["sandbox-base"]:FetchComponent("Targeting")
	Polyzone = exports["sandbox-base"]:FetchComponent("Polyzone")
	Sounds = exports["sandbox-base"]:FetchComponent("Sounds")
	Notification = exports["sandbox-base"]:FetchComponent("Notification")
	Action = exports["sandbox-base"]:FetchComponent("Action")
	Input = exports["sandbox-base"]:FetchComponent("Input")
	PedInteraction = exports["sandbox-base"]:FetchComponent("PedInteraction")
	Phone = exports["sandbox-base"]:FetchComponent("Phone")
	Inventory = exports["sandbox-base"]:FetchComponent("Inventory")
	Interaction = exports["sandbox-base"]:FetchComponent("Interaction")
	Progress = exports["sandbox-base"]:FetchComponent("Progress")
	Jail = exports["sandbox-base"]:FetchComponent("Jail")
	Reputation = exports["sandbox-base"]:FetchComponent("Reputation")
	Trunk = exports["sandbox-base"]:FetchComponent("Trunk")
	Escort = exports["sandbox-base"]:FetchComponent("Escort")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["sandbox-base"]:RequestDependencies("Jail", {
		"Callbacks",
		"Logger",
		"Blips",
		"Characters",
		"Animations",
		"Targeting",
		"Polyzone",
		"Sounds",
		"Notification",
		"Action",
		"PedInteraction",
		"Phone",
		"Inventory",
		"Interaction",
		"Progress",
		"Reputation",
		"Jail",
		"Trunk",
		"Escort",
		"Input",
	}, function(error)
		if #error > 0 then
			return
		end
		RetrieveComponents()

		Blips:Add("prison", "Bolingbroke Penitentiary", vector3(1852.444, 2585.973, 45.672), 188, 65, 0.8)

		Polyzone.Create:Poly("prison", Config.Prison.points, Config.Prison.options)
		Polyzone.Create:Poly("prison-logout", Config.Logout.points, Config.Logout.options)
		Polyzone.Create:Box(
			"prison-pickup",
			Config.Pickup.coords,
			Config.Pickup.length,
			Config.Pickup.width,
			Config.Pickup.options
		)

		Targeting.Zones:AddBox(
			string.format("bb-retreive", aptId),
			"hands-holding",
			Config.Retreival.coords,
			Config.Retreival.length,
			Config.Retreival.width,
			Config.Retreival.options,
			{
				{
					icon = "hand-holding",
					text = "Retrieve Items",
					event = "Jail:Client:RetreiveItems",
					isEnabled = function()
						return _inPickup
					end,
				},
			},
			3.0,
			true
		)

		Targeting.Zones:AddBox(
			string.format("prison-inmates-list"),
			"clipboard",
			Config.VisitorLog.coords,
			Config.VisitorLog.length,
			Config.VisitorLog.width,
			Config.VisitorLog.options,
			{
				{
					icon = "users-viewfinder",
					text = "View Inmates",
					event = "Jail:Client:ViewInmates",
				},
			},
			3.0,
			true
		)

		Targeting.Zones:AddBox(
			"prison-check",
			"police-box",
			Config.Payphone.coords,
			Config.Payphone.length,
			Config.Payphone.width,
			Config.Payphone.options,
			{
				{
					icon = "stopwatch",
					text = "Check Remaining Sentence",
					event = "Jail:Client:CheckSentence",
					isEnabled = function()
						return Jail:IsJailed()
					end,
				},
				{
					icon = "person-from-portal",
					text = "Process Release",
					event = "Jail:Client:Released",
					isEnabled = function()
						return Jail:IsJailed() and Jail:IsReleaseEligible()
					end,
				},
			},
			3.0,
			true
		)

		Targeting.Zones:AddBox(
			"prison-food",
			"fork-knife",
			Config.Cafeteria.Food.coords,
			Config.Cafeteria.Food.length,
			Config.Cafeteria.Food.width,
			Config.Cafeteria.Food.options,
			{
				{
					text = "Make Food",
					event = "Jail:Client:MakeFood",
				},
			},
			3.0,
			true
		)

		Targeting.Zones:AddBox(
			"prison-drink",
			"cup-straw-swoosh",
			Config.Cafeteria.Drink.coords,
			Config.Cafeteria.Drink.length,
			Config.Cafeteria.Drink.width,
			Config.Cafeteria.Drink.options,
			{
				{
					text = "Make Drink",
					event = "Jail:Client:MakeDrink",
				},
			},
			3.0,
			true
		)

		Targeting.Zones:AddBox(
			"prison-juice",
			"cup-straw-swoosh",
			Config.Cafeteria.Juice.coords,
			Config.Cafeteria.Juice.length,
			Config.Cafeteria.Juice.width,
			Config.Cafeteria.Juice.options,
			{
				{
					text = "Make Fruit Punch",
					event = "Jail:Client:MakeJuice",
					data = {
						name = "fruitpunchslushie",
					},
				},
				{
					text = "Make BerryRazz",
					event = "Jail:Client:MakeJuice",
					data = {
						name = "beatdownberryrazz",
					},
				},
			},
			3.0,
			true
		)

		Targeting.Zones:AddBox(
			"prison-payphone",
			"square-phone-flip",
			Config.Payphones.coords,
			Config.Payphones.length,
			Config.Payphones.width,
			Config.Payphones.options,
			{
				{
					text = "Use Payphone",
					event = "Phone:Client:OpenLimited",
				},
			},
			3.0,
			true
		)

		PedInteraction:Add("PrisonJobs", `csb_janitor`, Config.Foreman.coords, Config.Foreman.heading, 25.0, {
			{
				icon = "clipboard-check",
				text = "Start Work",
				event = "Jail:Client:StartWork",
				data = {},
				isEnabled = function()
					return LocalPlayer.state.Character:GetData("TempJob") == nil
				end,
			},
			{
				icon = "clipboard",
				text = "Quit Work",
				event = "Jail:Client:QuitWork",
				tempjob = "Prison",
				data = {},
			},
		}, "user-helmet-safety", "WORLD_HUMAN_JANITOR")

		Callbacks:RegisterClientCallback("Jail:DoMugshot", function(data, cb)
			_disabled = true
			_doingMugshot = true

			Phone:Close()
			Interaction:Hide()
			Inventory.Close:All()

			DoScreenFadeOut(1000)
			while not IsScreenFadedOut() do
				Citizen.Wait(10)
			end

			Animations.Emotes:Play("mugshot", false, -1, true)

			DoBoardShit(data.jailer, data.duration, data.date)
			DisableControls()
			TriggerEvent("PAC:IgnoreNextNoclipFlag")
			SetEntityCoords(
				LocalPlayer.state.ped,
				Config.Mugshot.coords.x,
				Config.Mugshot.coords.y,
				Config.Mugshot.coords.z,
				0,
				0,
				0,
				false
			)
			Citizen.Wait(100)
			SetEntityHeading(LocalPlayer.state.ped, Config.Mugshot.headings[1])
			FreezeEntityPosition(LocalPlayer.state.ped, true)

			DoScreenFadeIn(1000)
			while not IsScreenFadedIn() do
				Citizen.Wait(10)
			end

			Sounds.Play:One("mugshot.ogg", 0.2)
			Citizen.Wait(2000)
			for i = 2, #Config.Mugshot.headings do
				if LocalPlayer.state.loggedIn then
					SetEntityHeading(LocalPlayer.state.ped, Config.Mugshot.headings[i])
					Citizen.Wait(1000)
					Sounds.Play:One("mugshot.ogg", 0.2)
					Citizen.Wait(3000)
				end
			end

			SetEntityHeading(LocalPlayer.state.ped, Config.Mugshot.headings[1])
			Sounds.Play:One("mugshot.ogg", 0.2)
			Citizen.Wait(2000)

			Animations.Emotes:ForceCancel()
			_doingMugshot = false

			DoScreenFadeOut(1000)
			while not IsScreenFadedOut() do
				Citizen.Wait(10)
			end

			FreezeEntityPosition(LocalPlayer.state.ped, false)
			cb()
		end)
	end)
end)

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["sandbox-base"]:RegisterComponent("Jail", _JAIL)
end)

_JAIL = {
	IsJailed = function(self)
		if LocalPlayer.state.Character == nil then
			return false
		else
			local jailed = LocalPlayer.state.Character:GetData("Jailed")
			if jailed and not jailed.Released then
				return true
			else
				return false
			end
		end
	end,
	IsReleaseEligible = function(self)
		local jailed = LocalPlayer.state.Character:GetData("Jailed")
		if jailed and jailed.Duration < 9999 and GetCloudTimeAsInt() >= (jailed.Release or 0) then
			return true
		else
			return false
		end
	end,
}
