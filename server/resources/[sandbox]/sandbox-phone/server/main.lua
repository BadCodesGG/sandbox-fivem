function defaultApps()
	local defApps = {}
	local dock = { "contacts", "phone", "messages" }
	for k, v in pairs(PHONE_APPS) do
		if not v.canUninstall then
			table.insert(defApps, v.name)
		end
	end
	return {
		installed = defApps,
		home = defApps,
		dock = dock,
	}
end

function hasValue(tbl, value)
	for k, v in ipairs(tbl) do
		if v == value or (type(v) == "table" and hasValue(v, value)) then
			return true
		end
	end
	return false
end

function table.copy(t)
	local u = {}
	for k, v in pairs(t) do
		u[k] = v
	end
	return setmetatable(u, getmetatable(t))
end

local defaultSettings = {
	wallpaper = "wallpaper",
	ringtone = "ringtone1.ogg",
	texttone = "text1.ogg",
	colors = {
		accent = "#1a7cc1",
	},
	zoom = 75,
	volume = 100,
	notifications = true,
	appNotifications = {},
}

local defaultPermissions = {
	redline = {
		create = false,
	},
}

AddEventHandler("onResourceStart", function(resource)
	if resource == GetCurrentResourceName() then
		TriggerClientEvent("Phone:Client:SetApps", -1, PHONE_APPS)
	end
end)

AddEventHandler("Phone:Shared:DependencyUpdate", RetrieveComponents)

function RetrieveComponents()
	Fetch = exports["sandbox-base"]:FetchComponent("Fetch")
	Database = exports["sandbox-base"]:FetchComponent("Database")
	Callbacks = exports["sandbox-base"]:FetchComponent("Callbacks")
	Logger = exports["sandbox-base"]:FetchComponent("Logger")
	Utils = exports["sandbox-base"]:FetchComponent("Utils")
	Chat = exports["sandbox-base"]:FetchComponent("Chat")
	Phone = exports["sandbox-base"]:FetchComponent("Phone")
	Photos = exports["sandbox-base"]:FetchComponent("Photos")
	Middleware = exports["sandbox-base"]:FetchComponent("Middleware")
	Execute = exports["sandbox-base"]:FetchComponent("Execute")
	Config = exports["sandbox-base"]:FetchComponent("Config")
	MDT = exports["sandbox-base"]:FetchComponent("MDT")
	Jobs = exports["sandbox-base"]:FetchComponent("Jobs")
	Labor = exports["sandbox-base"]:FetchComponent("Labor")
	Crypto = exports["sandbox-base"]:FetchComponent("Crypto")
	VOIP = exports["sandbox-base"]:FetchComponent("VOIP")
	Generator = exports["sandbox-base"]:FetchComponent("Generator")
	Properties = exports["sandbox-base"]:FetchComponent("Properties")
	Vehicles = exports["sandbox-base"]:FetchComponent("Vehicles")
	Inventory = exports["sandbox-base"]:FetchComponent("Inventory")
	Loot = exports["sandbox-base"]:FetchComponent("Loot")
	Loans = exports["sandbox-base"]:FetchComponent("Loans")
	Billing = exports["sandbox-base"]:FetchComponent("Billing")
	Banking = exports["sandbox-base"]:FetchComponent("Banking")
	Reputation = exports["sandbox-base"]:FetchComponent("Reputation")
	Robbery = exports["sandbox-base"]:FetchComponent("Robbery")
	Wallet = exports["sandbox-base"]:FetchComponent("Wallet")
	Sequence = exports["sandbox-base"]:FetchComponent("Sequence")
	Vendor = exports["sandbox-base"]:FetchComponent("Vendor")
	RegisterChatCommands()
end

AddEventHandler("Core:Shared:Ready", function()
	exports["sandbox-base"]:RequestDependencies("Phone", {
		"Fetch",
		"Database",
		"Callbacks",
		"Logger",
		"Utils",
		"Chat",
		"Phone",
		"Middleware",
		"Execute",
		"Config",
		"MDT",
		"Jobs",
		"Labor",
		"Crypto",
		"VOIP",
		"Generator",
		"Properties",
		"Vehicles",
		"Inventory",
		"Loot",
		"Loans",
		"Billing",
		"Banking",
		"Reputation",
		"Robbery",
		"Wallet",
		"Sequence",
		"Vendor",
		"Photos",
	}, function(error)
		if #error > 0 then
			return
		end
		-- Do something to handle if not all dependencies loaded
		RetrieveComponents()
		Startup()
		TriggerEvent("Phone:Server:RegisterMiddleware")
		TriggerEvent("Phone:Server:RegisterCallbacks")
		TriggerEvent("Phone:Server:Startup")

		Reputation:Create("Racing", "LS Underground", {
			{ label = "Rank 1", value = 1000 },
			{ label = "Rank 2", value = 2500 },
			{ label = "Rank 3", value = 5000 },
			{ label = "Rank 4", value = 10000 },
			{ label = "Rank 5", value = 25000 },
			{ label = "Rank 6", value = 50000 },
			{ label = "Rank 7", value = 100000 },
			{ label = "Rank 8", value = 250000 },
			{ label = "Rank 9", value = 500000 },
			{ label = "Rank 10", value = 1000000 },
		}, true)

		InitBizPhones()
	end)
end)

AddEventHandler("Phone:Server:RegisterMiddleware", function()
	Middleware:Add("Characters:Spawning", function(source)
		local char = Fetch:CharacterSource(source)
		
		if char:GetData("PhonePosition") == nil then
			char:SetData("PhonePosition", { x = 1000, y = 250 })
		end
		TriggerClientEvent("Phone:Client:RestorePosition", source, char:GetData("PhonePosition"))
		
		local changed = false
		local apps = char:GetData("Apps")
		for k, v in pairs(apps) do
			for k2, v2 in ipairs(v) do
				if v2 == "irc" then
					table.remove(v, k2)
					changed = true
					break
				end
			end
		end
		if changed then
			char:SetData("Apps", apps)
		end
	end, -1)
	Middleware:Add("Characters:Spawning", function(source)
		Phone:UpdateJobData(source)
		TriggerClientEvent("Phone:Client:SetApps", source, PHONE_APPS)

		local char = Fetch:CharacterSource(source)
		local myPerms = char:GetData("PhonePermissions")
		local modified = false
		for app, perms in pairs(defaultPermissions) do
			if myPerms[app] == nil then
				myPerms[app] = perms
				modified = true
			else
				for perm, state in pairs(perms) do
					if myPerms[app][perm] == nil then
						myPerms[app][perm] = state
						modified = true
					end
				end
			end
		end

		if modified then
			char:SetData("PhonePermissions", myPerms)
		end
	end, 1)
	Middleware:Add("Characters:Spawning", function(source)
		local char = Fetch:CharacterSource(source)
		
		local data = MySQL.rawExecute.await("SELECT app, name, picture, meta FROM character_app_profiles WHERE sid = ?", {
			char:GetData("SID"),
		})

		if data then
			local profiles = {}
			for k, v in ipairs(data) do
				profiles[v.app] = {
					id = v.id,
					name = v.name,
					picture = v.picture,
					meta = json.decode(v.meta or "{}")
				}
			end
			char:SetData("Profiles", profiles)
		else
			char:SetData("Profiles", {})
		end

		local t = Middleware:TriggerEventWithData("Phone:Spawning", source, char)
		TriggerLatentClientEvent("Phone:Client:SetDataMulti", source, 50000, t)
	end, 1)
	Middleware:Add("Phone:UIReset", function(source)
		local plyr = Fetch:CharacterSource(source)
		if char ~= nil then
			Phone:UpdateJobData(source)
			TriggerClientEvent("Phone:Client:SetApps", source, PHONE_APPS)
			
			local t = Middleware:TriggerEventWithData("Phone:Spawning", source, char)
			TriggerLatentClientEvent("Phone:Client:SetDataMulti", source, 50000, t)
		end
	end)
	Middleware:Add("Characters:Creating", function(source, cData)
		local t = Middleware:TriggerEventWithData("Phone:CharacterCreated", source, cData) or {}
		local aliases = {}

		for k, v in ipairs(t) do
			if v ~= nil then
				aliases[v.app] = v.alias
			end
		end

		local p = Middleware:TriggerEventWithData("Phone:CreateProfiles", source, cData) or {}
		local profiles = {}

		for k, v in ipairs(p) do
			if v ~= nil then
				profiles[v.app] = v.profile
			end
		end

		return {
			{
				Alias = aliases,
				Apps = defaultApps(),
				PhoneSettings = defaultSettings,
				PhonePermissions = defaultPermissions,
			},
		}
	end)
end)

RegisterNetEvent("Phone:Server:UIReset", function()
	Middleware:TriggerEvent("Phone:UIReset", source)
end)

AddEventHandler("Phone:Server:RegisterCallbacks", function()
	Callbacks:RegisterServerCallback("Phone:SavePosition", function(source, data, cb)
		local char = Fetch:CharacterSource(source)
		if char ~= nil then
			char:SetData("PhonePosition", data)
		end
	end)

	Callbacks:RegisterServerCallback("Phone:Apps:Home", function(src, data, cb)
		local char = Fetch:CharacterSource(src)
		local apps = char:GetData("Apps")
		if data.action == "add" then
			table.insert(apps.home, data.app)
		else
			local newHome = {}
			for k, v in ipairs(apps.home) do
				if v ~= data.app then
					table.insert(newHome, v)
				end
			end

			apps.home = newHome
		end
		char:SetData("Apps", apps)
	end)

	Callbacks:RegisterServerCallback("Phone:Apps:Dock", function(src, data, cb)
		local char = Fetch:CharacterSource(src)
		local apps = char:GetData("Apps")
		if data.action == "add" then
			if #apps.dock < 4 then
				table.insert(apps.dock, data.app)
			end
		else
			local newDock = {}
			for k, v in ipairs(apps.dock) do
				if v ~= data.app then
					table.insert(newDock, v)
				end
			end

			apps.dock = newDock
		end
		char:SetData("Apps", apps)
	end)

	Callbacks:RegisterServerCallback("Phone:Apps:Reorder", function(src, data, cb)
		local char = Fetch:CharacterSource(src)
		local apps = char:GetData("Apps")
		apps[data.type] = data.apps
		char:SetData("Apps", apps)
	end)

	Callbacks:RegisterServerCallback("Phone:UpdateAlias", function(src, data, cb)
		local char = Fetch:CharacterSource(src)
		local alias = char:GetData("Alias") or {}
		if data.unique then
			local query = {
				["Alias." .. data.app] = data.alias,
				Phone = {
					["$ne"] = char:GetData("Phone"),
				},
				Deleted = {
					["$ne"] = true,
				},
			}

			if data?.alias?.name ~= nil then
				query = {
					["Alias." .. data.app .. ".name"] = data.alias.name,
					Phone = {
						["$ne"] = char:GetData("Phone"),
					},
					Deleted = {
						["$ne"] = true,
					},
				}
			end
			Database.Game:find({
				collection = "characters",
				query = query,
			}, function(success, results)
				if #results > 0 then
					cb(false)
				else
					local upd = {
						["Alias." .. data.app] = data.alias,
					}

					if data?.alias?.name ~= nil then
						upd = {
							["Alias." .. data.app .. ".name"] = data.alias.name,
						}
					end

					Database.Game:updateOne({
						collection = "characters",
						query = {
							_id = char:GetData('ID'),
						},
						update = {
							["$set"] = upd,
						},
					}, function(success, updated)
						if success then
							alias[data.app] = data.alias
							char:SetData("Alias", alias)
							cb(true)
		
							--TriggerEvent("Phone:Server:AliasUpdated", src)
						else
							cb(false)
						end
					end)
				end
			end)
		else
			alias[data.app] = data.alias
			char:SetData("Alias", alias)
			cb(true)
			--TriggerEvent("Phone:Server:AliasUpdated", src)
		end
	end)

	Callbacks:RegisterServerCallback("Phone:UpdateProfile", function(src, data, cb)
		local char = Fetch:CharacterSource(src)
		if char ~= nil then
			local sid = char:GetData("SID")
			local profiles = char:GetData("Profiles") or {}
			if profiles[data.app] ~= nil then
				MySQL.insert("INSERT INTO app_profile_history (sid, app, name, picture, meta) VALUES(?, ?, ?, ?, ?)", {
					char:GetData("SID"),
					data.app,
					profiles[data.app].name,
					profiles[data.app].picture,
					json.encode(profiles[data.app].meta),
				})
			end

			local count = MySQL.scalar.await("SELECT COUNT(*) FROM character_app_profiles WHERE app = ? AND name = ? AND sid != ?", {
				data.app,
				data.name,
				sid
			})

			if count == 0 then
				MySQL.prepare.await(
					"INSERT INTO character_app_profiles (sid, app, name, picture, meta) VALUES(?, ?, ?, ?, ?) ON DUPLICATE KEY UPDATE name = VALUES(name), picture = VALUES(picture), meta = VALUES(meta)",
					{
						char:GetData("SID"),
						data.app,
						data.name,
						data.picture,
						json.encode(data.meta or {}),
					}
				)
	
				profiles[data.app] = {
					sid = char:GetData("SID"),
					app = data.app,
					name = data.name,
					picture = data.picture,
					meta = data.meta or {},
				}
				char:SetData("Profiles", profiles)

				--TriggerEvent("Phone:Server:UpdateProfile", src, data)
				cb(true)
			else
				Execute:Client(src, "Notification", "Error", "Alias already in use")
				cb(false)
			end
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("Phone:ShareMyContact", function(src, data, cb)
		local char = Fetch:CharacterSource(src)
		local myPed = GetPlayerPed(src)
		local myCoords = GetEntityCoords(myPed)
		local myBucket = GetPlayerRoutingBucket(src)
		for k, v in ipairs(GetPlayers()) do
			local tsrc = tonumber(v)
			local tped = GetPlayerPed(tsrc)
			local coords = GetEntityCoords(tped)
			if tsrc ~= src and #(myCoords - coords) <= 5.0 and GetPlayerRoutingBucket(tsrc) == myBucket then
				TriggerClientEvent("Phone:Client:ReceiveShare", tsrc, {
					type = "contacts",
					data = {
						name = char:GetData("First") .. " " .. char:GetData("Last"),
						number = char:GetData("Phone"),
					},
				}, os.time())
			end
		end
	end)

	Callbacks:RegisterServerCallback("Phone:Permissions", function(src, data, cb)
		local char = Fetch:CharacterSource(src)

		if char ~= nil then
			local perms = char:GetData("PhonePermissions")

			for k, v in pairs(data) do
				for k2, v2 in ipairs(v) do
					if not perms[k][v2] then
						cb(false)
						return
					end
				end
			end
			cb(true)
		else
			cb(false)
		end
	end)
end)
