AddEventHandler("Commands:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Fetch = exports["sandbox-base"]:FetchComponent("Fetch")
	Callbacks = exports["sandbox-base"]:FetchComponent("Callbacks")
	Chat = exports["sandbox-base"]:FetchComponent("Chat")
	Config = exports["sandbox-base"]:FetchComponent("Config")
	Sounds = exports["sandbox-base"]:FetchComponent("Sounds")
	Execute = exports["sandbox-base"]:FetchComponent("Execute")
	Waitlist = exports["sandbox-base"]:FetchComponent("WaitList")
	Pwnzor = exports["sandbox-base"]:FetchComponent("Pwnzor")
	RegisterChatCommands()
end

AddEventHandler("Core:Shared:Ready", function()
	exports["sandbox-base"]:RequestDependencies("Commands", {
		"Chat",
		"Callbacks",
		"Config",
		"Sounds",
		"Execute",
		"WaitList",
		"Pwnzor",
	}, function(error)
		if #error > 0 then
			return
		end -- Do something to handle if not all dependencies loaded
		RetrieveComponents()
		RegisterCallbacks()
	end)
end)

function RegisterChatCommands()
	Chat:RegisterCommand("clear", function(source, args, rawCommand)
		TriggerClientEvent("chat:clearChat", source)
	end, {
		help = "Clear The Chat",
	})

	Chat:RegisterCommand("ooc", function(source, args, rawCommand)
		if #rawCommand:sub(4) > 0 then
			Chat.Send:OOC(source, rawCommand:sub(4))
		end
	end, {
		help = "Out of Character Chat, THIS IS NOT A SUPPORT CHAT",
		params = {
			{
				name = "Message",
				help = "The Message You Want To Send To The OOC Channel",
			},
		},
	}, -1)

	Chat:RegisterCommand("dice", function(source, args, rawCommand)
		local weight = tonumber(args[1]) or 6
		local times = tonumber(args[2]) or 1

		if weight > 1 and times > 0 then
			if weight > 100 then
				weight = 100
			end

			if times > 5 then
				times = 5
			end

			local str = ""
			for i = 1, times do
				str = str .. string.format("Dice Roll: %s/%s~n~", math.random(weight), weight)
			end

			TriggerClientEvent("Animations:Client:DiceRoll", source)
			Citizen.Wait(1000)
			TriggerClientEvent("Chat:Client:ReceiveMe", -1, source, GetGameTimer(), str, true)
		else
			Chat.Send.System:Single(source, "Invalid Arguments")
		end
	end, {
		help = "Roll a Dice",
		params = {
			{
				name = "Weight",
				help = "What number does the dice go up to?",
			},
			{
				name = "Times",
				help = "How many times do you want to roll?",
			},
		},
	}, -1)

	Chat:RegisterCommand("streamermode", function(source, args, rawCommand)
		TriggerClientEvent("Commands:Client:StreamerMode", source)
	end, {
		help = "Toggle Streamer Mode (Disables Any Music Playing)",
	})

	--[[ ADMIN-RESTRICTED COMMANDS ]]

	Chat:RegisterStaffCommand("screenshot", function(source, args, rawCommand)
		local sid = tonumber(args[1])
		Pwnzor:Screenshot(sid, "Requested With Command")
	end, {
		help = "Screenshot Specified Player",
		params = {
			{
				name = "State ID",
				help = "ID of the Waitlist to screenshot",
			},
		},
	}, 1)

	Chat:RegisterAdminCommand("printqueue", function(source, args, rawCommand)
		Waitlist:PrintQueue(args[1])
	end, {
		help = "Prints Players In Specified Waitlist",
		params = {
			{
				name = "ID",
				help = "ID of the Waitlist to print",
			},
		},
	}, 1)
	--
	Chat:RegisterAdminCommand("debug", function(source, args, rawCommand)
		TriggerClientEvent("HUD:Client:Debug", source)
	end, {
		help = "Toggle debugger",
	})

	Chat:RegisterAdminCommand("server", function(source, args, rawCommand)
		Chat.Send.Server:All(rawCommand:sub(8))
	end, {
		help = "Send Server Message To All Players",
		params = {
			{
				name = "Message",
				help = "The Message You Want To Send To Server Channel",
			},
		},
	}, -1)

	Chat:RegisterAdminCommand("system", function(source, args, rawCommand)
		Chat.Send.System:All(rawCommand:sub(8))
	end, {
		help = "Send System Message To All Players",
		params = {
			{
				name = "Message",
				help = "The Message You Want To Send To System Channel",
			},
		},
	}, -1)

	Chat:RegisterAdminCommand("broadcast", function(source, args, rawCommand)
		local auth = Fetch:Source(source)
		Chat.Send.Broadcast:All(auth:GetData("Name"), rawCommand:sub(10))
	end, {
		help = "Make A Broadcast To All Players",
		params = {
			{
				name = "Message",
				help = "The Message You Want To Send To Broadcast Channel",
			},
		},
	}, -1)

	-- Chat:RegisterStaffCommand("kicksource", function(source, args, rawCommand)
	-- 	local data = exports["sandbox-base"]:FetchComponent("Punishment"):Kick(tonumber(args[1]), args[2], source)
	-- 	if data and data.success then
	-- 		Chat.Send.Server:Single(
	-- 			source,
	-- 			string.format("%s [%s] Has Been Kicked For %s", data.Name, data.AccountID, data.reason)
	-- 		)
	-- 	elseif not data.success then
	-- 		if data and data.success and data.message then
	-- 			Chat.Send.Server:Single(source, data.message)
	-- 		else
	-- 			Chat.Send.Server:Single(source, "Error Kicking")
	-- 		end
	-- 	end
	-- end, {
	-- 	help = "Kick Player By Server ID",
	-- 	params = {
	-- 		{
	-- 			name = "Target",
	-- 			help = "Server ID of Who You Want To Kick",
	-- 		},
	-- 		{
	-- 			name = "Reason",
	-- 			help = "Reason For The Kick",
	-- 		},
	-- 	},
	-- }, -1)

	-- Chat:RegisterStaffCommand("kick", function(source, args, rawCommand)
	-- 	local t = Fetch:SID(tonumber(args[1]))
	-- 	if t ~= nil then
	-- 		if t:GetData("Source") ~= source then
	-- 			exports["sandbox-base"]:FetchComponent("Punishment"):Kick(t:GetData("Source"), args[2], source)
	-- 		else
	-- 			Chat.Send.System:Single(source, "Cannot Kick Yourself")
	-- 		end
	-- 	else
	-- 		Chat.Send.System:Single(source, "Invalid State ID")
	-- 	end
	-- end, {
	-- 	help = "Kick Player By State ID",
	-- 	params = {
	-- 		{
	-- 			name = "Target",
	-- 			help = "State ID of Who You Want To Kick",
	-- 		},
	-- 		{
	-- 			name = "Reason",
	-- 			help = "Reason For The Kick",
	-- 		},
	-- 	},
	-- }, 2)

	-- Chat:RegisterAdminCommand("unban", function(source, args, rawCommand)
	-- 	exports["sandbox-base"]:FetchComponent("Punishment").Unban:BanID(args[1], source)
	-- end, {
	-- 	help = "Unban Player",
	-- 	params = {
	-- 		{
	-- 			name = "Ban ID",
	-- 			help = "Unique Ban ID You're Disabling",
	-- 		},
	-- 	},
	-- }, 1)

	-- Chat:RegisterAdminCommand("unbanid", function(source, args, rawCommand)
	-- 	local type = args[1]

	-- 	local player = Fetch:Source(source)
	-- 	if type == "identifier" then
	-- 		exports["sandbox-base"]:FetchComponent("Punishment").Unban:Identifier(args[2], source)
	-- 	elseif type == "account" then
	-- 		exports["sandbox-base"]:FetchComponent("Punishment").Unban:AccountID(tonumber(args[2]), source)
	-- 	end
	-- end, {
	-- 	help = "Unban Site ID",
	-- 	params = {
	-- 		{
	-- 			name = "ID Type",
	-- 			help = "Valid Types: identifier, account",
	-- 		},
	-- 		{
	-- 			name = "Target",
	-- 			help = "ID of Who You Want To Unban",
	-- 		},
	-- 	},
	-- }, 2)

	-- Chat:RegisterStaffCommand("bansource", function(source, args, rawCommand)
	-- 	local player = Fetch:Source(source)
	-- 	if player then
	-- 		local targetSource, days = tonumber(args[1]), tonumber(args[2])
	-- 		if source == targetSource then
	-- 			return Chat.Send.System:Single(source, "Cannot Ban Yourself")
	-- 		end

	-- 		if (days >= 1 and days <= 7) or (player.Permissions:IsAdmin() and days >= -1 and days <= 90) then
	-- 			exports["sandbox-base"]:FetchComponent("Punishment").Ban:Source(targetSource, days, args[3], source)
	-- 		else
	-- 			Chat.Send.System:Single(source, "Invalid Time")
	-- 		end
	-- 	end
	-- end, {
	-- 	help = "Ban Player By Server ID",
	-- 	params = {
	-- 		{
	-- 			name = "Target",
	-- 			help = "Server ID of Who You Want To Ban",
	-- 		},
	-- 		{
	-- 			name = "Days",
	-- 			help = "# of Days To Ban, -1 For Perma Ban (Staff Can Ban Up to 7 Days)",
	-- 		},
	-- 		{
	-- 			name = "Reason",
	-- 			help = "Reason For The Ban",
	-- 		},
	-- 	},
	-- }, 3)

	-- Chat:RegisterStaffCommand("ban", function(source, args, rawCommand)
	-- 	local player = Fetch:Source(source)
	-- 	if player then
	-- 		local targetSID, days = tonumber(args[1]), tonumber(args[2])
	-- 		local t = Fetch:SID(targetSID)
	-- 		if t ~= nil then
	-- 			if t:GetData("Source") == source then
	-- 				return Chat.Send.System:Single(source, "Cannot Ban Yourself")
	-- 			end

	-- 			if (days >= 1 and days <= 7) or (player.Permissions:IsAdmin() and days >= -1 and days <= 90) then
	-- 				exports["sandbox-base"]:FetchComponent("Punishment").Ban:Source(t:GetData("Source"), days, args[3], source)
	-- 			else
	-- 				Chat.Send.System:Single(source, "Invalid Time")
	-- 			end
	-- 		else
	-- 			Chat.Send.System:Single(source, "Invalid State ID (Not Online)")
	-- 		end
	-- 	end
	-- end, {
	-- 	help = "Ban Player By State ID",
	-- 	params = {
	-- 		{
	-- 			name = "Target",
	-- 			help = "State ID of Who You Want To Ban",
	-- 		},
	-- 		{
	-- 			name = "Days",
	-- 			help = "# of Days To Ban, -1 For Permanent Ban",
	-- 		},
	-- 		{
	-- 			name = "Reason",
	-- 			help = "Reason For The Ban",
	-- 		},
	-- 	},
	-- }, 3)

	-- Chat:RegisterAdminCommand("banid", function(source, args, rawCommand)
	-- 	local player = Fetch:Source(source)
	-- 	if player then
	-- 		local type, target, days = args[1], args[2], tonumber(args[3])

	-- 		if days >= -1 and days <= 90 then
	-- 			if type == "identifier" then
	-- 				local res = exports["sandbox-base"]
	-- 					:FetchComponent("Punishment").Ban
	-- 					:Identifier(target, days, args[4], source)
	-- 				if res and res.success then
	-- 					Chat.Send.System:Single(source, "Banned Identifier: " .. res.Identifier)
	-- 				else
	-- 					if res and res.message then
	-- 						Chat.Send.System:Single(source, "Error: " .. res.message)
	-- 					else
	-- 						Chat.Send.System:Single(source, "Error Banning")
	-- 					end
	-- 				end
	-- 			elseif type == "account" then
	-- 				local res =
	-- 					exports["sandbox-base"]:FetchComponent("Punishment").Ban:AccountID(target, days, args[4], source)
	-- 				if res and res.success then
	-- 					Chat.Send.System:Single(source, "Banned Account: " .. res.AccountID)
	-- 				else
	-- 					if res and res.message then
	-- 						Chat.Send.System:Single(source, "Error: " .. res.message)
	-- 					else
	-- 						Chat.Send.System:Single(source, "Error Banning")
	-- 					end
	-- 				end
	-- 			else
	-- 				Chat.Send.System:Single(source, "Invalid ID Type")
	-- 			end
	-- 		else
	-- 			Chat.Send.System:Single(source, "Invalid Time")
	-- 		end
	-- 	end
	-- end, {
	-- 	help = "Ban Player From Server",
	-- 	params = {
	-- 		{
	-- 			name = "ID Type",
	-- 			help = "Valid Types: identifier, account",
	-- 		},
	-- 		{
	-- 			name = "Target",
	-- 			help = "Identifier of Who You Want To Ban",
	-- 		},
	-- 		{
	-- 			name = "Days",
	-- 			help = "# of Days To Ban, -1 For Permanent Ban",
	-- 		},
	-- 		{
	-- 			name = "Reason",
	-- 			help = "Reason For The Ban",
	-- 		},
	-- 	},
	-- }, 4)

	Chat:RegisterAdminCommand("tpm", function(source, args, rawCommand)
		TriggerClientEvent("Commands:Client:TeleportToMarker", source)
	end, {
		help = "Teleport to Marker",
	})

	Chat:RegisterAdminCommand("tp", function(source, args, rawCommand)
		local coolArgs = stringsplit(rawCommand:sub(4):gsub(",", ""), " ")

		if tonumber(coolArgs[1]) ~= nil and tonumber(coolArgs[2]) ~= nil and tonumber(coolArgs[3]) ~= nil then
			SetEntityCoords(
				GetPlayerPed(source),
				tonumber(coolArgs[1]) + 0.0,
				tonumber(coolArgs[2]) + 0.0,
				tonumber(coolArgs[3]) + 0.0,
				0,
				0,
				0,
				false
			)
		else
			Chat.Send.System:Single(source, "Not All Numbers")
		end
	end, {
		help = "Teleport To Given Coords",
		params = {
			{
				name = "X",
				help = "X Coord",
			},
			{
				name = "Y",
				help = "Y Coord",
			},
			{
				name = "Z",
				help = "Z Coord",
			},
		},
	}, 3)

	Chat:RegisterAdminCommand("saveall", function(source, args, rawCommand)
		TriggerEvent("Core:Server:ForceAllSave")
	end, {
		help = "Drop all players and force any saves to prep for restart",
		params = {},
	}, 0)

	Chat:RegisterAdminCommand("forceunload", function(source, args, rawCommand)
		if tonumber(args[1]) then
			TriggerEvent("Core:Server:ForceUnload", tonumber(args[1]))
		else
			Chat.Send.System:Single(source, "Invalid Argument")
		end
	end, {
		help = "Forcefully Unloads Target Source",
		params = {
			{
				name = "State",
				help = "The State You Want To Force Unload",
			},
		},
	}, 1)

	Chat:RegisterAdminCommand("payphone", function(source, args, rawCommand)
		TriggerClientEvent("Execute:Client:Component", source, "Phone", "OpenLimited")
	end, {
		help = "Open Phone In Payphone Mode",
		params = {},
	}, 0)

	Chat:RegisterAdminCommand("addstate", function(source, args, rawCommand)
		local char = Fetch:CharacterSource(source)
		if char ~= nil then
			local states = char:GetData("States") or {}
			for k, v in ipairs(states) do
				if v == args[1] then
					Chat.Send.System:Single(source, "Already Have That State")
					return
				end
			end
			table.insert(states, args[1])
			char:SetData("States", states)
			Chat.Send.System:Single(source, "State Added")
		else
			Chat.Send.System:Single(source, "Not Logged In")
		end
	end, {
		help = "Add A State To Yourself",
		params = {
			{
				name = "State",
				help = "The State You Want To Add",
			},
		},
	}, 1)

	Chat:RegisterAdminCommand("addstatetarget", function(source, args, rawCommand)
		local sid, state = tonumber(args[1]), args[2]
		local char = Fetch:SID(sid)
		if char ~= nil then
			local states = char:GetData("States") or {}
			for k, v in ipairs(states) do
				if v == state then
					Chat.Send.System:Single(source, "Already Have That State")
					return
				end
			end
			table.insert(states, state)
			char:SetData("States", states)
			Chat.Send.System:Single(source, "State Added")
		else
			Chat.Send.System:Single(source, "Not Logged In")
		end
	end, {
		help = "Add A State To Yourself",
		params = {
			{
				name = "Target State ID",
				help = "Target State ID To Add State To",
			},
			{
				name = "State",
				help = "The State You Want To Add",
			},
		},
	}, 2)

	Chat:RegisterStaffCommand("checkradio", function(source, args, rawCommand)
		local targ = tonumber(args[1])
		local char = Fetch:SID(targ)
		if char ~= nil then
			local pState = Player(char:GetData("Source")).state
			Chat.Send.System:Single(source, pState?.onRadio and string.format("Radio Frequency: %s", pState?.onRadio) or "Not On Radio")
		else
			Chat.Send.System:Single(source, "Not Logged In")
		end
	end, {
		help = "Check Radio Channel Player Is On",
		params = {
			{
				name = "State ID",
				help = "State ID To Check",
			},
		},
	}, 1)

	Chat:RegisterStaffCommand("viewfreq", function(source, args, rawCommand)
		local str = string.format("Players On Frequency %s:<br />", args[1])
		local plyrs = {}
		for k, v in ipairs(GetPlayers()) do
			local pState = Player(v).state
			if pState?.onRadio and pState.onRadio == args[1] then
				local char = Fetch:CharacterSource(tonumber(v))
				if char ~= nil then
					table.insert(plyrs, string.format("%s %s (%s)", char:GetData("First"), char:GetData("Last"), char:GetData("SID")))
				end
			end
		end

		str = str .. table.concat(plyrs, ", ")

		Chat.Send.System:Single(source, str)
	end, {
		help = "Prints All Players On Specified Frequency",
		params = {
			{
				name = "Radio Frequency",
				help = "Frequency To Check (If a whole number, try with and without .0)",
			},
		},
	}, 1)
end

function stringsplit(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t = {}
	i = 1
	for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
		t[i] = str
		i = i + 1
	end
	return t
end
