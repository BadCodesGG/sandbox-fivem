local isAfk = false
local afkAnswer = false
local inputShowing = false
local submitting = false

local afkCd = false

local function GetCode()
	Callbacks:ServerCallback("Pwnzor:GetCode", {}, function(c)
		afkAnswer = c
	end)
end

local function ShowInput()
	if inputShowing then
		return
	end
	inputShowing = true

	while afkAnswer == nil do
		Citizen.Wait(1)
	end

	Input:Show("Are You There?", string.format('Enter: "%s" To Prevent Being Kicked', afkAnswer), {
		{
			id = "code",
			type = "text",
			options = {
				inputProps = {
					autofocus = "autofocus",
				},
			},
		},
	}, "Pwnzor:Client:EnterAFKCode", {})
end

local timerStarted = false
local function StartKickTimer()
	if timerStarted then
		return
	end
	timerStarted = true
	isAfk = true

	Citizen.CreateThread(function()
		afkAnswer = nil
		GetCode()
		ShowInput()
	end)

	local time = 0
	local AFKTimer = 60 * 5

	Citizen.CreateThread(function()
		while isAfk do
			if time > AFKTimer then
				if isAfk and not submitting and not (GlobalState["DisableAFK"] or false) then
					Callbacks:ServerCallback("Pwnzor:AFK")
				end
			end

			Notification.Persistent:Error(
				"pwnzor-afk",
				"You Will Be Kicked In " .. (AFKTimer - time) .. " Seconds For Being AFK"
			)

			time += 1

			Citizen.Wait(1000)
		end
		timerStarted = false
	end)

	Citizen.CreateThread(function()
		while isAfk do
			if afkAnswer ~= nil and not inputShowing then
				ShowInput()
			end
			Citizen.Wait(1)
		end
	end)
end

AddEventHandler("Pwnzor:Client:EnterAFKCode", function(vals, data)
	submitting = true
	Callbacks:ServerCallback("Pwnzor:EnterCode", vals.code, function(c)
		if c then
			afkAnswer = false
			Notification.Persistent:Remove("pwnzor-afk")

			isAfk = false
			submitting = false
			inputShowing = false

			afkCd = true
			Citizen.SetTimeout(1000 * GlobalState["AFKTimer"], function()
				afkCd = false
			end)
		else
			inputShowing = false
		end
	end)
end)

AddEventHandler("Input:Closed", function(event, data)
	inputShowing = false
end)

RegisterNetEvent("Characters:Client:Spawn", function()
	if LocalPlayer.state.isDev or LocalPlayer.state.isStaff then
		return
	end

	Citizen.CreateThread(function()
		local time = 0
		local prevPos = nil
		local currentPos = nil

		Citizen.Wait(30000)

		while GlobalState["AFKTimer"] == nil do
			Citizen.Wait(1000)
		end

		local AFKTimer = GlobalState["AFKTimer"]

		while LocalPlayer.state.inCreator do
			Citizen.Wait(30000)
		end

		while LocalPlayer.state.loggedIn do
			Citizen.Wait(1000)
			--TriggerServerEvent('mythic_pwnzor:server:PingCheck', securityToken, isLoggedIn)
			local playerPed = PlayerPedId()
			if playerPed and not afkCd and not isAfk and not (GlobalState["DisableAFK"] or false) then
				currentPos = GetEntityCoords(playerPed)
				if prevPos ~= nil then
					if
						#(vector3(currentPos.x, currentPos.y, currentPos.z) - vector3(prevPos.x, prevPos.y, prevPos.z))
						< 1.0
					then
						if time > AFKTimer then
							StartKickTimer()
							time = 0
						else
							time += 1
						end
					else
						time = 0
						afkCd = true
						Citizen.SetTimeout(1000 * 60, function()
							afkCd = false
						end)
					end
				end

				prevPos = currentPos
			end
		end
	end)
end)
