function StartUsingMicrophone(withRange)
	if PLAYER_CONNECTED and (not CALL_CHANNEL or CALL_CHANNEL <= 0) and not RADIO_TALKING and not USING_MEGAPHONE then
		Citizen.CreateThread(function()
			Logger:Info("VOIP", "Microphone On")
			USING_MICROPHONE = true

			MumbleSetAudioInputIntent(`music`)

			UpdateVOIPIndicatorStatus()
			while
				_characterLoaded
				and USING_MICROPHONE
				and (not CALL_CHANNEL or CALL_CHANNEL <= 0)
				and not LocalPlayer.state.isDead
				and not USING_MEGAPHONE
			do
				--TriggerServerEvent('VOIP:Server:Microphone:SetPlayerState', true)

				MumbleSetTalkerProximity(withRange + 0.0)
				Citizen.Wait(7500)
			end

			StopUsingMicrophone()
			StopUsingMegaphone()
		end)
	end
end

function StopUsingMicrophone()
	if USING_MICROPHONE then
		Logger:Info("VOIP", "Microphone Off")
		USING_MICROPHONE = false
		TriggerServerEvent("VOIP:Server:Microphone:SetPlayerState", false)

		MumbleSetAudioInputIntent(`speech`)

		MumbleSetTalkerProximity(CURRENT_VOICE_MODE_DATA.Range + 0.0)
		UpdateVOIPIndicatorStatus()
	end
end

-- RegisterNetEvent('VOIP:Client:Microphone:SetPlayerState', function(targetSource, state)
--     if VOIP ~= nil and LocalPlayer.state.loggedIn then
--         VOIP:ToggleVoice(targetSource, state, 'microphone')
--     end
-- end)

function CreateMicrophonePolyzones()
	Polyzone.Create:Box("microphone_rockford_records_stage", vector3(-1006.03, -254.44, 39.47), 9.4, 2.6, {
		heading = 325,
		--debugPoly=true,
		minZ = 38.47,
		maxZ = 42.07,
	}, {
		VOIP_MICROPHONE = true,
		VOIP_MICROPHONE_RANGE = 40.0,
	})

	-- Polyzone.Create:Box("microphone_galileo_stage", vector3(-423.65, 1129.78, 326.6), 7.2, 5, {
	-- 	heading = 347,
	-- 	--debugPoly=true,
	-- 	minZ = 324.4,
	-- 	maxZ = 330.2,
	-- }, {
	-- 	VOIP_MICROPHONE = true,
	-- 	VOIP_MICROPHONE_RANGE = 40.0,
	-- })

	Polyzone.Create:Poly("woods-saloon-stage-area", {
		vector2(-302.32943725586, 6256.03515625),
		vector2(-303.57437133789, 6257.0512695312),
		vector2(-304.86837768555, 6257.4614257812),
		vector2(-306.24032592773, 6257.2270507812),
		vector2(-307.33044433594, 6256.5620117188),
		vector2(-308.42529296875, 6255.6479492188),
		vector2(-305.61660766602, 6252.7807617188),
	}, {
		--debugPoly=true,
		minZ = 29.526962280273,
		maxZ = 33.530416488647,
	}, {
		VOIP_MICROPHONE = true,
		VOIP_MICROPHONE_RANGE = 30.0,
	})

	Polyzone.Create:Box("microphone_unicorn_dj", vector3(120.51, -1281.51, 29.48), 3.2, 1.8, {
		heading = 30,
		--debugPoly=true,
		minZ = 28.48,
		maxZ = 31.48,
	}, {
		VOIP_MICROPHONE = true,
		--VOIP_MICROPHONE_RANGE = 40.0,
	})

	Polyzone.Create:Box("microphone_triad_stage", vector3(-840.07, -718.52, 28.28), 6.0, 4.6, {
		heading = 320,
		--debugPoly=true,
		minZ = 27.28,
		maxZ = 29.68,
	}, {
		VOIP_MICROPHONE = true,
		VOIP_MICROPHONE_RANGE = 40.0,
	})

	Polyzone.Create:Box("microphone_tequila_stage", vector3(-551.23, 284.04, 82.98), 8.0, 3.0, {
		heading = 355,
		--debugPoly=true,
		minZ = 81.98,
		maxZ = 85.18,
	}, {
		VOIP_MICROPHONE = true,
		VOIP_MICROPHONE_RANGE = 40.0,
	})

	Polyzone.Create:Box("microphone_rockford_records_booth1", vector3(-1001.02, -282.4, 44.8), 2, 2, {
		heading = 324,
		--debugPoly=true,
		minZ = 43.8,
		maxZ = 46.6,
	}, {
		VOIP_MICROPHONE = true,
		VOIP_MICROPHONE_RANGE = 12.0,
	})

	Polyzone.Create:Box("microphone_rockford_records_booth2", vector3(-1006.51, -289.22, 44.8), 1.6, 2, {
		heading = 28,
		--debugPoly=true,
		minZ = 43.8,
		maxZ = 46.4,
	}, {
		VOIP_MICROPHONE = true,
		VOIP_MICROPHONE_RANGE = 15.0,
	})

	Polyzone.Create:Box("microphone_rockford_records_booth3", vector3(-1007.51, -294.11, 44.8), 4.2, 6.4, {
		heading = 27,
		--debugPoly=true,
		minZ = 43.8,
		maxZ = 47.2,
	}, {
		VOIP_MICROPHONE = true,
		VOIP_MICROPHONE_RANGE = 15.0,
	})

	Polyzone.Create:Box("microphone_vinewoodbowl", vector3(685.97, 576.13, 130.46), 18.0, 18.2, {
		heading = 340,
		--debugPoly=true,
		minZ = 129.46,
		maxZ = 133.46,
	}, {
		VOIP_MICROPHONE = true,
		VOIP_MICROPHONE_RANGE = 75.0,
	})

	Polyzone.Create:Box("microphone_triad_studio", vector3(-813.82, -719.33, 32.34), 6.6, 5.2, {
		heading = 0,
		--debugPoly=true,
		minZ = 31.34,
		maxZ = 34.74,
	}, {
		VOIP_MICROPHONE = true,
		VOIP_MICROPHONE_RANGE = 15.0,
	})

	Polyzone.Create:Box("microphone_courtroom_main", vector3(-576.85, -210.29, 38.23), 5.8, 2.6, {
		heading = 30,
		--debugPoly=true,
		minZ = 36.83,
		maxZ = 40.83,
	}, {
		VOIP_MICROPHONE = true,
		VOIP_MICROPHONE_RANGE = 50.0,
	})

	Polyzone.Create:Box("microphone_courtroom_podium", vector3(-572.54, -207.85, 38.23), 2, 2, {
		heading = 30,
		--debugPoly=true,
		minZ = 36.43,
		maxZ = 40.43,
	}, {
		VOIP_MICROPHONE = true,
		VOIP_MICROPHONE_RANGE = 50.0,
	})

	Polyzone.Create:Box("microphone_vineyard", vector3(-1925.561, 1998.401, 155.615), 7.0, 7.0, {
		heading = 80.0,
		--debugPoly=true,
		minZ = 153.6,
		maxZ = 158.5,
	}, {
		VOIP_MICROPHONE = true,
		VOIP_MICROPHONE_RANGE = 25.0,
	})

	Polyzone.Create:Box("microphone_vineyard_dj", vector3(-1866.34, 2070.24, 141.57), 2.8, 5.6, {
		heading = 0.0,
		--debugPoly=true,
		minZ = 138.57,
		maxZ = 142.57,
	}, {
		VOIP_MICROPHONE = true,
		VOIP_MICROPHONE_RANGE = 25.0,
	})

	Polyzone.Create:Box("microphone_vineyard_tables", vector3(-1881.26, 2092.21, 140.99), 1.6, 3.0, {
		heading = 344.0,
		--debugPoly=true,
		minZ = 138.19,
		maxZ = 142.19,
	}, {
		VOIP_MICROPHONE = true,
		VOIP_MICROPHONE_RANGE = 20.0,
	})

	Polyzone.Create:Box("microphone_sandy_airfield_stage", vector3(1695.98, 3280.53, 41.71), 4.0, 4.0, {
		heading = 35.00,
		--debugPoly=true,
		minZ = 40.0,
		maxZ = 44.0,
	}, {
		VOIP_MICROPHONE = true,
		VOIP_MICROPHONE_RANGE = 20.0,
	})

	Polyzone.Create:Box("microphone_wedding_to_be_deleted", vector3(-300.63, 2845.66, 55.34), 3.0, 2.0, {
		heading = 66.00,
		--debugPoly=true,
		minZ = 54.0,
		maxZ = 58.0,
	}, {
		VOIP_MICROPHONE = true,
		VOIP_MICROPHONE_RANGE = 20.0,
	})

	Polyzone.Create:Box("microphone_wedding_to_be_deleted2", vector3(-1694.590, -213.516, 57.542), 3.0, 2.0, {
		heading = 103.159,
		--debugPoly=true,
		minZ = 56.0,
		maxZ = 59.0,
	}, {
		VOIP_MICROPHONE = true,
		VOIP_MICROPHONE_RANGE = 20.0,
	})

	Polyzone.Create:Box("microphone_beach_event_festival", vector3(-1462.44, -1314.16, 6.0), 5, 7.4, {
		heading = 20.00,
		--debugPoly=true,
		minZ = 5.0,
		maxZ = 9.0,
	}, {
		VOIP_MICROPHONE = true,
		VOIP_MICROPHONE_RANGE = 50.0,
	})

	Polyzone.Create:Box("microphone_wedding_mansion", vector3(-1582.183, 85.701, 59.121), 3.0, 2.0, {
		heading = 42.212,
		--debugPoly=true,
		minZ = 57.0,
		maxZ = 61.0,
	}, {
		VOIP_MICROPHONE = true,
		VOIP_MICROPHONE_RANGE = 20.0,
	})
end

AddEventHandler("Polyzone:Enter", function(id, testedPoint, insideZones, data)
	if data and data.VOIP_MICROPHONE then
		StartUsingMicrophone(data.VOIP_MICROPHONE_RANGE or VOIP_CONFIG.MicrophoneRange)
	end
end)

AddEventHandler("Polyzone:Exit", function(id, testedPoint, insideZones, data)
	if data and data.VOIP_MICROPHONE then
		StopUsingMicrophone()
	end
end)
