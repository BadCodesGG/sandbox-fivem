function StartUsingMegaphone(vehAnim)
	if PLAYER_CONNECTED and (not CALL_CHANNEL or CALL_CHANNEL <= 0) and not RADIO_TALKING and not USING_MICROPHONE then
		Citizen.CreateThread(function()
			Logger:Info("VOIP", "Megaphone On")
			USING_MEGAPHONE = true
			if vehAnim then
				Animations.Emotes:Play("radio", false, false, true)
			else
				Animations.Emotes:Play("megaphone", false, false, true)
			end
			UpdateVOIPIndicatorStatus()
			while
				_characterLoaded
				and USING_MEGAPHONE
				and (not CALL_CHANNEL or CALL_CHANNEL <= 0)
				and not LocalPlayer.state.isDead
				and not USING_MICROPHONE
			do
				TriggerServerEvent("VOIP:Server:Megaphone:SetPlayerState", true)

				MumbleSetTalkerProximity(VOIP_CONFIG.MegaphoneRange + 0.0)
				Citizen.Wait(7500)
			end

			StopUsingMegaphone()
			StopUsingMicrophone()
		end)
	end
end

function StopUsingMegaphone()
	if USING_MEGAPHONE then
		Logger:Info("VOIP", "Megaphone Off")
		USING_MEGAPHONE = false
		TriggerServerEvent("VOIP:Server:Megaphone:SetPlayerState", false)

		MumbleSetTalkerProximity(CURRENT_VOICE_MODE_DATA.Range + 0.0)
		Animations.Emotes:ForceCancel()
		UpdateVOIPIndicatorStatus()
	end
end

RegisterNetEvent("VOIP:Client:Megaphone:SetPlayerState", function(targetSource, state)
	if VOIP ~= nil and LocalPlayer.state.loggedIn then
		VOIP:ToggleVoice(targetSource, state, "megaphone")
	end
end)

RegisterNetEvent("VOIP:Client:Megaphone:Use", function(vehAnim)
	if not USING_MEGAPHONE then
		StartUsingMegaphone(vehAnim)
	else
		StopUsingMegaphone(vehAnim)
	end
end)

RegisterNetEvent("Characters:Client:SetData", function()
	Citizen.Wait(1000)
	if LocalPlayer.state.loggedIn and USING_MEGAPHONE then
		if not CheckCharacterHasMegaphone() then
			StopUsingMegaphone()
		end
	end
end)

function CheckCharacterHasMegaphone()
	local character = LocalPlayer.state.Character
	if character then
		local states = character:GetData("States") or {}
		for k, v in ipairs(states) do
			if v == "MEGAPHONE" then
				return true
			end
		end
	end
	return false
end
