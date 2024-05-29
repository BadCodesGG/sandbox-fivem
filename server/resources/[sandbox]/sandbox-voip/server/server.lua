voiceData = {}
radioData = {}
callData = {}

local mappedChannels = {}

function firstFreeChannel()
	for i = 1, 2048 do
		if not mappedChannels[i] then
			return i
		end
	end

	return 0
end

function GetDefaultPlayerVOIPData(source)
	return {
		Radio = 0,
		Call = 0,
		LastRadio = 0,
		LastCall = 0,
	}
end

AddEventHandler("VOIP:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Database = exports["sandbox-base"]:FetchComponent("Database")
	Callbacks = exports["sandbox-base"]:FetchComponent("Callbacks")
	Fetch = exports["sandbox-base"]:FetchComponent("Fetch")
	Chat = exports["sandbox-base"]:FetchComponent("Chat")
	Middleware = exports["sandbox-base"]:FetchComponent("Middleware")
	Logger = exports["sandbox-base"]:FetchComponent("Logger")
	Inventory = exports["sandbox-base"]:FetchComponent("Inventory")
	VOIP = exports["sandbox-base"]:FetchComponent("VOIP")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["sandbox-base"]:RequestDependencies("VOIP", {
		"Database",
		"Callbacks",
		"Fetch",
		"Chat",
		"Middleware",
		"Logger",
		"Inventory",
		"VOIP",
	}, function(error)
		if #error > 0 then
			return
		end -- Do something to handle if not all dependencies loaded
		RetrieveComponents()
		RegisterMiddleware()

		local mAddress = GetConvar("ext_mumble_address", "")
		if mAddress ~= "" then
			GlobalState.MumbleAddress = mAddress
			GlobalState.MumblePort = GetConvarInt("ext_mumble_port", 64738)
		end

		--RegisterChatCommands()
		Inventory.Items:RegisterUse("radio", "VOIP", function(source, itemData)
			TriggerClientEvent("Radio:Client:OpenUI", source, 1)
		end)

		Inventory.Items:RegisterUse("radio_shitty", "VOIP", function(source, itemData)
			TriggerClientEvent("Radio:Client:OpenUI", source, 3)
		end)

		Inventory.Items:RegisterUse("radio_extendo", "VOIP", function(source, itemData)
			TriggerClientEvent("Radio:Client:OpenUI", source, 2)
		end)

		Inventory.Items:RegisterUse("megaphone", "VOIP", function(source, itemData)
			TriggerClientEvent("VOIP:Client:Megaphone:Use", source, false)
		end)
	end)
end)

function RegisterMiddleware()
	Middleware:Add("Characters:Spawning", function(source)
		VOIP:AddPlayer(source)
	end, 3)
end

_fuckingVOIP = {
	AddPlayer = function(self, source)
		if not voiceData[source] then
			voiceData[source] = GetDefaultPlayerVOIPData()

			local plyState = Player(source).state

			if plyState then
				local chan = firstFreeChannel()
				if chan > 0 then
					mappedChannels[chan] = source

					plyState:set("voiceChannel", chan, true)
				end
			end
		end
	end,
	RemovePlayer = function(self, source)
		if voiceData[source] then
			local plyData = voiceData[source]

			if plyData.Radio > 0 then
				VOIP.Radio:SetChannel(source, 0)
			end

			if plyData.Call > 0 then
				VOIP.Phone:SetChannel(source, 0)
			end

			voiceData[source] = nil
		end

		local aChannel = Player(source).state.voiceChannel
		if aChannel then
			mappedChannels[aChannel] = nil
		end
	end,
}

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["sandbox-base"]:RegisterComponent("VOIP", _fuckingVOIP)
end)

AddEventHandler("Characters:Server:PlayerLoggedOut", function(source)
	VOIP:RemovePlayer(source)
end)
