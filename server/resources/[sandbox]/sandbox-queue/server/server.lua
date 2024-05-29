Convar = {}

local queueEnabled, queueActive, queueClosed = true, false, false
local resourceName = GetCurrentResourceName()
local MAX_PLAYERS = tonumber(GetConvar("sv_maxclients", "32"))

GlobalState["MaxPlayers"] = MAX_PLAYERS

local playerJoining = false
local privPlayerJoining = false

local _dbReadyTime = 0
local _dbReady = false

AddEventHandler("Queue:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	c = exports["sandbox-base"]:FetchComponent("Config")
	Database = exports["sandbox-base"]:FetchComponent("Database")
	WebAPI = exports["sandbox-base"]:FetchComponent("WebAPI")
	Punishment = exports["sandbox-base"]:FetchComponent("Punishment")
	Queue = exports["sandbox-base"]:FetchComponent("Queue")
	Convar = exports["sandbox-base"]:FetchComponent("Convar")
	Chat = exports["sandbox-base"]:FetchComponent("Chat")
	Execute = exports["sandbox-base"]:FetchComponent("Execute")
	Sequence = exports["sandbox-base"]:FetchComponent("Sequence")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["sandbox-base"]:RequestDependencies("Queue", {
		"Config",
		"Database",
		"WebAPI",
		"Punishment",
		"Queue",
		"Convar",
		"Chat",
		"Execute",
		"Sequence",
	}, function(error)
		if #error > 0 then return; end
		RetrieveComponents()

		Config.Server = c.Server
		Config.Groups = c.Groups
		queueActive = true

		Chat:RegisterAdminCommand("queue", function(source, args, rawCommand)
			local message = "Queue List"

			for k, v in ipairs(QUEUE_PLAYERS_SORTED) do
				local pData = QUEUE_PLAYERS_DATA[v]
				if pData then
					message = message .. string.format("<br>#%d - %s (%s)", k, pData.Name, v)
				end
			end
			Chat.Send.System:Single(source, message)
		end, {
			help = "Print the Queue",
		})

		Chat:RegisterAdminCommand("yeetqueue", function(source, args, rawCommand)
			for k, v in pairs(QUEUE_PLAYERS) do
				if QUEUE_PLAYERS_DATA[k] then
					QUEUE_PLAYERS_DATA[k].Deferrals.done("Deleted")
				end

				Queue.Queue:Pop(k, true)
			end
			Chat.Send.System:Single(source, "Done")
		end, {
			help = "Yeet the Queue [DANGER!]",
		})

		Chat:RegisterAdminCommand("maxplayers", function(source, args, rawCommand)
			local max = tonumber(args[1])
			if max and max > 0 and max < 500 then
				MAX_PLAYERS = max
				GlobalState["MaxPlayers"] = MAX_PLAYERS
				SetConvarServerInfo("sv_maxclients", MAX_PLAYERS)
				Chat.Send.System:Single(source, "Max Players Set")
			end
		end, {
			params = {
				{
					name = "Max Player Count",
					help = "Number",
				},
			},
			help = "Set Max Players",
		})

		Chat:RegisterStaffCommand("tempprio", function(source, args, rawCommand)
			local ident = args[1]
			local prio = tonumber(args[2])

			if ident and prio and prio > 0 and prio <= 200 then
				Queue:AddTempPriority(ident, prio)
				Chat.Send.System:Single(source, "Priority Added")
			else
				Chat.Send.System:Single(source, "Error")
			end
		end, {
			params = {
				{
					name = "Player Identifier",
					help = "Player's FiveM Identifier (License)",
				},
				{
					name = "Priority",
					help = "Number (1-200)",
				},
			},
			help = "Add Temporary Priority",
		})
	end)

	_dbReadyTime = GetGameTimer()
	_dbReady = true
end)

QUEUE_PLAYERS_DATA = {}

QUEUE_PLAYERS = {}
QUEUE_PLAYERS_SORTED = {}

CURRENT_CONNECTORS = {} 
CURRENT_CONNECTORS_COUNT = 0

QUEUE_CRASH_PRIORITY = {}
QUEUE_TEMP_PRIORITY = {}

CONNECTING_PLAYERS_DATA = {}

QUEUE_PLAYER_HISTORY = {} -- For remembering queue positions

local PACResourceName = "sandbox-pwnzor2"
local _waitingForPac = {}
local _pacInstalled = true

-- Ensure pac is fully ready for our new hook
AddEventHandler("PhoenixAC::Loaded", function()
    exports[PACResourceName]:AddHook("PhoenixAC::PlayerConnected", "CustomDeferralState",
    function(Source, Name, Kick, Deferrals)
		_waitingForPac[Source] = false
    end)
end)

_QUEUE = {
	HandleAccountLinking = function(self, identifier, deferrals)
		local p = promise.new()

		deferrals.presentCard(Config.Cards.NotWhitelisted, function(data, rawData)
			if data.linking then
				Citizen.SetTimeout(50, function()
					deferrals.presentCard(Config.Cards.AccountLinking, function(data, rawData)
						if data.code and #data.code > 8 then
							local sRes = WebAPI:Request("GET", "serverAPI/linking", {
								license = identifier,
								code = _b64enc(data.code),
							}, {})

							if sRes.code == 200 and sRes.data?.success then
								deferrals.update(Config.Strings.WebLinkComplete)
								p:resolve(true)
							else
								deferrals.done(Config.Strings.WebLinkError)
								p:resolve(false)
							end
						else
							if data.cancel then
								deferrals.done(Config.Strings.NotWhitelisted)
							else
								deferrals.done(Config.Strings.WebLinkError)
							end

							p:resolve(false)
						end
					end)
				end)
			else
				deferrals.done(Config.Strings.NotWhitelisted)
				p:resolve(false)
			end
		end)

		return Citizen.Await(p)
	end,
	HandleConnection = function(self, source, identifier, deferrals)
		if GlobalState.IsProduction then
			while GetGameTimer() < (_dbReadyTime + (Config.Settings.QueueDelay * (1000 * 60))) do
				local min = math.floor(
					(
						(math.floor(_dbReadyTime / 1000) + (Config.Settings.QueueDelay * 60))
						- math.floor(GetGameTimer() / 1000)
					) / 60
				)
				local secs = math.floor(
					(
						(math.floor(_dbReadyTime / 1000) + (Config.Settings.QueueDelay * 60))
						- math.floor(GetGameTimer() / 1000)
					) - (min * 60)
				)

				if min <= 0 then
					deferrals.update(
						string.format(Config.Strings.WaitingSeconds, secs, secs ~= 1 and "Seconds" or "Second")
					)
				else
					deferrals.update(
						string.format(
							Config.Strings.Waiting,
							min,
							min ~= 1 and "Minutes" or "Minute",
							secs,
							secs ~= 1 and "Seconds" or "Second"
						)
					)
				end
				Citizen.Wait(100)
			end
		end

		while not queueActive do
			Citizen.Wait(100)
		end

		Queue.Queue:Pop(identifier)

		local ply = PlayerClass(identifier, source, deferrals)

		if GetConvar("SERVER_TYPE", "prod") == "prod" then
			if not ply or not ply:IsWhitelisted() then
				local success = Queue:HandleAccountLinking(identifier, deferrals)

				if not success then
					return CancelEvent()
				end

				Citizen.Wait(5000)

				ply = PlayerClass(identifier, source, deferrals)
			end
		end

		if not ply or not ply:IsWhitelisted() or not GetPlayerEndpoint(source) then
			deferrals.done(Config.Strings.NotWhitelisted)
			return CancelEvent()
		end

		-- Banning Handled by TxAdmin

		local time = GetGameTimer()
		local joinedAt = GetGameTimer()
		local useSavedPos = false
		if QUEUE_PLAYER_HISTORY[identifier] and QUEUE_PLAYER_HISTORY[identifier].expires > GetGameTimer() then
			joinedAt = QUEUE_PLAYER_HISTORY[identifier].joinedAt
			useSavedPos = true
		end

		QUEUE_PLAYERS_DATA[identifier] = ply
		QUEUE_PLAYERS[identifier] = {
			priority = ply:GetPriority(),
			joinedAt = joinedAt,
			time = time,
		}
		QUEUE_PLAYER_HISTORY[identifier] = {
			joinedAt = joinedAt,
			expires = GetGameTimer() + (Config.Settings.SavePosition * 60000),
		}

		Queue.Queue:Sort()
		Citizen.Wait(1000)

		local pos, total = Queue.Queue:GetPosition(identifier)
		Log(
			string.format(
				Config.Strings.Add,
				ply.Name,
				ply.AccountID,
				ply.Identifier,
				pos,
				total,
				GetNumPlayerIndices(),
				ply.Priority
			)
		)

		while GetPlayerEndpoint(source) and not queueClosed and (
			(not Queue.Queue:Check(identifier)) 
			or (GetNumPlayerIndices() == MAX_PLAYERS) 
			or ((GetNumPlayerIndices() + CURRENT_CONNECTORS_COUNT + 1) > MAX_PLAYERS) 
			or ((GetNumPlayerIndices() + CURRENT_CONNECTORS_COUNT) >= MAX_PLAYERS)
		) do
			ply.Timer:Tick()
			local pos, total = Queue.Queue:GetPosition(identifier)
			local msg = ""
			if ply.Priority > 0 then
				msg = "\n\nTotal Priority of " .. ply.Priority .. ": " .. ply.Message
			end

			if useSavedPos then
				msg = msg .. "\n\n🥳 You Were Returned to Your Saved Queue Position"
			end

			if pos == nil or total == nil then
				print("Someone In Queue nil/nil ID:", ply.Identifier, "Data: ", identifier, pos, total, json.encode(QUEUE_PLAYERS_DATA[identifier]), json.encode(QUEUE_PLAYERS[identifier]))
			end

			ply.Deferrals.update(string.format(Config.Strings.Queued, pos, total, ply.Timer:Output(), msg))

			if QUEUE_PLAYER_HISTORY[identifier] then
				QUEUE_PLAYER_HISTORY[identifier].expires = GetGameTimer() + (Config.Settings.SavePosition * 60000)
			end

			Citizen.Wait(5000)
		end

		-- Can join the server now :)

		if queueClosed then
			deferrals.done(Config.Strings.PendingRestart)
			Queue.Queue:Pop(identifier, true)
			return CancelEvent()
		end

		if GetPlayerEndpoint(source) then
			CURRENT_CONNECTORS[identifier] = {
				source = source
			}
			CURRENT_CONNECTORS_COUNT += 1

			ply.Deferrals.update(Config.Strings.Joining)
			-- ply.Deferrals.handover({
			-- 	name = ply.Name,
			-- 	priority = ply.Priority,
			-- 	priorityMessage = ply.Message,
			-- })
			Citizen.Wait(500)
			ply.Deferrals.done()

			Log(
				string.format(
					Config.Strings.Joined,
					ply.Name,
					ply.AccountID,
					ply.Identifier
				)
			)

			CONNECTING_PLAYERS_DATA[identifier] = ply
			Queue.Queue:Pop(identifier)
		else
			if QUEUE_PLAYERS[identifier] and QUEUE_PLAYERS[identifier].time == time then
				Queue.Queue:Pop(identifier, true)
			end
		end
	end,
	Queue = {
		Sort = function(self)
			local sorted = getKeysSortedByValue(QUEUE_PLAYERS, function(a, b) 
				if a.priority ~= b.priority then
					return a.priority > b.priority
				end

				return a.joinedAt < b.joinedAt
			end)

			QUEUE_PLAYERS_SORTED = sorted
		end,
		Pop = function(self, identifier, disconnect)
			if QUEUE_PLAYERS[identifier] then
				QUEUE_PLAYERS[identifier] = nil
				local ply = QUEUE_PLAYERS_DATA[identifier]
				if ply and disconnect then
					Log(
						string.format(
							Config.Strings.Disconnected,
							ply.Name,
							ply.AccountID,
							ply.Identifier
						)
					)
				end

				QUEUE_PLAYERS_DATA[identifier] = nil
				Queue.Queue:Sort()
			end
		end,
		Check = function(self, identifier)
			if QUEUE_PLAYERS_SORTED[1] == identifier then
				return true
			end
			return false
		end,
		GetCount = function(self)
			local count = 0
			for k,v in pairs(QUEUE_PLAYERS) do
				count += 1
			end
			return count
		end,
		GetPosition = function(self, identifier)
			local count = 0
			local found = nil
			for k,v in ipairs(QUEUE_PLAYERS_SORTED) do
				count += 1

				if v == identifier then
					found = k
				end
			end

			return found, count
		end,
		CheckGhosts = function(self)
			for k, v in pairs(CURRENT_CONNECTORS) do
				if v and not GetPlayerEndpoint(v.source) then
					CURRENT_CONNECTORS[k] = nil
				end
			end

			local count = 0
			for k,v in pairs(CURRENT_CONNECTORS) do
				if v then
					count += 1
				end	
			end

			CURRENT_CONNECTORS_COUNT = count
		end,
	},
	AddCrashPriority = function(self, identifier, message)
		-- for _, v in ipairs(Config.ExcludeDrop) do
		-- 	if string.find(message, v) then
		-- 		return
		-- 	end
		-- end

		local ply = QUEUE_PLAYERS_DATA[identifier]
		if ply then
			Log(
				string.format(
					Config.Strings.Crash,
					ply.Name,
					ply.AccountID,
					ply.Identifier
				)
			)
		end

		table.insert(QUEUE_CRASH_PRIORITY, {
			Identifier = identifier,
			Grace = os.time() + (60 * 20),
		})
	end,
	HasCrashPriority = function(self, identifier)
		for k, v in ipairs(QUEUE_CRASH_PRIORITY) do
			if v.Identifier == identifier and os.time() < v.Grace then
				return true
			end
		end
	end,
	AddTempPriority = function(self, identifier, prio)
		Queue:RemoveTempPriority(identifier)

		table.insert(QUEUE_TEMP_PRIORITY, {
			Identifier = identifier,
			Priority = prio,
		})
	end,
	RemoveTempPriority = function(self, identifier)
		for k, v in ipairs(QUEUE_TEMP_PRIORITY) do
			if v.Identifier == identifier then
				table.remove(QUEUE_TEMP_PRIORITY, k)
			end
		end
	end,
	HasTempPriority = function(self, identifier)
		for k, v in ipairs(QUEUE_TEMP_PRIORITY) do
			if v.Identifier == identifier then
				return v
			end
		end
	end,
	Utils = {
		CloseAndDrop = function(self)
			queueClosed = true

			for k, v in pairs(QUEUE_PLAYERS) do
				if QUEUE_PLAYERS_DATA[k] then
					QUEUE_PLAYERS_DATA[k].Deferrals.done("Deleted")
				end

				Queue.Queue:Pop(k, true)
			end
		end
	}
}

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["sandbox-base"]:RegisterComponent("Queue", _QUEUE)
end)

AddEventHandler("playerConnecting", function(playerName, setKickReason, deferrals)
	local _src = source
	_waitingForPac[source] = true

	deferrals.defer()
	Citizen.Wait(1)
	deferrals.update(_pacInstalled and Config.Strings.ACWaiting or Config.Strings.Init)

	if not _dbReady or GlobalState.IsProduction == nil then
		deferrals.done(Config.Strings.NotReady)
		return CancelEvent()
	end

	if queueClosed then
		deferrals.done(Config.Strings.PendingRestart)
		return CancelEvent()
	end

	local identifier = GetPlayerLicense(_src)
	if not identifier or identifier == "" then
		deferrals.done(Config.Strings.NoIdentifier)
		return CancelEvent()
	end

	if Queue == nil then
		deferrals.done(Config.Strings.NotReady)
		return CancelEvent()
	end

	while _waitingForPac[_src] and _pacInstalled do
		Citizen.Wait(10)
	end

	Queue:HandleConnection(_src, identifier, deferrals)
end)

AddEventHandler("playerDropped", function(message)
	local src = source

	_waitingForPac[src] = nil

	local license = GetPlayerLicense(src)
	if license then
		if CURRENT_CONNECTORS[license] then
			if CURRENT_CONNECTORS_COUNT >= 1 then
				CURRENT_CONNECTORS_COUNT -= 1
			end

			CURRENT_CONNECTORS[license] = nil
		end

		Queue:AddCrashPriority(license, message)
		if QUEUE_PLAYERS[license] then
			print("lol someone just got playerDropped while in queue somehow", license, message)
		end
		-- Queue.Queue:Pop(license, true)
	end
end)

RegisterServerEvent("Core:Server:SessionStarted")
AddEventHandler("Core:Server:SessionStarted", function()
	local src = source
	local license = GetPlayerLicense(src)
	if license then
		if CURRENT_CONNECTORS[license] then
			if CURRENT_CONNECTORS_COUNT >= 1 then
				CURRENT_CONNECTORS_COUNT -= 1
			end

			-- print("Remove Joiner", CURRENT_CONNECTORS_COUNT)

			CURRENT_CONNECTORS[license] = nil
		end

		local ply = CONNECTING_PLAYERS_DATA[license]
		if ply then
			TriggerClientEvent("Queue:Client:SessionActive", src)
			TriggerEvent("Queue:Server:SessionActive", src, {
				Groups = ply.Groups,
				Name = ply.Name,
				Discord = ply.Discord,
				Mention = ply.Mention,
				AccountID = ply.AccountID,
				Avatar = ply.Avatar,
				Identifier = ply.Identifier,
				Tokens = ply.Tokens,
			})

			CONNECTING_PLAYERS_DATA[license] = nil
			Queue:RemoveTempPriority(license)
			return
		end
	end

	DropPlayer(src, Config.Strings.NoIdentifier)
end)

Citizen.CreateThread(function()
	while not queueActive do
		Citizen.Wait(1000)
	end

	if not exports["sandbox-base"]:FetchComponent("WebAPI").Enabled then
		Log("^8Queue Disabled^7", { console = true })
		queueEnabled = false
		return
	end

	_pacInstalled = GetResourceState(PACResourceName) ~= "stopped"

	while GetResourceState("hardcap") ~= "stopped" do
		local state = GetResourceState("hardcap")
		if state == "missing" then
			break
		end

		if state == "started" then
			StopResource("hardcap")
			break
		end

		Citizen.Wait(5000)
	end

	Citizen.Wait(10000)
end)

Citizen.CreateThread(function()
	while true do
		if Queue ~= nil then
			GlobalState["QueueCount"] = Queue.Queue:GetCount()

			Queue.Queue:CheckGhosts()
		end

		Citizen.Wait(20000)
	end
end)

RegisterCommand("print_connect_count", function()
	print("CC", CURRENT_CONNECTORS_COUNT)
end, true)

RegisterCommand("print_queue", function()
	print("CC", json.encode(QUEUE_PLAYERS, { indent = true }))
end, true)
