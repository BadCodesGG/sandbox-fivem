_currentTree = {}
_treeLooted = {}
_currentDate = os.date("*t", os.time())
XMAS_MONTH = 12

AddEventHandler("Xmas:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Database = exports["sandbox-base"]:FetchComponent("Database")
	Callbacks = exports["sandbox-base"]:FetchComponent("Callbacks")
	Middleware = exports["sandbox-base"]:FetchComponent("Middleware")
	Logger = exports["sandbox-base"]:FetchComponent("Logger")
	Utils = exports["sandbox-base"]:FetchComponent("Utils")
	Chat = exports["sandbox-base"]:FetchComponent("Chat")
	Fetch = exports["sandbox-base"]:FetchComponent("Fetch")
	Inventory = exports["sandbox-base"]:FetchComponent("Inventory")
	Loot = exports["sandbox-base"]:FetchComponent("Loot")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["sandbox-base"]:RequestDependencies("Xmas", {
		"Database",
		"Callbacks",
        "Middleware",
		"Logger",
		"Utils",
		"Chat",
		"Fetch",
		"Inventory",
		"Loot",
	}, function(error)
		if #error > 0 then
			return
		end -- Do something to handle if not all dependencies loaded
        
        RetrieveComponents()
        RegisterCommands()
        RegisterCallbacks()
		RegisterItems()
        Startup()
		StartThreading()
        
        Middleware:Add("Characters:Spawning", function(source)
			if _currentDate.month == XMAS_MONTH then
				local char = Fetch:CharacterSource(source)
				if char ~= nil then
					local sid = char:GetData("SID")
					TriggerClientEvent("Xmas:Client:Init", source, _currentDate.day, _currentTree, _treeLooted[sid] ~= nil)
				end
			end
        end, 2)
	end)
end)
