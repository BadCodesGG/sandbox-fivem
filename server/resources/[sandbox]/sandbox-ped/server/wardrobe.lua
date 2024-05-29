AddEventHandler("Wardrobe:Shared:DependencyUpdate", RetrieveWardrobeComponents)
function RetrieveWardrobeComponents()
	Chat = exports["sandbox-base"]:FetchComponent("Chat")
	Fetch = exports["sandbox-base"]:FetchComponent("Fetch")
	Callbacks = exports["sandbox-base"]:FetchComponent("Callbacks")
	Middleware = exports["sandbox-base"]:FetchComponent("Middleware")
	Database = exports["sandbox-base"]:FetchComponent("Database")
	Logger = exports["sandbox-base"]:FetchComponent("Logger")
	Ped = exports["sandbox-base"]:FetchComponent("Ped")
	Wardrobe = exports["sandbox-base"]:FetchComponent("Wardrobe")
	Execute = exports["sandbox-base"]:FetchComponent("Execute")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["sandbox-base"]:RequestDependencies("Wardrobe", {
		"Chat",
		"Fetch",
		"Callbacks",
		"Middleware",
		"Database",
		"Execute",
		"Locations",
		"Logger",
		"Ped",
		"Wardrobe",
	}, function(error)
		if #error > 0 then
			return
		end -- Do something to handle if not all dependencies loaded
		RetrieveWardrobeComponents()
		RegisterWardrobeCallbacks()
		RegisterWardrobeMiddleware()
		RegisterChatCommands()
	end)
end)

WARDROBE = {}
AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["sandbox-base"]:RegisterComponent("Wardrobe", WARDROBE)
end)

function RegisterChatCommands()
	Chat:RegisterAdminCommand("wardrobe", function(source, args, rawCommand)
		TriggerClientEvent("Wardrobe:Client:ShowBitch", source)
	end, {
		help = "Test Notification",
	})
	Chat:RegisterAdminCommand("ped", function(source, args, rawCommand)
		local char
		local shopType = 0
		if args[1] and tonumber(args[1]) >= 0 then
			shopType = tonumber(args[1])
		end

		if args[2] and tonumber(args[2]) >= 1 then
			char = Fetch:SID(args[2])
		else
			char = Fetch:CharacterSource(source)
		end

		if char ~= nil then
			Execute:Client(
				source,
				"Notification",
				"Info",
				string.format("Ped Menu is given to State ID: %s", char:GetData("SID")),
				2000
			)
			TriggerClientEvent("Peds:Customization:Client:AdminAbuse", char:GetData("Source"), shopType)
		else
			Execute:Client(source, "Notification", "Error", "Player is not online.", 2000)
		end
	end, {
		help = "Show Ped Menu for Player",
		params = {
			{
				name = "Shop Type (optional)",
				help = "0 = Clothing (default), 1 = Surgery, 2 = Barber, 3 = Tattoo",
			},
			{
				name = "State ID (optional)",
				help = "Player you want to give a menu too",
			},
		},
	})
end

function RegisterWardrobeMiddleware()
	Middleware:Add("Characters:Creating", function(source, cData)
		return { {
			Wardrobe = {},
		} }
	end)
end

function RegisterWardrobeCallbacks()
	Callbacks:RegisterServerCallback("Wardrobe:GetAll", function(source, data, cb)
		local char = Fetch:CharacterSource(source)
		local wardrobe = char:GetData("Wardrobe") or {}

		local wr = {}

		for k, v in ipairs(wardrobe) do
			table.insert(wr, {
				label = v.label,
			})
		end

		cb(wr)
	end)

	Callbacks:RegisterServerCallback("Wardrobe:Save", function(source, data, cb)
		local char = Fetch:CharacterSource(source)

		if char ~= nil then
			local ped = char:GetData("Ped")
			local wardrobe = char:GetData("Wardrobe") or {}

			local outfit = {
				label = data.name,
				data = ped.customization,
			}
			table.insert(wardrobe, outfit)
			char:SetData("Wardrobe", wardrobe)
			cb(true)
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("Wardrobe:SaveExisting", function(source, data, cb)
		local char = Fetch:CharacterSource(source)

		if char ~= nil then
			local ped = char:GetData("Ped")
			local wardrobe = char:GetData("Wardrobe") or {}

			if wardrobe[data] ~= nil then
				wardrobe[data].data = ped.customization
				char:SetData("Wardrobe", wardrobe)
				cb(true)
			else
				cb(false)
			end
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("Wardrobe:Equip", function(source, data, cb)
		local char = Fetch:CharacterSource(source)
		if char ~= nil then
			local outfit = char:GetData("Wardrobe")[tonumber(data)]
			if outfit ~= nil then
				Ped:ApplyOutfit(source, outfit)
				cb(true)
			else
				cb(false)
			end
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("Wardrobe:Delete", function(source, data, cb)
		local char = Fetch:CharacterSource(source)
		if char ~= nil then
			local wardrobe = char:GetData("Wardrobe") or {}
			table.remove(wardrobe, data)
			char:SetData("Wardrobe", wardrobe)
			cb(true)
		else
			cb(false)
		end
	end)
end
