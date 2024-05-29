AddEventHandler("Admin:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Database = exports["sandbox-base"]:FetchComponent("Database")
	Logger = exports["sandbox-base"]:FetchComponent("Logger")
	Callbacks = exports["sandbox-base"]:FetchComponent("Callbacks")
	Fetch = exports["sandbox-base"]:FetchComponent("Fetch")
	Utils = exports["sandbox-base"]:FetchComponent("Utils")
	Jobs = exports["sandbox-base"]:FetchComponent("Jobs")
	Punishment = exports["sandbox-base"]:FetchComponent("Punishment")
	Chat = exports["sandbox-base"]:FetchComponent("Chat")
	Middleware = exports["sandbox-base"]:FetchComponent("Middleware")
	C = exports["sandbox-base"]:FetchComponent("Config")
	Properties = exports["sandbox-base"]:FetchComponent("Properties")
	Execute = exports["sandbox-base"]:FetchComponent("Execute")
	Tasks = exports["sandbox-base"]:FetchComponent("Tasks")
	Pwnzor = exports["sandbox-base"]:FetchComponent("Pwnzor")
	WebAPI = exports["sandbox-base"]:FetchComponent("WebAPI")
	Vehicles = exports["sandbox-base"]:FetchComponent("Vehicles")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["sandbox-base"]:RequestDependencies("Admin", {
		"Database",
		"Logger",
		"Callbacks",
		"Fetch",
		"Utils",
		"Jobs",
		"Punishment",
		"Chat",
		"Middleware",
		"Config",
		"Properties",
		"Execute",
		"Tasks",
		"Pwnzor",
		"WebAPI",
		"Vehicles",
	}, function(error)
		if #error > 0 then
			return
		end
		RetrieveComponents()
		RegisterCallbacks()
		RegisterChatCommands()
		StartDashboardThread()

		Middleware:Add('Characters:Spawning', function(source)
			local player = Fetch:Source(source)

			if player and player.Permissions:IsStaff() then
				local highestLevel, highestGroup, highestGroupName = 0, nil, nil
				for k, v in ipairs(player:GetData('Groups')) do
					if C.Groups[tostring(v)] ~= nil and (type(C.Groups[tostring(v)].Permission) == 'table') then
						if C.Groups[tostring(v)].Permission.Level > highestLevel then
							highestLevel = C.Groups[tostring(v)].Permission.Level
							highestGroup = v
							highestGroupName = C.Groups[tostring(v)].Name
						end
					end
				end

				TriggerClientEvent('Admin:Client:Menu:RecievePermissionData', source, {
					Source = source,
					Name = player:GetData('Name'),
					AccountID = player:GetData('AccountID'),
					Identifier = player:GetData('Identifier'),
					Groups = player:GetData('Groups'),
					Discord = player:GetData("Discord"),
					Mention = player:GetData("Mention"),
					Avatar = player:GetData("Avatar"),
				}, highestGroup, highestGroupName, highestLevel)
			end
		end, 5)
	end)
end)

function RegisterChatCommands()
	Chat:RegisterAdminCommand("weptest", function(source, args, rawCommand)
		if GlobalState.IsProduction then
			Execute:Client(source, "Notification", "Error", "Cannot Use This On Production Servers")
			return
		end
		TriggerClientEvent("Admin:Client:DamageTest", source, args[1] == "1")
	end, {
		help = "[Admin] Start Weapon Damage Testing",
		params = {
			{
				name = "Mode",
				help = "0 = Body Shots, 1 = Headshots",
			},
		},
	}, 1)

	Chat:RegisterAdminCommand("statebaglog", function(source, args, rawCommand)
		TriggerClientEvent("Admin:Client:StateBagLog", source)
	end, {
		help = "[Admin] Toggle Console State Bag Logging",
	}, 0)

	Chat:RegisterAdminCommand("voiptargetlog", function(source, args, rawCommand)
		TriggerClientEvent("VOIP:Client:ToggleDebugMode", source)
	end, {
		help = "[Admin] Toggle Console VOIP Target Logging",
	}, 0)

	Chat:RegisterAdminCommand("admin", function(source, args, rawCommand)
		TriggerClientEvent("Admin:Client:Menu:Open", source)
	end, {
		help = "[Admin] Open Admin Menu",
	}, 0)

	Chat:RegisterStaffCommand("staff", function(source, args, rawCommand)
		TriggerClientEvent("Admin:Client:Menu:Open", source)
	end, {
		help = "[Staff] Open Staff Menu",
	}, 0)

	Chat:RegisterStaffCommand("noclip", function(source, args, rawCommand)
		TriggerClientEvent("Admin:Client:NoClip", source, false)
	end, {
		help = "[Admin] Toggle NoClip",
	}, 0)

	Chat:RegisterAdminCommand("noclip:dev", function(source, args, rawCommand)
		TriggerClientEvent("Admin:Client:NoClip", source, true)
	end, {
		help = "[Developer] Toggle Developer Mode NoClip",
	}, 0)

	Chat:RegisterAdminCommand("noclip:info", function(source, args, rawCommand)
		TriggerClientEvent("Admin:Client:NoClipInfo", source)
	end, {
		help = "[Developer] Get NoClip Camera Info",
	}, 0)

	Chat:RegisterAdminCommand("marker", function(source, args, rawCommand)
		TriggerClientEvent("Admin:Client:Marker", source, tonumber(args[1]) + 0.0, tonumber(args[2]) + 0.0)
	end, {
		help = "Place Marker at Coordinates",
		params = {
			{
				name = "X",
				help = "X Coordinate",
			},
			{
				name = "Y",
				help = "Y Coordinate",
			},
		},
	}, 2)

	Chat:RegisterStaffCommand("cpcoords", function(source, args, rawCommand)
		TriggerClientEvent("Admin:Client:CopyCoords", source, args[1])
		Execute:Client(source, "Notification", "Success", "Copied Coordinates")
	end, {
		help = "[Dev] Copy Coords",
		params = {
			{
				name = "Type",
				help = "Type of Coordinate (vec3, vec4, vec2, table, z, h, rot)",
			},
		},
	}, -1)

	Chat:RegisterAdminCommand("cpproperty", function(source, args, rawCommand)
		local nearProperty = Properties.Utils:IsNearProperty(source)
		if nearProperty?.propertyId then
			Execute:Client(source, "Admin", "CopyClipboard", nearProperty?.propertyId)
			Execute:Client(source, "Notification", "Success", "Copied Property ID")
		end
	end, {
		help = "[Dev] Copy Property ID of Closest Property",
	}, 0)

	Chat:RegisterAdminCommand("property", function(source, args, rawCommand)
		local nearProperty = Properties.Utils:IsNearProperty(source)
		if nearProperty?.propertyId then
			local prop = Properties:Get(nearProperty.propertyId)
			if prop then
				Chat.Send.System:Single(
					source,
					string.format(
						"Property ID: %s<br>Property: %s<br>Interior: %s<br>Owner: %s<br>Price: $%s<br>Type: %s",
						prop.id,
						prop.label,
						prop.upgrades?.interior,
						prop.owner and prop.owner.SID or "N/A",
						prop.price,
						prop.type
					)
				)
			end
		end
	end, {
		help = "[Dev] Get Closest Property Data",
	}, 0)

	Chat:RegisterCommand("record", function(source, args, rawCommand)
		TriggerClientEvent("Admin:Client:Recording", source, 'record')
	end, {
		help = "Record With R* Editor",
	}, 0)

	Chat:RegisterCommand("recordstop", function(source, args, rawCommand)
		TriggerClientEvent("Admin:Client:Recording", source, 'stop')
	end, {
		help = "Record With R* Editor",
	}, 0)

	-- Chat:RegisterStaffCommand("recorddel", function(source, args, rawCommand)
	-- 	TriggerClientEvent("Admin:Client:Recording", source, 'delete')
	-- end, {
	-- 	help = "[Staff] Record With R* Editor",
	-- }, 0)

	-- Chat:RegisterStaffCommand("recordedit", function(source, args, rawCommand)
	-- 	TriggerClientEvent("Admin:Client:Recording", source, 'editor')
	-- end, {
	-- 	help = "[Staff] Record With R* Editor",
	-- }, 0)

	Chat:RegisterAdminCommand("setped", function(source, args, rawCommand)
		TriggerClientEvent("Admin:Client:ChangePed", source, args[1])
	end, {
		help = "[Admin] Set Ped",
		params = {
			{
				name = "Ped",
				help = "Ped Model",
			},
		},
	}, 1)

	Chat:RegisterAdminCommand("staffcam", function(source, args, rawCommand)
		TriggerClientEvent("Admin:Client:NoClip", source, true)
	end, {
		help = "[Staff] Camera Mode",
	}, 0)

	Chat:RegisterAdminCommand("zsetped", function(source, args, rawCommand)
		TriggerClientEvent("Admin:Client:ChangePed", tonumber(args[1]), args[2])
	end, {
		help = "[Admin] Set Ped",
		params = {
			{
				name = "Source (Lazy)",
				help = "Source",
			},
			{
				name = "Ped",
				help = "Ped Model",
			},
		},
	}, 2)

	Chat:RegisterAdminCommand("nuke", function(source, args, rawCommand)
		TriggerClientEvent("Admin:Client:NukeCountdown", -1)
		Citizen.Wait(23000)
		TriggerClientEvent("Admin:Client:Nuke", -1)
	end, {
		help = "DO NOT USE",
	}, 0)
end