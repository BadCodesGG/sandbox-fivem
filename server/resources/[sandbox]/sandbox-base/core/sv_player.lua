_dropping = {}
COMPONENTS.Players = COMPONENTS.Players or {}
COMPONENTS.RecentDisconnects = COMPONENTS.RecentDisconnects or {}

Citizen.CreateThread(function()
	while true do
		for k, v in pairs(COMPONENTS.Players) do
			if not GetPlayerEndpoint(k) and not _dropping[k] then
				local char = COMPONENTS.Fetch:CharacterSource(k)
				if char ~= nil then
					TriggerEvent("Characters:Server:PlayerDropped", k, char:GetData())
				end
				COMPONENTS.Middleware:TriggerEvent("playerDropped", k, "Time Out")
				COMPONENTS.Players[k] = nil
			end
		end
		Citizen.Wait(60000)
	end
end)

AddEventHandler("Proxy:Shared:RegisterReady", function()
	COMPONENTS.Middleware:Add("playerDropped", function(source, message)
		local player = COMPONENTS.Players[source]
		if player ~= nil then
			local lastLocationMessage = ""
			local lastCoords = COMPONENTS.Characters:GetLastLocation(source) or false
			if lastCoords and type(lastCoords) == "vector3" then
				lastLocationMessage = string.format(" [Coords: %s]", lastCoords)
			end

			COMPONENTS.Logger:Info(
				"Base",
				string.format(
					"%s (%s) With Source %s Disconnected, Reason: %s%s",
					player:GetData("Name"),
					player:GetData("AccountID"),
					source,
					message,
					lastLocationMessage
				),
				{
					console = true,
					discord = {
						embed = true,
						type = "info",
						webhook = GetConvar("discord_connection_webhook", ""),
					},
				}
			)
		end
	end, 1)
	COMPONENTS.Middleware:Add("playerDropped", function(source, message)
		local player = COMPONENTS.Players[source]
		if player ~= nil then
			local char = COMPONENTS.Fetch:CharacterSource(source)

			local pData = {
				Source = source,
				Groups = player:GetData("Groups"),
				Name = player:GetData("Name"),
				GameName = player:GetData("GameName"),
				ID = player:GetData("ID"),
				Discord = player:GetData("Discord"),
				Mention = player:GetData("Mention"),
				AccountID = player:GetData("AccountID"),
				Avatar = player:GetData("Avatar"),
				Identifier = player:GetData("Identifier"),
				Level = player.Permissions:GetLevel(),
				IsStaff = player.Permissions:IsStaff(),
				IsAdmin = player.Permissions:IsAdmin(),
				Character = player:GetData("Character"),
				Reason = message,
				DisconnectedTime = os.time(),
			}

			if #COMPONENTS.RecentDisconnects >= 60 then
				table.remove(COMPONENTS.RecentDisconnects, 1)
			end

			table.insert(COMPONENTS.RecentDisconnects, pData)
		end
	end, 2)
end)

AddEventHandler("playerDropped", function(message)
	local src = source
	_dropping[src] = true

	local char = COMPONENTS.Fetch:CharacterSource(src)
	if char ~= nil then
		TriggerEvent("Characters:Server:PlayerDropped", src, char:GetData())
	end

	COMPONENTS.Middleware:TriggerEvent("playerDropped", src, message)
	COMPONENTS.Players[src] = nil
	_dropping[src] = nil

	if char ~= nil then
		COMPONENTS.DataStore:DeleteStore(src, "Character")
	end
	COMPONENTS.DataStore:DeleteStore(src, "Player")
	TriggerEvent("Characters:Server:DropCleanup", src)
end)

AddEventHandler("Core:Server:ForceUnload", function(source)
	DropPlayer(source, "You were force unloaded but were still on the server, this was probably mistake.")
	COMPONENTS.Players[source] = nil
	_dropping[source] = nil
end)

AddEventHandler("Queue:Server:SessionActive", function(source, data)
	Citizen.CreateThread(function()
		Player(source).state.ID = source

		if data == nil then
			DropPlayer(source, "Unable To Get Your User Data, Please Try To Rejoin")
		else
			local pData = {
				Source = source,
				Groups = data.Groups,
				Name = data.Name,
				ID = data.ID,
				Discord = data.Discord,
				Mention = data.Mention,
				AccountID = data.AccountID,
				Avatar = data.Avatar,
				Identifier = data.Identifier,
				--Tokens = COMPONENTS.Player:CheckTokens(source, data.ID, data.Tokens),
				GameName = GetPlayerName(source),
			}

			for k, v in pairs(COMPONENTS.Players) do
				if v:GetData("AccountID") == pData.AccountID then
					COMPONENTS.Players[k] = nil
					COMPONENTS.Logger:Error(
						"Base",
						string.format("%s Connected But Was Already Registered As A Player, Clearing", pData.AccountID)
					)
					if v:GetData("Source") ~= nil then
						DropPlayer(
							v:GetData("Source"),
							"You've Been Dropped Because Your Account Has Rejoined The Server. Using your account on multiple PCs to connect multiple times is not allowed."
						)
					end
				end
			end

			COMPONENTS.Players[source] = PlayerClass(source, pData)
			COMPONENTS.Routing:RoutePlayerToHiddenRoute(source)
			COMPONENTS.Logger:Info(
				"Base",
				string.format(
					"%s (%s) Connected With Source %s",
					COMPONENTS.Players[source]:GetData("Name"),
					COMPONENTS.Players[source]:GetData("AccountID"),
					source
				),
				{
					console = true,
					discord = {
						embed = true,
						type = "info",
						webhook = GetConvar("discord_connection_webhook", ""),
					},
				}
			)

			TriggerClientEvent("Player:Client:SetData", source, COMPONENTS.Players[source]:GetData())

			Player(source).state.isStaff = COMPONENTS.Players[source].Permissions:IsStaff()
			Player(source).state.isAdmin = COMPONENTS.Players[source].Permissions:IsAdmin()
			Player(source).state.isDev = COMPONENTS.Players[source].Permissions:GetLevel() >= 100

			TriggerEvent("Player:Server:Connected", source)
		end
	end)
end)

COMPONENTS.Player = {
	_required = {},
	_name = "base",
	CheckTokens = function(self, source, accountId, existing)
		local p = promise.new()

		local ctkns = {}
		for i = 0, GetNumPlayerTokens(source) - 1 do
			ctkns[GetPlayerToken(source, i)] = true
		end

		if existing ~= nil then
			for k, v in ipairs(existing) do
				if ctkns[v] then
					ctkns[v] = nil
				end
			end
			for k, v in pairs(ctkns) do
				table.insert(existing, k)
			end
			COMPONENTS.Database.Auth:updateOne({
				collection = "tokens",
				query = {
					account = accountId,
				},
				update = {
					["$set"] = {
						tokens = existing,
					},
				},
			}, function()
				p:resolve(existing)
			end)
		else
			local tkns = {}
			for k, v in pairs(ctkns) do
				table.insert(tkns, k)
			end

			COMPONENTS.Database.Auth:updateOne({
				collection = "tokens",
				query = {
					account = accountId,
				},
				update = {
					["$set"] = {
						tokens = tkns,
					},
				},
				options = {
					upsert = true,
				},
			}, function()
				p:resolve(tkns)
			end)
		end

		return Citizen.Await(p)
	end,
}

function PlayerClass(source, data)
	local _data = COMPONENTS.DataStore:CreateStore(source, "Player", data)

	_data.Permissions = {
		IsStaff = function(self)
			for k, v in ipairs(_data:GetData("Groups")) do
				if
					COMPONENTS.Config.Groups[v] ~= nil
					and type(COMPONENTS.Config.Groups[v].Permission) == "table"
					and (
						COMPONENTS.Config.Groups[v].Permission.Group == "staff"
						or COMPONENTS.Config.Groups[v].Permission.Group == "admin"
					)
				then
					return true
				end
			end
			return false
		end,
		IsAdmin = function(self)
			for k, v in ipairs(_data:GetData("Groups")) do
				if
					COMPONENTS.Config.Groups[v] ~= nil
					and type(COMPONENTS.Config.Groups[v].Permission) == "table"
					and COMPONENTS.Config.Groups[v].Permission.Group == "admin"
				then
					return true
				end
			end
			return false
		end,
		GetLevel = function(self)
			local highest = 0
			for k, v in ipairs(_data:GetData("Groups")) do
				if
					COMPONENTS.Config.Groups[tostring(v)] ~= nil
					and type(COMPONENTS.Config.Groups[tostring(v)].Permission) == "table"
				then
					if COMPONENTS.Config.Groups[tostring(v)].Permission.Level > highest then
						highest = COMPONENTS.Config.Groups[tostring(v)].Permission.Level
					end
				end
			end

			return highest
		end,
	}

	local license = GetPlayerLicense(source)
	for k, v in ipairs(_data:GetData("Groups")) do
		if
			COMPONENTS.Config.Groups[tostring(v)] ~= nil
			and type(COMPONENTS.Config.Groups[tostring(v)].Permission) == "table"
			and COMPONENTS.Config.Groups[tostring(v)].Permission.Group
		then
			ExecuteCommand(
				("add_principal identifier.license:%s group.%s"):format(
					license,
					COMPONENTS.Config.Groups[tostring(v)].Permission.Group
				)
			)
		end
	end

	return _data
end

function GetPlayerLicense(source)
	for _, id in ipairs(GetPlayerIdentifiers(source)) do
		if string.sub(id, 1, string.len("license:")) == "license:" then
			local license = string.sub(id, string.len("license:") + 1)
			return license
		end
	end
end
