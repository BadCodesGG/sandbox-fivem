PLAYER_CONNECTED = false
PLAYER_SERVER_ID = GetPlayerServerId(PlayerId())
CURRENT_GRID = 0
CURRENT_VOICE_MODE = 1
CURRENT_VOICE_MODE_DATA = nil
VOIP_SETTINGS = nil
PLAYER_TALKING = false

_inDebug = false

_characterLoaded = false

USING_GAG = false
USING_MEGAPHONE = false
USING_MICROPHONE = false

RADIO_TALKING = false
RADIO_CHANNEL = false
RADIO_DATA = {}

CALL_CHANNEL = false
CALL_DATA = {}

SUBMIX_DATA = {}

local started = false
function RunStartup()
	if started then
		return
	end
	started = true

	SUBMIX_DATA = CreateVOIPSubmix()
	VOIP_SETTINGS = GetPlayerVOIPSettings()
end

AddEventHandler("VOIP:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Callbacks = exports["sandbox-base"]:FetchComponent("Callbacks")
	Notification = exports["sandbox-base"]:FetchComponent("Notification")
	Logger = exports["sandbox-base"]:FetchComponent("Logger")
	Hud = exports["sandbox-base"]:FetchComponent("Hud")
	Keybinds = exports["sandbox-base"]:FetchComponent("Keybinds")
	Utils = exports["sandbox-base"]:FetchComponent("Utils")
	Sounds = exports["sandbox-base"]:FetchComponent("Sounds")
	Animations = exports["sandbox-base"]:FetchComponent("Animations")
	Polyzone = exports["sandbox-base"]:FetchComponent("Polyzone")
	VOIP = exports["sandbox-base"]:FetchComponent("VOIP")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["sandbox-base"]:RequestDependencies("VOIP", {
		"Callbacks",
		"Notification",
		"Logger",
		"Hud",
		"Keybinds",
		"Utils",
		"Sounds",
		"Animations",
		"Polyzone",
		"VOIP",
	}, function(error)
		if #error > 0 then
			return
		end
		RetrieveComponents()
		RunStartup()
		CreateMicrophonePolyzones()

		Keybinds:Add("voip_cycleproximity", "Z", "keyboard", "Voice - Cycle Proximity", function()
			if _characterLoaded and PLAYER_CONNECTED then
				VOIP:Cycle()
			end
		end)

		Keybinds:Add("voip_radio", "CAPITAL", "keyboard", "Voice - Radio - Push to Talk", function()
			if _characterLoaded and PLAYER_CONNECTED and not LocalPlayer.state.isDead and not LocalPlayer.state.isCuffed and not LocalPlayer.state.isHardCuffed then
				RadioKeyDown()
			end
		end, function()
			if _characterLoaded and PLAYER_CONNECTED then
				RadioKeyUp()
			end
		end)
	end)
end)

AddEventHandler("mumbleConnected", function()
	if _characterLoaded then
		if not PLAYER_CONNECTED then
			PLAYER_CONNECTED = true
			TriggerEvent("VOIP:Client:ConnectionState", PLAYER_CONNECTED)
		end
	end
end)

AddEventHandler("mumbleDisconnected", function()
	if _characterLoaded then
		if PLAYER_CONNECTED then
			PLAYER_CONNECTED = false
			TriggerEvent("VOIP:Client:ConnectionState", PLAYER_CONNECTED)
		end
	end
end)

RegisterNetEvent("Characters:Client:Spawn")
AddEventHandler("Characters:Client:Spawn", function()
	_characterLoaded = true

	USING_GAG = false
	USING_MEGAPHONE = false
	RADIO_TALKING = false

	CURRENT_VOICE_MODE = 2
	CURRENT_VOICE_MODE_DATA = VOIP_CONFIG.Modes[CURRENT_VOICE_MODE]
	Hud:UpdateVoip(2, false)

	local address, port = GetVOIPMumbleAddress()
	MumbleSetServerAddress(address, port)

	Citizen.SetTimeout(5000, function()
		UpdateVOIPIndicatorStatus()
	end)

	Citizen.CreateThread(function()
		while _characterLoaded do
			Citizen.Wait(100)
			local isTalking = NetworkIsPlayerTalking(PlayerId())
			if isTalking and not PLAYER_TALKING then
				PLAYER_TALKING = true
				TriggerEvent("VOIP:Client:TalkingState", PLAYER_TALKING)
			elseif PLAYER_TALKING and not isTalking then
				PLAYER_TALKING = false
				TriggerEvent("VOIP:Client:TalkingState", PLAYER_TALKING)
			end
		end
	end)

	StartVOIPGridThreads()
end)

RegisterNetEvent("Characters:Client:Logout")
AddEventHandler("Characters:Client:Logout", function()
	_characterLoaded = false

	USING_MEGAPHONE = false

	MumbleSetServerAddress("", 0)
	Logger:Info("VOIP", "Disconnecting From Mumble (Character Logging Out)")
end)

AddEventHandler("VOIP:Client:ConnectionState", function(state)
	if state then
		Logger:Info("VOIP", "Connected to Mumble Server")

		while not LocalPlayer.state.voiceChannel do
			print("Waiting to Be Assigned Voice Channel")
			Citizen.Wait(100)
		end
	
		MumbleClearVoiceTarget(1)
		MumbleSetVoiceTarget(1)
	
		print("Assigned Voice Channel", LocalPlayer.state.voiceChannel)
		MumbleSetVoiceChannel(LocalPlayer.state.voiceChannel)
	
		while MumbleGetVoiceChannelFromServerId(PLAYER_SERVER_ID) ~= LocalPlayer.state.voiceChannel do
			Citizen.Wait(250)
			MumbleSetVoiceChannel(LocalPlayer.state.voiceChannel)
		end
	
		MumbleAddVoiceTargetChannel(1, LocalPlayer.state.voiceChannel)

		MumbleSetTalkerProximity(CURRENT_VOICE_MODE_DATA.Range + 0.0)
	else
		Logger:Warn("VOIP", "Disconnected from Mumble Server")
		StopUsingMegaphone()
	end

	if _characterLoaded then
		UpdateVOIPIndicatorStatus()
	end
end)

AddEventHandler("VOIP:Client:TalkingState", function()
	UpdateVOIPIndicatorStatus()
end)

function UpdateVOIPIndicatorStatus()
	local indicatorColor = "#610000"
	local indicatorIcon = "microphone-slash"
	local fillPercent = 100

	local stage = CURRENT_VOICE_MODE
	local talking = 0

	if PLAYER_CONNECTED then
		indicatorColor = "#ababab"
		indicatorIcon = "microphone"

		if RADIO_CHANNEL and RADIO_CHANNEL > 0 then
			indicatorIcon = "walkie-talkie"
		end

		if CALL_CHANNEL and CALL_CHANNEL > 0 then
			indicatorIcon = "phone-volume"
		end

		if PLAYER_TALKING then
			talking = 1
		end

		if RADIO_TALKING then
			talking = 2
		end

		fillPercent = (100 / #VOIP_CONFIG.Modes) * CURRENT_VOICE_MODE

		if USING_MEGAPHONE then
			indicatorIcon = "megaphone"
			stage = 3
		end

		if USING_MICROPHONE then
			indicatorIcon = "microphone-stand"
			stage = 3
		end

		if USING_GAG then
			indicatorIcon = "volume-xmark"
		end
	end

	
	Hud:UpdateVoip(stage, talking, indicatorIcon)
end

_fuckingVOIP = {
	Cycle = function(self, num)
		if playerMuted or USING_MEGAPHONE or USING_MICROPHONE then
			return
		end
		local newMode = CURRENT_VOICE_MODE + 1
		if num then
			newMode = num
		end
		if newMode > #VOIP_CONFIG.Modes then
			newMode = 1
		end

		CURRENT_VOICE_MODE = newMode
		CURRENT_VOICE_MODE_DATA = VOIP_CONFIG.Modes[CURRENT_VOICE_MODE]
		--MumbleSetAudioInputDistance(CURRENT_VOICE_MODE_DATA.Range + 0.0)
		MumbleSetTalkerProximity(CURRENT_VOICE_MODE_DATA.Range + 0.0)
		UpdateVOIPIndicatorStatus()

		LocalPlayer.state:set("proximity", CURRENT_VOICE_MODE_DATA.Range, false)
		Logger:Trace("VOIP", "New Voice Range: " .. CURRENT_VOICE_MODE)
	end,
	ToggleVoice = function(self, plySource, enabled, voiceType, volume)
		local volumeOverride = volume or GetVolumeForVoiceType(voiceType)
		if volumeOverride then
			MumbleSetVolumeOverrideByServerId(plySource, enabled and volumeOverride or -1.0)
		else
			MumbleSetVolumeOverrideByServerId(plySource, -1.0)
		end

		if enabled and voiceType and SUBMIX_DATA and SUBMIX_DATA[voiceType] then
			MumbleSetSubmixForServerId(plySource, SUBMIX_DATA[voiceType])
		else
			MumbleSetVolumeOverrideByServerId(plySource, -1.0)
			MumbleSetSubmixForServerId(plySource, -1)
		end
	end,
	MicClicks = function(self, on, isLocal)
		if on then
			Sounds.Do.Play:One("mic_click_on.ogg", 0.1 * (VOIP_SETTINGS?.RadioClickVolume or 1.0))
		else
			Sounds.Do.Play:One("mic_click_off.ogg", 0.1 * (VOIP_SETTINGS?.RadioClickVolume or 1.0))
		end
	end,
	SetPlayerTargets = function(self, ...)
		local targets = { ... }
		local addedPlayers = {
			[PLAYER_SERVER_ID] = true,
		}

		for i = 1, #targets do
			for id, _ in pairs(targets[i]) do
				if addedPlayers[id] and id ~= PLAYER_SERVER_ID then
					goto continue
				end
				if not addedPlayers[id] then
					addedPlayers[id] = true
					MumbleAddVoiceTargetPlayerByServerId(1, id)
				end
				::continue::
			end
		end
	end,
	Settings = {
		Volumes = {
			Radio = {
				Set = function(self, val)
					if type(val) == "number" and val >= 0 and val <= 200 then
						VOIP_SETTINGS = SetPlayerVOIPSetting("RadioVolume", val / 100)
					end

					return VOIP_SETTINGS.RadioVolume * 100
				end,
				Get = function(self)
					if VOIP_SETTINGS then
						return VOIP_SETTINGS.RadioVolume * 100
					end
				end,
			},
			RadioClicks = {
				Set = function(self, val)
					if type(val) == "number" and val >= 0 and val <= 200 then
						VOIP_SETTINGS = SetPlayerVOIPSetting("RadioClickVolume", val / 100)
					end

					return VOIP_SETTINGS.RadioClickVolume * 100
				end,
				Get = function(self)
					if VOIP_SETTINGS then
						return VOIP_SETTINGS.RadioClickVolume * 100
					end
				end,
			},
			Phone = {
				Set = function(self, val)
					if type(val) == "number" and val >= 0 and val <= 200 then
						VOIP_SETTINGS = SetPlayerVOIPSetting("CallVolume", val / 100)
					end

					return VOIP_SETTINGS.CallVolume * 100
				end,
				Get = function(self)
					if VOIP_SETTINGS then
						return VOIP_SETTINGS.CallVolume * 100
					end
				end,
			},
		},
	},
}

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["sandbox-base"]:RegisterComponent("VOIP", _fuckingVOIP)
end)

CreateThread(function()
	MumbleSetServerAddress("", 0)
end)

function GetVolumeForVoiceType(type)
	if type == "phone" then
		return 1.0 -- VOIP_SETTINGS.CallVolume
	elseif type == "radio" or type == "radio_med" or type == "radio_far" or type == "radio_really_far" then
		return VOIP_SETTINGS.RadioVolume
	end
	return false
end

RegisterNetEvent("VOIP:Client:ToggleDebugMode", function()
	_inDebug = not _inDebug
end)